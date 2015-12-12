----------------------------------------------------------------------------------
--
-- imageSlideView.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local Applicationconfig = require("Utils.ApplicationConfig")




--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,BackBtn



--------------------------------------------------


-----------------Function-------------------------



local function BackTouch( event )
	if event.phase == "began" then

		elseif event.phase == "ended" then
							if myImage then myImage:removeSelf();myImage =nil end

					composer.hideOverlay( "slideRight", 300 )

		--composer.gotoScene( openPage, "flip", 100 )
	end
	return true

end 

local function ImageDownload( event )
	if ( event.isError ) then
		print( "Network error - download failed" )
		elseif ( event.phase == "began" ) then
			print( "Progress Phase: began" )
			elseif ( event.phase == "ended" ) then
			print( "Displaying response image file" )

			spinner_hide()
			myImage = display.newImageRect( event.response.filename, event.response.baseDirectory, W-80, H-150 )
			myImage.alpha = 0
			myImage.x=W/2;myImage.y=H/2
			transition.to( myImage, { alpha=1.0 } )

			MainGroup:insert(myImage)
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

	BackBtn = display.newText(sceneGroup,"<",0,0,native.systemFont,24)
	BackBtn.x=20;BackBtn.y=tabBar.y+tabBar.contentHeight/2+10
	BackBtn:setFillColor(Utils.convertHexToRGB(color.Black))

	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			if event.params then
				print(event.params.FilePath)



				local params = {}
				params.progress = true

				spinner_show()

				imageDownload = network.download(
					ApplicationConfig.IMAGE_BASE_URL..event.params.FilePath,
					"GET",
					ImageDownload,
					params,
					"helloCopy.png",
					system.TemporaryDirectory)

			end


			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)

			BackBtn:addEventListener("touch",BackTouch)
		end	

		MainGroup:insert(sceneGroup)

	end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


			elseif phase == "did" then


					--if myImage then myImage:removeSelf();myImage=nil end
					menuBtn:removeEventListener("touch",menuTouch)
					BgText:removeEventListener("touch",menuTouch)
					network.cancel(imageDownload)

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