----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="messageLanding"



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

------------------------------------------------------

function scene:create( event )

	 local sceneGroup = self.view

	-- Background = display.newImageRect(chatGroup,"res/assert/background.jpg",W,H)
	-- Background.x=W/2;Background.y=H/2

	-- tabBar = display.newRect(chatGroup,W/2,0,W,40)
	-- tabBar.y=tabBar.contentHeight/2
	-- tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	-- menuBtn = display.newImageRect(chatGroup,"res/assert/menu.png",23,17)
	-- menuBtn.anchorX=0
	-- menuBtn.x=10;menuBtn.y=20;

	-- BgText = display.newImageRect(chatGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	-- BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	-- BgText.anchorX=0

	-- title_bg = display.newRect(chatGroup,0,0,W,30)
	-- title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	-- title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	-- title = display.newText(chatGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
	-- title.anchorX = 0
	-- title.x=5;title.y = title_bg.y
	-- title:setFillColor(0)

 --    MainGroup:insert(chatGroup)

end



function scene:show( event )


	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

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
        onPress = function() composer.gotoScene( "Controller.chatMessagePage" ); end,
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
        onPress =  function() composer.gotoScene( "Controller.Chat" ); end,
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
        onPress = function() composer.gotoScene( "Controller.GroupChat" ); end,
    },
    {
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
        onPress = function() composer.gotoScene( "Controller.ConsultantList" ); end,
    },
}

--chatGroup:insert(tabButtons)

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

			chatGroup:insert(chattabBar)

            rect = display.newRect(0,0,display.contentWidth,1.3)
			rect.x = 0;
			rect.anchorX=0
			rect.y = display.contentHeight - 50;
			rect:setFillColor(0)
			chatGroup:insert( rect )


    
     chatGroup:toFront()

   -- MainGroup:insert(chatGroup)

	composer.gotoScene( "Controller.chatMessagePage" )

	menuBtn:addEventListener("touch",menuTouch)
		
	end	
	
--MainGroup:insert(chatGroup)

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