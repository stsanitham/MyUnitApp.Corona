----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="eventCalenderPage"


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

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newText(sceneGroup,"MyUnit Buzz",0,0,native.systemFont,16)
	BgText:setFillColor( Utils.convertHexToRGB(color.White))
	BgText.x=menuBtn.x+menuBtn.contentWidth+15;BgText.y=menuBtn.y
	BgText.anchorX=0

	MainGroup:insert(sceneGroup)

end




function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

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