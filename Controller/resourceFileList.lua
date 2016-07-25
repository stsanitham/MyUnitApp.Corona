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
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="resourcePage"

local BackFlag = false

local ResourceListArray = {}

local fileAtr,rowTitle


local currentfilename = ""

local file_array = {}

local filenamevalue = {}

local changeMenuGroup = display.newGroup();

local RecentTab_Topvalue = 70

local file_attributemode = ""

local optionValue = "list" , tabBar , title_bg

local filenamevalue = ""


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

							timer.performWithDelay( 3000, onTimer )

							return true

						elseif BackFlag == true then

							os.exit() 

						end
						
					end

				end

				return false
			end


local pathValue="/"


			local function onRowRender_DocLibList( event )

			 -- Get reference to the row group
			 local row = event.row

			    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			    local rowHeight = row.contentHeight
			    local rowWidth = row.contentWidth

			    rowTitle = display.newText(row, file_array[row.index].name, 0, 0,280,38, nil, 14 )
				rowTitle:setFillColor( 0 )
				rowTitle.anchorX = 0
				rowTitle.x = 20
				rowTitle.y = rowHeight * 0.5+10


				-- row.rowValue = namevalue[row.index][2]

				-- row.text=namevalue[row.index][1]

				rowvalues = file_array[row.index].name


				print("NAME   :    "..file_array[row.index].name)


			end





			local function onRowTouch_DocLibList( event )
				local phase = event.phase
				local row = event.target

				if( "press" == phase ) then

										rowvalues = file_array[row.index].name
											local path = pathValue
										    local pathType1 = ""

										   -- title.text = file_array[row.index].name

										    if string.find(file_array[row.index].name, "//") then 

											    	print("((((((((")

											    	if string.find(file_array[row.index].name, "//.") then 

											    	print("ppppppppp")

											    	    title.text = string.gsub( file_array[row.index].name, "//.","")
													    title.type = "innertype"
													    back_icon_bg.type = "innertype"
													    back_icon.type = "innertype"

													else

														title.text = string.gsub( file_array[row.index].name, "//", "" ) 
													    title.type = "innertype"
													    back_icon_bg.type = "innertype"
													    back_icon.type = "innertype"


													end

										    	 
										    end

										

										  pathValue = pathValue..rowvalues

											-- Check to see if path exists
											if path and lfs.attributes(path..rowvalues ) then
											    pathType1= lfs.attributes( path..rowvalues ).mode
											    print("pathtype     "..pathType1)
											end

									
											-- Check if path is a directory
											if pathType1 == "directory" then

												for j=#file_array, 1, -1 do 
													file_array[#file_array] = nil
												end


												Documents_list:deleteAllRows()

												native.showAlert( "MUB", "Path : "..pathValue,{"ok"} )

														  for file in lfs.dir(pathValue ) do

														  	print("true")

																	if "." ~= file and ".." ~= file then

																         print("FILE 123: " .. file)

																         fileAtr = lfs.attributes( pathValue )


																         --filenamevalue[#filenamevalue+1] = { name = path..file_array[row.index].name }

																         print(json.encode(fileAtr))

																         print(file)

																         file_array[#file_array+1] = { name = file }

																         --title.text = rowvalues


																        -- Documents_list:deleteAllRows()


																         print(#file_array)

																	   		 if fileAtr ~= nil then 

																		   		 	file_attributemode = fileAtr.mode

																		   		 	print(path,file,file_attributemode) 

																	   		 end

																     end

															end

												else

													title.text = ResourceLibrary.PageTitle
												    title.type = "outerfile"
												    back_icon_bg.type = "outerfile"
												    back_icon.type = "outerfile"


												end



								 --title.text = rowTitle.text


								if #file_array == 0  then
									NoEvent = display.newText( scene.view, ResourceLibrary.NoDocument, 0,0,0,0,native.systemFontBold,16)
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

											

			    elseif ( "release" == phase ) then

			    	--print(file_array)

			 end

			end



		local function closeDetails( event )

			if event.phase == "began" then

				display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then


						display.getCurrentStage():setFocus( nil )

						if event.target.id =="backpress" and event.target.type == "outerfile" then

							print("123123")

							composer.gotoScene("Controller.resourcePage","slideRight",200)

						end

						if event.target.type ~= "outerfile" then

							print("sdfsdfsdf")


										getFileList()


										title.text = ResourceLibrary.PageTitle
									    title.type = "outerfile"
									    back_icon_bg.type = "outerfile"
									    back_icon.type = "outerfile"


										if NoEvent.isVisible == true then

											NoEvent.isVisible = false

										end

										Documents_list:deleteAllRows()


										for i = 1, #file_array do
										-- Insert a row into the tableView
										Documents_list:insertRow{ rowHeight = 45,rowColor = 
										{
										default = { 1, 1, 1, 0 },
										over={ 1, 0.5, 0, 0 },
										}}
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

			composer.removeHidden()

			ga.enterScene("Resource Library")


			function getFileList()


					for j=#file_array, 1, -1 do 
						file_array[#file_array] = nil
					end

				local path = pathValue
				local pathType = ""

				-- Check to see if path exists
				if path and lfs.attributes( path ) then
				    pathType = lfs.attributes( path ).mode
				    print("pathtype     "..pathType)
				end

				-- Check if path is a directory
				if pathType == "directory" then

						  for file in lfs.dir( path ) do

									if "." ~= file and ".." ~= file then

								         print("FILE: " .. file)

								         fileAtr = lfs.attributes( path.. file )

								         file_array[#file_array+1] = { name = path..""..file}


									   		 if fileAtr ~= nil then 

										   		 	file_attributemode = fileAtr.mode

										   		 	print(path,file,file_attributemode) 

									   		 end

								    end
							end

				else

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