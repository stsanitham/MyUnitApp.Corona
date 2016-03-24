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
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background

local menuBtn, chattabBar , tabButtons

openPage="MessagingPage"

local newtworkArray = {}

local NameArray = {}

local broadcastList_scrollview

local careerListArray = {}

local BroadcastList_array = {}

local BroadcastList = {}

local RecentTab_Topvalue = 75

local header_value = ""

local BackFlag = false, Image

local byNameArray = {}

local Listresponse_array = {}

local tabBarGroup = display.newGroup( )

local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"


---------------------------------------------------




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


local function CreateTabBarIcons( )

	if tab_Group_btn ~= nil then if tab_Group_btn.y then tab_Group_btn:removeSelf( );tab_Group_btn=nil end end
	if tab_Message_btn ~= nil then if tab_Message_btn.y then tab_Message_btn:removeSelf( );tab_Message_btn=nil end end
	if tab_Contact_btn ~= nil then if tab_Contact_btn.y then tab_Contact_btn:removeSelf( );tab_Contact_btn=nil end end


	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0



	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0



	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant.png", 35/1.4, 31/1.4 )
	tab_Contact_btn.x=tab_Contact.x
	tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
	tab_Contact_btn.anchorY=0


end


	local function TabbarTouch( event )

		if event.phase == "began" then 

		elseif event.phase == "ended" then
			
			if event.target.id == "message" then

				title.text = "Messages"


			elseif event.target.id == "group" then

				CreateTabBarIcons()


					tab_Group_btn:removeSelf( );tab_Group_btn=nil

					tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group active.png", 35/1.4, 31/1.4 )
					tab_Group_btn.x=tab_Group.x
					tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
					tab_Group_btn.anchorY=0
					tab_Group_btn:scale(0.1,0.1)

					tab_Group_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  0.3  )

					local circle = display.newCircle( tabBarGroup, tab_Group_btn.x, tab_Group_btn.y+tab_Group_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Group_btn:scale(0.8,0.8)

					    overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Group_btn.x

					        local options = {
									effect = "crossFade",
									time = 300,	  
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.groupPage", options )
					end

					if overlay then overlay:removeSelf( );overlay=nil end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Group_btn, { time=220, delay=100, xScale=1.3,yScale=1.3 , onComplete=listener1} )

   				



			elseif event.target.id == "contact" then

			    	CreateTabBarIcons()

			    	tab_Contact_btn:removeSelf( );tab_Contact_btn=nil

			    	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant active.png", 35/1.4, 31/1.4 )
					tab_Contact_btn.x=tab_Contact.x
					tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
					tab_Contact_btn.anchorY=0
					tab_Contact_btn:scale(0.1,0.1)

					tab_Contact_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Contact_btn.x, tab_Contact_btn.y+tab_Contact_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  Utils.convertHexToRGB(color.tabBarColor)  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Contact_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Contact_btn.x

					      local options = {
									effect = "crossFade",
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.consultantListPage", options )
					end

					if overlay then overlay:removeSelf( );overlay=nil end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Contact_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )

   				

			end

	    end

    return true 

	end


local function consultantTounch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			 				    local options = {
										effect = "crossFade",
										time = 300,	
										params = { tabbuttonValue2 =json.encode(tabButtons),contactDetails = event.target.value}
										}

					    composer.gotoScene( "Controller.chatPage", options )


	end

	return true

end

local function Broadcast_list( list )


	for j=#BroadcastList_array, 1, -1 do 
		
		display.remove(BroadcastList_array[#BroadcastList_array])
		BroadcastList_array[#BroadcastList_array] = nil
	end



	for i=1,#list do

		local flag = true

		for j=1,i-1 do

			if list[j].Message_To == list[i].Message_To  then

				flag=false

			end

		end
		--print( json.encode( list[i] ))

		if flag then 

			BroadcastList_array[#BroadcastList_array+1] = display.newGroup()

			local tempGroup = BroadcastList_array[#BroadcastList_array]

			local Image 

			local tempHeight = 0

			local background = display.newRect(tempGroup,0,0,W,50)

			if(BroadcastList_array[#BroadcastList_array-1]) ~= nil then
				tempHeight = BroadcastList_array[#BroadcastList_array-1][1].y + BroadcastList_array[#BroadcastList_array-1][1].height+3
			end

			background.anchorY = 0
			background.x=W/2;background.y=tempHeight
			background.id=list[i].Message_To
			background.alpha=0.01
			background.value = list[i]

			print( json.encode( list[i]))

			local Name_txt = display.newText(tempGroup,list[i].ToName,0,0,native.systemFont,14)
			Name_txt.x=5;Name_txt.y=background.y+background.height/2-10
			Name_txt.anchorX=0
			Utils.CssforTextView(Name_txt,sp_labelName)
			Name_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

			local Position_txt = display.newText(tempGroup,list[i].MyUnitBuzz_Message,0,0,native.systemFont,14)
			Position_txt.x=5;Position_txt.y=background.y+background.height/2+10
			Position_txt.anchorX=0
			Utils.CssforTextView(Position_txt,sp_fieldValue)

			local right_img = display.newImageRect(tempGroup,"res/assert/arrow_1.png",15/2,30/2)
			right_img.anchorX=0
			right_img.x=background.x+background.contentWidth/2-30;right_img.y=background.y+background.height/2

			local line = display.newRect(tempGroup,W/2,background.y,W,1)
			line.y=background.y+background.contentHeight-line.contentHeight
			line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
--UPDATE
			local new_msgCount = 0

			if list[i].Message_Status == "UPDATE" then

				for k=1,#list do

					if list[i].Message_To == list[k].Message_To then

						if list[i].Message_Status == "UPDATE" and list[k].Message_Status == "UPDATE" then

							new_msgCount=new_msgCount+1

						end

					end

				end

				local circle = display.newCircle( tempGroup, W-80, background.y+background.contentHeight/2, 10 )
				circle.height=23;circle.width=25
				circle:setFillColor( Utils.convertHexToRGB("#008B45" ))

				local circle_txt = display.newText( tempGroup,new_msgCount,circle.x,circle.y,native.systemFontBold,14 )
				circle_txt:setTextColor( 1)

			end

			background:addEventListener( "touch", consultantTounch )
			broad_scrollview:insert(tempGroup)

		end

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

	title.text = "Messages"


   


			-- broadcastList_scrollview = widget.newScrollView
			-- {
			-- 	top = RecentTab_Topvalue-5,
			-- 	left = 0,
			-- 	width = W,
			-- 	height =H-RecentTab_Topvalue-chattabBar.height+5,
			-- 	hideBackground = true,
			-- 	isBounceEnabled=false,
			-- 	horizontalScrollingDisabled = true,
			-- 	verticalScrollingDisabled = false,
			-- }

   --          sceneGroup:insert(broadcastList_scrollview)

    MainGroup:insert(sceneGroup)

end



	function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

		composer.removeHidden()

		broad_scrollview = widget.newScrollView
			{
				top = RecentTab_Topvalue-5,
				left = 0,
				width = W,
				height =H-RecentTab_Topvalue-50+5,
				hideBackground = true,
				isBounceEnabled=false,
				horizontalScrollingDisabled = true,
				verticalScrollingDisabled = false,
			}

            sceneGroup:insert(broad_scrollview)

	for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message ORDER BY id DESC ") do

		BroadcastList[#BroadcastList+1] =row

	end

	if #BroadcastList ~= nil then

		Broadcast_list(BroadcastList)
	end

		function printTimeSinceStart( event )
		    if chatReceivedFlag==true then
		    	chatReceivedFlag=false

		    	for i=1,#BroadcastList do
		    		
		    		BroadcastList[i]=nil

		    	end

		    	for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message ORDER BY id DESC ") do

					BroadcastList[#BroadcastList+1] =row

				end

				if #BroadcastList ~= nil then

					Broadcast_list(BroadcastList)
				end
		    end
		end 
		Runtime:addEventListener( "enterFrame", printTimeSinceStart )


			

		if event.params then
			nameval = event.params.tabbuttonValue1

		end

-- 	 tabButtons = {
-- {
--         label = "Group",
--         defaultFile = "res/assert/phone.png",
--         overFile = "res/assert/phone.png",
--         size = 11.5,
--         labelYOffset = 2,
--         id = "group",
--         labelColor = { 
--             default = { 0,0,0}, 
--             over = { 0,0,0 }
--         },
--         width = 20,
--         height = 20,
--         onPress = handleTabBarEvent,
--     },


--        {
--         label = "Chats",
--         defaultFile = "res/assert/user.png",
--         overFile = "res/assert/user.png",
--         size = 11.5,
--         labelYOffset = 2,
--         id = "broadcast_list",
--         labelColor = { 
--              default = { 0,0,1}, 
--             over = {0,0,1}
--         },
--         width = 20,
--         height = 20,
--         onPress = handleTabBarEvent,
--         selected = true,
--     },


--     {
--         label = "Consultant List",
--         defaultFile = "res/assert/map.png",
--         overFile = "res/assert/map.png",
--         size = 11.5,
--         labelYOffset = 2,
--         id = "consultant_list",
--         labelColor = { 
--             default = { 0,0,0}, 
--             over = { 0,0,0 }
--         },
--         width = 16,
--         height = 20,
--         onPress = handleTabBarEvent,
--     }
   
-- }



-- 			    chattabBar = widget.newTabBar{
-- 			    top =  display.contentHeight - 55,
-- 			    left = 0,
-- 			    width = display.contentWidth, 
-- 			    backgroundFile = tabBarBackground,
-- 			    tabSelectedLeftFile = tabBarLeft,   
-- 			    tabSelectedRightFile = tabBarRight,    
-- 			    tabSelectedMiddleFile = tabBarMiddle,   
-- 			    tabSelectedFrameWidth = 20,                                         
-- 			    tabSelectedFrameHeight = 50, 
-- 			    backgroundFrame = 1,
-- 			    tabSelectedLeftFrame = 2,
-- 			    tabSelectedMiddleFrame = 3,
-- 			    tabSelectedRightFrame = 4,                                       
-- 			    buttons = tabButtons,
-- 			    height = 50,
-- 			}

-- 			sceneGroup:insert(chattabBar)


--             local rect = display.newRect(0,0,display.contentWidth,1.3)
-- 			rect.x = 0;
-- 			rect.anchorX=0
-- 			rect.y = display.contentHeight - 50;
-- 			rect:setFillColor(0)
-- 			sceneGroup:insert( rect )


tabBg = display.newRect( tabBarGroup, W/2, H-40, W, 40 )
tabBg.anchorY=0
tabBg.strokeWidth = 1
tabBg:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor),0.7 )

tab_Group = display.newRect(tabBarGroup,0,0,70,40)
tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
tab_Group.anchorY=0
tab_Group.alpha=0.01
tab_Group.id="group"
tab_Group:setFillColor( 0.2 )

tab_Message = display.newRect(tabBarGroup,0,0,70,40)
tab_Message.x=W/2;tab_Message.y=tabBg.y
tab_Message.anchorY=0
tab_Message.alpha=0.01
tab_Message.id="message"
tab_Message:setFillColor( 0.2 )

tab_Contact = display.newRect(tabBarGroup,0,0,70,40)
tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
tab_Contact.anchorY=0
tab_Contact.alpha=0.01
tab_Contact.id="contact"
tab_Contact:setFillColor( 0.2 )

tab_Group:addEventListener( "touch", TabbarTouch )
tab_Message:addEventListener( "touch", TabbarTouch )
tab_Contact:addEventListener( "touch", TabbarTouch )

CreateTabBarIcons()

	if tab_Message_btn then tab_Message_btn:removeSelf( );tab_Message_btn=nil end

	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0

	overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
	overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

tab_Group_txt = display.newText( tabBarGroup, "Group",0,0,native.systemFont,11 )
tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
tab_Group_txt:setFillColor( 0.3 )

tab_Message_txt = display.newText( tabBarGroup, "Chats",0,0,native.systemFont,11 )
tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

tab_Contact_txt = display.newText( tabBarGroup, "Consultant List",0,0,native.systemFont,11 )
tab_Contact_txt.x=tab_Contact_btn.x;tab_Contact_txt.y=tab_Contact_btn.y+tab_Contact_btn.contentHeight+5
tab_Contact_txt:setFillColor( 0.3 )

sceneGroup:insert( tabBarGroup )


	elseif phase == "did" then

		--Webservice.GET_ACTIVE_TEAMMEMBERS(get_Activeteammember)

	
	-- local centerText = display.newText(sceneGroup,"Broadcast List",0,0,native.systemFontBold,16)
	-- centerText.x=W/2;centerText.y=H/2
	-- centerText:setFillColor( 0 )

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


Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
	menuBtn:removeEventListener("touch",menuTouch)
	BgText:removeEventListener("touch",menuTouch)

	Runtime:removeEventListener( "key", onKeyEvent )
	tab_Group_btn=nil;tab_Message_btn=nil;tab_Contact_btn=nil
	elseif phase == "did" then

	composer.removeHidden()

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


