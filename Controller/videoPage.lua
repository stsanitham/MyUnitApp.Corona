----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth
local H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title
--local dataFileName = "audio"..os.date("%Y%m%d%H%M%S")
local menuBtn
local filePath
local okBtn,okBtn_txt,cancelBtn,cancelBtn_txt
local userAction="cancel"

openPage="videoPage"

local r                 -- media object for audio recording
local recButton         -- gui buttons
local fSoundPlaying = false   -- sound playback state
local fSoundPaused = false    -- sound pause state

local countdown
--------------------------------------------------


	-----------------Function-------------------------

	local function closeDetails( event )
		if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )
				if event.target.id =="background" then

				elseif event.target.id == "ok" then
					userAction="ok"
					composer.hideOverlay()
				else
					composer.hideOverlay()
				end

		end

	return true

	end



	local function onKeyEventDetail( event )

	        local phase = event.phase
	        local keyName = event.keyName

	    if phase == "up" then

	        if keyName=="back" then

	        	composer.hideOverlay( "slideRight", 300 )

	        	return true
	            
	        end

	    end

	        return false
	 end






	-- local function onVideoComplete( event )

	--    if ( event.completed ) then

	--       media.playVideo( event.url, media.RemoteSource, true, videoPlayBackDone )
	--       print( "video duration : ",event.duration )
	--       print( "video size : ",event.fileSize )

	--    end

	-- end



function formatSizeUnits(event)

      if (event>=1073741824) then 

      	size=(event/1073741824)..' GB'


      elseif (event>=1048576) then   

       	size=(event/1048576)..' MB'

	  
	  elseif (event > 10485760) then

	  print("highest size of the image ",size)

	    local image = native.showAlert( "Error in Video Upload", "Size of the video cannot be more than 10 MB", { CommonWords.ok } )

	       
      elseif (event>=1024)  then   

      	size = (event/1024)..' KB'

      else      

  	  end

  	 -- return size

  	  local nativealert = native.showAlert("Video size", size ,{"ok"})

end





local function copyVideoFile(videoPath,dstName,dstPath)
  local rfilePath=videoPath
  local wfilePath=system.pathForFile(dstName,dstPath)
  local rfh=io.open(rfilePath,"rb")
  local wfh=io.open(wfilePath,"wb")
  if not(wfh) then
    return false
  else
    local data=rfh:read("*a")
    if not(data) then
      return false
    else
      if not(wfh:write(data)) then
        return false
      end
    end
  end
  rfh:close()
  wfh:close()
  return true
end




    local function onVideoComplete ( event )
 
        local video = event.target

        local baseDir = system.DocumentsDirectory

       if (event.completed) then

			local videoFileExtension=".mov"

			if (system.getInfo("platformName")=="Android") then

			videoFileExtension=".mp4"

			end

    --      local sourcePath = string.sub(event.url,6,-1)

    --      local destPath = system.pathForFile( videoname, baseDir )

    --      print(" s,d = ", sourcePath, destPath)


		    local videoFilePath = string.sub(event.url,8,-1)
		    local savedVideoFileName = "video"..os.date("%Y%m%d%H%M%S")..videoFileExtension
		    local savedVideoDirectory = system.DocumentsDirectory


		    if (copyVideoFile(videoFilePath,savedVideoFileName,savedVideoDirectory)) then

			        videoPreview.isVisible = true

				    videofile = native.newVideo( title.x , title_bg.y+title_bg.contentHeight + 15, W-60 , 150)
				    videofile.x=title.x
				    videofile.y= title_bg.y+title_bg.contentHeight + 15
					videofile.id="video object"
					videofile.anchorX=0
					videofile.anchorY = 0

					videofile:load( savedVideoFileName , savedVideoDirectory )
					videofile:play()

		    end


	        print( "video duration : ",event.duration )
		    print( "video size : ",event.fileSize )

    
			-- local video = native.newVideo( display.contentCenterX, display.contentCenterY, 320, 350 )

			-- local function videoListener( event )
			-- print( "Event phase: " .. event.phase )

			-- if event.errorCode then
			-- native.showAlert( "Error!", event.errorMessage, { "OK" } )
			-- end
			-- end

			-- -- Load a video and jump to 0:30
			-- video:load( "sample1.mp4", system.DocumentsDirectory )
			-- video:seek( 30 )

			-- -- Add video event listener 
			-- video:addEventListener( "video", videoListener )


		videofilesize = event.fileSize
		videourl = event.url

        formatSizeUnits(videofilesize)

	    end

		local nativealert = native.showAlert("Video Properties", event.duration .."        "..event.fileSize.."        "..event.url,{"ok"})	

