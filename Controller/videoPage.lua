----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth
local H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title
--local dataFileName = "audio"..os.date("%Y%m%d%H%M%S")
local menuBtn
local filePath
local okBtn,okBtn_txt,cancelBtn,cancelBtn_txt
--local userAction="cancel"
local videoFilePath,videofilesize
openPage="videoPage"

local r                 -- media object for audio recording
local recButton         -- gui buttons
local fSoundPlaying = false   -- sound playback state
local fSoundPaused = false    -- sound pause state

local countdown

local PHOTO_FUNCTION = media.SavedPhotosAlbum  
--------------------------------------------------


	-----------------Function-------------------------

	local function closeDetails( event )
		if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

				if event.target.id == "background" then

				elseif event.target.id == "backbg" or event.target.id == "title" or event.target.id == "back" then

					composer.hideOverlay("slideRight", 300)

				end

		end

	return true

	end





function formatSizeUnits(event)

      if (event>=1073741824) then 

      	size=(event/1073741824)..' GB'


      elseif (event>=1048576) then   

       	size=(event/1048576)..' MB'

	  
	  elseif (event > 10485760) then

	    --print("highest size of the image ",size)

	    --local image = native.showAlert( "Error in Video Upload", "Size of the video cannot be more than 10 MB", { CommonWords.ok } )

	    size=(event/10485760)..' MB'

	    if size > "10 MB" then

	    	local image = native.showAlert( "Error in Video Upload", "Size of the video cannot be more than 10 MB", { CommonWords.ok } )

	    end

	       
      elseif (event>=1024)  then   

      	size = (event/1024)..' KB'

      end

  	 	local nativealert = native.showAlert("Video size", size ,{"ok"})

end






	local function onKeyEventDetail( event )

	        local phase = event.phase
	        local keyName = event.keyName

	    if phase == "up" then

	        if keyName=="back" or keyName == "a" then

	        	composer.hideOverlay( "slideRight", 300 )

	        	return true
	            
	        end

	    end

	        return false
	 end





local function copyVideoFile(videoPath,dstName,dstPath)
  local rfilePath=videoPath
  local wfilePath=system.pathForFile(dstName,dstPath)
  local rfh=io.open(rfilePath,"rb")
  local wfh=io.open(wfilePath,"wb")

  if not(wfh) then

  	--local video1 = native.showAlert("111","error1",{"ok"})
    return false
  else
    local data=rfh:read("*a")
    if not(data) then

    	--local video2 = native.showAlert("222","error2",{"ok"})
      return false
    else
      if not(wfh:write(data)) then

      	--local video3 = native.showAlert("333","error3",{"ok"})
        return false
      end
    end
  end
  rfh:close()
  wfh:close()
  return true
end





function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
 
    local results = false
 
    local srcPath = doesFileExist( srcName, srcPath )
 
    if srcPath == false then
        -- Source file doesn't exist
        return nil
    end
 
    -- Check to see if destination file already exists
    if not overwrite then

    local alert1 = native.showAlert("MUB video","dfgdfg",{"ok"})


        if fileLib.doesFileExist( dstName, dstPath ) then
            -- Don't overwrite the file
            return 1
        end
    end
 
    -- Copy the source file to the destination file
    --
    local rfilePath = system.pathForFile( srcName, srcPath )
    local wfilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open( rfilePath, "rb" )
 
    local wfh = io.open( wfilePath, "wb" )
 
    if  not wfh then
        print( "writeFileName open error!" )
        return false            -- error
    else
        -- Read the file from the Resource directory and write it to the destination directory
        local data = rfh:read( "*a" )
        if not data then
            print( "read error!" )
            return false    -- error
        else
            if not wfh:write( data ) then
                print( "write error!" )
                return false    -- error
            end
        end
    end
 
    results = 2     -- file copied
 
    -- Clean up our file handles
    rfh:close()
    wfh:close()

 
    return results

end





--     local function onVideoComplete ( event )
 
