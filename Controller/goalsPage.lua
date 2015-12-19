----------------------------------------------------------------------------------
--
-- Golas Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local json = require('json')

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local GoalText

local menuBtn,webView

openPage="goalsPage"

local RecentTab_Topvalue = 40

local cleaner = {
{ "&amp;", "&" },
{ "&#151;", "-" },
{ "&#146;", "'" },
{ "&#160;", " " },
{ "&nbsp;", " " },
{ "&#39;", "'" },
{ "<br />", "\n" },
{ "</p>", "\n\n" },
{ "(%b<>)", "\n" },
{ "\n\n*", "\n" },
{ "\n*$", "\n" },
{ "^\n*", "\n" },
{ "&quot;", "'" },
}

--------------------------------------------------


-----------------Function-------------------------


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

	


	MainGroup:insert(sceneGroup)
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then





		elseif phase == "did" then

			composer.removeHidden()

			goal_scrollview  = widget.newScrollView
			{
			top = RecentTab_Topvalue,
			left = 0,
			width = W,
			height =H-70,
			hideBackground = true,
			isBounceEnabled=false,
			horizontalScrollingDisabled = false,
			verticalScrollingDisabled = false,

   -- listener = scrollListener
}

goal_scrollview.anchorY=0
goal_scrollview.y=RecentTab_Topvalue+30
goal_scrollview.x=W/2


title = display.newText(sceneGroup,"Goals",0,0,native.systemFont,18)
title.anchorX = 0 ;title.anchorY=0
title.x=5;title.y = tabBar.y+tabBar.contentHeight/2+10
title:setFillColor(0)





function get_Goals(response)

	if response.MyUnitBuzzGoals ~= nil then



		local t = response.MyUnitBuzzGoals


		for i=1, #cleaner do
			local cleans = cleaner[i]
			t = string.gsub( t, cleans[1], cleans[2] )
		end

		print(t)


		GoalText = display.newText(t,0,0,W-20,t:len()/2.2,native.systemFont,14)
		GoalText.anchorY=0
		GoalText.x=W/2;GoalText.y=0
		GoalText:setFillColor(Utils.convertHexToRGB(color.Black))
		goal_scrollview:insert(GoalText)
	end

end
Webservice.GET_MYUNITAPP_GOALS(get_Goals)


sceneGroup:insert(goal_scrollview)


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

			composer.removeHidden()

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