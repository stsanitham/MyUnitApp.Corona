----------------------------------------------------------------------------------
--
-- imageSlideView.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local Applicationconfig = require("Utils.ApplicationConfig")


local imageGroup = display.newGroup( )

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,BackBtn

local title_bg,BackBtn,title,imageslider_bg,seprate_bg,shareImg_bg,shareImg,downImg_bg,downImg

local imageTrans,SliderTimer,myImage
--------------------------------------------------


-----------------Function-------------------------

local function BgTouch( event )
	if event.phase == "ended" then


	end

return true
end


local function downloadAction(filename)

			local localpath = system.pathForFile( filename, system.TemporaryDirectory )
						
					local path = system.pathForFile("/storage/sdcard1/"..filename)                         -- Change this path to the path of an image on your computer
					------------------------------------------------------------------------
					--------------------------- Read ----------------------------
						local file, reason = io.open( localpath, "r" )                               -- Open the image in read mode
						local contents
						if file then
						    contents = file:read( "*a" )                                        -- Read contents
						    io.close( file )                                                    -- Close the file (Important!)
						else
						    print("Invalid path")
						    return
						end

					--------------------------- Write ----------------------------
	
						local file = io.open( path, "w" )                                    -- Open the destination path in write mode
		
							if file then
							    file:write(contents)                                                -- Writes the contents to a file
							    io.close(file)                                                      -- Close the file (Important!)
							else
								path = system.pathForFile("/storage/sdcard0/"..filename)
								local file = io.open( path, "w" )                                    -- Open the destination path in write mode
								if file then
								    file:write(contents)                                                -- Writes the contents to a file
								    io.close(file)                                                      -- Close the file (Important!)
								else
								   path = system.pathForFile("/storage/sdcard/"..filename)
									local file = io.open( path, "w" )                                    -- Open the destination path in write mode
									if file then
										file:write(contents)                                                -- Writes the contents to a file
										io.close(file)                                                      -- Close the file (Important!)
									else
									    print("Error")
									    return
									 end
								 end
							end

								native.showAlert( imageName.text, ResourceLibrary.Download_alert, { CommonWords.ok} )

