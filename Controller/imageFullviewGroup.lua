local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )


openPage="ImageFullViewGroup"

local leftPadding = 10

local W = display.contentWidth;H= display.contentHeight



-- local function onCloseTouch( event )
--     if event.phase == "began" then
--         display.getCurrentStage():setFocus( event.target )
--         elseif event.phase == "ended" then
--         display.getCurrentStage():setFocus( nil )

--         print("close",AlertGroup.numChildren)
--        for j=AlertGroup.numChildren, 1, -1 do 
-- 						display.remove(AlertGroup[AlertGroup.numChildren])
-- 						AlertGroup[AlertGroup.numChildren] = nil
-- 	 	end

--     end

--     return true

-- end



local function touchBg( event )

	if event.phase == "began" then

		elseif event.phase == "ended" then

		native.setKeyboardFocus(nil)

				  --      for j=ImageFullViewGroup.numChildren, 1, -1 do 
						-- display.remove(ImageFullViewGroup[ImageFullViewGroup.numChildren])
						-- ImageFullViewGroup[ImageFullViewGroup.numChildren] = nil
	 	   --            end

	 	end
	 	return true
	 end



	 function GetImageFullViewPopup()

	 	if ImageFullViewGroup.numChildren ~= nil then
	 		for j=ImageFullViewGroup.numChildren, 1, -1 do 
	 			display.remove(ImageFullViewGroup[ImageFullViewGroup.numChildren])
	 			ImageFullViewGroup[ImageFullViewGroup.numChildren] = nil
	 		end
	 	end

	 	ImageFullViewGroup.isVisible = true

	 	ImageFullViewGroup=display.newGroup( )
	 	print("coming here")

	 	Background = display.newImageRect(ImageFullViewGroup,"res/assert/background.jpg",W,H)
	 	Background.x=W/2;Background.y=H/2
	 	Background.alpha = 0.35
	 	Background:addEventListener("touch",touchBg)

	 	AlertTop_bg = display.newRect(ImageFullViewGroup,leftPadding_value + 140, H/2-100, W-20, 150 )
	 	AlertTop_bg:setFillColor(1,0,0)
	 	AlertTop_bg:setStrokeColor(0,0,0)
	 	AlertTop_bg.strokeWidth = 0.4
	 	AlertTop_bg.isVisible=false
	 	AlertTop_bg:addEventListener("touch",touchBg)

	 	AlertTop = display.newRect(W/2,H/2-185,299,30)
	 	AlertTop:setStrokeColor(0,0,0,0.5)
	 	AlertTop.strokeWidth = 0.51
	 	AlertTop:setFillColor(Utils.convertHexToRGB(color.Gray))
	 	ImageFullViewGroup:insert(AlertTop)

	 	AlertText = display.newText(ImageLibrary.Image ,0,0,native.systemFontBold,15)
	 	AlertText.anchorX=0
	 	AlertText.x=20;AlertText.y=AlertTop.y
	 	AlertText:setFillColor(1,1,1)
	 	ImageFullViewGroup:insert(AlertText)

	 	alertList = display.newRect(leftPadding_value + 140, H/2+18, W-21, 375 )
	 	alertList.strokeWidth=1
	 	alertList:setFillColor(1,1,1,0.3)
	 	alertList:setStrokeColor(Utils.convertHexToRGB(color.LtyGray))
	 	AlertGroup:insert(alertList)

	 	

	 	MainGroup:insert(ImageFullViewGroup)


	 end



