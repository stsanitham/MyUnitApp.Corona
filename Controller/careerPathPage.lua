----------------------------------------------------------------------------------
--
-- Career path Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local Applicationconfig = require("Utils.ApplicationConfig")

viewValue = "position"

--position

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,listBg,list_Name,list_Position

--Button

local menuBtn

local careerList_scrollview

openPage="careerPathPage"


local newtworkArray = {}

local NameArray = {}

local careerListArray = {}

local List_array = {}

local RecentTab_Topvalue = 70

local header_value = ""

local changeMenuGroup = display.newGroup();
--------------------------------------------------


-----------------Function-------------------------

local function detailPageFun(event)
	

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		print("touch began")
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

	composer.showOverlay( "Controller.careerPathDetailPage", options )
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

	for i=1,#List_array do

		if i == 1 then 
			if viewValue == "position" then
				header_value = List_array[i].CarrierProgress
				parentFlag=true
			else
				header_value = List_array[i].Last_Name:sub(1,1)
				parentFlag=true
			end

		else
			if viewValue == "position" then
				if(header_value ~= List_array[i].CarrierProgress) then
					header_value = List_array[i].CarrierProgress
					parentFlag=true
				end
			else
				if(header_value:upper() ~= List_array[i].Last_Name:sub(1,1):upper()) then
					header_value = List_array[i].Last_Name:sub(1,1)
					parentFlag=true
				end
			end
		end

		careerListArray[#careerListArray+1] = display.newGroup()

		local tempGroup = careerListArray[#careerListArray]

		local Image 

		local tempHeight = 0

		local background = display.newRect(tempGroup,0,0,W,50)

		if(careerListArray[#careerListArray-1]) ~= nil then
			tempHeight = careerListArray[#careerListArray-1][1].y + careerListArray[#careerListArray-1][1].height+3
		end

		background.anchorY = 0
		background.x=W/2;background.y=tempHeight
		background.id=List_array[i].Contact_Id
		background.alpha=0.01
		background:addEventListener("touch",detailPageFun)

		if parentFlag == true then
			parentFlag=false


			parentTitle = display.newRect(tempGroup,0,0,W,25)
			if(careerListArray[#careerListArray-1]) ~= nil then
				--here
				tempHeight = careerListArray[#careerListArray-1][1].y + careerListArray[#careerListArray-1][1].height/2+10
			end


			parentTitle.anchorY = 0
			parentTitle.x=W/2;parentTitle.y=tempHeight+parentTitle.contentHeight/2
			parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))		

			if viewValue == "position" then
				parent_centerText = display.newText(tempGroup,header_value,0,0,native.systemFontBold,14)
			else
				parent_centerText = display.newText(tempGroup,header_value:upper(),0,0,native.systemFontBold,14)

			end

			parent_centerText.x=5
			parent_centerText.anchorX=0
			parent_centerText.y=parentTitle.y+parentTitle.contentHeight/2

			background.y=parentTitle.y+background.contentHeight/2

			


		end

		

		if List_array[i].Image_Path ~= nil then

			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

			newtworkArray[#newtworkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..List_array[i].Image_Path,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else
						Image:removeSelf();Image=nil
						Image = display.newImage(tempGroup,img_event.response.filename,system.TemporaryDirectory)
						Image.width=35;Image.height=35
						Image.x=30;Image.y=background.y+background.contentHeight/2
    				--event.row:insert(img_event.target)
    			end

    			end, "career"..List_array[i].Contact_Id..".png", system.TemporaryDirectory)
		else
			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

		end

		local text = display.newText(tempGroup,List_array[i].Last_Name,0,0,native.systemFont,14)
		text.x=60;text.y=background.y+background.height/2
		text.anchorX=0
		text:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		local right_img = display.newImageRect(tempGroup,"res/assert/arrow_1.png",15/2,30/2)
		right_img.anchorX=0
		right_img.x=background.x+background.contentWidth/2-30;right_img.y=background.y+background.height/2

		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
		--[[role = display.newText(tempGroup,List_array[i].CarrierProgress,0,0,native.systemFont,14)
		role.x=80;role.y=tempHeight
		role.anchorX=0
		role:setFillColor(Utils.convertHexToRGB(color.Black))]]

		tempGroup.Contact_Id = List_array[i].Contact_Id

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

								function compare(a,b)
									return a.CarrierProgress < b.CarrierProgress
								end

								table.sort(List_array, compare)

								careePath_list(List_array)

							else

								function compare(a,b)
									return a.Last_Name < b.Last_Name
								end

								table.sort(List_array, compare)

								careePath_list(List_array)

							end
							
					 --Webservice.GET_ACTIVE_TEAMMEMBERS(get_Activeteammember)
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

	List_array=response

	if response ~= nil and #response ~= 0 then


		--[[	for i=1,#response do
					local function titleCase( first, rest )
					   return first:upper()..rest:lower()
					end

					

					characterName = response[i]:gsub( "(%a)([%w_']*)", titleCase )


					if ContactDisplay ==  1 or ContactDisplay == nil then

						nameString = 

					--NameArray

			end]]
							if viewValue == "position" then

								function compare(a,b)
									return a.CarrierProgress < b.CarrierProgress
								end

								table.sort(List_array, compare)

								careePath_list(List_array)

							else

								function compare(a,b)
									return a.Last_Name < b.Last_Name
								end

								table.sort(List_array, compare)

								careePath_list(List_array)

							end
	else

		NoEvent.isVisible=true

	end
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


	title = display.newText(sceneGroup,"Career Path",0,0,native.systemFont,18)
	title.anchorX = 0 ;title.anchorY=0
	title.x=5;title.y = tabBar.y+tabBar.contentHeight/2+10
	title:setFillColor(0)

	changeList_order_icon = display.newImageRect(sceneGroup,"res/assert/list.png",8/2,32/2)
	changeList_order_icon.x=W-20;changeList_order_icon.y=title.y
	changeList_order_icon.anchorY=0

	changeList_order_touch = display.newRect(sceneGroup,changeList_order_icon.x,changeList_order_icon.y+15,35,35)
	changeList_order_touch.alpha=0.01
	changeList_order_touch:addEventListener("touch",changeListmenuTouch)

	NoEvent = display.newText( sceneGroup, "No Team Members to show", 0,0,0,0,native.systemFontBold,16)
	NoEvent.x=W/2;NoEvent.y=H/2
	NoEvent.isVisible=false
	NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

	

	careerList_scrollview = widget.newScrollView
	{
	top = RecentTab_Topvalue,
	left = 0,
	width = W,
	height =H-60,
	hideBackground = true,
	isBounceEnabled=false,
	horizontalScrollingDisabled = false,
	verticalScrollingDisabled = false,

   -- listener = scrollListener
}

--spinner_show()

sceneGroup:insert(careerList_scrollview)

--changeMenuGroup

listBg = display.newRect(changeMenuGroup,W/2+110,changeList_order_icon.y+60,100,80)
listBg.strokeWidth = 1
listBg:setStrokeColor( 0, 0, 0,0.3 )
listBg.id="bg"
list_Name = display.newText(changeMenuGroup,"By Name",0,0,native.systemFont,16)
list_Name.x=listBg.x;list_Name.y=listBg.y-20
list_Name:setFillColor(Utils.convertHexToRGB(color.Black))
list_Name.id="name"

list_Position = display.newText(changeMenuGroup,"By Position",0,0,native.systemFont,16)
list_Position.x=listBg.x;list_Position.y=listBg.y+20
list_Position:setFillColor(Utils.convertHexToRGB(color.Black))
list_Position.id="position"
changeMenuGroup.isVisible=false


listBg:addEventListener("touch",listPosition_change)
list_Name:addEventListener("touch",listPosition_change)
list_Position:addEventListener("touch",listPosition_change)

sceneGroup:insert(changeMenuGroup)
MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			composer.removeHidden()

			Webservice.GET_ACTIVE_TEAMMEMBERS(get_Activeteammember)
			--tempArray = {}

			if viewValue == "position" then

				function compare(a,b)
					return a.CarrierProgress < b.CarrierProgress
				end

				table.sort(List_array, compare)

				careePath_list(List_array)

			else

				function compare(a,b)
					return a.Last_Name < b.Last_Name
				end

				table.sort(List_array, compare)

				careePath_list(List_array)

			end

			




			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)


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
				BgText:removeEventListener("touch",menuTouch)

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