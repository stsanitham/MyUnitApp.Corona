----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local style = require("res.value.style")
local Utility = require( "Utils.Utility" )
local json = require("json")


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background, BgText, Message_content, send_button, send_button_text, url_dropdown , url_textcontent, feed_url, feed_cancelbutton,

      urlhelp_text

local menuBtn

openPage="messagePage"

local messageGroup

---------------------------------------------------


---------------------Function----------------------


	local function MessageLimitation( event )

	   if event.phase == "began" then

	   elseif event.phase == "ended" then

	print( event.target.text )

	   elseif event.phase == "editing" then

	if (string.len(event.target.text) > 160) then

	       event.target.text = event.target.text:sub(1, 160)
	end

	    end

	end


	local function bgTouch( event )

	if event.phase == "began" then
	display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then
	display.getCurrentStage():setFocus( nil )

	end

	return true

	end



---------------------------------------------------


	function MessageSending( Request_response )

	print("response after sending message ",Request_response)


	end


	function get_messageresponse(response)

		MessageSending(response)

	end



    local function sendMessage( method )

		Webservice.SEND_MESSAGE(Message_content.text,method,get_messageresponse)

    end




    function onSendButtonTouch(event)

    	local phase = event.phase

    	if phase=="began" then

    		display.getCurrentStage():setFocus( event.target )

			native.setKeyboardFocus(nil)

    	elseif phase=="ended" then

    	    display.getCurrentStage():setFocus( nil )

    	    sendMessage("SEND")

    	end

    end


    function messageResponse(content,response)

    	print("send message response: ", response)

    	print("message content ",content)

    end



	function onCancelButtonTouch(event)

	    local phase = event.phase

		if phase=="began" then

			display.getCurrentStage():setFocus( event.target )

			native.setKeyboardFocus(nil)

		elseif phase=="ended" then

			display.getCurrentStage():setFocus( nil )

			feed_url.text = " "

		end

	end



	function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,Message.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	--------------textbox for message--------------

	Message_content = native.newTextBox( 0, 0, W-20, EditBoxStyle.height+70)
	Message_content.placeholder = Message.Message_placeholder 
	Message_content.isEditable = true
	Message_content.size=14
	Message_content.value=""
	Message_content.hasBackground = true
	Message_content.inputType = "default"
	sceneGroup:insert(Message_content)
	Message_content.x=title_bg.x-title_bg.contentWidth/2+160;Message_content.y=title_bg.y+ title_bg.contentHeight/2+55
	Message_content:addEventListener( "userInput", MessageLimitation )


    --------------url dropdown for selection-------


	url_dropdown_bg = display.newRect( W/2, Message_content.y+Message_content.height-35, W-20, EditBoxStyle.height+10)
	url_dropdown_bg.id="eventname"
	url_dropdown_bg.anchorY=0
	url_dropdown_bg:setStrokeColor(0,0,0,0.4)
	url_dropdown_bg.strokeWidth = 1
	url_dropdown_bg.hasBackground = true
	sceneGroup:insert(url_dropdown_bg)


    -------------dropdown contents---------------

	url_dropdown = display.newText("",url_dropdown_bg.x-url_dropdown_bg.contentWidth/2+10,url_dropdown_bg.y,native.systemFont,14 )
	url_dropdown.text = "YouTube"
	url_dropdown.value = "optionname"
	url_dropdown.id="optionname"
	url_dropdown.alpha=0.7
	url_dropdown:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
	url_dropdown.y=url_dropdown_bg.y+url_dropdown_bg.contentHeight/2
	url_dropdown.anchorX=0
	sceneGroup:insert(url_dropdown)

	url_dropdown_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
	url_dropdown_icon.x=url_dropdown_bg.x+url_dropdown_bg.contentWidth/2-15
	url_dropdown_icon.y=url_dropdown.y


	----------url textfield-------------------

	url_textcontent = display.newText(sceneGroup,"Copy URL on clicking share in YouTube", 0, 0, native.systemFontBold, 13 )
	url_textcontent.x = display.contentCenterX
	url_textcontent.y = url_dropdown_bg.y + url_dropdown_bg.contentHeight+15
	url_textcontent:setFillColor( 0, 0, 0 )

	feed_url = native.newTextField(0, 0, W-60 , EditBoxStyle.height+10)
	feed_url.id = "video url"
	feed_url.anchorX=0
	feed_url.size=14
	feed_url.value=""
	feed_url.hasBackground = true
	feed_url.inputType = "url"
	feed_url.isVisible = true
	sceneGroup:insert(feed_url)
	feed_url.x=title_bg.x-title_bg.contentWidth/2+10
	feed_url.y=url_textcontent.y+ url_textcontent.contentHeight/2+25


	----------cancel button------------------

	feed_cancelbutton = display.newImageRect("res/assert/button_cancel_22.png",20,20)
	feed_cancelbutton.id = "url cancel"
	feed_cancelbutton.anchorX=0
	feed_cancelbutton:setFillColor(0,0,0,0.7)
	sceneGroup:insert(feed_cancelbutton)
	feed_cancelbutton.x= feed_url.width+25
	feed_cancelbutton.y=url_textcontent.y+ url_textcontent.contentHeight/2+25

	------------example text for url---------

	urlhelp_text = display.newText(sceneGroup,"Ex.http://www.youtube.com/watch?v=qOmDoZCuFtM", 0, 0,W,0,native.systemFontBold, 13 )
	urlhelp_text.x = display.contentCenterX
	urlhelp_text.width = W
	urlhelp_text.align = "center"
	urlhelp_text.y = feed_url.y-feed_url.contentHeight/2+ 50 
	urlhelp_text:setFillColor( 0, 0, 0 )


	--------send button----------------------

	send_button = display.newRect(sceneGroup,0,0,W-60,30)
	send_button.x=Message_content.x
	send_button.y = Message_content.y+230
	send_button.width = W-170
	send_button:setFillColor( Utils.convertHexToRGB(color.darkgreen) )
	send_button.id="send"

	send_button_text = display.newText(sceneGroup,Message.SendButton,0,0,native.systemFont,16)
	send_button_text.x=send_button.x
	send_button_text.y=send_button.y
	Utils.CssforTextView(send_button_text,sp_primarybutton)

	MainGroup:insert(sceneGroup)

	end




	function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then


	elseif phase == "did" then


	send_button:addEventListener("touch",onSendButtonTouch)	
	feed_cancelbutton:addEventListener("touch",onCancelButtonTouch)

	composer.removeHidden()

	menuBtn:addEventListener("touch",menuTouch)
    BgText:addEventListener("touch",menuTouch)

	end	

	MainGroup:insert(sceneGroup)

	end




	function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

	menuBtn:removeEventListener("touch",menuTouch)
	BgText:removeEventListener("touch",menuTouch)
	Message_content:removeEventListener( "userInput", MessageLimit )

	send_button:removeEventListener("touch",onButtonTouch)	

	elseif phase == "did" then

	end	

	end



	function scene:destroy( event )
	local sceneGroup = self.view

	end


	scene:addEventListener( "create", scene )
	scene:addEventListener( "show", scene )
	scene:addEventListener( "hide", scene )
	scene:addEventListener( "destroy", scene )


	return scene







		-- Message_content =  native.newTextField(0, 0, W-20 , EditBoxStyle.height+70)
		-- Message_content.id = "message content"
		-- Message_content.placeholder = Message.Message_placeholder 
		-- Message_content.anchorX=0
		-- Message_content.size=14
		-- Message_content.value=""
		-- Message_content.hasBackground = false
		-- Message_content.inputType = "default"
		-- sceneGroup:insert(Message_content)
		-- Message_content.x=title_bg.x-title_bg.contentWidth/2+10;Message_content.y=title_bg.y+ title_bg.contentHeight/2+55




	-- url_dropdown =  native.newTextField(0, 0, W-20 , EditBoxStyle.height+10)
	-- url_dropdown.id = "video url options"
	-- url_dropdown.anchorX=0
	-- url_dropdown.size=14
	-- url_dropdown.width = W-45
	-- url_dropdown.height = EditBoxStyle.height+10
	-- url_dropdown.isVisible = true
	-- url_dropdown.value=""
	-- url_dropdown.hasBackground = true
	-- url_dropdown.inputType = "url"
	-- sceneGroup:insert(url_dropdown)
	-- url_dropdown.x=title_bg.x-title_bg.contentWidth/2+10;url_dropdown.y=Message_content.y+ Message_content.contentHeight/2+30


 --    -------------dropdown contents---------------

 --    url_options = display.newImage(sceneGroup,"res/assert/arrow2.png", 0, 0, 15,15 )
 --    url_options.x = url_dropdown.width + 20
 --    url_options.y = url_dropdown.y
