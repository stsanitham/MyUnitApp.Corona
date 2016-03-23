----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local lfs = require ("lfs")
local mime = require("mime")
local style = require("res.value.style")
local Utility = require( "Utils.Utility" )
local newGroup = require( "Controller.newGroupAlert" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,tabButtons,chattabBar

openPage="groupPage"

local BackFlag = false

local networkArray = {}

local NameArray = {}

local groupList_scrollview

local careerListArray = {}

local RecentTab_Topvalue = 75

local header_value = ""

local Image

local byNameArray = {}

local Listresponse_array = {}


local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"





	local function onTimer ( event )

		print( "event time completion" )

		BackFlag = false

	end


    local function addGroupAction(event)

	 	 if event.phase == "began" then

         elseif event.phase == "ended" then

         composer.removeHidden()

		    local options = {
						effect = "crossFade",
						time = 500,	
						params = { addGroupid = addGroupBtn.id }
						}

	        composer.gotoScene( "Controller.consultantListPage", options )

         end

	    return true

    end


	local function onKeyEvent( event )

	        local phase = event.phase
	        local keyName = event.keyName

	        if phase == "up" then

	        if keyName=="back" then

	        	if BackFlag == false then

	        		Utils.SnackBar("Press again to exit")

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



		local function handleTabBarEvent( event )

			if event.phase == "press" then 

					tabbutton_id = event.target._id 

			    if tabbutton_id == "group" then

					title.text = "Group"

				elseif tabbutton_id == "broadcast_list" then

	 				print("tabButtons details : "..json.encode(tabButtons))

						chattabBar:setSelected( 1 ) 
						composer.removeHidden()
	   				    local options = {
										effect = "crossFade",
										time = 300,	
										params = { tabbuttonValue2 =json.encode(tabButtons)}
										}

					    composer.gotoScene( "Controller.broadCastListPage", options )

				-- elseif tabbutton_id == "chat" then

				-- 	    print("tabButtons details : "..json.encode(tabButtons))

				-- 		chattabBar:setSelected( 2 ) 
				-- 		composer.removeHidden()
	   -- 				    local options = {
				-- 						effect = "crossFade",
				-- 						time = 300,	
				-- 						params = { tabbuttonValue2 =json.encode(tabButtons)}
				-- 						}

				-- 	    composer.gotoScene( "Controller.chatPage", options )

				elseif tabbutton_id == "consultant_list" then

				    	chattabBar:setSelected( 4 ) 
				    	composer.removeHidden()
	   				    local options = {
										effect = "crossFade",
										time = 300,	 
										params = { tabbuttonValue4 =json.encode(tabButtons)}
										}

					    composer.gotoScene( "Controller.consultantListPage", options )

				end

		    end

	    return true 

		end


	------------------------------------------------------


	local function careePath_list( list )


	for j=#careerListArray, 1, -1 do 
		
		display.remove(careerListArray[#careerListArray])
		careerListArray[#careerListArray] = nil
	end

	for i=1,#list do
      print("here")


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
		background.id=list[i].Contact_Id
		background.alpha=0.01
		background.value = list[i]

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

		

		if list[i].Image_Path ~= nil then

			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

			networkArray[#networkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..list[i].Image_Path,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else

						if Image then

						print(img_event.response.filename)
						Image = display.newImage(tempGroup,img_event.response.filename,system.TemporaryDirectory)
						Image.width=35;Image.height=35
						Image.x=30;Image.y=background.y+background.contentHeight/2
    				--event.row:insert(img_event.target)

    			    else

						Image:removeSelf();Image=nil

					 end
    			end

    			end, "career"..list[i].Contact_Id..".png", system.TemporaryDirectory)
		else
			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

		end


			



		local Name_txt = display.newText(tempGroup,list[i].Name,0,0,native.systemFont,14)
		Name_txt.x=60;Name_txt.y=background.y+background.height/2-10
		Name_txt.anchorX=0
		Utils.CssforTextView(Name_txt,sp_labelName)
		Name_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		local Position_txt = display.newText(tempGroup,list[i].CarrierProgress,0,0,native.systemFont,14)
		Position_txt.x=60;Position_txt.y=background.y+background.height/2+10
		Position_txt.anchorX=0
		Utils.CssforTextView(Position_txt,sp_fieldValue)

		if Position_txt.text:len() > 26 then
			Position_txt.text = string.sub(Position_txt.text,1,26).."..."

		end

		-- local right_img = display.newImageRect(tempGroup,"res/assert/arrow_1.png",15/2,30/2)
		-- right_img.anchorX=0
		-- right_img.x=background.x+background.contentWidth/2-30;right_img.y=background.y+background.height/2


			-- local opt = {
			-- width = 32,
			-- height = 32,
			-- numFrames = 2,
			-- sheetContentWidth = 64,
			-- sheetContentHeight = 32
			-- }
			-- local mySheet = graphics.newImageSheet( "img/check.png", opt )

			-- local checkboxButton = widget.newSwitch {
			-- left = 50,
			-- top = 50,
			-- width = 32,
			-- height = 32,
			-- style = "checkbox",
			-- sheet = mySheet,
			-- frameOff = 1,
			-- frameOn = 2,
			-- }


		selectcontact_checkbox = widget.newSwitch(
		{
		left = 15,
		top = Position_txt.y-5,
		style = "checkbox",
		id = "email_Checkbox",
		initialSwitchState = false,
		--onPress = onSwitchPress
		})
		selectcontact_checkbox.width= 20
		selectcontact_checkbox.height = 20
		selectcontact_checkbox.anchorX=0
		selectcontact_checkbox.x = background.x+background.contentWidth/2-33
		selectcontact_checkbox.y=background.y+background.height/2

		tempGroup:insert(selectcontact_checkbox)


		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
	

		tempGroup.Contact_Id = list[i].Contact_Id

		--background:addEventListener( "touch", consultantTounch )

		groupList_scrollview:insert(tempGroup)

	end
end




function get_Activeteammember(response)


	for i=1,#Listresponse_array do
		Listresponse_array[i]=nil
		byNameArray[i]=nil
	end

	Listresponse_array=response

	if response ~= nil and #response ~= 0 then
				
--NameArray

print("size = "..#Listresponse_array)

						for i=1,#Listresponse_array do

							local list_Name = Listresponse_array[i].LastName

							

								if Listresponse_array[i].FirstName then

									list_Name = Listresponse_array[i].FirstName.." "..Listresponse_array[i].LastName

								end

							

							print(list_Name)

							local temp = {}

							if list_Name:sub(1,1) == " " then
								list_Name = list_Name:sub( 2,list_Name:len())
							end

							temp.Name = list_Name
							temp.CarrierProgress = Listresponse_array[i].EmailAddress
							temp.Contact_Id = Listresponse_array[i].MyUnitBuzzRequestAccessId

							byNameArray[#byNameArray+1] = temp


						end

								careePath_list(byNameArray)

	else

		NoEvent.isVisible=true

	end
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

		title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=5;title.y = title_bg.y
		title:setFillColor(0)
		title.text = "Group"

		addGroupBtn = display.newImageRect( sceneGroup, "res/assert/addevent.png", 66/2,66/2.2 )
		addGroupBtn.x=W-40
		addGroupBtn.y=tabBar.y+tabBar.contentHeight-4
		addGroupBtn.anchorX = 0
		addGroupBtn.isVisible = true
		addGroupBtn.id="addGroup"

		subjectBar = display.newRect(sceneGroup,W/2,0,W,40)
		subjectBar.y=title_bg.y+15
		subjectBar.height = 40
		subjectBar.anchorY = 0
		subjectBar.isVisible = false
		subjectBar:setFillColor(0,0,0,0.1)

		GroupSubject =  native.newTextField( W/2+3, subjectBar.y + 20, W-60, 25)
		GroupSubject.id="groupSubject"
		GroupSubject.y = subjectBar.y +20
		GroupSubject.size=14
		GroupSubject.anchorX = 0
		GroupSubject.isVisible = false
		GroupSubject.x = 10
		GroupSubject:setReturnKey( "done" )
		GroupSubject.hasBackground = false	
		GroupSubject.placeholder = "Type group subject here..."
		sceneGroup:insert(GroupSubject)

		create_groupicon =  display.newImageRect(sceneGroup,"res/assert/tick.png",25,22)
		create_groupicon.anchorX=0
		create_groupicon.isVisible = false
		create_groupicon.x=GroupSubject.x+GroupSubject.contentWidth+15
		create_groupicon.y=subjectBar.y +20


		 tabButtons = {
    {
        label = "Broadcast List",
        defaultFile = "res/assert/user.png",
        overFile = "res/assert/user.png",
        size = 11.5,
        labelYOffset = 2,
        id = "broadcast_list",
        labelColor = { 
            default = { 0,0,0}, 
            over = {0,0,0}
        },
        width = 20,
        height = 20,
        onPress = handleTabBarEvent,
        selected = true,
    },
    {
        label = "Chat",
        defaultFile = "res/assert/mail.png",
        overFile = "res/assert/mail.png",
        size = 11.5,
        labelYOffset = 2,
        id = "chat",
        labelColor = { 
            default = { 0,0,0}, 
            over = {0,0,0}
        },
        width = 20,
        height = 15,
        onPress = handleTabBarEvent,
    },
    {
        label = "Group",
        defaultFile = "res/assert/phone.png",
        overFile = "res/assert/phone.png",
        size = 11.5,
        labelYOffset = 2,
        id = "group",
        labelColor = { 
            default = { 0,0,0}, 
            over = { 0,0,0 }
        },
        width = 20,
        height = 20,
        onPress = handleTabBarEvent,
    },
   
}

if IsOwner == true then

tabButtons[#tabButtons+1] =  {
        label = "Consultant List",
        defaultFile = "res/assert/map.png",
        overFile = "res/assert/map.png",
        size = 11.5,
        labelYOffset = 2,
        id = "consultant_list",
        labelColor = { 
            default = { 0,0,0}, 
            over = { 0,0,0 }
        },
        width = 16,
        height = 20,
        onPress = handleTabBarEvent,
    }

end

				    chattabBar = widget.newTabBar{
				    top =  display.contentHeight - 55,
				    left = 0,
				    width = display.contentWidth, 
				    backgroundFile = tabBarBackground,
				    tabSelectedLeftFile = tabBarLeft,   
				    tabSelectedRightFile = tabBarRight,    
				    tabSelectedMiddleFile = tabBarMiddle,   
				    tabSelectedFrameWidth = 20,                                         
				    tabSelectedFrameHeight = 50, 
				    backgroundFrame = 1,
				    tabSelectedLeftFrame = 2,
				    tabSelectedMiddleFrame = 3,
				    tabSelectedRightFrame = 4,                                       
				    buttons = tabButtons,
				    height = 50,
				}

				sceneGroup:insert(chattabBar)


	            local rect = display.newRect(0,0,display.contentWidth,1.3)
				rect.x = 0;
				rect.anchorX=0
				rect.y = display.contentHeight - 50;
				rect:setFillColor(0)
				sceneGroup:insert( rect )


				groupList_scrollview = widget.newScrollView
				{
					top = RecentTab_Topvalue+subjectBar.height-5,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue-50-subjectBar.height+5,
					hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
				}

            sceneGroup:insert(groupList_scrollview)

	--Webservice.GetMyUnitBuzzRequestAccesses("GRANT",get_Activeteammember)


	MainGroup:insert(sceneGroup)

	end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

			if event.params then
				nameval = event.params.tabbuttonValue3
			end

			-- local centerText = display.newText(sceneGroup,"Group Page",0,0,native.systemFontBold,16)
			-- centerText.x=W/2;centerText.y=H/2
			-- centerText:setFillColor( 0 )


		elseif phase == "did" then

			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)

			addGroupBtn:addEventListener("touch",addGroupAction)

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

			addGroupBtn:removeEventListener("touch",addGroupAction)

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