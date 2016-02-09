
local composer = require( "composer" )
local scene = composer.newScene()
display.setStatusBar( display.HiddenStatusBar ) 

openpage = "PhotoLibraryPage"

local image_button1 , topmenuimage


local centerX = display.contentCenterX
local centerY = display.contentCenterY
local W = display.contentWidth
local H = display.contentHeight


--local photo		-- holds the photo object
local PHOTO_FUNCTION = media.PhotoLibrary 		-- or media.SavedPhotosAlbum


-- Camera not supported on simulator.                    
local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
if (isXcodeSimulator) then
	 local alert = native.showAlert( "Information", "No Photo Library available on iOS Simulator.", { "OK"})    
end
--

print( "display.contentScale x,y: " .. display.contentScaleX, display.contentScaleY )



local function bgTouch(event)

local phase = event.phase

if phase=="ended" then

end

return true

end








	function MessageSending( Request_response )

	print("response after sending message ",Request_response)

	end



	function get_messageresponse(response)

		MessageSending(response)

		print("SuccessMessage")

		local sentalert = native.showAlert( Message.SuccessMsg, Message.SuccessContent, { CommonWords.ok })

		Message_content.text = ""

		feed_url.isVisible = true

		feed_url.text = ""

		url_dropdown.text = "YouTube"

	end



    local function sendMessage( method )

		Webservice.SEND_MESSAGE(Message_content.text,feed_url.text,method,get_messageresponse)

    end



-- local function selectionComplete ( event )
 
--         local photo = event.target

--         local baseDir = system.DocumentsDirectory

--         if photo then

--         	print(photo.fileSize)

--         display.save(photo, "photo.jpg", baseDir)

--         photo:removeSelf()

--         photo = nil

--         photoname = "photo.jpg"

-- 	else

-- 	end

-- end



 --    function onImageButtonTouch( event )

 --    	local phase = event.phase

 --    	if phase=="began" then

 --    		display.getCurrentStage():setFocus( event.target )

	
 --    	elseif phase=="ended" then

 --    	--sendMessage("SEND")

 --    if media.hasSource( PHOTO_FUNCTION  ) then
	-- timer.performWithDelay( 100, function() media.selectPhoto( { listener = selectionComplete, mediaSource = PHOTO_FUNCTION } ) 
	-- end )

 --    end
	
	-- return true


 --    end

 --    end



    function onSendButtonTouch(event)

    	local phase = event.phase

    	if phase=="began" then

    		display.getCurrentStage():setFocus( event.target )

	
    	elseif phase=="ended" then

    	    display.getCurrentStage():setFocus( nil )

        sendMessage("SEND")

		 end


    end







local function removeevent( event )

	composer.gotoScene("Controller.MenuPage","slideRight",500)
end




local function selectionComplete ( event )
 
        local photo = event.target

        local baseDir = system.DocumentsDirectory

        if photo then

        display.save(photo, "photo.jpg", baseDir)

        photo:removeSelf()

        photo = nil

        photoname = photo.jpg


  --       local img = display.newImage("photo.jpg",baseDir,true)

		-- local xScale = W / img.contentWidth
		-- local yScale = H / img.contentHeight
		-- local scale = math.max( xScale, yScale ) * .5
		-- photo:scale( scale, scale )

  --       thumbnail = display.newGroup()

	 --    img:translate(display.contentCenterX,display.contentCenterY)

		-- thumbnail:insert(img)


	else
		image_button_text.text = "No Image Selected"
		image_button_text.x = display.contentCenterX
		image_button_text.y = display.contentCenterY
		print( "No Image Selected" )
	end

	   -- local thumbnail = display.newGroup()

	   -- local img = display.newImage("photo.jpg",baseDir,true)

	   -- img.width = 150

	   -- img.height = 150

	   -- img:translate(160,350)

	   -- thumbnail:insert(img)

	  -- img:scale(0.5,0.5)

end




local pickPhoto = function( event )

	display.remove(image_button1)

	image_button_text.text = "Select a picture.."
	image_button_text.size = 22
	image_button_text.x = centerX
	image_button_text.y = centerY

	 if media.hasSource( PHOTO_FUNCTION  ) then
	timer.performWithDelay( 100, function() media.selectPhoto( { listener = selectionComplete, mediaSource = PHOTO_FUNCTION } ) 
	end )

    else

        native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )

    end
	
	return true
end




function scene:create( event )
	local sceneGroup = self.view

    Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	local topmenu = display.newImageRect( "res/assert/wood_bg.jpg",display.contentWidth,40 )
	topmenu.anchorY = 0
	topmenu.anchorX = 0
	sceneGroup:insert(topmenu)

	local topmenutitle = display.newText( "Photo Library",0,0,"Arial",22)
	topmenutitle:setFillColor(1,1,1)
	topmenutitle.x = W/2 - topmenutitle.contentWidth/2
	topmenutitle.y = 10
	topmenutitle.anchorY = 0
	topmenutitle.anchorX = 0
	sceneGroup:insert(topmenutitle)

	topmenuimage = display.newImageRect( "res/assert/left-arrow.png",15,15 )
	topmenuimage.y = 20
	topmenuimage.x = 10
	topmenuimage.anchorX = 0
	sceneGroup:insert(topmenuimage)

    image_button1 = display.newRect( display.contentCenterX, display.contentCenterY - 100, 160, 35 )
	image_button1.strokeWidth = 2
	image_button1.x = display.contentCenterX
	image_button1.y = display.contentCenterY-100
	image_button1:setFillColor(0.234,0.54,0.34,0.2)
	image_button1:setStrokeColor( 1, 0, 0 )
	sceneGroup:insert(image_button1)

    image_button_text = display.newText(sceneGroup,"Photo Picker Button",0,0,native.systemFont,16)
	image_button_text.x=image_button1.x;image_button_text.y=image_button1.y
	image_button_text:setFillColor(0)

end




function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	elseif phase == "did" then

		image_button1:addEventListener("tap",pickPhoto )

		topmenuimage:addEventListener("touch",removeevent)

		Background:addEventListener("touch",bgTouch)
	
	end	
end




function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then

		topmenuimage:removeEventListener("touch",removeevent)

	    display.remove( thumbnail )
 
        thumbnail = nil

  		composer.removeHidden()
		
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

