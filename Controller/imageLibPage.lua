----------------------------------------------------------------------------------
--
-- img lib Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local mime = require("mime")
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
require( "Controller.genericAlert" )

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn
local List_array = {}
local position_array = {}
local imageArray = {}
local uploadArray = {}
local ImageUploadGroup = {}

local careerList_scrollview

local addEventBtn,UserId

local ImageLibListArray = {}

local PHOTO_FUNCTION = media.PhotoLibrary 

openPage="imageLibPage"

local BackFlag = false

local changeMenuGroup = display.newGroup();

local RecentTab_Topvalue = 70

local viewValue = "list" , tabBar ,title_bg

local gridArray = {}

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	UserId = row.UserId
	ContactId = row.ContactId
	MemberName = row.MemberName

end

local floatingButtonGroup = display.newGroup( )


local UserName = ""

local Imagename = ""

local Imagepath = ""

local Imagesize = ""

local MemberName = ""

local MessageType = ""


--------------------------------------------------


-----------------Function-------------------------


local function onTimer ( event )

	print( "event time completion" )

	BackFlag = false

end


local function onKeyEvent( event )

	local phase = event.phase
	local keyName = event.keyName

	if phase == "up" then

		if keyName=="back" then

			if BackFlag == false then


				Utils.SnackBar(ChatPage.PressAgain)

				BackFlag = true

				timer.performWithDelay( 2000, onTimer )

				return true

			elseif BackFlag == true then

				os.exit() 

			end
			
		end

	end

	return false
end





	function get_sendMssage(response)

			if image_name_png.isVisible == true and image_name_close.isVisible == true then

				image_name_png.isVisible = false 

				image_name_close.isVisible = false 

				sendBtn.isVisible = false

				sendBtn_bg.isVisible = false

				recordBtn.isVisible = true

			end	

		end





