----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
require( "res.value.style" )
require( "Webservice.ServiceManager" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local isRotate = false

local spListArray = {}

local List_array = {}

local RecentTab_Topvalue = 75

local header_value = ""

local webView

local reportArray

local reportArrayList = {}

local tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title,refresh_icon_bg,refresh

openPage="specialRecognition"

local coloumArray = {}

local widthArray = {}

local Parent={}
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




local function onKeyEvent( event )

	local phase = event.phase
	local keyName = event.keyName

	if phase == "up" then

		if keyName == "back" or keyName == "a" then

			isRotate = false

			if webView then webView:removeSelf( );webView=nil end


			composer.hideOverlay( "slideRight", 300 )

			return true
		end

	end

	return false
end




local function onBackgroundTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

	end
	return true
end


local function ListCliked( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )


	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )
		local dx = math.abs( ( event.x - event.xStart ) )

		if ( dy > 10 ) or ( dx > 10 ) then
			display.getCurrentStage():setFocus( nil )
			HorizontalScroll:takeFocus( event )
		end

		elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )


		if event.target.ContactId ~= nil and tonumber(event.target.ContactId) > 0 then

			local options = {
				effect = "fromTop",
				time = 200,	
				params = {
					contactId = event.target.ContactId,
					MessageType = "SPECIAL",
					GroupTypeValue = "",
				}

			}


			composer.showOverlay( "Controller.Chathead_detailPage", options )

		else

 	     	--native.showAlert( "MyUnitBuzz", "Contact not in our Database",{"OK"})

 	     end

 	 end
 	 return true
 	end



 	local function onButtonTouch( event )

 		if event.phase == "began" then

 			display.getCurrentStage():setFocus( event.target )

 			elseif event.phase == "ended" then

 			display.getCurrentStage():setFocus( nil )

 			if event.target.id == "backbtn" or event.target.id == "titlename" then

 				isRotate = false

 				if webView then webView:removeSelf( );webView=nil end

 				composer.gotoScene( "Controller.specialRecognition","slideRight", 300 )


 			elseif event.target.id == "refresh" then

 				isRotate = true

 				trans = transition.to(refresh,{delay=200,time=10000,rotation=2700})

 				if isRotate == true then

 					function getRefreshedSpecialRecognition_PageContent(response)

 						isRotate = false
 						transition.cancel()
 						refresh.rotation = 0

 						if response.PageContent ~= nil and response.PageContent ~= "" then

 							webView.isVisible = true

 							local t = response.PageContent

 							local saveData = [[<!DOCTYPE html>
 							<html>
 							<head>
 							<meta charset="utf-8">
 							<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
 							</head>]]..t..[[</html>]]

 							local path = system.pathForFile( "specialRecognition.html", system.DocumentsDirectory )
 							local file, errorString = io.open( path, "w" )

 							if not file then
 								print( "File error: " .. errorString )
 							else
 								file:write( saveData )
 								io.close( file )
 							end

 							file = nil

 							webView:request( "specialRecognition.html", system.DocumentsDirectory )

 						else

 							webView.isVisible = false

 							NoEvent = display.newText( sceneGroup,CommonWords.No.." "..response.UserPageName.." "..CommonWords.Found, 0,0,0,0,native.systemFontBold,16)
 							NoEvent.x=W/2;NoEvent.y=H/2
 							NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

 						end

 					end


 					Webservice.GetSpecialRecognitionPageContent(sr_eventid,getRefreshedSpecialRecognition_PageContent)

 					spinner.isVisible=false

 				end

 			end

 		end

 	end






 	local parent_centerText = {}

 	local function CreateRow( tempHeight,tempGroup,totalCount,count,k,v,source )
 		
 		local contact = 0


 		if v ~= "ContactId" and k ~= "ContactId" then

 			local ColoumWidth = W/3

 			if #Parent == 3 then
 				ColoumWidth = W/2
 			end

 			coloumArray[#coloumArray+1] = display.newRect(tempGroup,0,0,ColoumWidth,35)
 			coloumArray[#coloumArray].anchorY = 0
 			coloumArray[#coloumArray].anchorX = 0
 			coloumArray[#coloumArray].x=0;coloumArray[#coloumArray].y=tempHeight
 			
 			coloumArray[#coloumArray]:setFillColor(0,0,0,0)
 			

 			if totalCount > 1 then

 				if coloumArray[#coloumArray-1] ~= nil then
 					coloumArray[#coloumArray].x = coloumArray[#coloumArray-1].x+coloumArray[#coloumArray-1].width+0.1
 				end

 			end


 			local options = 
				{
				    parent = tempGroup,
				    text = "",     
				    x = 100,
				    y = 200,
				    width = 100,
				    font = native.systemFont,   
				    fontSize = 12,
				    align = "center"  -- alignment parameter
				}


 			parent_centerText[#parent_centerText+1] = display.newText(options)


 			if source == "parent" then

 					coloumArray[#coloumArray]:setFillColor(Utils.convertHexToRGB(color.Gray))

 			else

	 				if #reportArrayList%2 == 0 then
	 					
	 					coloumArray[#coloumArray]:setFillColor(Utils.convertHexToRGB(color.table2))
	 				else
	 					coloumArray[#coloumArray]:setFillColor(Utils.convertHexToRGB(color.table1))
	 				end

 			end


 			parent_centerText[#parent_centerText].x=coloumArray[#coloumArray].x + 5
 			parent_centerText[#parent_centerText].anchorX=0
 			parent_centerText[#parent_centerText].y=coloumArray[#coloumArray].y+coloumArray[#coloumArray].contentHeight/2

 			if k ~= "" then

 				parent_centerText[#parent_centerText].text = k
 			else
 				parent_centerText[#parent_centerText].text = "-"
 			end
 			parent_centerText[#parent_centerText].value = v
 			parent_centerText[#parent_centerText]:setTextColor( 0 )					

 			

 			if source == "parent" then

 				if parent_centerText[#parent_centerText].contentWidth > coloumArray[#coloumArray].width  then
 					coloumArray[#coloumArray].width = parent_centerText[#parent_centerText].contentWidth+15
 				end

 				widthArray[#widthArray+1] = coloumArray[#coloumArray].contentWidth

 				if #Parent ~= 3 then
 					widthArray[#widthArray+1] = coloumArray[#coloumArray].contentWidth+1
 				end
 			
 				parent_centerText[#parent_centerText]:setTextColor( 1 )	

 			else

 				print( "totalCount : "..totalCount )

 				coloumArray[#coloumArray].width = widthArray[totalCount]

 			end

 			
 				coloumArray[#coloumArray].strokeWidth = 1
				coloumArray[#coloumArray]:setStrokeColor( 0,0,0,0.3 )
 			

 		else

 			print( "hwew "..v,k,count)

 			contact = k

 			if tonumber(contact) ~= nil then

 				if tonumber(contact) > 0 then

 					parent_centerText[#parent_centerText].id = contact

 					
 					for j=0,#Parent-1 do
 						if parent_centerText[#parent_centerText-j] ~= nil then
 							if string.find(parent_centerText[#parent_centerText-j].value:lower( ),"consultant") then
 								parent_centerText[#parent_centerText-j]:setTextColor( 0,0,1 )

 								parent_centerText[#parent_centerText-j].ContactId = parent_centerText[#parent_centerText].id

 								parent_centerText[#parent_centerText-j]:addEventListener("touch",ListCliked)

 					           
 							end
 						end

 					end
 				end

 			end

 			

 			

 		end


 		return contact

 		
 	end



 	local function CreateHorizontalTable( sceneGroup , List )

		--local temp = json.decode(List.data)

			-- for j=#reportArray, 1, -1 do 
			
			-- 	display.remove(reportArray[#reportArray])
			-- 	reportArray[#reportArray] = nil
			-- end
			-- List = json.decode(List)
			--print( json.encode(List[1].data) )


			
				local reportArray =  List[1].data

				 Parent  = List[1].title

							
			for i=1,#reportArray do


				reportArrayList[#reportArrayList+1] = display.newGroup()

				local tempGroup = reportArrayList[#reportArrayList]

				local Image 


				local tempHeight = 0

				local background = display.newRect(tempGroup,0,0,H-45,35)

				if(reportArrayList[#reportArrayList-1]) ~= nil then
					tempHeight = reportArrayList[#reportArrayList-1][1].y + reportArrayList[#reportArrayList-1][1].height
				end

				
				background.x=W/2;background.y=tempHeight
				background.anchorY=0
				
				background.alpha=0.01


						--background:setFillColor( math.random(),math.random(),math.random() )


						local count = 0
						for k,v in pairs(reportArray) do
							count = count + 1
						end

						if parentFlag == true then
							parentFlag = false

							local totalCount = 0 

						--print( (reportArray[i]) )

						

						-- for k,v in pairs(reportArray[i]) do
						--    -- print( "KEY: "..k.." | ".."VALUE: "..v )


						--     --	print( count , totalCount  )

						--     if count ~= totalCount then

						--     	totalCount = totalCount + 1

						--     	background.ContactId = CreateRow( tempHeight,tempGroup,totalCount,count,Parent[totalCount],v,"parent" )
						    	
						    	
						--     else
						-- 			--coloumArray[1].contactId = 

						-- 		end

						-- 	end

						for  s=1,#Parent do

							totalCount = totalCount + 1

						--	print( reportArray[i]["Consultant Name"] )

							background.ContactId1 = CreateRow( tempHeight,tempGroup,totalCount,count,Parent[totalCount],reportArray[i][tostring(Parent[totalCount])],"parent" )

						end

							background.y= coloumArray[#coloumArray-1].y+background.contentHeight

						end

						
						
						local totalCount = 0 

						--print("hjkjkkj:"..json.encode(reportArray[i]))
							for  s=1,#Parent do

					    		totalCount = totalCount + 1

					    		background.ContactId1 =  CreateRow( background.y,tempGroup,totalCount,count,reportArray[i][tostring(Parent[totalCount])],Parent[totalCount],"child" )
					    		
							end


							--background:addEventListener( "touch", ListCliked )

							HorizontalScroll:insert(tempGroup)

					end



-- HorizontalScroll.horizontalScrollDisabled=false
-- HorizontalScroll.verticalScrollDisabled=true

				--print( "Lenght : "..reportArray[1] )



			end


			local function scrollListener( event )

				local phase = event.phase
				if ( phase == "began" ) then print( "Scroll view was touched" )
				elseif ( phase == "moved" ) then print( event.direction  )


					elseif ( phase == "ended" ) then print( "Scroll view was released" )
				end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
    	if ( event.direction == "up" ) then print( "Reached bottom limit" )        	
    	elseif ( event.direction == "down" ) then print( "Reached top limit" )
    	elseif ( event.direction == "left" ) then print( "Reached right limit" )       	

    	elseif ( event.direction == "right" ) then print( "Reached left limit" )

    	end
    end

    return true
end


local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 0
    rowTitle.y = rowHeight * 0.5
end
------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view
	
	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.id = "background"

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
	title_bg:setFillColor(0,0,0,0 )

	back_icon_bg = display.newRect(sceneGroup,0,0,20,20)
	back_icon_bg.x= 5
	back_icon_bg.anchorX=0
	back_icon_bg.anchorY=0
	back_icon_bg.alpha=0.01
	back_icon_bg:setFillColor(0)
	back_icon_bg.y= title_bg.y-8

	back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
	back_icon.x= 8
	back_icon.id = "backbtn"
	back_icon.anchorX=0
	back_icon.anchorY=0
	back_icon:setFillColor(0)
	back_icon.y= title_bg.y - 8


	title = display.newText(sceneGroup,"",0,0,native.systemFont,16)
	title.anchorX = 0
	title.id = "titlename"
	title.x=back_icon.x+back_icon.contentWidth+7;title.y = title_bg.y
	title:setFillColor(0)

	
			

			MainGroup:insert(sceneGroup)

		end





		function scene:show( event )

			local sceneGroup = self.view
			local phase = event.phase
			
			if phase == "will" then


				composer.removeHidden(  )

				local Title = display.newText(sceneGroup,"",0,0,0,0,"Segoe Print",18)
		--Title = native.newFont( "CoolCustomFont.ttf", 16 )
		Title.x=W/2;Title.y=title_bg.y+title_bg.contentHeight+5
		Title:setTextColor( 0,0,1 )



		local options = 
				{
				    parent = sceneGroup,
				    text = "",     
				    x = 100,
				    y = 200,
				    width = W-40,
				    font = "Segoe Print",   
				    fontSize = 12,
				    align = "center"  -- alignment parameter
				}

		local subTitle = display.newText(options)
		subTitle.x=W/2;subTitle.y=Title.y+Title.contentHeight+10
		subTitle:setTextColor( 0,0,1 )
		subTitle.align = "center"

		HorizontalScroll = widget.newScrollView(
		{
			top = 150,
			width = W,
			height = H-150,
				      --  horizontalScrollDisabled = true,
				       -- verticalScrollDisabled = false,
				        --isBounceEnabled=false,
				        hideScrollBar=true,
				        hideBackground=true,
				      -- listener = scrollListener
				  }
				  )



		 -- HorizontalScroll.anchorX = 1
		 -- HorizontalScroll.anchorY = 0.5

		 sceneGroup:insert( HorizontalScroll )
		 if event.params then

		 	sr_eventdetails = event.params.specialRecognition_Details

		 	sr_eventid = event.params.specialRecognition_id

		 end

		 title.text = sr_eventdetails.ReportName

		 reportType = sr_eventdetails.ReportType



		 if tonumber(reportType) == 0 then

		 	function getSpecialRecognition_JsonContent(sp_jsonresponse)

		 		--sp_jsonresponse = 	json.decode(sp_jsonresponse)

		 		--sp_jsonresponse = 	string.gsub(json.encode(sp_jsonresponse),"/")

		 		print("JSON content 11111: "..json.encode(sp_jsonresponse))

		 		


		 		if sp_jsonresponse ~= nil and sp_jsonresponse[1].data ~= nil then 

		 			if sp_jsonresponse[1].heading ~= nil and #sp_jsonresponse[1].data > 0  then

		 				parentFlag=true
		 				CreateHorizontalTable(sceneGroup,sp_jsonresponse)

		 				Title.text  = sp_jsonresponse[1].heading[1]
		 				subTitle.text  = sp_jsonresponse[1].heading[2]

		 			end

		 		end



		 		if sp_jsonresponse ~= nil and (sp_jsonresponse[1].data == nil or #sp_jsonresponse[1].data <= 0) then

													--NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent, 0,0,0,0,native.systemFontBold,16)
													--NoEvent = display.newText( sceneGroup, "No "..response.UserPageName.." Found", 0,0,0,0,native.systemFontBold,16)
													NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent, 0,0,0,0,native.systemFontBold,16)
													NoEvent.x=W/2;NoEvent.y=H/2
													NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

												end

											end


											Webservice.GetSpecialRecognitionJsonContent(sr_eventid,getSpecialRecognition_JsonContent)

										elseif tonumber(reportType) == 1 then


											function getSpecialRecognition_PageContent(response)

												sr_detailresponse = response.PageContent

												if response.PageContent ~= nil and response.PageContent ~= "" then

													local t = response.PageContent

													content = t

													local saveData = [[<!DOCTYPE html>
													<html>
													<head>
													<meta charset="utf-8">
													<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
													</head>]]..t..[[</html>]]

												-- Path for the file to write
												local path = system.pathForFile( "specialRecognition.html", system.DocumentsDirectory )

												-- Open the file handle
												local file, errorString = io.open( path, "w" )

												if not file then
												    -- Error occurred; output the cause
												else
												    -- Write data to file
												    file:write( saveData )
												    -- Close the file handle
												    io.close( file )
												end

												file = nil

												webView = native.newWebView( display.contentCenterX, display.contentCenterY+35, display.viewableContentWidth, display.viewableContentHeight-80 )
												--webView.anchorY=0

												webView.hasBackground=false
												webView:request( "specialRecognition.html", system.DocumentsDirectory )
												sceneGroup:insert( webView )

											else

												--NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent, 0,0,0,0,native.systemFontBold,16)
												--NoEvent = display.newText( sceneGroup, "No "..response.UserPageName.." Found", 0,0,0,0,native.systemFontBold,16)
												NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent, 0,0,0,0,native.systemFontBold,16)
												NoEvent.x=W/2;NoEvent.y=H/2
												NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

											end

										end

										Webservice.GetSpecialRecognitionPageContent(sr_eventid,getSpecialRecognition_PageContent)

									end



								elseif phase == "did" then

									Runtime:addEventListener( "key", onKeyEvent )
									menuBtn:addEventListener("touch",menuTouch)
									back_icon:addEventListener("touch",onButtonTouch)
									title:addEventListener("touch",onButtonTouch)
									
								end	
								
								MainGroup:insert(sceneGroup)

							end


							function scene:resumeGameNormal( ContactIdValue )


							end

							


							function scene:hide( event )

								local sceneGroup = self.view
								local phase = event.phase

								if event.phase == "will" then

									if webView then webView:removeSelf( );webView=nil end

									Runtime:addEventListener( "key", onKeyEvent )
									back_icon:removeEventListener("touch",onButtonTouch)
									title:removeEventListener("touch",onButtonTouch)

									
									isRotate = false


									for j=1,#spListArray do 
										if spListArray[j] then spListArray[j]:removeSelf();spListArray[j] = nil	end
									end



								elseif phase == "did" then

		-- event.parent:resumeGame()


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