--         local video = event.target

--         local baseDir = system.DocumentsDirectory

--        if (event.completed) then

-- 			local videoFileExtension=".mov"

-- 			if (system.getInfo("platformName")=="Android") then

-- 			videoFileExtension=".mp4"

-- 			end

-- 				--  local sourcePath = string.sub(event.url,6,-1)

-- 				--  local destPath = system.pathForFile( videoname, baseDir )

-- 				--  print( " s,d = ", sourcePath, destPath )

-- 		    local videoFilePath = string.sub(event.url,8,-1)
-- 		    local savedVideoFileName = "video"..os.date("%Y%m%d%H%M%S")..videoFileExtension
-- 		    local savedVideoDirectory = system.DocumentsDirectory

-- 		    local al = native.showAlert("Video Name", videoFilePath .."        "..savedVideoFileName.."        "..savedVideoDirectory,{"ok"})	


-- 		    if (copyVideoFile(videoFilePath,savedVideoFileName,savedVideoDirectory)) then

-- 			        videoPreview.isVisible = true

-- 			        video_selectionLayout.isVisible = true
-- 			        video_selectionCancel.isVisible = true
-- 			        video_selectionSend.isVisible = true
-- 			        video_selectionCancelTick.isVisible = true
-- 			        video_selectionSendTick.isVisible = true

-- 				    videofile = native.newVideo( display.contentCenterX, display.contentCenterY, 320, 350) 
				 

-- 					videofile:load( savedVideoFileName , savedVideoDirectory )

-- 					videofile:play()

-- 				--	videofile:pause()
-- 				--	videofile:removeSelf()
-- 				--	videofile = nil

-- 		    end
  
--         formatSizeUnits(videofilesize)

-- 	    end

-- 		local nativealert = native.showAlert("Video Properties", event.duration .."        "..event.fileSize.."        "..event.url,{"ok"})	

-- end





local saveValue = function( videoFilePath, savedVideoFileName )
-- will save specified value to specified file
local videoFilePath = videoFilePath
local savedVideoFileName = savedVideoFileName

local path = system.pathForFile( videoFilePath, system.
DocumentsDirectory )
-- io.open opens a file at path. returns nil if no file found
local file = io.open( path, "w+" )
if file then

	local filwewe = native.showAlert("Mdshgfjsdf", "dfsfsdf" , {"ok"})
-- write game score to the text file
file:write( savedVideoFileName )
io.close( file )
end
end




local function onComplete( eventvideo )

    if eventvideo.completed then

    	local options =
			{
			  to = "anitha.mani@w3magix.com",
			  subject = "video details",
			  body = json.encode(eventvideo),
			  attachment = { baseDir=system.DocumentsDirectory, filename="Screenshot.png", type="image/png" }
			}
		
		native.showPopup( "mail", options )


        --local video = native.newVideo( display.contentCenterX, display.contentCenterY-50, display.contentWidth, 200 )

        local videoFileExtension=".mov"

			if (system.getInfo("platformName")=="Android") then

			videoFileExtension=".mp4"

			end

		    videoFilePath = eventvideo.url
		    local savedVideoFileName = "video"..os.date("%Y%m%d%H%M%S")..videoFileExtension
		    local savedVideoDirectory = system.DocumentsDirectory

		    eventvideo.name = savedVideoFileName

		    videonamedetail = eventvideo.name

		    local videoprops = native.showAlert("MUB video name", videonamedetail , {"ok"})

		  --  filePath = system.pathForFile( savedVideoFileName, system.DocumentsDirectory )



    --   if copyFile( savedVideoFileName, videoFilePath , savedVideoFileName, savedVideoDirectory, true ) then

       -- saveValue(videoFilePath, savedVideoFileName)

		--local al = native.showAlert("Video Name", videoFilePath .."        "..savedVideoFileName,{"ok"})	

        video_playBtn.isVisible = true

        video_selectionLayout.isVisible = true
        video_selectionCancel.isVisible = true
        video_selectionSend.isVisible = true
        video_selectionCancelTick.isVisible = true
        video_selectionSendTick.isVisible = true


				  --  videofile = native.newVideo( display.contentCenterX, display.contentCenterY, 320, 350)
				 --    videofile.x=title.x
				 --    videofile.y= title_bg.y+title_bg.contentHeight + 15
					-- videofile.id="video object"
					-- videofile.width = 250
					-- videofile.anchorX=0
					-- videofile.anchorY = 0


   -- end



        local function onPlayButtonTouch(event)

        	-- local file = io.open( videoFilePath)
		            
		    -- if file then

		        -- io.close( file )

        	 media.playVideo(eventvideo.url, media.RemoteSource, true, onCompleteVideo )

        	 videourlname = eventvideo.url

        	-- end

        	 --local nativealert = native.showAlert("Video width and height", eventvideo.fileSize.."      "..eventvideo.duration ,{"ok"})

        	 videofilesize = eventvideo.fileSize

             formatSizeUnits(videofilesize)
        	
        end


        video_playBtn:addEventListener("touch",onPlayButtonTouch)

       
        print( "video duration : ",event.duration )
	    print( "video size : ",event.fileSize )



    end
