----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local lfs = require ("lfs")
local mime = require("mime")
local style = require("res.value.style")

local Utility = require( "Utils.Utility" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local pasteboard = require( "plugin.pasteboard" )
local toast = require('plugin.toast')
local context


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="imagePreviewPage"

local BackFlag = false



--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

	end

return true

end



local function onTimer ( event )

	BackFlag = false

end



local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName == "back" or keyName == "a" then

        	composer.hideOverlay( "slideRight", 300 )

                return true
        end

    end

        return false
 end






	local function onButtonTouch( event )

		if event.phase == "began" then

				display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

				display.getCurrentStage():setFocus( nil )

				if event.target.id == "cancel icon" or event.target.id == "cancel" or event.target.id == "cancel_icon_text" then

	                   composer.hideOverlay("slideRight",300)

	                   button_idvalue = "cancel"


				end


				if event.target.id == "send icon" or event.target.id == "send" or event.target.id == "send_icon_text" then

	                   composer.hideOverlay("slideRight",300)

	                   button_idvalue = "send"

	                 
				end

		end

	  return true

	end




------------------------------------------------------

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

		BackBtn = display.newImageRect( sceneGroup, "res/assert/right-arrow(gray-).png",15,15 )
		BackBtn.anchorX = 0
		BackBtn.x=25;BackBtn.y = title_bg.y
		BackBtn.xScale=-1
		--BackBtn:setFillColor(0)

		title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=BackBtn.x+BackBtn.contentWidth-5;title.y = title_bg.y
		title:setFillColor(0)


        MainGroup:insert(sceneGroup)

end




function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	context = event.parent
	
	if phase == "will" then

		baseDir = system.DocumentsDirectory
 
        if event.params then

        	photoview = event.params.imageselected
        	contactId = event.params.contactId
        	messageType = event.params.MessageType
        	sendto = event.params.sendto

        end


		title.text = "Send to "..sendto


		local photo = display.newImageRect( sceneGroup,photoview,baseDir, W-40, 200 )
		photo.x = 20
		photo.anchorX = 0
		photo.anchorY= 0
		photo.y = title_bg.y + 25


------------------------------------- image cancel button -------------------------------------------

	    cancel_button = display.newRect(sceneGroup,0,0,W-50,26)
		cancel_button.x = W/2 - W/3 + 5
		cancel_button.y = photo.y + photo.contentHeight +20
		cancel_button.width = W - 225
		cancel_button.anchorX = 0
		cancel_button.anchorY=0
		cancel_button:setFillColor( 0,0,0,0.7 )
		cancel_button.id="cancel"

		cancel_icon = display.newImageRect("res/assert/drafticon.png",16,14)
		cancel_icon.id = "cancel icon"
		sceneGroup:insert(cancel_icon)
		cancel_icon.anchorY=0
		cancel_icon.anchorX=0
		cancel_icon.x= cancel_button.x + 6
		cancel_icon.y= cancel_button.y+cancel_button.contentHeight/2-cancel_icon.contentHeight/2

		cancel_icon_text = display.newText(sceneGroup,CommonWords.cancel,0,0,cancel_button.contentWidth-12,0,native.systemFont,14)
		cancel_icon_text.anchorX=0
		cancel_icon_text.anchorY=0
		cancel_icon_text.id = "cancel_icon_text"
		cancel_icon_text.x=cancel_icon.x+cancel_icon.contentWidth+ 5
		cancel_icon_text.y=cancel_icon.y
		Utils.CssforTextView(cancel_icon_text,sp_primarybutton)

	    cancel_button.height=cancel_icon_text.contentHeight+10


 ------------------------------------- image send button -------------------------------------------       

	    image_send_button = display.newRect(sceneGroup,0,0,W-50,26)
		image_send_button.x = W/2 +10
		image_send_button.y = photo.y + photo.contentHeight +20
		image_send_button.width = W - 235
		image_send_button.anchorX = 0
		image_send_button.anchorY=0
		image_send_button:setFillColor(Utils.convertHexToRGB(color.darkgreen))
		image_send_button.id="send"

		send_icon = display.newImageRect("res/assert/sendmsg.png",16,14)
		send_icon.id = "send icon"
		sceneGroup:insert(send_icon)
		send_icon.anchorY=0
		send_icon.anchorX=0
		send_icon.x= image_send_button.x + 6
		send_icon.y=image_send_button.y+image_send_button.contentHeight/2-send_icon.contentHeight/2

		send_icon_text = display.newText(sceneGroup,MessagePage.Send,0,0,image_send_button.contentWidth-12,0,native.systemFont,14)
		send_icon_text.anchorX=0
		send_icon_text.anchorY=0
		send_icon_text.id = "send_icon_text"
		send_icon_text.x=send_icon.x+send_icon.contentWidth+ 5
		send_icon_text.y=send_icon.y
		Utils.CssforTextView(send_icon_text,sp_primarybutton)

	    image_send_button.height=send_icon_text.contentHeight+10



--------------------------------------------- Draft Button ---------------------------------------------------------




  --       path = system.pathForFile( photoview, baseDir)

  --       local size = lfs.attributes (path, "size")

		-- local fileHandle = io.open(path, "rb")

		-- file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		-- io.close( fileHandle )

  --       print("mime conversion ",file_inbytearray)

  --       print("bbb ",size)

        	--formatSizeUnits(size)

        	--sendImage()

	elseif phase == "did" then

			menuBtn:addEventListener("touch",menuTouch)

			Runtime:addEventListener( "key", onKeyEvent )

			cancel_button:addEventListener("touch",onButtonTouch)
			cancel_icon:addEventListener("touch",onButtonTouch)
			cancel_icon_text:addEventListener("touch",onButtonTouch)

			image_send_button:addEventListener("touch",onButtonTouch)
			send_icon:addEventListener("touch",onButtonTouch)
			send_icon_text:addEventListener("touch",onButtonTouch)
		
	end	
	
MainGroup:insert(sceneGroup)

end




	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


		Runtime:addEventListener( "key", onKeyEvent )

		cancel_button:removeEventListener("touch",onButtonTouch)
		cancel_icon:removeEventListener("touch",onButtonTouch)
		cancel_icon_text:removeEventListener("touch",onButtonTouch)

		image_send_button:removeEventListener("touch",onButtonTouch)
		send_icon:removeEventListener("touch",onButtonTouch)
		send_icon_text:removeEventListener("touch",onButtonTouch)


			elseif phase == "did" then

	             event.parent:resumeImageCallBack(photoview,button_idvalue)

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