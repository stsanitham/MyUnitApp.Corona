----------------------------------------------------------------------------------
--
-- Splash Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local style = require("res.value.style")
local string = require("res.value.string")


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local Splash_TimeOut = 500



--------------------------------------------------


-----------------Function-------------------------

local function SplashTimeOut( event )
	timer.cancel(event.source)

	composer.gotoScene( "Controller.singInPage", "slideLeft", Splash_TimeOut )
end

------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/bg-image.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/2,81/2)
	BgText.x=W/2;BgText.y=H/2

	

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		timer.performWithDelay( 2000, SplashTimeOut )

	elseif phase == "did" then


		end	

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