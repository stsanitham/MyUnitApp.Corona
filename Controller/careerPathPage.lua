----------------------------------------------------------------------------------
--
-- Career path Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

--Button

local menuBtn


--------------------------------------------------


-----------------Function-------------------------


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newRect(sceneGroup,W/2,H/2,W,H)

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",30,30)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newText(sceneGroup,"MyUnit App",0,0,native.systemFont,integer.TITLE_TEXT_SIZE)
	BgText:setFillColor( Utils.convertHexToRGB(color.black))
	BgText.x=menuBtn.x+menuBtn.contentWidth+15;BgText.y=menuBtn.y
	BgText.anchorX=0

	center = display.newText(sceneGroup,"Career Path Page",0,0,native.systemFont,integer.TITLE_TEXT_SIZE)
	center:setFillColor( Utils.convertHexToRGB(color.black))
	center.x=W/2;center.y=H/2

	
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