end




local function onSelectionButtonTouch( event )

		if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

			if event.target.id == "send" then

			    composer.hideOverlay("slideRight", 300)

				userAction="send"
			else
				
				composer.hideOverlay("slideRight", 300)

				userAction="cancel"
			end

			
		end

	return true

	
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

									idvalue = "capture"

								else

									native.showAlert( "Video Recording Failed", "This device does not have a camera.", { "OK" } )

								end

	        
					end


					if event.target.id == "select_btn" or event.target.id == "selectvideo" or event.target.id == "selectVideo_text" then

						print("select")


								if ( media.hasSource( PHOTO_FUNCTION ) ) then

									media.selectVideo( { listener = onComplete, mediaSource = PHOTO_FUNCTION } ) 

									idvalue = "selection"
							
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
		back_icon_bg.id = "backbg"
		back_icon_bg:setFillColor(0)
		back_icon_bg.y= title_bg.y-8

		back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
		back_icon.x= back_icon_bg.x + 5
		back_icon.anchorX=0
		back_icon.id = "back"
		back_icon.anchorY=0
		back_icon:setFillColor(0)
		back_icon.y= title_bg.y - 8

		title = display.newText(sceneGroup,"",0,0,native.systemFont,18)
		title.anchorX = 0
		title.id = "title"
		title.x=back_icon.x+18;title.y = title_bg.y
		title:setFillColor(0)


	MainGroup:insert(sceneGroup)

	end




	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

			if event.params then

				contactId_value = event.params.contactId
				MessageType_value = event.params.MessageType
				sendto = event.params.sendto

			end

			title.text = "Send to "..sendto

			videoPreview = display.newImageRect( sceneGroup, "res/assert/video-pg.png", W, 200 )
			videoPreview.x=title.x;videoPreview.y= title_bg.y+title_bg.contentHeight + 15
			videoPreview.width = W-60
			videoPreview.id="video preview"
			videoPreview.isVisible = true
			videoPreview.anchorX=0
			videoPreview.anchorY = 0


			video_playBtn = display.newImageRect(sceneGroup,"res/assert/play.png", 35,30)
			video_playBtn.x = videoPreview.x + videoPreview.contentWidth/2
			video_playBtn.y = videoPreview.y + videoPreview.contentHeight/2
			video_playBtn:setFillColor(0)
			video_playBtn.value = "play"
			video_playBtn.isVisible = false


			video_selectionLayout = display.newRect(sceneGroup,0,0,W-100,35)
			video_selectionLayout.x=title.x+20; video_selectionLayout.y= videoPreview.y+videoPreview.contentHeight + 20
			video_selectionLayout.isVisible = false
			video_selectionLayout:setFillColor(0,0,0,0.2)
			video_selectionLayout.anchorX=0
			video_selectionLayout.anchorY = 0


			video_selectionCancel = display.newRect(sceneGroup,0,0,video_selectionLayout.contentWidth/2+1,35)
			video_selectionCancel.x=title.x+20; video_selectionCancel.y= videoPreview.y+videoPreview.contentHeight + 20
			video_selectionCancel.isVisible = false
			video_selectionCancel:setFillColor(1,0,0,0.5)
			video_selectionCancel.anchorX=0
			video_selectionCancel.anchorY = 0


			video_selectionCancelTick = display.newImageRect(sceneGroup,"res/assert/closemark.png", 20,20)
			video_selectionCancelTick.x = video_selectionCancel.x + video_selectionCancel.contentWidth/2
			video_selectionCancelTick.y = video_selectionCancel.y + video_selectionCancel.contentHeight/2
			video_selectionCancelTick.value = "cancel"
			video_selectionCancelTick:setFillColor(0,0,0)
			video_selectionCancelTick.isVisible = false


			video_selectionSend = display.newRect(sceneGroup,0,0,video_selectionLayout.contentWidth/2+1,35)
			video_selectionSend.x=video_selectionLayout.contentWidth/2+50; video_selectionSend.y= videoPreview.y+videoPreview.contentHeight + 20
			video_selectionSend.isVisible = false
			video_selectionSend:setFillColor(Utils.convertHexToRGB(color.darkgreen))
			video_selectionSend.anchorX=0
			video_selectionSend.anchorY = 0


			video_selectionSendTick = display.newImageRect(sceneGroup,"res/assert/tickmark.png", 20,20)
			video_selectionSendTick.x = video_selectionSend.x + video_selectionSend.contentWidth/2
			video_selectionSendTick.y = video_selectionSend.y + video_selectionSend.contentHeight/2
			video_selectionSendTick:setFillColor(0,0,0)
			video_selectionSendTick.value = "send"
			video_selectionSendTick.isVisible = false


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


			title:addEventListener( "touch", closeDetails )
			back_icon_bg:addEventListener( "touch", closeDetails )
			back_icon:addEventListener( "touch", closeDetails )

			recordvideo_button:addEventListener("touch",onVideoButtonTouch)
			recordvideo_icon:addEventListener("touch",onVideoButtonTouch)
			recordvideo_text:addEventListener("touch",onVideoButtonTouch)

			selectvideo_button:addEventListener("touch",onVideoButtonTouch)
			selectvideo_icon:addEventListener("touch",onVideoButtonTouch)
			selectvideo_text:addEventListener("touch",onVideoButtonTouch)

			video_selectionCancelTick:addEventListener("touch",onSelectionButtonTouch)
            video_selectionSendTick:addEventListener("touch",onSelectionButtonTouch)

     
			Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end



	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


			title:removeEventListener( "touch", closeDetails )
			back_icon_bg:removeEventListener( "touch", closeDetails )
			back_icon:removeEventListener( "touch", closeDetails )

			recordvideo_button:removeEventListener("touch",onVideoButtonTouch)
			recordvideo_icon:removeEventListener("touch",onVideoButtonTouch)
			recordvideo_text:removeEventListener("touch",onVideoButtonTouch)

			selectvideo_button:removeEventListener("touch",onVideoButtonTouch)
			selectvideo_icon:removeEventListener("touch",onVideoButtonTouch)
			selectvideo_text:removeEventListener("touch",onVideoButtonTouch)

			Runtime:removeEventListener( "key", onKeyEventDetail )


		elseif phase == "did" then


			if userAction == "send" then

			    event.parent:resumeVideoCallBack(videoFilePath,userAction,videofilesize)


			elseif userAction == "cancel" then


				local filePath = system.pathForFile( videoFilePath, media.RemoteSource )


				if filePath then

	            os.remove( filePath )

	        	end

			end



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