local function downloadAction(filename,file)

		local option ={
						{content=CommonWords.ok,positive=true},
					}
		genericAlert.createNew(file,  ResourceLibrary.Download_alert,option)



	--native.showAlert( file, ResourceLibrary.Download_alert, { CommonWords.ok} )

	local localpath = system.pathForFile( filename, system.DocumentsDirectory )
	
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
							
						end

						local function showShare(fileNameString)

							
							local popupName = "activity"
							local isAvailable = native.canShowPopup( popupName )
							local isSimulator = "simulator" == system.getInfo( "environment" )

							local items =
							{
								{ type = "image", value = { filename = fileNameString, baseDir = system.DocumentsDirectory } },
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
			    	
			            --native.showAlert( "Error", "Can't display the view controller. Are you running iOS 7 or later?", { "OK" } )
			            
			        end
			    end


			    local function share(fileName)



			    	print( "fileName : "..fileName )

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
		           	{ filename = fileName, baseDir = system.DocumentsDirectory },
		           },
		           
		           })
		    else
		    	
		            --native.showAlert( "Cannot send share message.", "Please setup your share account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		            
		        end

		    	--showShare(fileName)

		    end

		    local function listTouchAction( event)
		    	
		    	print( event.filename )


		    	local function networkListener( downloan_event )
		    		if ( downloan_event.isError ) then
		    		elseif ( downloan_event.phase == "began" ) then
		    			elseif ( downloan_event.phase == "ended" ) then
		    			spinner_hide()

		    			if event.id =="download" then
		    				
							--downloadAction(downloan_event.response.filename,event.filename)

							local function onComplete( event )

								--if event.action == "clicked" then

									local i = event

									if i == 1 then

										file = event.filename

										filename = downloan_event.response.filename

										local localpath = system.pathForFile( filename, system.DocumentsDirectory )
										
					local path = system.pathForFile("/storage/sdcard1/"..filename)    --External (SD Card)

					--------------------------- Read ----------------------------
					local file, reason = io.open( localpath, "r" )                              
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
								path = system.pathForFile("/storage/sdcard0/"..filename) -- internal
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
								--end
							end

								local option ={
												 {content=CommonWords.ok,positive=true},
											}
							genericAlert.createNew(filename, ResourceLibrary.Download_alert,option)


							--native.showAlert( filename, ResourceLibrary.Download_alert, { CommonWords.ok} )
							-- native.showAlert( filename, ResourceLibrary.SaveOptions_alert, {CommonWords.ok,CommonWords.cancel} , onComplete )

						end

					end

				end


					local option ={
							 {content=CommonWords.ok,positive=true},
							 {content=CommonWords.cancel,positive=true},
						}
						genericAlert.createNew(downloan_event.response.filename, ResourceLibrary.SaveOptions_alert,option,onComplete)


				--native.showAlert( downloan_event.response.filename, ResourceLibrary.SaveOptions_alert, {CommonWords.ok,CommonWords.cancel} , onComplete )


			elseif event.id =="share" then

				if isAndroid then

					share(downloan_event.response.filename)
					
				else

					showShare(downloan_event.response.filename)

				end

			end


		end
	end


	local destDir = system.DocumentsDirectory 
	local result, reason = os.remove( system.pathForFile( "imageLib.png", destDir ) )


	spinner_show()

	network.download(
		event.value,
		"GET",
		networkListener,
		event.value:match( "([^/]+)$" ),
		system.DocumentsDirectory
		)

end



local function listTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		listTouchAction(event.target)

	end

	return true
end



local function onRowRender_ImageLib( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    --local Lefticon = display.newImageRect(row,"res/assert/image-active.png",25,25)
    --Lefticon.x=30;Lefticon.y=rowHeight/2

    local Lefticon

    if List_array[row.index].FilePath ~= nil then

    	Lefticon = display.newImageRect(row,"res/assert/image_tump.png",35,35)
    	Lefticon.x=30;Lefticon.y=rowHeight/2
    	print( List_array[row.index].ImageFileName )


			local path = system.pathForFile( List_array[row.index].FilePath:match( "([^/]+)$" ),system.DocumentsDirectory)
			local fhd = io.open( path )

				
				-- Determine if file exists
				if fhd then

								if Lefticon then Lefticon:removeSelf();Lefticon=nil end

		    				Lefticon = display.newImage(row,List_array[row.index].FilePath:match( "([^/]+)$" ),system.DocumentsDirectory)
		    				Lefticon.width=45;Lefticon.height=38
		    				Lefticon.x=30;Lefticon.y=rowHeight/2
		    				--event.row:insert(img_event.target)

		    				local mask = graphics.newMask( "res/assert/masknew.png" )

		    				Lefticon:setMask( mask )

				else

			    		imageArray[#imageArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath,
			    		"GET",
			    		function ( img_event )
			    			if ( img_event.isError ) then
			    				print ( "Network error - download failed" )
			    			else
			    				--if Lefticon then Lefticon:removeSelf();Lefticon=nil end

			    				print("response file "..img_event.response.filename)
			    				Lefticon = display.newImage(row,img_event.response.filename,system.DocumentsDirectory)
			    				Lefticon.width=45;Lefticon.height=38
			    				Lefticon.x=30;Lefticon.y=rowHeight/2
			    				--event.row:insert(img_event.target)

			    				local mask = graphics.newMask( "res/assert/masknew.png" )

			    				Lefticon:setMask( mask )
			    			end

			    			end, List_array[row.index].FilePath:match( "([^/]+)$" ), system.DocumentsDirectory)

    		end
    else
    	Lefticon = display.newImageRect(row,"res/assert/image_tump.png",35,35)
    	Lefticon.x=30;Lefticon.y=rowHeight/2

    end


    local textname = display.newText(row,List_array[row.index].ImageFileName,0,0,native.systemFont,16)
    textname.x=Lefticon.x+Lefticon.contentWidth-5;textname.y=rowHeight/2
    textname.anchorX=0
    textname:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


	    if isIos then

	    	    if textname.text:len() > 20 then
						textname.text = textname.text:sub(1,20).."..."
			   	end

	    elseif isAndroid then

			    if textname.text:len() > 15 then
						textname.text = textname.text:sub(1,15).."..."
			   	end

	    end



    local seprate_bg = display.newRect(row,0,0,120,rowHeight)
    seprate_bg.anchorX=0
    seprate_bg.x=W/2+80;seprate_bg.y=rowHeight/2-1
    seprate_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


    local line = display.newRect(row,W/2,rowHeight/2,W,1.1)
    line.y=rowHeight-1.1
    line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


    local shareImg_bg = display.newRect(row,0,0,35,35)
    shareImg_bg.x=seprate_bg.x+25;shareImg_bg.y=seprate_bg.y
    shareImg_bg.id="share"
    shareImg_bg.alpha=0.01
    shareImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    shareImg_bg.filename = List_array[row.index].ImageFileName

    local shareImg = display.newImageRect(row,"res/assert/upload.png",15,15)
    shareImg.x=seprate_bg.x+25;shareImg.y=seprate_bg.y
    shareImg.id="share"
    shareImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    shareImg.filename = List_array[row.index].ImageFileName

    if isAndroid then

	    	local downImg_bg = display.newRect(row,0,0,25,25)
	    	downImg_bg.x=shareImg.x+30;downImg_bg.y=seprate_bg.y
	    	downImg_bg.id="download"
	    	downImg_bg.alpha=0.01
	    	downImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
	    	downImg_bg.filename = List_array[row.index].ImageFileName

	    	local downImg = display.newImageRect(row,"res/assert/download.png",15,15)
	    	downImg.x=shareImg.x+30;downImg.y=seprate_bg.y
	    	downImg.id="download"
	    	downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath

		    --work
		    downImg.filename = List_array[row.index].ImageFileName
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


row.ImageId = List_array[row.index].ImageId
row.FilePath = List_array[row.index].FilePath
addImageBg:toFront( );addEventBtn:toFront( );floatingButtonGroup:toFront( )

end




local function onRowTouch_ImageLib( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

	elseif ( "release" == phase ) then

		local options = {
			effect = "flip",
			time =100,
			params = { ImageList = List_array,count = row.index }
		}

		Runtime:removeEventListener( "key", onKeyEvent )

		composer.showOverlay( "Controller.imageSlideView", options )


	end

end




function scene:resumeGame()

	Runtime:addEventListener( "key", onKeyEvent )

end



------------------------------------------------------

local function BgTouch(event)
	

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			careerList_scrollview:takeFocus( event )
		end
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		
		if event.target.id == "hide" then

			if changeMenuGroup.isVisible == true then
				changeMenuGroup.isVisible=false
			else
				changeMenuGroup.isVisible=true
			end
		elseif event.target.id == "addimage" then

					local function hide( event )
						floatingButtonGroup.isVisible=false
					end

					addImageBg.alpha=0

					transition.to(addEventBtn, {time=200,rotation=0,width = addEventBtn.width + 5} )

					transition.to( floatingButtonGroup, {time=100,y=20,onComplete=hide} )

		end
	end

	return true

end




local function changeListmenuTouch(event)
	

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			careerList_scrollview:takeFocus( event )
		end
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		changeMenuGroup:toFront()
		
		if changeMenuGroup.isVisible == true then
			changeMenuGroup.isVisible=false
		else
			changeMenuGroup.isVisible=true
		end
	end

	return true

end




local function imageDetail(event)

	local phase = event.phase

	if ( "began" == phase ) then 

	elseif ( phase == "moved" ) then

		local dy = math.abs(( event.y - event.yStart ))

		if ( dy > 10 ) then

			careerList_scrollview:takeFocus( event )
		end

		elseif ( "ended" == phase )  then

		local imagecount

		imagecount = event.target.value

		print("imagecount ", imagecount)
		
		local options = {
			effect = "flip",
			time =100,
			params = { ImageList = List_array,count = imagecount }
		}

		Runtime:removeEventListener( "key", onKeyEvent )

		composer.showOverlay( "Controller.imageSlideView", options )

	end

	return true

end





local function Grid_list( gridlist)

	local rect_bg

	for j=1,#gridArray do 

		if gridArray[j] then gridArray[j]:removeSelf();gridArray[j] = nil	end

	end

	local processCount = 0

	tempYPos = 5

	for i=1,#List_array do

		gridArray[#gridArray+1] = display.newGroup()

		local tempGroup = gridArray[#gridArray]

		local Background = display.newRect(tempGroup,0,0,149,115)
		Background.x = W/2;
		Background.anchorY = 0
		Background.alpha = 0.01

		
		if processCount < 2  then

			
		else

			tempYPos = gridArray[#gridArray-1][1].y + gridArray[#gridArray-1][1].contentHeight + 9
			processCount=0

		end
		processCount= processCount +1 

		Background.y = tempYPos


		local rect, Lefticonimage, image_bg, image_name , seperate_imagebg, shareImage_bg, shareImage, downImg_bg, downImg

		if List_array[i].FilePath ~= nil then


			imageArray[#imageArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..""..List_array[i].FilePath,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else

						if i%2 == 0 then

							Background.x= W/2+W/4

					--Background.y = tempYPos - gridArray[#gridArray-1][1].contentHeight - 20
				else
					
					Background.x=W/4
				end

				rect = display.newRect(Background.x, Background.y + Background.contentHeight/2, 150, 115)
				rect:setFillColor(1,1,1,0) 
				rect:setStrokeColor(0.7) 
				rect.strokeWidth = 3
				tempGroup:insert(rect)

				print("response file "..img_event.response.filename)
				Lefticonimage = display.newImageRect(img_event.response.filename,system.DocumentsDirectory,150,115)
				tempGroup:insert(Lefticonimage)
				Lefticonimage.width=150;Lefticonimage.height=115
				Lefticonimage.x=Background.x;Lefticonimage.y=Background.y + Background.contentHeight/2 	
				Lefticonimage.value = i	
				Lefticonimage:addEventListener("touch",imageDetail)

				image_bg = display.newRect( Lefticonimage.x, Lefticonimage.y+40, Lefticonimage.width, Lefticonimage.height-90)
				image_bg:setFillColor( 0,0,0 )
				image_bg.alpha = 0.4
				image_bg.x = Lefticonimage.x
				image_bg.y = Lefticonimage.y+Lefticonimage.contentHeight/2-image_bg.contentHeight/2
				tempGroup:insert(image_bg)

				print(List_array[i].ImageFileName)

				local image_nameString = List_array[i].ImageFileName

				if string.len(List_array[i].ImageFileName) > 5 then

					image_nameString=string.sub(List_array[i].ImageFileName, 1, 5).."..."

				end

				image_name = display.newText(image_nameString,0,0,native.systemFont,16)
				image_name.x=image_bg.x-image_bg.contentWidth/2+ 5;image_name.y=image_bg.y
				image_name.anchorX=0
				image_name:setFillColor(Utils.convertHexToRGB(color.White))
				tempGroup:insert(image_name)

				seperate_imagebg = display.newRect(image_bg.x,image_bg.y,Lefticonimage.width- 70, image_bg.height)
				seperate_imagebg.anchorX=0
				seperate_imagebg.x=image_bg.x-image_bg.contentWidth/2+ 70
				seperate_imagebg.y=image_bg.y
				seperate_imagebg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
				tempGroup:insert(seperate_imagebg)

				shareImage_bg = display.newRect(image_bg.x,image_bg.y,27,25)
				shareImage_bg.x=seperate_imagebg.x+25;shareImage_bg.y=seperate_imagebg.y
				shareImage_bg.id="share"
				shareImage_bg.alpha=0.01
				shareImage_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[i].FilePath
				shareImage_bg.filename = List_array[i].ImageFileName
				tempGroup:insert(shareImage_bg)

				shareImage = display.newImageRect("res/assert/upload.png",17,17)
				shareImage.x=shareImage_bg.x
				shareImage.y=shareImage_bg.y
				shareImage.id="share"
				shareImage:setFillColor(Utils.convertHexToRGB(color.White))
				shareImage.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[i].FilePath
				shareImage.filename = List_array[i].ImageFileName
				tempGroup:insert(shareImage)


				if isAndroid then

					downImg_bg = display.newRect(image_bg.x,image_bg.y,27,25)
					downImg_bg.x=shareImage.x+30
					downImg_bg.y=seperate_imagebg.y
					downImg_bg.id="download"
					downImg_bg.alpha=0.01
					downImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[i].FilePath
					downImg_bg.filename = List_array[i].ImageFileName
					tempGroup:insert(downImg_bg)

					downImg = display.newImageRect("res/assert/download.png",17,17)
					downImg.x=shareImage_bg.x+30
					downImg.y=shareImage_bg.y
					downImg.id="download"
					downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[i].FilePath
					downImg.filename = List_array[i].ImageFileName
					tempGroup:insert(downImg)

					downImg:addEventListener("touch",listTouch)
					downImg_bg:addEventListener("touch",listTouch)

				else

					seperate_imagebg.width = seperate_imagebg.contentWidth/2
					seperate_imagebg.x=image_bg.x-image_bg.contentWidth/2+ 110
					shareImage_bg.x=seperate_imagebg.x+seperate_imagebg.contentWidth/2
					shareImage_bg.x=seperate_imagebg.x+seperate_imagebg.contentWidth/2
					shareImage.x=shareImage_bg.x+2
					shareImage.y=shareImage_bg.y

				end

				shareImage:addEventListener("touch",listTouch)
				shareImage_bg:addEventListener("touch",listTouch)

			end

			end, List_array[i].FilePath:match( "([^/]+)$" ), system.DocumentsDirectory)

else

	Lefticonimage = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",150,115)
	Lefticonimage.x=display.contentWidth/2;Lefticonimage.y=Background.y + Background.contentHeight/2 

end

careerList_scrollview:insert(tempGroup)

end
addImageBg:toFront( );addEventBtn:toFront( );floatingButtonGroup:toFront( )
end





local function touchBg(event)

	if event.phase == "began" then

		elseif event.phase == "ended" then

		native.setKeyboardFocus(nil)

	end

	return true

end




	local function onCloseTouch( event )
			
			 if event.phase == "began" then

					display.getCurrentStage():setFocus( event.target )

					native.setKeyboardFocus( nil )

			 elseif ( event.phase == "moved" ) then
		        

			 elseif event.phase == "ended" then
				    
				    display.getCurrentStage():setFocus( nil )

			        for j=ImageUploadGroup.numChildren, 1, -1 do 
						display.remove(ImageUploadGroup[ImageUploadGroup.numChildren])
						ImageUploadGroup[ImageUploadGroup.numChildren] = nil
				 	end

			  end

		   
		  return true

	end







function formatSizeUnits(event)

		if (event>=1073741824) then 

			size=(event/1073741824)..' GB'

			print("size of the image11 ",size)


		elseif (event>=1048576) then   

			size=(event/1048576)..' MB'

			print("size of the image 22",size)

			
		elseif (event > 10485760) then

			print("highest size of the image ",size)

				local option ={
							 {content=CommonWords.ok,positive=true},
						}
				genericAlert.createNew("Error in Image Upload", "Size of the image cannot be more than 10 MB",option)



			--local image = native.showAlert( "Error in Image Upload", "Size of the image cannot be more than 10 MB", { CommonWords.ok } )

			
		elseif (event>=1024)  then   

			size = (event/1024)..' KB'

			print("size of the image 33",size)

		else      

		end

end




		function get_Allimage(response)

			
				for j=#List_array, 1, -1 do 
					display.remove(List_array[#List_array])
					List_array[#List_array] = nil
				end


			List_array = response

			Image_Lib_list:deleteAllRows()

			if #List_array == 0  then
				NoEvent = display.newText( scene.view, ImageLibrary.NoImage, 0,0,0,0,native.systemFontBold,16)
				NoEvent.x=W/2;NoEvent.y=H/2
				NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
			end


			for i = 1, #List_array do
		    -- Insert a row into the tableView
		    Image_Lib_list:insertRow{ rowHeight = 40,rowColor = 
		    {
		    	default = { 1, 1, 1, 0 },
		    	over={ 1, 0.5, 0, 0 },

		    	}}
		    end
		end



	function get_imageupload(response)

	   print(json.encode(response))

	   if response == "Success" then

	   			local option ={
							 {content=CommonWords.ok,positive=true},
						}
						genericAlert.createNew(ImageLibrary.UploadImage, ImageLibrary.ImageUploaded,option)



		   	   --local a = native.showAlert(ImageLibrary.UploadImage,ImageLibrary.ImageUploaded,{CommonWords.ok})

		       Webservice.GET_ALL_MYUNITAPP_IMAGE(get_Allimage)

	           -- get_Allimage(response)

	    end

	end





local function selectionComplete ( event )


	      -- local options =
       --                                      {
       --                                         to = { "malarkodi.sellamuthu@w3magix.com"},
       --                                         subject = "file type",
       --                                         isBodyHtml = true,
       --                                         body = ""..json.encode(event),

       --                                      }

       --                                      native.showPopup( "mail", options )
	
	local photo = event.target

	   local baseDir = system.DocumentsDirectory

	   if photo then

	   	photo.x = display.contentCenterX
	   	photo.y = display.contentCenterY
	   	local w = photo.width
	   	local h = photo.height
	   	print( "w,h = ".. w .."," .. h )


		   local function rescale()
		   	
			   	if photo.width > W or photo.height > H then

			   		photo.width = photo.width/2
			   		photo.height = photo.height/2

			   		intiscale()

			   	else
			   		
			   		return false

			   	end
		   end



		   function intiscale()
		   	
			   	if photo.width > W or photo.height > H then

			   		photo.width = photo.width/2
			   		photo.height = photo.height/2

			   		rescale()

			   	else

			   		return false

			   	end

		   end


		   intiscale()

		   photoname = "image"..os.date("%Y%m%d%H%M%S")..".png"

		   display.save(photo,photoname,system.DocumentsDirectory)


		   local options =  {
		   	effect = "fromTop",
		   	time = 400,	
		   	params = {
		   		imageselected = photoname,
		   		image = photo,
		   		value = "ImageLibrary",
		   	}

		   }

		   composer.showOverlay("Controller.imagePreviewPage",options)

		   photo:removeSelf()

		   photo = nil


		   path = system.pathForFile( photoname, baseDir)

		   local size1 = lfs.attributes (path, "size")

		   local fileHandle = io.open(path, "rb")

		   file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		   io.close( fileHandle )

		  -- print("mime conversion ",file_inbytearray)

		   print("bbb ",size1)

		   formatSizeUnits(size1)

        	--sendImage()

        else

        end

    end







function scene:resumeImageCallBack(imagenamevalue,photoviewname,button_idvalue)

	    print("^&&&&&&&&&&& "..imagenamevalue)

			composer.removeHidden()

			local Image_Name

		     if imagenamevalue == "" or imagenamevalue == nil then

		     	Image_Name = photoviewname:match( "([^/]+)$" )

		     else

		     	Image_Name = imagenamevalue..".png"

		     end



		if button_idvalue == "send" then

	  		  Webservice.AddImageFromNativeAppImageLibrary(file_inbytearray,Image_Name,"Images",get_imageupload)

	    end


end




	local function uploadImageAction( event )
            
            if event.phase == "ended" then
			 	
			 		if event.target.id == "gallery" then

			 			local function hide( event )
								floatingButtonGroup.isVisible=false
							end

							addImageBg.alpha=0

							transition.to(addEventBtn, {time=200,rotation=0,width = event.target.width + 5} )

							transition.to( floatingButtonGroup, {time=100,y=20,onComplete=hide} )



			 			if media.hasSource( PHOTO_FUNCTION  ) then
							timer.performWithDelay( 500, function() media.selectPhoto( { listener = selectionComplete, mediaSource = PHOTO_FUNCTION } ) 
							end )
						end

			 		elseif event.target.id == "camera" then

			 			local function hide( event )
								floatingButtonGroup.isVisible=false
						end

							addImageBg.alpha=0

							transition.to(addEventBtn, {time=200,rotation=0,width = event.target.width + 5} )

							transition.to( floatingButtonGroup, {time=100,y=20,onComplete=hide} )


			 			if media.hasSource( media.Camera ) then
							timer.performWithDelay( 500, function() media.capturePhoto( { listener = selectionComplete, mediaSource = media.Camera } ) 
							end )
							end

		 		 	elseif event.target.id == "addEvent" then

						--event.target.rotation = 45

						if event.target.rotation >= 45 then

							addImageBg.alpha=0

							local function hide( event )
								floatingButtonGroup.isVisible=false
							end

							transition.to( event.target, {time=200,rotation=0,width = event.target.width+4,height = event.target.height-4} )


							transition.to( floatingButtonGroup, {time=100,y=20,onComplete=hide} )

							

						else

							addImageBg.alpha=0.5

							floatingButtonGroup.y=30

							transition.to( event.target, {time=200,rotation=45,width = event.target.width-4 ,height = event.target.height+4} )

							transition.to( floatingButtonGroup, {time=300,y=0,transition=easing.outBack} )

							floatingButtonGroup.isVisible=true

						end
					



		        -- local alert = native.showAlert(ImageLibrary.FileChoose, Message.FileSelectContent, {Message.FromGallery,Message.FromCamera,CommonWords.cancel} , onComplete)


			end

		end

		return true
		
	end



local function listPosition_change( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			careerList_scrollview:takeFocus( event )
		end
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		local function action()

			if viewValue == "list" then

				for j=1,#gridArray do 
					if gridArray[j] then gridArray[j]:removeSelf();gridArray[j] = nil	end
				end

				Image_Lib_list:deleteAllRows()

				Image_Lib_list:toFront()

				for i = 1, #List_array do
						    -- Insert a row into the tableView
						    Image_Lib_list:insertRow{ rowHeight = 40,rowColor = 
						    {
						    	default = { 1, 1, 1, 0 },
						    	over={ 1, 0.5, 0, 0 },

						    	}}
						    end

						else    

							if careerList_scrollview ~= nil then careerList_scrollview:toFront() end

							addEventBtn:toFront()
							floatingButtonGroup:toFront( )

							Image_Lib_list:deleteAllRows()

							Grid_list(List_array)		

						end
					end

					if event.target.id == "bg" then

					elseif event.target.id == "list" then
						changeMenuGroup.isVisible=false
						viewValue="list"
						action()

					elseif event.target.id == "grid" then
						changeMenuGroup.isVisible=false
						viewValue="grid"
						action()

					end
				end
				

				return true
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

				title = display.newText(sceneGroup,ImageLibrary.PageTitle,0,0,native.systemFont,18)
				title.anchorX = 0
				title.x=5;title.y = title_bg.y
				title:setFillColor(0)



				sceneGroup:insert( floatingButtonGroup )

				  addImageBg = display.newRect( W/2, H/2, W, H )
			    addImageBg.id="addimage"
			    addImageBg.alpha=0.01
			   sceneGroup:insert( addImageBg)
			    addImageBg.x=W/2;addImageBg.y=H/2
			    addImageBg:addEventListener( "touch", BgTouch )

				if IsOwner == true then



				addEventBtn = display.newImageRect( sceneGroup, "res/assert/add(gray).png", 76/1.6,76/1.9 )
				addEventBtn.x=W/2+W/3;addEventBtn.y=H-40;addEventBtn.id="addEvent"
				addEventBtn:addEventListener("touch",uploadImageAction)

			    end

			  

				fromGalleryIcon = display.newImageRect( floatingButtonGroup, "res/assert/gallery1.png", 76/1.6,76/2 )
				fromGalleryIcon.x=addEventBtn.x;fromGalleryIcon.y=addEventBtn.y-45;fromGalleryIcon.id="gallery"
				fromGalleryIcon:addEventListener("touch",uploadImageAction)

				local fromGalleryIconTipsRect = display.newRoundedRect( floatingButtonGroup, 0,0,80,25,2 )
				fromGalleryIconTipsRect.anchorX=1
				fromGalleryIconTipsRect.x=fromGalleryIcon.x-35
				fromGalleryIconTipsRect.y=fromGalleryIcon.y
				fromGalleryIconTipsRect:setFillColor( 0,0,0,0.7 )

				local fromGalleryIconTips = display.newText( floatingButtonGroup, "Gallery",0,0,native.systemFont,14 )
				fromGalleryIconTips.x=fromGalleryIconTipsRect.x-fromGalleryIconTipsRect.contentWidth/2
				fromGalleryIconTips.y=fromGalleryIconTipsRect.y
				

				fromCameraIcon = display.newImageRect( floatingButtonGroup, "res/assert/camera1.png", 76/1.6,76/2 )
				fromCameraIcon.x=fromGalleryIcon.x;fromCameraIcon.y=fromGalleryIcon.y-45;fromCameraIcon.id="camera"
				fromCameraIcon:addEventListener("touch",uploadImageAction)

				local fromCameraIconTipsRect = display.newRoundedRect( floatingButtonGroup, 0,0,80,25,2 )
				fromCameraIconTipsRect.anchorX=1
				fromCameraIconTipsRect.x=fromCameraIcon.x-35
				fromCameraIconTipsRect.y=fromCameraIcon.y
				fromCameraIconTipsRect:setFillColor( 0,0,0,0.7 )

				local fromCameraIconTips = display.newText( floatingButtonGroup, "Camera",0,0,native.systemFont,14 )
				fromCameraIconTips.x=fromCameraIconTipsRect.x-fromCameraIconTipsRect.contentWidth/2
				fromCameraIconTips.y=fromCameraIconTipsRect.y

				floatingButtonGroup.isVisible=false


				changeList_order_icon = display.newImageRect(sceneGroup,"res/assert/list.png",8/2,32/2)
				changeList_order_icon.x=W-20;changeList_order_icon.y=title_bg.y-10
				changeList_order_icon.anchorY=0

				changeList_order_touch = display.newRect(sceneGroup,changeList_order_icon.x,changeList_order_icon.y+15,35,35)
				changeList_order_touch.alpha=0.01
				changeList_order_touch:addEventListener("touch",changeListmenuTouch)

				careerList_scrollview = widget.newScrollView
				{
					top = RecentTab_Topvalue,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue,
					hideBackground = true,
					isBounceEnabled=false,
					bottomPadding = 10,
	--horizontalScrollingDisabled = false,
	--verticalScrollingDisabled = false,
}


sceneGroup:insert(careerList_scrollview)

listTouch_bg = display.newRect( changeMenuGroup, W/2, H/2, W, H )
listTouch_bg.alpha=0
listTouch_bg.id = "hide"

listBg = display.newRect(changeMenuGroup,W/2+110,changeList_order_icon.y+65,100,80)
listBg.strokeWidth = 1
listBg.id = "show"
listBg:setStrokeColor( 0, 0, 0 , 0.3)
listBg.id="bg"

list_Bylist_bg = display.newRect( changeMenuGroup, listBg.x-listBg.contentWidth/2+50, listBg.y-20, 100, 25 )
list_Bylist_bg:setFillColor( 0.4 )
list_Bylist_bg.alpha=0.01
list_Bylist_bg.id="list"

list_Bylist = display.newText(changeMenuGroup,ImageLibrary.List,0,0,native.systemFont,16)
list_Bylist.x=listBg.x-listBg.contentWidth/2+5;list_Bylist.y=listBg.y-20
list_Bylist.anchorX=0
list_Bylist:setFillColor(Utils.convertHexToRGB(color.Black))
list_Bylist.id="list"

list_ByGrid_bg = display.newRect( changeMenuGroup, listBg.x-listBg.contentWidth/2+50, listBg.y+20, 100, 25 )
list_ByGrid_bg.alpha=0.01
list_ByGrid_bg.id="grid"

list_ByGrid = display.newText(changeMenuGroup,ImageLibrary.Grid,0,0,native.systemFont,16)
list_ByGrid.x=listBg.x-listBg.contentWidth/2+5;list_ByGrid.y=listBg.y+20
list_ByGrid.anchorX=0
list_ByGrid:setFillColor(Utils.convertHexToRGB(color.Black))
list_ByGrid.id="grid"

changeMenuGroup.isVisible=false

listBg:addEventListener("touch",listPosition_change)
list_Bylist_bg:addEventListener("touch",listPosition_change)
list_ByGrid_bg:addEventListener("touch",listPosition_change)

listTouch_bg:addEventListener("touch",BgTouch)

sceneGroup:insert(changeMenuGroup)

MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then


	elseif phase == "did" then

		composer.removeHidden()

		ga.enterScene("Image Library")


					Image_Lib_list = widget.newTableView
			{
				left = 0,
				top = 75,
				height = H-75,
				width = W,
				onRowRender = onRowRender_ImageLib,
				onRowTouch = onRowTouch_ImageLib,
				hideBackground = true,
				isBounceEnabled = false,
				noLines = true,
			}

			sceneGroup:insert(Image_Lib_list)


		Webservice.GET_ALL_MYUNITAPP_IMAGE(get_Allimage)

		local function hide( event )
						floatingButtonGroup.isVisible=false
					end

					addImageBg.alpha=0

					transition.to(addEventBtn, {time=200,rotation=0,width = addEventBtn.width + 5} )

					transition.to( floatingButtonGroup, {time=100,y=20,onComplete=hide} )

		menuBtn:addEventListener("touch",menuTouch)
		BgText:addEventListener("touch",menuTouch)

		Runtime:addEventListener( "key", onKeyEvent )


	end	

	MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		composer.removeHidden()
		
		menuBtn:removeEventListener("touch",menuTouch)
		BgText:removeEventListener("touch",menuTouch)

		Runtime:removeEventListener( "key", onKeyEvent )


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