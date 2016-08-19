----------------------------------------------------------------------------------
--
-- Career path Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local Applicationconfig = require("Utils.ApplicationConfig")

local viewValue = "position"

local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local ContactDisplay

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

	ContactDisplay = row.ContactDisplay
	
end

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,listBg,list_Name,list_Position

--Button

local menuBtn, line

local careerList_scrollview

openPage="careerPathPage"

local newtworkArray = {}

local NameArray = {}

local careerListArray = {}

local List_array = {}

local RecentTab_Topvalue = 90

local header_value = ""

local BackFlag = false

local changeMenuGroup = display.newGroup();

local byNameArray = {}

local byPositionArray = {}
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




local function detailPageFun(event)
	

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

		local options = {
			isModal = true,
			effect = "slideLeft",
			time = 300,
			params = {
				contactId = event.target.id
			}
		}

		Runtime:removeEventListener( "key", onKeyEvent )

		composer.showOverlay( "Controller.careerPathDetailPage", options )
	end

	return true

end




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
		
		if changeMenuGroup.isVisible == true then
			changeMenuGroup.isVisible=false
		else
			changeMenuGroup.isVisible=true
		end
	end

	return true


end




local function careePath_list( list )


	for j=#careerListArray, 1, -1 do 
		
		display.remove(careerListArray[#careerListArray])
		careerListArray[#careerListArray] = nil
	end

	for i=1,#list do
		print("here")


		if i == 1 then 
			if viewValue == "position" then
				header_value = list[i].CarrierProgress
				parentFlag=true
			else


				header_value = list[i].Name:sub(1,1)

				print( "header_value "..list[i].Name,header_value )

				parentFlag=true
			end

		else
			if viewValue == "position" then
				if(header_value ~= list[i].CarrierProgress) then
					header_value = list[i].CarrierProgress
					parentFlag=true
				end
			else
				if(header_value:upper() ~= list[i].Name:sub(1,1):upper()) then
					header_value = list[i].Name:sub(1,1)
					parentFlag=true
				end
			end
		end

		careerListArray[#careerListArray+1] = display.newGroup()

		local tempGroup = careerListArray[#careerListArray]

		local Image 

		local tempHeight = 10

		local background = display.newRect(tempGroup,0,0,W,58)

		if(careerListArray[#careerListArray-1]) ~= nil then
			tempHeight = careerListArray[#careerListArray-1][1].y + careerListArray[#careerListArray-1][1].height+15
		end

		background.anchorY = 0
		background.x=W/2;background.y=tempHeight
		background.id=list[i].Contact_Id
		background.alpha=0.01
		background:addEventListener("touch",detailPageFun)


		if parentFlag == true then

			parentFlag=false

			parentTitle = display.newRect(tempGroup,0,0,W,45)
			if(careerListArray[#careerListArray-1]) ~= nil then

				if line.isVisible == true then

					line.isVisible = false

				end
				--here
				tempHeight = careerListArray[#careerListArray-1][1].y + careerListArray[#careerListArray-1][1].height+20
			end

			parentTitle.anchorY = 0
			parentTitle.x=W/2;parentTitle.y=tempHeight+parentTitle.contentHeight/2 - 35
			parentTitle:setFillColor(0,0,0,0.1)		

			if viewValue == "position" then
				parent_centerText = display.newText(tempGroup,header_value,0,0,"Roboto-Bold",15.5)
			else
				parent_centerText = display.newText(tempGroup,header_value:upper(),0,0,"Roboto-Bold",15.5)
			end

			parent_centerText.x=16
			parent_centerText.anchorX=0
			parent_centerText:setFillColor(0)
			parent_centerText.y=parentTitle.y+parentTitle.contentHeight/2

			background.y=parentTitle.y+background.contentHeight/2+20

		end


		

		if list[i].Image_Path ~= nil then

			Image = display.newImageRect(tempGroup,"res/assert/img_with_circle.png",45,45)
			Image.x=40;Image.y=background.y+background.height/2 - 21
			Image.anchorY=0

			newtworkArray[#newtworkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..list[i].Image_Path,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else

						if Image then
							Image:removeSelf();Image=nil
							print(img_event.response.filename)
							Image = display.newImage(tempGroup,img_event.response.filename,system.DocumentsDirectory)
							Image.width=45;Image.height=45
							Image.anchorY=0
							Image.x=40;Image.y=background.y+background.contentHeight/2- 21
    						--event.row:insert(img_event.target)

    				local mask = graphics.newMask( "res/assert/mask1.png")
    				Image:setMask( mask )
    				Image.maskX=0.1
    				Image.maskY=0.1

    			else

    				Image:removeSelf();Image=nil

    			end
    		end

    		end, "career"..list[i].Contact_Id..".png", system.DocumentsDirectory)
		else
			Image = display.newImageRect(tempGroup,"res/assert/img_with_circle.png",45,45)
			Image.x=40;Image.y=background.y+background.height/2- 21
			Image.anchorY=0

		end
		


		local Name_txt = display.newText(tempGroup,list[i].Name,0,0,"Roboto-Regular",16)
		Name_txt.x=80;Name_txt.y=background.y+background.height/2-20
		Name_txt.anchorX=0
		Name_txt.anchorY=0
		Utils.CssforTextView(Name_txt,sp_labelName)
		Name_txt:setFillColor(Utils.convertHexToRGB(color.Black))

		local Position_txt = display.newText(tempGroup,list[i].CarrierProgress,0,0,"Roboto-Light",13)
		Position_txt.x=80;Position_txt.y=background.y+background.height/2+12
		Position_txt.anchorX=0
		Utils.CssforTextView(Position_txt,sp_fieldValue)

		local right_img = display.newImageRect(tempGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
		right_img.anchorX=0
		right_img:setFillColor(0,0,0,0.4)
		right_img.x=background.x+background.contentWidth/2-22;right_img.y=background.y+background.height/2

	    line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight + 10
		line:setFillColor(Utility.convertHexToRGB(color.Gray))
		

		tempGroup.Contact_Id = list[i].Contact_Id

		careerList_scrollview:insert(tempGroup)

	end
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

			if viewValue == "position" then

				local function compare(a,b)
					return a.DisplayPosition < b.DisplayPosition
				end

				table.sort(byNameArray, compare)

				careePath_list(byNameArray)

			else

				
				
				local function compare(a,b)
					return a.Name:upper( ) < b.Name:upper( )
				end

				table.sort(byNameArray, compare)

				careePath_list(byNameArray)

			end
		end

		if event.target.id == "bg" then

		elseif event.target.id == "name" then
			changeMenuGroup.isVisible=false
			viewValue="name"
			action()

		elseif event.target.id == "position" then
			changeMenuGroup.isVisible=false
			viewValue="position"
			action()

		end
	end
	

	return true
end




function get_Activeteammember(response)

			for i=1,#List_array do
				List_array[i]=nil
				byNameArray[i]=nil
			end


			List_array=response

			if response ~= nil and #response ~= 0 then
				
		--NameArray

				print("size = "..#List_array)

					for i=1,#List_array do

						local list_Name = List_array[i].Last_Name

						if List_array[i].First_Name then

							list_Name = List_array[i].First_Name.." "..List_array[i].Last_Name

						end

								print(list_Name)

								local temp = {}

								if list_Name:sub(1,1) == " " then
									list_Name = list_Name:sub( 2,list_Name:len())
								end

								temp.Name = list_Name
								temp.CarrierProgress = List_array[i].CarrierProgress
								temp.Image_Path = List_array[i].Image_Path
								temp.Contact_Id = List_array[i].Contact_Id
								temp.DisplayPosition = List_array[i].DisplayPosition

								byNameArray[#byNameArray+1] = temp

					end


					if viewValue == "position" then

							function compare(a,b)
								return a.DisplayPosition < b.DisplayPosition
							end

							table.sort(byNameArray, compare)

							careePath_list(byNameArray)

					else

							function compare(a,b)
								return a.Name:upper( ) < b.Name:upper( )
							end

							table.sort(byNameArray, compare)

							careePath_list(byNameArray)

					end
		else

			NoEvent.isVisible=true

		end
end



------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view
	
	Background = display.newRect(sceneGroup,0,0,W,H)
	Background.x=W/2;Background.y=H/2
	Background:setFillColor(1,1,1)

	tabBar = display.newImageRect(sceneGroup,"res/assert/banner.png",W,110)
	tabBar.y=tabBar.contentHeight/2
	tabBar.x=W/2

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=16;menuBtn.y=20;

	menuTouch_s = display.newRect( sceneGroup, 0, menuBtn.y, 135, 50 )
	menuTouch_s.anchorX=0
	menuTouch_s.alpha=0.01

	title = display.newText(sceneGroup,CareerPath.PageTitle,0,0,"Roboto-Regular",18.5)
	title.anchorX = 0
	title.x=42;title.y = tabBar.y+tabBar.contentHeight/2-25
	title:setFillColor(1,1,1)

	changeList_order_icon = display.newImageRect(sceneGroup,"res/assert/menuCircle.png",19,7)
	changeList_order_icon.x=W-25;changeList_order_icon.y=tabBar.y+tabBar.contentHeight/2-27.5
	changeList_order_icon:setFillColor(1,1,1)
	changeList_order_icon.anchorY=0

	changeList_order_touch = display.newRect(sceneGroup,changeList_order_icon.x,changeList_order_icon.y+15,60,55)
	changeList_order_touch.alpha=0.01
	changeList_order_touch:addEventListener("touch",changeListmenuTouch)

	NoEvent = display.newText( sceneGroup, CareerPath.NoMember, 0,0,0,0,native.systemFontBold,16)
	NoEvent.x=W/2;NoEvent.y=H/2
	NoEvent.isVisible=false
	NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )


	careerList_scrollview = widget.newScrollView
	{
		top = RecentTab_Topvalue+20,
		left = 0,
		width = W,
		height =H-RecentTab_Topvalue+5-25,
		hideBackground = true,
		isBounceEnabled=false,
		horizontalScrollingDisabled = false,
		verticalScrollingDisabled = false,
	}
	sceneGroup:insert(careerList_scrollview)


------------------------------------------------------------changeMenuGroup--------------------------------------------------------------------

	listTouch_bg = display.newRect( changeMenuGroup, W/2, H/2, W, H )
	listTouch_bg.alpha=0.01
	listTouch_bg.id = "hide"

	listBg = display.newRect(changeMenuGroup,W/2+110,changeList_order_icon.y+60,100,80)
	listBg.strokeWidth = 1
	listBg.id = "show"
	listBg:setStrokeColor( 0, 0, 0,0.3 )
	listBg.id="bg"


	list_Name = display.newText(changeMenuGroup,CareerPath.By_Name,0,0,native.systemFont,16)
	list_Name.x=listBg.x-listBg.contentWidth/2+5;list_Name.y=listBg.y-20
	list_Name.anchorX=0
	list_Name:setFillColor(Utils.convertHexToRGB(color.Black))
	list_Name.id="name"

	list_Position = display.newText(changeMenuGroup,CareerPath.By_Position,0,0,native.systemFont,16)
	list_Position.x=listBg.x-listBg.contentWidth/2+5;list_Position.y=listBg.y+20
	list_Position.anchorX=0
	list_Position:setFillColor(Utils.convertHexToRGB(color.Black))
	list_Position.id="position"
	changeMenuGroup.isVisible=false


	listBg:addEventListener("touch",listPosition_change)
	list_Name:addEventListener("touch",listPosition_change)
	list_Position:addEventListener("touch",listPosition_change)

	listTouch_bg:addEventListener("touch",BgTouch)
	listBg:addEventListener("touch",BgTouch)

	sceneGroup:insert(changeMenuGroup)
	MainGroup:insert(sceneGroup)

end




function scene:resumeGame(contactId)

	composer.removeHidden(true)

	local function OnAction( event )

		if contactId == 0 and openPage == "careerPathPage" then

				Runtime:addEventListener( "key", onKeyEvent )
				Webservice.GET_ACTIVE_TEAMMEMBERS(get_Activeteammember)

		elseif contactId > 0 and openPage == "careerPathPage" then

				local options = {
					isModal = true,
					effect = "slideLeft",
					time = 300,
					params = {
						contactId = contactId,page = "career"
					}
				}
				composer.showOverlay( "Controller.careerPathDetailPage", options )

		end

	end

	timer.performWithDelay(10,OnAction)

end




function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		composer.removeHidden()

		Webservice.GET_ACTIVE_TEAMMEMBERS(get_Activeteammember)

		menuBtn:addEventListener("touch",menuTouch)
		menuTouch_s:addEventListener("touch",menuTouch)

		Runtime:addEventListener( "key", onKeyEvent )


	end	
	MainGroup:insert(sceneGroup)

end



function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then


	elseif phase == "did" then

		for i=1,#newtworkArray do

			network.cancel(newtworkArray[i])
		end


		for j=1,#careerListArray do 
			if careerListArray[j] then careerListArray[j]:removeSelf();careerListArray[j] = nil	end
		end

		menuBtn:removeEventListener("touch",menuTouch)

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