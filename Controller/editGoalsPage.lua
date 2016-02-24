----------------------------------------------------------------------------------
--
-- Golas Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local json = require('json')

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local GoalText

local menuBtn,BackBtn

local webView 

openPage="goalsPage"

local BackFlag = false

local RecentTab_Topvalue = 40


--------------------------------------------------


-----------------Function-------------------------


------------------------------------------------------


local function onTimer ( event )

	BackFlag = false

end


local function onKeyEventDetail( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

        	composer.hideOverlay( "slideRight", 300 )
            
            return true
            
        end

    end

        return false
 end



local function BackTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then

	     print("webview check")
	     display.getCurrentStage():setFocus( nil )

		 composer.hideOverlay( "slideRight", 300 )

		 --composer.gotoScene("Controller.goalsPage","slideRight",500)

	end

	return true

end



function scene:create( event )

	print( "******************************" )

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

	MainGroup:insert(sceneGroup)
end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		ga.enterScene("Unit Goals")

		print( "edit goals" )

		elseif phase == "did" then

--composer.removeHidden()

title_bg = display.newRect(sceneGroup,0,0,W,30)
title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

BackBtn = display.newText(sceneGroup,"<",0,0,native.systemFont,26)
BackBtn.x=20;BackBtn.y=tabBar.y+tabBar.contentHeight/2+15
BackBtn:setFillColor(Utils.convertHexToRGB(color.Black))

title = display.newText(sceneGroup,Goals.PageTitle,0,0,native.systemFont,18)
title.anchorX = 0
title.x=BackBtn.x+BackBtn.contentWidth/2+5;title.y = BackBtn.y
title:setFillColor(0)



function saveEditedGoals(response)


end


--Webservice.SAVE_MYUNITAPP_GOALS(saveEditedGoals)


menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)

BackBtn:addEventListener("touch",BackTouch)
title:addEventListener("touch",BackTouch)

Runtime:addEventListener( "key", onKeyEventDetail )

end	

MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

			--composer.removeHidden()

			if webView then webView:removeSelf( );webView=nil end


		elseif phase == "did" then

			event.parent:resumeGame()

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

			Runtime:removeEventListener( "key", onKeyEventDetail )

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