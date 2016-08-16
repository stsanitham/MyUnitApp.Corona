----------------------------------------------------------------------------------
--
-- resource Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local lfs = require("lfs")
local mime = require("mime")
local json = require("json")
require( "Controller.genericAlert" )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage = "resourcePage"

local Category_Id,Category_Name1

local changeCategoryGroup = display.newGroup();

-- local CategoryId_value = "2640"

-- local Category_Name = "Uncategorized"

local Category_bg,Category_listBg,Category_List

local List_array = {}

local ResourceList_scrollview

local BackFlag = false

local doc_Name = ""; Doc_Byte = ""; Doc_TempFile = ""; Doc_SelectedOption = ""

local ResourceListArray = {}

local changeMenuGroup = display.newGroup();

local RecentTab_Topvalue = 70

local optionValue = "list" , tabBar , title_bg

local resourceGridArray = {}

local ResourceList_scrollview


--------------------------------------------------


-----------------Function-------------------------



local function showShare(fileNameString)


	local popupName = "quickLook"
	local isAvailable = native.canShowPopup( popupName )
	local isSimulator = "simulator" == system.getInfo( "environment" )

	local items =
	{
		{ type = "url", value = { filename = fileNameString, baseDir = system.DocumentsDirectory } },
			     --{ type = "UIActivityTypePostToFacebook", value = "UIActivityTypePostToFacebook" },
			     { type = "string", value = " " },

			 }
						    -- If it is possible to show the popup
						    if isAvailable then
						    	

						    	local popupOptions = 
						    	{
						        files =  -- Files you wish to load into the quick look preview
						        { 
						        	{ filename=fileNameString, baseDir=system.DocumentsDirectory },
						        	
						        },
						        startIndex = 1,  -- The file you wish to start the preview at; default is 1
						        listener = quickLookListener  -- Callback listener
						    }

						    -- Show the quick look popup
						    native.showPopup( "quickLook", popupOptions )

						else
							
			            --native.showAlert( "Error", "Can't display the view controller. Are you running iOS 7 or later?", { "OK" } )
			            
			        end
			    end

			    local function share(fileName)
			    	local isAvailable = native.canShowPopup( "social", "share" )

			    	print( "fileName : "..fileName )

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
		            --message = "Images share test",
		            listener = listener,
		            image = 
		            {
		            	{ filename = fileName, baseDir = system.DocumentsDirectory },
		            },
		            
		            })
		    else
		    	
		            --native.showAlert( "Cannot send share message.", "Please setup your share account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		            
		        end

		    end








		    local function listTouchAction( event)
		    	
		    	local tempreverse = string.find(string.reverse( event.value ),"%.")
		    	fileExt = event.value:sub( event.value:len()-tempreverse+2,event.value:len())

		    	local function networkListener( downloan_event )
		    		if ( downloan_event.isError ) then
		    		elseif ( downloan_event.phase == "began" ) then
		    			elseif ( downloan_event.phase == "ended" ) then
		    			spinner_hide()


		    			if event.id =="download" then

		    				local function onComplete( event )

		    					--if event.action == "clicked" then

		    						local i = event

		    						if i == 1 then

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
								end
							end

							local option ={
											 {content=CommonWords.ok,positive=true},
											}
							genericAlert.createNew(filename, ResourceLibrary.Download_alert,option)

							--native.showAlert( filename, ResourceLibrary.Download_alert, { CommonWords.ok} )
							-- native.showAlert( filename, ResourceLibrary.SaveOptions_alert, {CommonWords.ok,CommonWords.cancel} , onComplete )

					--	end

					end

				end


							local option ={
											 {content=CommonWords.ok,positive=true},
											 {content=CommonWords.cancel,positive=true}
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

	spinner_show()

	local destDir = system.DocumentsDirectory 
	local result, reason = os.remove( system.pathForFile( "imageLib.png", destDir ) )


	network.download(
		event.value,
		"GET",
		networkListener,
		event.filename,
		system.DocumentsDirectory
		)



end





local function uploadDocumentAction( event )
            
        if event.phase == "ended" then
				 
			 		 if event.target.id == "addResourceEvent" then

									    -- Options table for the overlay scene "pause.lua"
									local options = 
									{
									    effect = "slideRight",
									    time = 400,
									}

									-- By some method (a pause button, for example), show the overlay
								composer.showOverlay( "Controller.resourceFileList", options )

				     end

		end

		return true
		
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






local function imageDetail(event)

	local phase = event.phase

	if ( "began" == phase ) then 

	elseif ( phase == "moved" ) then

		local dy = math.abs(( event.y - event.yStart ))

		if ( dy > 10 ) then

			ResourceList_scrollview:takeFocus( event )
		end

		elseif ( "ended" == phase )  then

		local imagecount

		imagecount = event.target.value

		print("imagecount ", imagecount)

		system.openURL( List_array[imagecount].FP )

	end

	return true

end





local function ResourceGrid_list( gridlist)

	local rect_bg

	for j=1,#resourceGridArray do 

		if resourceGridArray[j] then resourceGridArray[j]:removeSelf();resourceGridArray[j] = nil	

		end

	end


	local processCount = 0

	tempYPos = 5

	for i=1,#List_array do

		resourceGridArray[#resourceGridArray+1] = display.newGroup()

		local tempGroup = resourceGridArray[#resourceGridArray]

		local Background = display.newRect(tempGroup,0,0,149,115)
		Background.x = W/2;
		Background.anchorY = 0
		Background:setFillColor(0,0,0,0.45 )
		Background.alpha = 1.01

		if processCount < 2  then
			
		else

			tempYPos = resourceGridArray[#resourceGridArray-1][1].y + resourceGridArray[#resourceGridArray-1][1].contentHeight + 9
			processCount=0

		end
		processCount= processCount +1 

		Background.y = tempYPos


		local rect, Lefticonimage, image_bg, image_name , seperate_imagebg, shareImage_bg, shareImage, downImg_bg, downImg, circle_bg


		local tempValue = List_array[i].FP

		local tempreverse = string.find(string.reverse( tempValue ),"%.")

		fileExt = tempValue:sub( tempValue:len()-tempreverse+2,tempValue:len())

		print( "file ext : "..fileExt )

		if fileExt == "png" or fileExt == "jpg" or fileExt == "jpeg" or fileExt == "gif" or fileExt == "bmp" or fileExt == "tif" or fileExt == "JPG" or fileExt == "JPEG" or fileExt == "BMP" or fileExt == "GIF" or fileExt == "PNG" or fileExt == "TIF" or fileExt == "TIFF" then

			tempValue="res/assert/image-active.png"

		elseif fileExt == "doc" or fileExt == "docx" or fileExt == "txt" or fileExt == "xls"  or fileExt == "xlsx" or fileExt == "ppt"  or fileExt == "pptx"  or fileExt == "xps"  or fileExt == "pps" or fileExt == "wma" or fileExt == "pub" or fileExt == "js" or fileExt == "swf" or fileExt == "xml" or fileExt == "html" or fileExt == "htm" or fileExt == "rtf"  then

			tempValue="res/assert/word-active.png"

		elseif fileExt == "pdf" then

			tempValue="res/assert/pdf-active.png"

		elseif fileExt == "mpg" or fileExt == "au" or fileExt == "aac" or fileExt == "aif" or fileExt == "gsm" or fileExt == "mid" or fileExt == "mp3" or fileExt == "rm"  or fileExt == "wav" then

			tempValue="res/assert/audio(white).png"
			
		elseif fileExt == "mpeg" or fileExt == "avi" then

			tempValue="res/assert/video.png"

		else

			tempValue="res/assert/image-active.png"

		end


		if i%2 == 0 then

			Background.x= W/2+W/4

		else
			
			Background.x=W/4

		end


		rect = display.newRect(Background.x, Background.y + Background.contentHeight/2, 149,115)
		rect:setFillColor(1,1,1,0) 
		rect:setStrokeColor(0.5) 
		rect.strokeWidth = 1
		tempGroup:insert(rect)

		circle_bg = display.newCircle(tempGroup,Background.x,Background.y+ 45, 35 )
		circle_bg.height = 60
		circle_bg:setFillColor( Utils.convertHexToRGB(color.primaryColor))

		print("response file "..tempValue)
		Lefticonimage = display.newImage(tempValue,40,40)

		if tempValue == "res/assert/audio(white).png" then

			Lefticonimage.width=25;Lefticonimage.height=25
			Lefticonimage:setFillColor(1,1,1,0.9)

		else
		    Lefticonimage.width=40;Lefticonimage.height=40
	    end

		Lefticonimage.x=Background.x
		Lefticonimage.y=Background.y + Background.contentHeight/2 - 13	
		Lefticonimage.value = i	
		tempGroup:insert(Lefticonimage)
		Lefticonimage:addEventListener("touch",imageDetail)

		image_bg = display.newRect( Lefticonimage.x, Lefticonimage.y+80, Background.width, 25)
		image_bg:setFillColor( 0,0,0 )
		image_bg.alpha = 0.4
		image_bg.x = Background.x
		image_bg.y = Background.y+102
		tempGroup:insert(image_bg)

		print(List_array[i].FN)

		local image_nameString = List_array[i].FN

		if string.len(List_array[i].FN) > 5 then

			image_nameString=string.sub(List_array[i].FN, 1, 5).."..."

		end

		image_name = display.newText(image_nameString,0,0,native.systemFont,16)
		image_name.x=image_bg.x-image_bg.contentWidth/2+ 5;image_name.y=image_bg.y
		image_name.anchorX=0
		image_name:setFillColor(Utils.convertHexToRGB(color.White))
		tempGroup:insert(image_name)

		seperate_imagebg = display.newRect(image_bg.x,image_bg.y,Background.width/2, 25)
		seperate_imagebg.anchorX=0
		seperate_imagebg.x=image_bg.x
		seperate_imagebg.y=image_bg.y
		seperate_imagebg:setFillColor(Utils.convertHexToRGB(color.primaryColor))
		tempGroup:insert(seperate_imagebg)

		shareImage_bg = display.newRect(image_bg.x,image_bg.y,27,25)
		shareImage_bg.x=seperate_imagebg.x+25;shareImage_bg.y=seperate_imagebg.y
		shareImage_bg.id="share"
		shareImage_bg.alpha=0.01
		shareImage_bg.value=List_array[i].FP
		shareImage_bg.filename = List_array[i].FN
		tempGroup:insert(shareImage_bg)

		shareImage = display.newImageRect("res/assert/upload.png",17,17)
		shareImage.x=shareImage_bg.x
		shareImage.y=shareImage_bg.y
		shareImage.id="share"
		shareImage:setFillColor(Utils.convertHexToRGB(color.White))
		shareImage.value=List_array[i].FP
		shareImage.filename = List_array[i].FN
		tempGroup:insert(shareImage)


		if isAndroid then

			downImg_bg = display.newRect(image_bg.x,image_bg.y,27,25)
			downImg_bg.x=shareImage.x+30
			downImg_bg.y=seperate_imagebg.y
			downImg_bg.id="download"
			downImg_bg.alpha=0.01
			downImg_bg.value=List_array[i].FP
			downImg_bg.filename = List_array[i].FN
			tempGroup:insert(downImg_bg)

			downImg = display.newImageRect("res/assert/download.png",17,17)
			downImg.x=shareImage_bg.x+30
			downImg.y=shareImage_bg.y
			downImg.id="download"
			downImg.value=List_array[i].FP
			downImg.filename = List_array[i].FN
			tempGroup:insert(downImg)

			downImg:addEventListener("touch",listTouch)
			downImg_bg:addEventListener("touch",listTouch)

		else

			seperate_imagebg.width = seperate_imagebg.contentWidth/2
			seperate_imagebg.x=image_bg.x-image_bg.contentWidth/2+ 112
			shareImage_bg.x=seperate_imagebg.x+seperate_imagebg.contentWidth/2
			shareImage_bg.x=seperate_imagebg.x+seperate_imagebg.contentWidth/2
			shareImage.x=shareImage_bg.x+2
			shareImage.y=shareImage_bg.y

		end

		shareImage:addEventListener("touch",listTouch)
		shareImage_bg:addEventListener("touch",listTouch)

		ResourceList_scrollview:insert(tempGroup)

	end

	addEventBtn:toFront( )

	changecategory_icon:toFront()

	addImageBg:toFront( )

end










local function listPosition_change( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			ResourceList_scrollview:takeFocus( event )
		end
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )


		if changeCategoryGroup.isVisible == true then

			changeCategoryGroup.isVisible = false

			transition.to( changecategory_icon, { time=300, x= -15 } )

		end


		local function action()

			if optionValue == "list" then

				for j=1,#resourceGridArray do 
					if resourceGridArray[j] then resourceGridArray[j]:removeSelf();resourceGridArray[j] = nil	end
				end

				Document_Lib_list:deleteAllRows()

				Document_Lib_list:toFront()

				for i = 1, #List_array do
						    -- Insert a row into the tableView
						    Document_Lib_list:insertRow{ rowHeight = 45,rowColor = 
						    {
						    	default = { 1, 1, 1, 0 },
						    	over={ 1, 0.5, 0, 0 },

						    	}}
						    end

						else    

							if ResourceList_scrollview ~= nil then ResourceList_scrollview:toFront() end

							addEventBtn:toFront()

							changecategory_icon:toFront()

							Document_Lib_list:deleteAllRows()

							ResourceGrid_list(List_array)		

						end
					end

					if event.target.id == "bg" then

					elseif event.target.id == "list" then
						changeMenuGroup.isVisible=false
						optionValue="list"
						action()

					elseif event.target.id == "grid" then
						changeMenuGroup.isVisible=false
						optionValue="grid"
						action()

					end
				end
				
		return true
end








local function onRowRenderCategoryList( event )

 local row = event.row

    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    print("**************** "..Category_array[row.index].MyDocumentCategoryName.."   "..Category_array[row.index].MyDocumentCategoryId)


    local textname = display.newText(row,Category_array[row.index].MyDocumentCategoryName,0,0,native.systemFont,15)
   -- textname.x= Category_listBg.x + Category_listBg.contentWidth/2 + 10;textname.y=Category_listBg.y + 5
    textname.anchorX = 0
    textname.anchorY=0
    textname.x = 5
    textname.y = rowHeight * 0.2
    textname:setFillColor(Utils.convertHexToRGB(color.primaryColor))


	    if isIos then

	    	    if textname.text:len() > 20 then
						textname.text = textname.text:sub(1,20).."..."
			   	end

	    elseif isAndroid then

			    if textname.text:len() > 15 then
						textname.text = textname.text:sub(1,15).."..."
			   	end

	    end


    local line = display.newRect(row,W/2,rowHeight/2,W,1.1)
    line.y=rowHeight-1.1
    line:setFillColor(0,0,0,0.3)

    row.categoryid = Category_array[row.index].MyDocumentCategoryId
    row.categoryname = Category_array[row.index].MyDocumentCategoryName


    Category_Id = row.categoryid
    Category_Name1 = row.categoryname

end





local function GetCategoryList( CategoryId_value,Category_Name_Value )

			print("Category_Name_Value : "..Category_Name_Value)

			title.text = ResourceLibrary.PageTitle.." - "..Category_Name_Value


		    addImageBg.alpha=0

		    changecategory_icon:toFront()

            transition.to( changeCategoryGroup, { time=100, x= -15 } )
            transition.to( changecategory_icon, { time=100, x= -15 } )


       local function getDocumentLibByCategoryId(response)

			-- for j=#List_array, 1, -1 do 
			-- 	display.remove(List_array[#List_array])
			-- 	List_array[#List_array] = nil
			-- end

			List_array = response

			       	if optionValue == "list" then

							for j=1,#resourceGridArray do 
								if resourceGridArray[j] then resourceGridArray[j]:removeSelf();resourceGridArray[j] = nil	end
							end

							Document_Lib_list:deleteAllRows()

							Document_Lib_list:toFront()

							changecategory_icon:toFront()

							for i = 1, #List_array do
						    -- Insert a row into the tableView
						    Document_Lib_list:insertRow{ rowHeight = 40,rowColor = 
						    {
						    	default = { 1, 1, 1, 0 },
						    	over={ 1, 0.5, 0, 0 },
						    	}}
						    end		

					else    

							if careerList_scrollview ~= nil then careerList_scrollview:toFront() end

							addEventBtn:toFront()

							Document_Lib_list:deleteAllRows()

							ResourceGrid_list(List_array)		

					end


					-- if #List_array == 0 then

					-- 		NoEvent = display.newText( scene.view, ResourceLibrary.NoDocument, 0,0,0,0,native.systemFontBold,16)
					-- 		NoEvent.x=W/2;NoEvent.y=H/2
					-- 		NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

					-- end

		end


		Webservice.GetDocumentibByCategoryId(CategoryId_value,getDocumentLibByCategoryId)

end




local function onRowTouchCategoryList( event )

	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

	elseif ( "release" == phase ) then

		print(" &&&&&&&&&&&&&&&&&&&&&& categoryid &&&&&&&&&&&&&&&&&&&&& "..row.categoryid)

		if changeMenuGroup.isVisible == true then

			changeMenuGroup.isVisible = false

		end


		CategoryId_value = Category_array[row.index].MyDocumentCategoryId

		Category_Name_Value = Category_array[row.index].MyDocumentCategoryName

		title.text = ResourceLibrary.PageTitle.." - "..Category_Name_Value

		GetCategoryList(CategoryId_value,Category_Name_Value)


	end

end





local function onRowRender_DocLib( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth


    local tempValue = List_array[row.index].FP

    local tempreverse = string.find(string.reverse( tempValue ),"%.")

    fileExt = tempValue:sub( tempValue:len()-tempreverse+2,tempValue:len())

    print( "file ext : "..fileExt )

    if fileExt == "png" or fileExt == "jpg" or fileExt == "jpeg" or fileExt == "gif" or fileExt == "bmp" or fileExt == "tif" or fileExt == "JPG" or fileExt == "JPEG" or fileExt == "BMP" or fileExt == "GIF" or fileExt == "PNG" or fileExt == "TIF" or fileExt == "TIFF" then

    	tempValue="res/assert/image-active.png"

    elseif fileExt == "doc" or fileExt == "docx" or fileExt == "txt" or fileExt == "xls"  or fileExt == "xlsx" or fileExt == "ppt"  or fileExt == "pptx"  or fileExt == "xps"  or fileExt == "pps" or fileExt == "wma" or fileExt == "pub" or fileExt == "js" or fileExt == "swf" or fileExt == "xml" or fileExt == "html" or fileExt == "htm" or fileExt == "rtf"  then

    	tempValue="res/assert/word-active.png"

    elseif fileExt == "pdf" then

    	tempValue="res/assert/pdf-active.png"

    elseif fileExt == "mpg" or fileExt == "au" or fileExt == "aac" or fileExt == "aif" or fileExt == "gsm" or fileExt == "mid" or fileExt == "mp3" or fileExt == "rm"  or fileExt == "wav" or fileExt == "ogg" then

    	tempValue="res/assert/audio.png"
    	
    elseif fileExt == "mpeg" or fileExt == "avi" then

    	tempValue="res/assert/video.png"

    else

    	tempValue="res/assert/image-active.png"

    end

    local Lefticon = display.newImageRect(row,tempValue,25,25)
    Lefticon.x=30;Lefticon.y=rowHeight/2


    local textname = display.newText(row,List_array[row.index].FN,0,0,native.systemFont,16)
    textname.x=Lefticon.x+Lefticon.contentWidth/2+10;textname.y=rowHeight/2
    textname.anchorX=0
    textname:setFillColor(Utils.convertHexToRGB(color.Black))


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
    seprate_bg:setFillColor(Utils.convertHexToRGB(color.primaryColor))


    local shareImg_bg = display.newRect(row,0,0,50,35)
    shareImg_bg.x=seprate_bg.x+25;shareImg_bg.y=seprate_bg.y
    shareImg_bg.id="share"
    shareImg_bg.alpha=0.01
    shareImg_bg.value=List_array[row.index].FP
    shareImg_bg.filename = List_array[row.index].FN

    local shareImg = display.newImageRect(row,"res/assert/upload.png",15,15)
    shareImg.x=seprate_bg.x+25;shareImg.y=seprate_bg.y
    shareImg.id="share"
    shareImg.value=List_array[row.index].FP
    shareImg.filename = List_array[row.index].FN


    if isAndroid then

    	local downImg_bg = display.newRect(row,0,0,45,35)
    	downImg_bg.x=shareImg_bg.x+shareImg_bg.contentWidth/2+downImg_bg.contentWidth/2;downImg_bg.y=seprate_bg.y
    	downImg_bg.id="download"
    	downImg_bg.alpha=0.01
    	downImg_bg.value=List_array[row.index].FP
    	downImg_bg.filename = List_array[row.index].FN

    	local downImg = display.newImageRect(row,"res/assert/download.png",15,15)
    	downImg.x=shareImg.x+40;downImg.y=seprate_bg.y
    	downImg.id="download"
    	--downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    	downImg.value=List_array[row.index].FP
    	--downImg.filename =  List_array[row.index].DocumentFileName
    	downImg.filename =  List_array[row.index].FN


    	local line = display.newRect(row,W/2,rowHeight/2,W+30,1.1)
    	line.y=rowHeight-1.1
    	line:setFillColor(Utility.convertHexToRGB(color.LtyGray))

    	downImg:addEventListener("touch",listTouch)
    	downImg_bg:addEventListener("touch",listTouch)
    	
    else

    	seprate_bg.width = seprate_bg.contentWidth/2
    	seprate_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
    	shareImg_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
    	shareImg.x=seprate_bg.x+seprate_bg.contentWidth/2
    end

    shareImg_bg:addEventListener("touch",listTouch)
    shareImg:addEventListener("touch",listTouch)

    addEventBtn:toFront()

    changecategory_icon:toFront()

    addImageBg:toFront( )


    row.ImageId = List_array[row.index].CatId
    row.FilePath = List_array[row.index].FP
    row.fileName = List_array[row.index].FN

end




local function onRowTouch_DocLib( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

		system.openURL( row.FilePath )

	elseif ( "release" == phase ) then

	end

end

------------------------------------------------------


local function BgTouch(event)
	

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			ResourceList_scrollview:takeFocus( event )
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

					addImageBg.alpha=0

					if changeCategoryGroup.isVisible == true then

						changeCategoryGroup.isVisible = false

						transition.to( changecategory_icon, { time=100, x= -15 } )

					end


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
			ResourceList_scrollview:takeFocus( event )
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





function get_allDocument(response)
		
		for j=#List_array, 1, -1 do 
			display.remove(List_array[#List_array])
			List_array[#List_array] = nil
		end


		List_array = response

		Document_Lib_list:deleteAllRows()

		if #List_array == 0  then
			NoEvent = display.newText( scene.view, ResourceLibrary.NoDocument, 0,0,0,0,native.systemFontBold,16)
			NoEvent.x=W/2;NoEvent.y=H/2
			NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
		end


		for i = 1, #List_array do
	    -- Insert a row into the tableView
	    Document_Lib_list:insertRow{ rowHeight = 40,rowColor = 
	    {
	    	default = { 1, 1, 1, 0 },
	    	over={ 1, 0.5, 0, 0 },

	    	}}
	    end

end




function get_documentupload(response)

   if response == "Success" then


   	       local function onResponseComplete( event )
	       	
				local i = event

				if i == 1 then

					-- Webservice.GET_ALL_MYUNITAPP_DOCUMENT(get_allDocument)



				       local function getDocumentLibByCategoryId(response)

							-- for j=#List_array, 1, -1 do 
							-- 	display.remove(List_array[#List_array])
							-- 	List_array[#List_array] = nil
							-- end

							List_array = response

							title.text = ResourceLibrary.PageTitle.." - "..Category_Name_Value


							       	if optionValue == "list" then

											for j=1,#resourceGridArray do 
												if resourceGridArray[j] then resourceGridArray[j]:removeSelf();resourceGridArray[j] = nil	end
											end


											Document_Lib_list:deleteAllRows()

											Document_Lib_list:toFront()

											for i = 1, #List_array do
													    -- Insert a row into the tableView
													    Document_Lib_list:insertRow{ rowHeight = 40,rowColor = 
													    {
													    	default = { 1, 1, 1, 0 },
													    	over={ 1, 0.5, 0, 0 },

													    	}}
													    end

									else    

														if careerList_scrollview ~= nil then careerList_scrollview:toFront() end

														addEventBtn:toFront()

														Document_Lib_list:deleteAllRows()

														ResourceGrid_list(List_array)		

									end


						end



						Webservice.GetDocumentibByCategoryId(CategoryId_value,getDocumentLibByCategoryId)


				end

		    end



   			local option 

   			option = {
					 {content=CommonWords.ok,positive=true},
					 }

			genericAlert.createNew(ResourceLibrary.DocumentUpload,ResourceLibrary.DocumentUploaded,option,onResponseComplete)


    end

end




function scene:resumeDocumentCallBack(doc_Name,Doc_bytearray,button_idvalue)

		composer.removeHidden()

		if button_idvalue == "Add" then

	  		  Webservice.AddDocumentFromNativeAppDocumentLibrary(CategoryId_value,Doc_bytearray,doc_Name,"Docs",get_documentupload)

	    end


end





local LEFT = 0
local CENTER = display.contentCenterX
local RIGHT = display.contentWidth - 150


local function handleSwipe( event )
    if ( event.phase == "moved" ) then
        local dX = event.x - event.xStart
        print( event.x, event.xStart, dX )
        if ( dX > 10 ) then
            --swipe right
            local spot = RIGHT
            if ( event.target.x == LEFT ) then
                spot = CENTER
            end

            changeCategoryGroup:toFront()
            addImageBg.alpha=0.3
            changeCategoryGroup.isVisible = true
            transition.to( changeCategoryGroup, { time=500, x=spot,transition=easing.outQuart } )
            transition.to( event.target, { time=480, x=spot,transition=easing.outQuart } )


			      	   	local function getCategoryList( response )

									-- for j=#Category_array, 1, -1 do 
									-- 	display.remove(Category_array[#Category_array])
									-- 	Category_array[#Category_array] = nil
									-- end

								    Category_array = response

									Category_List:deleteAllRows()

									Category_List:toFront()


									if #Category_array == 0  then
										NoEvent = display.newText( scene.view, "No Categories Found", 0,0,0,0,native.systemFontBold,16)
										NoEvent.x=W/2;NoEvent.y=H/2
										NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
									end


					       			 print(" ************* Category List ************* " ,json.encode(Category_array))


									for i = 1, #Category_array do
								    -- Insert a row into the tableView
								    Category_List:insertRow{ rowHeight = 36,rowColor = 
							        {
							    	default = { 1, 1, 1, 0 },
							    	over={ 1, 0.5, 0, 0 },

							    	}}

								    end



					    end

				        Webservice.GetDocumentLibraryCategory(getCategoryList)


        elseif ( dX < -5 ) then
            --swipe left
            local spot = LEFT - 15
            if ( event.target.x == RIGHT ) then
                spot = LEFT - 15
            end

            addImageBg.alpha=0

            transition.to( changeCategoryGroup, { time=300, x=spot } )
            transition.to( event.target, { time=300, x=spot } )
        end
    end
    return true
end
 







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

				timer.performWithDelay( 3000, onTimer )

				return true

			elseif BackFlag == true then

				os.exit() 

			end
			
		end

	end

	return false
end





function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,ResourceLibrary.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


	addImageBg = display.newRect( W/2, H/2, W, H )
	addImageBg.id="addimage"
	addImageBg.alpha=0.01
	sceneGroup:insert( addImageBg)
	addImageBg.x=W/2;addImageBg.y=H/2
	addImageBg:addEventListener( "touch", BgTouch )



	if IsOwner == true then

		addEventBtn = display.newImageRect( sceneGroup, "res/assert/add(gray).png", 66/1.5,66/1.7 )
		addEventBtn.x=W/2+W/3;addEventBtn.y=H-40;addEventBtn.id="addResourceEvent"
		addEventBtn:addEventListener("touch",uploadDocumentAction)

	end


	----------------------------------------------     icon for category selection     ----------------------------------------------------


				changecategory_icon = display.newImageRect(sceneGroup,"res/assert/semicircle.png",45,55)
				changecategory_icon.x= -15;changecategory_icon.y=H/2 + 10
				changecategory_icon.anchorX = 0
				changecategory_icon.anchorY=0
				changecategory_icon.isVisible = true
				changecategory_icon:addEventListener("touch",handleSwipe)

				changecategory_icon:toFront()

				changecategory_touch = display.newRect(sceneGroup,changecategory_icon.x,changecategory_icon.y+23,50,55)
				changecategory_touch.alpha=1
				changecategory_touch.anchorX = 0
				changecategory_touch.isVisible = false
				changecategory_touch.anchorY = 0
				changecategory_touch:addEventListener("touch",handleSwipe)


----------------------------------------------------------------------------------------------------------------------------------------

				---Category List---


			   	Category_bg = display.newRect( changeCategoryGroup, W/2+7,title_bg.y-10+90,185,H-RecentTab_Topvalue )
			   	Category_bg.x = -170
			   	Category_bg.anchorX = 0
			   	Category_bg.y = RecentTab_Topvalue
			   	Category_bg.anchorY = 0
			  	Category_bg.id = "hide"
			  	Category_bg:setFillColor( 0 )


			    Category_listBg = display.newRect(changeCategoryGroup,W/2+7,title_bg.y-10+90,185,H-RecentTab_Topvalue)
				Category_listBg.strokeWidth = 1
				Category_listBg.width = 185
				Category_listBg.height = H-RecentTab_Topvalue
				Category_listBg.x = -170
			   	Category_listBg.anchorX = 0
			   	Category_listBg.anchorY = 0
			   	Category_listBg.y = RecentTab_Topvalue+0.5
				Category_listBg.id = "hide"
				--Category_listBg:setFillColor(255/255,182/255,193/255,0.5)
				--Category_listBg:setFillColor(238/255,77/255,109/255,0.3)
				Category_listBg:setFillColor(0.9,0.7,0.8)
				Category_listBg:setStrokeColor( 0, 0, 0 , 0.3)



				Category_titlebg = display.newRect( changeCategoryGroup, W/2+7,RecentTab_Topvalue,185,30 )
			   	Category_titlebg.x = -170
			   	Category_titlebg.anchorX = 0
			   	Category_titlebg.y = RecentTab_Topvalue
			   	Category_titlebg.anchorY = 0
			  	Category_titlebg.id = "hide"
			  	Category_titlebg:setFillColor( Utils.convertHexToRGB(color.tabbar) )


			  	Category_title = display.newText(changeCategoryGroup,"Categories",0,0,native.systemFont,16)
				Category_title.anchorX = 0
				Category_title.x=Category_titlebg.x+5;Category_title.y = Category_titlebg.y+Category_titlebg.height/2 - 10
				Category_title.anchorY = 0
				Category_title:setFillColor(0)


				-- Category_nocontent = display.newText(changeCategoryGroup,"No Categories",0,0,native.systemFont,16)
				-- Category_nocontent.anchorX = 0
				-- Category_nocontent.x=Category_listBg.width/2;Category_nocontent.y = Category_listBg.height/2
				-- Category_nocontent.anchorY = 0
				-- Category_nocontent.isVisible = true
				-- Category_nocontent:setFillColor(0)



			  	Category_List = widget.newTableView(
			  	{
					left = -170,
  		  			top = RecentTab_Topvalue+30,
  		  			height = H-RecentTab_Topvalue-30,
  		  			width = 185,
			  		onRowRender = onRowRenderCategoryList,
			  		onRowTouch = onRowTouchCategoryList,
			  		hideBackground = true,
			  		isBounceEnabled = false,
			  		noLines = true,
				    -- listener = scrollListener
				})



			  	changeCategoryGroup:insert(Category_List)
			  	Category_List.id = "hide"
			  	Category_bg.anchorY = 0
			  	--Category_bg.isVisible = false

			  	changeCategoryGroup.isVisible=false


----------------------------------------------------------------------------------------------------------------------------------





	changeList_order_icon = display.newImageRect(sceneGroup,"res/assert/list.png",8/2,32/2)
	changeList_order_icon.x=W-20;changeList_order_icon.y=title_bg.y-10
	changeList_order_icon.anchorY=0


	changeList_order_touch = display.newRect(sceneGroup,changeList_order_icon.x,changeList_order_icon.y+15,35,35)
	changeList_order_touch.alpha=0.01
	changeList_order_touch:addEventListener("touch",changeListmenuTouch)


	ResourceList_scrollview = widget.newScrollView
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

	sceneGroup:insert(ResourceList_scrollview)


	listTouch_bg = display.newRect( changeMenuGroup, W/2, H/2, W, H )
	listTouch_bg.alpha=0.01
	listTouch_bg.id = "hide"

	listBg = display.newRect(changeMenuGroup,W/2+110,changeList_order_icon.y+65,100,80)
	listBg.strokeWidth = 1
	listBg.id = "show"
	listBg:setStrokeColor( 0, 0, 0 , 0.3)
	listBg.id="bg"

	list_Bylist_bg = display.newRect( changeMenuGroup, listBg.x-listBg.contentWidth/2+50, listBg.y-20, 100, 25 )
	--list_Bylist_bg:setFillColor( 0,0,0,0.4 )
	list_Bylist_bg.alpha=0.01
	list_Bylist_bg.id="list"

	list_Bylist = display.newText(changeMenuGroup,ImageLibrary.List,0,0,native.systemFont,16)
	list_Bylist.x=listBg.x-listBg.contentWidth/2+5;list_Bylist.y=listBg.y-20
	list_Bylist.anchorX=0
	list_Bylist:setFillColor(Utils.convertHexToRGB(color.Black))
	list_Bylist.id="list"

	list_ByGrid_bg = display.newRect( changeMenuGroup, listBg.x-listBg.contentWidth/2+50, listBg.y+20, 100, 25 )
	list_ByGrid_bg.alpha=0.01
	--list_ByGrid_bg:setFillColor(0,0,0,0.3)
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

		ga.enterScene("Resource Library")


				Document_Lib_list = widget.newTableView
		
				{
					left = -10,
					top = 75,
					height = H-75,
					width = W+10,
					onRowRender = onRowRender_DocLib,
					onRowTouch = onRowTouch_DocLib,
					hideBackground = true,
					isBounceEnabled = false,
					--noLines = true,
				}

				sceneGroup:insert(Document_Lib_list)

			
				--Webservice.GET_ALL_MYUNITAPP_DOCUMENT(get_allDocument)


			-- local Category_Name = "Uncategorized"

		 --    title.text = ResourceLibrary.PageTitle.." - "..Category_Name

		 --    GetCategoryList(CategoryId_value,Category_Name)


		 local Category_Name

	      	   	local function getCategoryList( response )

						    Category_array = response

						    print(json.encode(Category_array))

							Category_List:deleteAllRows()

							Category_List:toFront()


							if #Category_array == 0  then
								NoEvent = display.newText( scene.view,ResourceLibrary.NoDocument, 0,0,0,0,native.systemFontBold,16)
								NoEvent.x=W/2;NoEvent.y=H/2
								NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
							end


			        print(" ************* Category List in show ************* " ,#Category_array)


							for i = 1, #Category_array do
						    -- Insert a row into the tableView
						    Category_List:insertRow{ rowHeight = 36,rowColor = 
					        {
					    	default = { 1, 1, 1, 0 },
					    	over={ 1, 0.5, 0, 0 },

					    	}}

						    end

						    Category_Name = Category_array[1].MyDocumentCategoryName

						    title.text = ResourceLibrary.PageTitle.." - "..Category_Name

					        GetCategoryList(Category_array[1].MyDocumentCategoryId, Category_array[1].MyDocumentCategoryName)


			    end

		        Webservice.GetDocumentLibraryCategory(getCategoryList)



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


	elseif phase == "did" then

		menuBtn:removeEventListener("touch",menuTouch)
		BgText:removeEventListener("touch",menuTouch)
		Runtime:removeEventListener( "key", onKeyEvent )

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