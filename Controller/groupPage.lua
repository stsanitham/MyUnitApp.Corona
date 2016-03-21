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



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,tabButtons,chattabBar

openPage="groupPage"

local BackFlag = false

local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"





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


	MainGroup:insert(sceneGroup)

	end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

			if event.params then
				nameval = event.params.tabbuttonValue3
			end

			local centerText = display.newText(sceneGroup,"Group Page",0,0,native.systemFontBold,16)
			centerText.x=W/2;centerText.y=H/2
			centerText:setFillColor( 0 )


		elseif phase == "did" then

			menuBtn:addEventListener("touch",menuTouch)
			
		end	
		
	MainGroup:insert(sceneGroup)

	end



	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


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