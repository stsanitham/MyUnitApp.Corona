----------------------------------------------------------------------------------
--
-- resource Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local mime = require("mime")
local lfs = require("lfs")
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,SubFileMode,SubFile,tmpPath

local filetype = ""

local paths = {}

local words ={}

openPage="resourcePage"

local fileextensions = {".png",".jpg",".jpeg",".gif",".bmp",".tif",".tiff",".doc",".docx",".txt",".xls",".xlsx",".ppt",".pptx",".xps",".pps",".wma",".pub",".js",".swf",
".xml",".html",".htm",".rtf" ,".pdf",".mpg",".au",".aac",".aif",".gsm",".mid",".mp3",".rm",".wav",".mpeg",".avi",".mp4",".wmv",".m4a",'JPG','JPEG','BMP','GIF','PNG','TIF','TIFF'}

local BackFlag = false

local ResourceListArray = {}

local fileAtr,rowTitle,rowIcon

local currentfilename = ""

local file_array = {}

local filenamevalue = {}

local changeMenuGroup = display.newGroup();

local RecentTab_Topvalue = 70

local file_attributemode = ""

local optionValue = "list" , tabBar , title_bg

local filenamevalue = ""

local Document_name,document_inbytearray,option_selected="","",""


local workingdir=""

--------------------------------------------------