end
			local function showShare(fileNameString)

				print( "fileNameString : "..fileNameString )

			    local popupName = "activity"
			    local isAvailable = native.canShowPopup( popupName )
			    local isSimulator = "simulator" == system.getInfo( "environment" )

			    local items =
			{
			    { type = "image", value = { filename = fileNameString, baseDir = system.TemporaryDirectory } },
			     --{ type = "UIActivityTypePostToFacebook", value = "UIActivityTypePostToFacebook" },
			      { type = "string", value = " " },

			}
						    -- If it is possible to show the popup
			    if isAvailable then
			        local listener = {}
			        function listener:popup( event )
			            print( "name(" .. event.name .. ") type(" .. event.type .. ") activity(" .. tostring(event.activity) .. ") action(" .. tostring(event.action) .. ")" )
			        end

			        -- Show the popup
			        native.showPopup( popupName,
			        {
			            items = items,
			            -- excludedActivities = { "UIActivityTypeCopyToPasteboard", },
			            listener = listener,
			            permittedArrowDirections={ "up", "down" }
			        })
			    else
			  
			           -- native.showAlert( "Error", "Can't display the view controller. Are you running iOS 7 or later?", { "OK" } )
			        
			    end
			end



	local function share(fileName)

		local isAvailable = native.canShowPopup( "social", "share" )

		    -- If it is possible to show the popup
		    if isAvailable then
		    	local listener = {}
		    	function listener:popup( event )

		    		 native.setKeyboardFocus(nil)

		       	end

		        -- Show the popup
		        native.showPopup( "social",
		        {
		            service = "share", -- The service key is ignored on Android.
		           -- message = "Images share test",
		            listener = listener,
		            image = 
		            {
		            { filename = fileName, baseDir = system.TemporaryDirectory },
		            },
		            
		            })
		    else
		 
		            --native.showAlert( "Cannot send share message.", "Please setup your share account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		       
		    end


end


local function BackTouch( event )
	if event.phase == "began" then

	elseif event.phase == "ended" then

					composer.hideOverlay( "slideRight", 300 )

	end
	return true

end

local function PausePlayAction(event)

if event.phase == "began" then

	elseif event.phase == "ended" then

			title_playBtn:removeSelf( );title_playBtn  = nil

			if event.target.value == "pause" then

				title_playBtn = display.newImageRect(MainGroup,"res/assert/play.png", 22/1.5,26/1.5)
				title_playBtn.value = "play"
				event.target.value =  "play"
				if SliderTimer then timer.pause( SliderTimer ) end


			else

				print( "start play" )

				title_playBtn = display.newImageRect(MainGroup,"res/assert/pause.png", 22/1.5,26/1.5)
				title_playBtn.value = "pause"
				event.target.value =  "pause"
				timer.resume( SliderTimer )

			end


			title_playBtn.x=W-25
			title_playBtn.y=title_bg.y

			 --title_playBtn:addEventListener( "touch", PausePlayAction )

	end
	return true

end

local function listTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

			event = event.target


					

						if event.id == "share" then
							if isAndroid then

								share(event.filename..".png")
								
							else

								showShare(event.filename..".png")

							end
						elseif event.id =="download" then
							downloadAction(event.filename..".png")


						end



	end

	return true
end



local function slideShow(filename)

						spinner_hide()

						if myImage ~= nil then myImage:removeSelf( );myImage=nil end

							shareImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..ImageList[indexValue].FilePath
   							shareImg_bg.filename = ImageList[indexValue].ImageFileName
   							shareImg.value=ApplicationConfig.IMAGE_BASE_URL..""..ImageList[indexValue].FilePath
    						shareImg.filename = ImageList[indexValue].ImageFileName

    						if downImg_bg then

    						downImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..ImageList[indexValue].FilePath
  							downImg_bg.filename = ImageList[indexValue].ImageFileName
 							downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..ImageList[indexValue].FilePath
   							downImg.filename = ImageList[indexValue].ImageFileName

   						end


						myImage = display.newImage( filename, system.TemporaryDirectory )
						myImage.anchorY=0
						myImage.y=110
						myImage.x=W/2;myImage.alpha=0

						imageGroup:insert( myImage )
						

						if myImage.width > myImage.height then
							myImage.height = 150
							myImage.width = W-60
							myImage.y=H/2-myImage.contentHeight/2

						else
							if myImage.height > H-110 then

								myImage.height = H-100
								myImage.width = W-60

							else
								myImage.y=H/2-myImage.contentHeight/2
							end

							if myImage.width > W-60 then
								myImage.width = W-60
							end

						end

						
						myImage.alpha = 0
						imageTrans = transition.to( myImage, { time=1000, alpha=1, tag="transTag" } )

						imageGroup:insert(myImage)

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

	BackBtn = display.newText(sceneGroup,"<",0,0,native.systemFont,24)
	BackBtn.x=20;BackBtn.y=tabBar.y+tabBar.contentHeight/2+12
	BackBtn:setFillColor(Utils.convertHexToRGB(color.Black))

	


	title = display.newText(sceneGroup,ImageLibrary.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=BackBtn.x+BackBtn.contentWidth/2+5;title.y = BackBtn.y
	title:setFillColor(0)


	title_playbg = display.newRect(sceneGroup,0,0,50,30)
    title_playbg.x=W-25
    title_playbg.y=title_bg.y
    title_playbg.id="share"
    title_playbg.alpha=0.01
    title_playbg.value="play"

	title_playBtn = display.newImageRect( sceneGroup, "res/assert/play.png", 22/1.5,26/1.5)
	title_playBtn.x=W-25
	title_playBtn.y=title_bg.y
	


	imageslider_bg = display.newRect(sceneGroup,0,0,W,30)
	imageslider_bg.x=W/2;imageslider_bg.y = title_bg.y+title_bg.contentHeight
	imageslider_bg:setFillColor( 0 )

	imageName = display.newText( sceneGroup, " ", 0, 0, native.systemFont, 14 )
	imageName.x=10;imageName.y=imageslider_bg.y
	imageName.anchorX=0

	 seprate_bg = display.newRect(sceneGroup,0,0,120,imageslider_bg.height)
    seprate_bg.anchorX=0
    seprate_bg.x=W/2+80;seprate_bg.y=imageslider_bg.y
    seprate_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

 	shareImg_bg = display.newRect(sceneGroup,0,0,30,30)
    shareImg_bg.x=seprate_bg.x+25;shareImg_bg.y=seprate_bg.y
    shareImg_bg.id="share"
    shareImg_bg.alpha=0.01
 

   shareImg = display.newImageRect(sceneGroup,"res/assert/upload.png",15,15)
    shareImg.x=seprate_bg.x+25;shareImg.y=seprate_bg.y
    shareImg.id="share"


   if isAndroid then

    downImg_bg = display.newRect(sceneGroup,0,0,25,25)
    downImg_bg.x=shareImg.x+30;downImg_bg.y=seprate_bg.y
    downImg_bg.id="download"
    downImg_bg.alpha=0.01


    downImg = display.newImageRect(sceneGroup,"res/assert/download.png",15,15)
    downImg.x=shareImg.x+30;downImg.y=seprate_bg.y
    downImg.id="download"

   downImg:addEventListener("touch",listTouch)
    downImg_bg:addEventListener("touch",listTouch)

	else

		seprate_bg.width = seprate_bg.contentWidth/2
		seprate_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
		shareImg_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
		shareImg.x=seprate_bg.x+seprate_bg.contentWidth/2

	end

	shareImg:addEventListener("touch",listTouch)
    shareImg_bg:addEventListener("touch",listTouch)

    title_playbg:addEventListener( "touch", PausePlayAction )
    Background:addEventListener( "touch", BgTouch )

	sceneGroup:insert( imageGroup )
	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			if event.params then
				--print(event.params.FilePath)

				ImageList = event.params.ImageList
				indexValue = event.params.count

	
		local function downloadAction( )

					spinner_show()

				local fileNameString 


					fileNameString = ImageList[indexValue].ImageFileName..".png"

			

					imageName.text = fileNameString

					local path = system.pathForFile( fileNameString, system.TemporaryDirectory )
					local fhd = io.open( path )

					if fhd then
						SliderTimer = timer.performWithDelay( 5000, onSlideTimer )

						if title_playbg.value == "play" then
							timer.pause( SliderTimer )
						end
					  slideShow(fileNameString)

					   fhd:close()
					else


				
						imageDownload = network.download(
						ApplicationConfig.IMAGE_BASE_URL..ImageList[indexValue].FilePath,
						"GET",
						function ( event )
						if ( event.isError ) then
							print( "Network error - download failed" )
							elseif ( event.phase == "began" ) then
								elseif ( event.phase == "ended" ) then
								print( "12323123" )
								SliderTimer = timer.performWithDelay( 5000, onSlideTimer )

								if title_playbg.value == "play" then
									timer.pause( SliderTimer )
								end

							slideShow(event.response.filename)

							

					end
		end		,
						fileNameString,
						system.TemporaryDirectory)
					end

					

					

		end


		function onSlideTimer( event )
		  	
		  	indexValue = indexValue + 1 

		  	if #ImageList < indexValue then
		  		indexValue=1
		  	end

		  	downloadAction()

		end

		

		
						
		downloadAction()
					

			end


			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)
			title:addEventListener("touch",BackTouch)
			BackBtn:addEventListener("touch",BackTouch)
		end	

		MainGroup:insert(sceneGroup)

	end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			if title_playBtn then title_playBtn:removeSelf( );title_playBtn=nil end

			elseif phase == "did" then

				spinner_hide()
				

				if imageTrans then transition.cancel( imageTrans );imageTrans=nil end
				if SliderTimer then timer.cancel( SliderTimer );SliderTimer=nil end


					--if myImage then myImage:removeSelf();myImage=nil end
					menuBtn:removeEventListener("touch",menuTouch)
					BgText:removeEventListener("touch",menuTouch)
					network.cancel(imageDownload)

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