end






	local function onVideoButtonTouch( event )

		 	if event.phase == "began" then

					display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then

					display.getCurrentStage():setFocus( nil )

					if event.target.id == "record" or event.target.id == "recordvideo" or event.target.id == "recordvideo_text" then

						print("record")


								if ( media.hasSource( media.Camera ) ) then

								media.captureVideo( { listener = onVideoComplete, preferredQuality = "high", } )

								else

								native.showAlert( "Video Recording Failed", "This device does not have a camera.", { "OK" } )

								end

	        
					end


					if event.target.id == "select_btn" or event.target.id == "selectvideo" or event.target.id == "selectVideo_text" then

						print("select")


								if ( media.hasSource( PHOTO_FUNCTION ) ) then

								media.selectVideo( { listener = onVideoComplete, mediaSource = PHOTO_FUNCTION } ) 
							
								else

								native.showAlert( "Video Capture Failed", "This device does not have a photo library.", { CommonWords.ok  } )

								end

					end

			end

		 return true
	end



	------------------------------------------------------

	function scene:create( event )

		local sceneGroup = self.view

		print( "video record" )


	    Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
		Background.x=W/2;Background.y=H/2
		Background.id="background"
		Background:addEventListener( "touch", closeDetails )


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
		title_bg.height = 30
		title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
		title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	    back_icon_bg = display.newRect(sceneGroup,0,0,20,20)
		back_icon_bg.x= 5
		back_icon_bg.anchorX=0
		back_icon_bg.anchorY=0
		back_icon_bg.alpha=0.01
		back_icon_bg:setFillColor(0)
		back_icon_bg.y= title_bg.y-8

		back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
		back_icon.x= back_icon_bg.x + 5
		back_icon.anchorX=0
		back_icon.anchorY=0
		back_icon:setFillColor(0)
		back_icon.y= title_bg.y - 8

		title = display.newText(sceneGroup,"Video",0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=back_icon.x+18;title.y = title_bg.y
		title:setFillColor(0)

		title:addEventListener( "touch", closeDetails )
		back_icon_bg:addEventListener( "touch", closeDetails )
		back_icon:addEventListener( "touch", closeDetails )


	MainGroup:insert(sceneGroup)

	end




	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then


			videoPreview = display.newImageRect( sceneGroup, "res/assert/videopreview.png", W-60, 150 )
			videoPreview.x=title.x;videoPreview.y= title_bg.y+title_bg.contentHeight + 15
			videoPreview.id="video preview"
			videoPreview.anchorX=0
			videoPreview.anchorY = 0

----------------------------------------------- record video button --------------------------------------------------------------			

		    recordvideo_button = display.newRect(sceneGroup,0,0,W-50,50)
			recordvideo_button.x = 0
			recordvideo_button.y = H - 50
			recordvideo_button.width =160
			recordvideo_button.height = 50
			recordvideo_button.anchorX = 0
			recordvideo_button.anchorY=0
			recordvideo_button:setFillColor(Utils.convertHexToRGB(color.darkgreen))
			recordvideo_button.id="record"

			recordvideo_icon = display.newImageRect("res/assert/sendmsg.png",16,14)
			recordvideo_icon.id = "recordvideo"
			sceneGroup:insert(recordvideo_icon)
			recordvideo_icon.anchorY=0
			recordvideo_icon.anchorX=0
			recordvideo_icon.x= recordvideo_button.x + 20
			recordvideo_icon.y=recordvideo_button.y+recordvideo_button.contentHeight/2-recordvideo_icon.contentHeight/2 - 5

			recordvideo_text = display.newText(sceneGroup,"Record Video",0,0,recordvideo_button.contentWidth-12,0,native.systemFont,14)
			recordvideo_text.anchorX=0
			recordvideo_text.anchorY=0
			recordvideo_text.id = "recordvideo_text"
			recordvideo_text.x=recordvideo_icon.x+recordvideo_icon.contentWidth+ 5
			recordvideo_text.y=recordvideo_icon.y
			Utils.CssforTextView(recordvideo_text,sp_primarybutton)

		   -- recordvideo_button.height=recordvideo_text.contentHeight+10


----------------------------------------------- select video button --------------------------------------------------------------			    

			selectvideo_button = display.newRect(sceneGroup,0,0,W-50,50)
			selectvideo_button.x = W/2 
			--draft_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
			selectvideo_button.y = H - 50
			selectvideo_button.width = 160
			selectvideo_button.height = 50
			selectvideo_button.anchorX = 0
			selectvideo_button.anchorY=0
			selectvideo_button:setFillColor( 0,0,0,0.7 )
			selectvideo_button.id="select_btn"

			selectvideo_icon = display.newImageRect("res/assert/drafticon.png",16,14)
			selectvideo_icon.id = "selectvideo"
			sceneGroup:insert(selectvideo_icon)
			selectvideo_icon.anchorY=0
			selectvideo_icon.anchorX=0
			selectvideo_icon.x= selectvideo_button.x + 20
			selectvideo_icon.y= selectvideo_button.y+selectvideo_button.contentHeight/2-selectvideo_icon.contentHeight/2 - 5

			selectvideo_text = display.newText(sceneGroup,"Select Video",0,0,selectvideo_button.contentWidth-12,0,native.systemFont,14)
			selectvideo_text.anchorX=0
			selectvideo_text.anchorY=0
			selectvideo_text.id = "selectVideo_text"
			selectvideo_text.x=selectvideo_icon.x+selectvideo_icon.contentWidth+ 5
			selectvideo_text.y=selectvideo_icon.y
			Utils.CssforTextView(selectvideo_text,sp_primarybutton)

		 --   selectvideo_button.height=selectvideo_text.contentHeight+10




		elseif phase == "did" then

			menuBtn:addEventListener("touch",menuTouch)

			recordvideo_button:addEventListener("touch",onVideoButtonTouch)
			recordvideo_icon:addEventListener("touch",onVideoButtonTouch)
			recordvideo_text:addEventListener("touch",onVideoButtonTouch)

			selectvideo_button:addEventListener("touch",onVideoButtonTouch)
			selectvideo_icon:addEventListener("touch",onVideoButtonTouch)
			selectvideo_text:addEventListener("touch",onVideoButtonTouch)

			Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end



	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			recordvideo_button:removeEventListener("touch",onVideoButtonTouch)
			recordvideo_icon:removeEventListener("touch",onVideoButtonTouch)
			recordvideo_text:removeEventListener("touch",onVideoButtonTouch)

			selectvideo_button:removeEventListener("touch",onVideoButtonTouch)
			selectvideo_icon:removeEventListener("touch",onVideoButtonTouch)
			selectvideo_text:removeEventListener("touch",onVideoButtonTouch)

			Runtime:removeEventListener( "key", onKeyEventDetail )


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