-----------------Function-------------------------



			local function onTimer ( event )

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


	local function formatSizeUnits(event)

		if (event>=1073741824) then 

			size=(event/1073741824)..' GB'

		elseif (event>=1048576) then   

			size=(event/1048576)..' MB'
			
		elseif (event > 10485760) then

				local option ={
							 {content=CommonWords.ok,positive=true},
						}
				genericAlert.createNew(ResourceLibrary.DocumentUploadError, ResourceLibrary.DocumentUploadSize ,option)

				return false
			
		elseif (event>=1024)  then   

			size = (event/1024)..' KB'

		else      

		end

		--return size

    end


	local function onRowRender_DocLibList( event )

			 -- Get reference to the row group
			 local row = event.row

			    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			    local rowHeight = row.contentHeight
			    local rowWidth = row.contentWidth


			    if file_array[row.index].filemode == "directory" and file_array[row.index].filemode ~= "file"  then

					    local rowIcon = display.newImageRect(row,"res/assert/folderimage.png",25,25 )
					    rowIcon.x = 20
					    rowIcon.anchorX = 0 
					    rowIcon.y = rowHeight * 0.5 - 5

				elseif file_array[row.index].filemode == "file" and file_array[row.index].filemode ~= "directory" then


					    local tempreverse = string.find(string.reverse( file_array[row.index].name ),"%.")

					    if tempreverse ~= nil then

						    fileExt = file_array[row.index].name:sub( file_array[row.index].name:len()-tempreverse+2,file_array[row.index].name:len())

					    end


				        if fileExt == "png" or fileExt == "jpg" or fileExt == "jpeg" or fileExt == "gif" or fileExt == "bmp" or fileExt == "tif" then

								tempValue="res/assert/image-active.png"

						elseif fileExt == "doc" or fileExt == "docx" or fileExt == "txt" or fileExt == "xls"  or fileExt == "xlsx" or fileExt == "ppt"  or fileExt == "pptx"  or fileExt == "xps"  or fileExt == "pps" or fileExt == "wma" or fileExt == "pub" or fileExt == "js" or fileExt == "swf" or fileExt == "xml" or fileExt == "html" or fileExt == "htm" or fileExt == "rtf"  then

								tempValue="res/assert/word-active.png"

						elseif fileExt == "pdf" then

								tempValue="res/assert/pdf-active.png"

						elseif fileExt == "mpg" or fileExt == "au" or fileExt == "aac" or fileExt == "aif" or fileExt == "gsm" or fileExt == "mid" or fileExt == "mp3" or fileExt == "rm"  or fileExt == "wav" then

								tempValue="res/assert/audio.png"
									    	
						elseif fileExt == "mpeg" or fileExt == "avi" then

								tempValue="res/assert/video.png"

						else

								tempValue="res/assert/invalid_file.png"
						end


						local rowIcon = display.newImageRect(row,tempValue,25,22 )
					    rowIcon.x = 20
					    rowIcon.anchorX = 0
					    rowIcon.y = rowHeight * 0.5 - 5


				end


			    rowTitle = display.newText(row, file_array[row.index].name, 0, 0,280,38, nil, 14 )
				rowTitle:setFillColor( 0 )
				rowTitle.anchorX = 0
				rowTitle.x = 60
				rowTitle.y = rowHeight * 0.5+10


				rowvalues = file_array[row.index].name

				--print("NAME   :    "..file_array[row.index].name)

	end


	local function createPathlist(FullPath,rowvalues,rowfilemode)

		local pathType1 = ""

								if FullPath and lfs.attributes(FullPath ) then

								    pathType1= lfs.attributes( FullPath ).mode

								end
									
											if pathType1 == "directory" then

												

						    	    
											  


												for j=#file_array, 1, -1 do 
													file_array[#file_array] = nil
												end


														  for file in lfs.dir(FullPath ) do


																	if "." ~= file and ".." ~= file then

																         --  print("FILE 123: " .. file)

																         local fhd = io.open( FullPath.."/"..file ) 

																	         if fhd then
																			 		  SubFile = FullPath.."/"..file

																			          SubFileMode = lfs.attributes(SubFile).mode

																			         -- print("mode +++++++ : "..lfs.attributes(SubFile).mode)

																			          file_array[#file_array+1] = { name = file , filemode = SubFileMode}

																			else

																			 			--native.showAlert( "File", "Permission Denied" ,{"OK"} )

																			end


																        
																	   	
																     end

															end

															if #file_array >= 1 then

																

																workingdir = FullPath
														  		title.text = string.gsub( rowvalues, "//.","")
															    title.type = "innertype"
															    back_icon_bg.type = "innertype"
															    back_icon.type = "innertype"

															 end

											else


												    local fileValidation = false

												        for i=1, #fileextensions do

												    		 print(tostring(rowvalues).." and "..tostring(fileextensions[i]))

													            if string.find(tostring(rowvalues), tostring(fileextensions[i])) ~= nil then

													            			fileExtForName = tostring(fileextensions[i])

													            			fileValidation = true

													            			Document_name = "Resource"..os.date("%Y%m%d%H%M%S")..fileExtForName


																		    tmpPath = system.pathForFile(Document_name,system.DocumentsDirectory) -- Destination path to the temporary image


																				  


													            	           local function onComplete( action_event )

																				   local i = action_event

																					    if i == 1 then

																					 	        option_selected = "Add"

																								print("cccccc")

																								 workingdir = FullPath


																								--------------------------- Read ----------------------------
																								local file, reason = io.open( workingdir, "r" )                               -- Open the image in read mode
																								local contents
																								if file then
																								    contents = file:read( "*a" )                                        -- Read contents
																								    io.close( file )                                                    -- Close the file (Important!)
																								else
																								    print("Invalid path")
																								    return
																								end

																								--------------------------- Write ----------------------------

																								local file = io.open( tmpPath, "w" )                                    -- Open the destination path in write mode
																								if file then
																								    file:write(contents)   
																								    written_file = file:write(contents)                                            -- Writes the contents to a file
																								    io.close(file)                                                      -- Close the file (Important!)
																								else
																								    print("Error")
																								    return
																								end


																								       local size1 = lfs.attributes (tmpPath, "size")

																									   local fileHandle = io.open(tmpPath, "rb")

																									   document_inbytearray = mime.b64( fileHandle:read( "*a" ) )

																									   io.close( fileHandle )


																									 --  print("file_inbytearray "..document_inbytearray)

																									 --  print("bbb ",size1)

																									   formatSizeUnits(size1)



																										-- 	local options = {
																										-- 		effect = "slideRight",
																										-- 		time =300,
																										-- 		params = { Document_Name = Document_name, Document_bytearray = document_inbytearray, temp_docfile = written_file , selectedoption = option_selected }
																										-- 	}

																										print("123")

																									   composer.hideOverlay()


																					 else

																					 	    option_selected = "Cancel"

																					 	    local tmpPath = system.pathForFile(Document_name,system.DocumentsDirectory)

																							os.remove( tmpPath )

																					 end

																	end

																			
																	local option = {
																					 {content="Add",positive=true},
																					 {content=CommonWords.cancel,positive=true},
																				}

																	genericAlert.createNew(ResourceLibrary.DocumentUpload, ResourceLibrary.DocumentUploadAlert ,option,onComplete)


																		return 					

																end
														
													    end



													if fileValidation == false then

															local option ={
																	        {content=CommonWords.ok,positive=true},
																          }
																genericAlert.createNew(ResourceLibrary.InvalidFile, ResourceLibrary.InvalidFileError ,option)


													end
	

											end



								if #file_array == 0  then
									NoEvent = display.newText( scene.view, "This folder is empty", 0,0,0,0,native.systemFontBold,16)
									NoEvent.x=W/2;NoEvent.y=H/2
									NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
							    end


							    Documents_list:deleteAllRows()


							    for i = 1, #file_array do

							       Documents_list:insertRow{ rowHeight = 45,rowColor = 
							       {
							    	default = { 1, 1, 1, 0 },
							    	over={ 1, 0.5, 0, 0 },
							    	}}
							    end

	end


			local function onRowTouch_DocLibList( event )
				local phase = event.phase
				local row = event.target

				if( "press" == phase ) then

			    elseif ( "release" == phase ) then

			    	local rowHeight = row.contentHeight
			        local rowWidth = row.contentWidth


    		                    local rowvalues = file_array[row.index].name
    		                    rowfilemode = file_array[row.index].filemode
								local FullPath = workingdir.."/"..rowvalues
							    local pathType1 = ""


							    createPathlist(FullPath,rowvalues,rowfilemode)


			 end

			end





		local function closeDetails( event )

				if event.phase == "began" then

					    display.getCurrentStage():setFocus( event.target )

				elseif event.phase == "ended" then

						display.getCurrentStage():setFocus( nil )


						if event.target.id =="backpress" and workingdir == "/" then

								composer.hideOverlay("slideRight",300)

						else

								if NoEvent.isVisible == true then

									NoEvent.isVisible = false

								end


								local tempPath = string.reverse( workingdir )
								local FullPath,rowvalues

								       if string.find( tempPath,"/" ) ~= nil then

											   local placeholder = string.find( tempPath,"/" )

												print( placeholder )

												tempPath = workingdir:sub( 1, workingdir:len()-placeholder )
												 FullPath = tempPath
												 tempPath = string.reverse( tempPath )

												if string.find( tempPath,"/" ) ~= nil then

													local placeholder = string.find( tempPath,"/" )
															tempPath = string.reverse( tempPath )
														 rowvalues = tempPath:sub( tempPath:len()-placeholder+2, tempPath:len() )

												end
			    		                    

			    		                    rowfilemode = ""
											
											if rowvalues == "" then
												rowvalues = ResourceLibrary.PageTitle
											end

											workingdir = FullPath
										   
										    createPathlist(FullPath,rowvalues,rowfilemode)

							    	end

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

				back_icon_bg = display.newRect(sceneGroup,0,0,20,20)
				back_icon_bg.x= 5
				back_icon_bg.anchorX=0
				back_icon_bg.id="backpress"
				back_icon_bg.type = "outerfile"
				back_icon_bg.anchorY=0
				back_icon_bg.alpha=0.01
				back_icon_bg:setFillColor(0)
				back_icon_bg.y= title_bg.y-8

				back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
				back_icon.x= back_icon_bg.x + 5
				back_icon.anchorX=0
				back_icon.id="backpress"
				back_icon.type = "outerfile"
				back_icon.anchorY=0
				back_icon:setFillColor(0)
				back_icon.y= title_bg.y - 8

				title = display.newText(sceneGroup,ResourceLibrary.PageTitle,0,0,native.systemFont,18)
				title.anchorX = 0
				title.id = "backpress"
				title.type = "outerfile"
				title.x = back_icon.x+back_icon.contentWidth+5;title.y = title_bg.y
				title:setFillColor(0)

				title:addEventListener( "touch", closeDetails )
				back_icon_bg:addEventListener( "touch", closeDetails )
			 	back_icon:addEventListener( "touch", closeDetails )


				ResourceList_scrollview = widget.newScrollView
				{
					top = RecentTab_Topvalue,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue,
					hideBackground = true,
					isBounceEnabled=false,
					bottomPadding = 10,
				}


		sceneGroup:insert(ResourceList_scrollview)

		MainGroup:insert(sceneGroup)

	end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

		


		elseif phase == "did" then


			ga.enterScene("Resource Library")


		        function getFileList()


							for j=#file_array, 1, -1 do 
								file_array[#file_array] = nil
							end


						workingdir = "/"

						local path = workingdir
						local pathType = ""


						firstrootpath = workingdir

						-- Check to see if path exists
						if path and lfs.attributes( "/" ) then
						    pathType = lfs.attributes( "/" ).mode
						    --print("pathtype     "..pathType)
						end

						-- Check if path is a directory
						if pathType == "directory" then

								  for file in lfs.dir( "/" ) do

											if "." ~= file and ".." ~= file then

										        -- print("FILE: " .. file)

										         fileAtr = lfs.attributes( file )

									         	 if fileAtr ~= nil then 

											   		 	file_attributemode = fileAtr.mode

											   		     --print("@@@@@ "..path,file,file_attributemode) 

										   		 end

										         file_array[#file_array+1] = { name = file , filemode = file_attributemode }

										    end
									end

						else


															local option ={
																        {content=CommonWords.ok,positive=true},
															          }
															genericAlert.createNew(ResourceLibrary.InvalidFile, ResourceLibrary.InvalidFileError ,option)

															title.text = ResourceLibrary.PageTitle
														    title.type = "outerfile"
														    back_icon_bg.type = "outerfile"
														    back_icon.type = "outerfile"
						end


					end




		    getFileList()

		    



			Documents_list = widget.newTableView
			{
				left = -10,
				top = 75,
				height = H-75,
				width = W+10,
				onRowRender = onRowRender_DocLibList,
				onRowTouch = onRowTouch_DocLibList,
				hideBackground = true,
				isBounceEnabled = false,
			    --noLines = true,
			}

			sceneGroup:insert(Documents_list)


			if #file_array == 0  then
				NoEvent = display.newText( sceneGroup, ResourceLibrary.NoDocument, 0,0,0,0,native.systemFontBold,16)
				NoEvent.x=W/2;NoEvent.y=H/2
				NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
		    end


		    for i = 1, #file_array do
		       -- Insert a row into the tableView
		       Documents_list:insertRow{ rowHeight = 45,rowColor = 
		       {
		    	default = { 1, 1, 1, 0 },
		    	over={ 1, 0.5, 0, 0 },
		    	}}
		    end



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

				menuBtn:removeEventListener("touch",menuTouch)
				BgText:removeEventListener("touch",menuTouch)
				Runtime:removeEventListener( "key", onKeyEvent )

		elseif phase == "did" then

				print("@@@@@@@@@@")

				if option_selected == "Add" then

				    event.parent:resumeDocumentCallBack(Document_name,document_inbytearray,option_selected)

			    else

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