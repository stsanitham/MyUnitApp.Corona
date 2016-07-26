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

local cancel_button, cancel_icon, cancel_icon_text , image_send_button, send_icon ,send_icon_text

openPage="imageLibPage"

local BackFlag = false

local W = display.contentWidth;
local H= display.contentHeight

local captionField

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

		if keyName == "back" then

			composer.hideOverlay( "slideRight", 300 )

			return true
		end

	end

	return false
end





local function rescale(pwidth1,pheight1)
	
	if pwidth1>= W or pheight1 >= H-40 then

		pwidth1 = pwidth1/2
		pheight1 = pheight1/2

		intiscale(pwidth1,pheight1)

	else

		photowidth = pwidth1

		photoheight = pheight1
		
		return false

	end
end




local function intiscale(pwidth,pheight)
	
	if pwidth >= W or pheight >= H-40 then

		pwidth= pwidth/2
		pheight = pheight/2

		rescale(pwidth,pheight)

	else

		photowidth = pwidth

		photoheight = pheight

		return false

	end

end






local function onButtonTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

		if event.target.id == "cancel icon" or event.target.id == "cancel" or event.target.id == "cancel_icon_text" or event.target.id == "backbtn" then

			composer.hideOverlay("slideRight",300)

			button_idvalue = "cancel"

		end


		if event.target.id == "send icon" or event.target.id == "send" or event.target.id == "send_icon_text" then

		   composer.hideOverlay("slideRight",300)

		   button_idvalue = "send"


		
	end

	if event.target.id == "background" then

			native.setKeyboardFocus( nil )

	end

end

return true

end


local function captionListener( event )

	if ( event.phase == "began" ) then
        -- user begins editing defaultField

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
    
        native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then

		    	if valuename == "Chat" then

			    		if event.text:len() > 150 then

			    			event.target.text = event.target.text:sub(1,150)

			    		end
			    end


		    	if valuename == "ImageLibrary" then

			    		if event.text:len() > 20 then

			    			event.target.text = event.target.text:sub(1,20)

			    		end

		    	end

    end
end

------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.id = "background"
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
	BackBtn.id = "backbtn"
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
				imageview = event.params.image
				contactId = event.params.contactId
				messageType = event.params.MessageType
				sendto = event.params.sendto
				valuename = event.params.value

				print("Imageview photo : ",imageview)

				print("photoview : ",photoview)

			end


			intiscale(imageview.width,imageview.height)


			photo = display.newImageRect( sceneGroup,photoview,baseDir, 0 , 0 )
			photo.x = display.contentCenterX
			photo.anchorY= 0
			photo.y = title_bg.y+15
			photo.width = photowidth
			photo.height = photoheight/1.3

			captionField_bg = display.newRect(W/2, 0, W-20, 25)
			captionField_bg.y = photo.y+photo.contentHeight+35
			captionField_bg.alpha = 0.01
			sceneGroup:insert(captionField_bg)

			captionField = native.newTextField(W/2+3, 0, W-10, 25)
			captionField.id="First Name"
			captionField.size=14	
			captionField.anchorX = 0
			captionField.x = 10
			captionField.y = captionField_bg.y
			captionField.hasBackground = false
			captionField:setReturnKey( "done" )
			captionField.placeholder="Add a Caption"
			captionField:addEventListener( "userInput", captionListener )
			sceneGroup:insert(captionField)

			captionField_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
			captionField_bottom.x=W/2
			captionField_bottom.y= captionField.y+11




------------------------------------- image send button -------------------------------------------   


image_send_button = display.newRect( sceneGroup, 0,0, W/2, 45 )
image_send_button.x=0;image_send_button.y=H-45
image_send_button.id="send"
image_send_button.anchorX=0;image_send_button.anchorY=0
image_send_button:setFillColor( Utils.convertHexToRGB(color.darkGreen) )

send_icon = display.newImageRect( sceneGroup, "res/assert/audiosend.png",25,20 )
send_icon.id = "send icon"
send_icon.x=image_send_button.x+20;send_icon.y=image_send_button.y+image_send_button.contentHeight/2

send_icon_text = display.newText( sceneGroup, MessagePage.Send, 0,0,native.systemFont,16 )
send_icon_text.x=send_icon.x+25;send_icon_text.y=send_icon.y
send_icon_text.id = "send_icon_text"
send_icon_text.anchorX=0


 ------------------------------------- image cancel button -------------------------------------------  

 cancel_button = display.newRect( sceneGroup, 0,0, W/2, 45 )
 cancel_button.x=W/2;cancel_button.y=H-45
 cancel_button.id="cancel"
 cancel_button.anchorX=0;cancel_button.anchorY=0
 cancel_button:setFillColor( Utils.convertHexToRGB(color.Lytred) )

 cancel_icon = display.newImageRect( sceneGroup, "res/assert/audiocancel.png",25,20 )
 cancel_icon.id = "cancel icon"
 cancel_icon.x=cancel_button.x+20;cancel_icon.y=cancel_button.y+cancel_button.contentHeight/2

 cancel_icon_text = display.newText( sceneGroup, CommonWords.cancel, 0,0,native.systemFont,16 )
 cancel_icon_text.x=cancel_icon.x+25;cancel_icon_text.y=cancel_icon.y
 cancel_icon_text.id = "cancel_icon_text"
 cancel_icon_text.anchorX=0



			if valuename == "Chat" then

				title.text = "Send to "..sendto

					if title.text:len() > 25 then
			  				title.text = title.text:sub(1,25  ).."..."
			    	end

			else
               
                title.text = ImageLibrary.PageTitle

                captionField.placeholder="Add a name for your Image"

                photo.y = title_bg.y+30

                captionField_bg.y = photo.y+photo.contentHeight+40

                send_icon_text.text = "Add"
                
			end



 image_send_button:addEventListener("touch",onButtonTouch)
 send_icon:addEventListener("touch",onButtonTouch)
 send_icon_text:addEventListener("touch",onButtonTouch)

 cancel_button:addEventListener("touch",onButtonTouch)
 cancel_icon:addEventListener("touch",onButtonTouch)
 cancel_icon_text:addEventListener("touch",onButtonTouch)


		--    path = system.pathForFile( photoview, baseDir)

		--    local size = lfs.attributes (path, "size")

		--    local fileHandle = io.open(path, "rb")

		--    file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		--    io.close( fileHandle )

		--    print("mime conversion ",file_inbytearray)

		--    print("bbb ",size)

        --    formatSizeUnits(size)

        --    sendImage()


    elseif phase == "did" then

    	menuBtn:addEventListener("touch",menuTouch)

    	Runtime:addEventListener( "key", onKeyEvent )

    	BackBtn:addEventListener("touch",onButtonTouch)

    	Background:addEventListener("touch",onButtonTouch)
    	
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

		BackBtn:removeEventListener("touch",onButtonTouch)
		Background:removeEventListener("touch",onButtonTouch)


	elseif phase == "did" then

		event.parent:resumeImageCallBack(captionField.text,photoview,button_idvalue)

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