local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )


openPage="AlertGroup"

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
-- 	 	  end
--     end
--     return true
-- end



local function touchBg( event )

	if event.phase == "began" then

	elseif event.phase == "ended" then

		native.setKeyboardFocus(nil)

	end

	return true
end



function GetAlertPopup()

	if AlertGroup.numChildren ~= nil then
		for j=AlertGroup.numChildren, 1, -1 do 
			display.remove(AlertGroup[AlertGroup.numChildren])
			AlertGroup[AlertGroup.numChildren] = nil
		end
	end

	AlertGroup.isVisible = true

	AlertGroup=display.newGroup( )
	print("coming here")

	Background = display.newImageRect(AlertGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.alpha = 0.35
	Background:addEventListener("touch",touchBg)

	AlertTop_bg = display.newRect(AlertGroup,leftPadding_value + 140, H/2-11, W-20, 160 )
	AlertTop_bg:setFillColor(0,0,0)
	AlertTop_bg:setStrokeColor(0,0,0)
	AlertTop_bg.strokeWidth = 0.4
	AlertTop_bg.isVisible=false
	AlertTop_bg:addEventListener("touch",touchBg)

	AlertTop = display.newRect(W/2,H/2-106.1,299,30)
	AlertTop:setStrokeColor(0,0,0,0.5)
	AlertTop.strokeWidth = 0.51
	AlertTop:setFillColor(Utils.convertHexToRGB(color.Gray))
	AlertGroup:insert(AlertTop)

	AlertText = display.newText(CommonWords.Remove ,0,0,native.systemFontBold,15)
	AlertText.anchorX=0
	AlertText.x=20;AlertText.y=AlertTop.y
	AlertText:setFillColor(1,1,1)
	AlertGroup:insert(AlertText)

	alertList = display.newRect(leftPadding_value + 140, H/2 -10.62, W-22, 158 )
	alertList.strokeWidth=1
	alertList:setStrokeColor(Utils.convertHexToRGB(color.LtyGray))
	AlertGroup:insert(alertList)

	AlertContentText = display.newText(CareerPath.RemoveAccess,0,0,W-20,0,native.systemFont,14)
	AlertContentText.x = 20
	AlertContentText.anchorX= 0
	AlertContentText.y=AlertTop.y+AlertTop.contentHeight+10
	AlertContentText:setFillColor(0,0,0)
	AlertGroup:insert(AlertContentText)


------------------------------remove or block buttons------------------------------------------

	accept_button = display.newImageRect(AlertGroup,"res/assert/positive_alert.png" ,200, EditBoxStyle.height)
	accept_button.x = W/2
	accept_button.id = "accept"
	accept_button.y = AlertContentText.y+AlertContentText.contentHeight+22
	--accept_button:addEventListener("touch",onProcessButtonTouch)

	accept_button_text = display.newText(AlertGroup,CareerPath.ToRemove,0,0,native.systemFont,14)
	accept_button_text.x=accept_button.x
	accept_button_text.y=accept_button.y
	accept_button_text:setFillColor(0,0,0)


	reject_button = display.newImageRect(AlertGroup,"res/assert/negative_alert.png",200, EditBoxStyle.height)
	reject_button.id = "reject"
	reject_button.x = accept_button.x
	reject_button.y = accept_button.y + accept_button.contentHeight+15
	--reject_button:addEventListener("touch",onProcessButtonTouch)

	reject_button_text = display.newText(AlertGroup,CareerPath.NotToRemove,0,0,native.systemFont,14)
	reject_button_text.x=reject_button.x + 15
	reject_button_text.y=reject_button.y
	reject_button_text:setFillColor(0,0,0)

	MainGroup:insert(AlertGroup)

end


 --  accept_button = display.newImageRect(AlertGroup,"res/assert/positive_alert.png" ,200, EditBoxStyle.height)
 --  	--accept_button:setStrokeColor(0,0,0,0.7)
 --  	--accept_button:setFillColor(0,0,0,0.3)
 --  	--accept_button.cornerRadius = 2
 --  	accept_button.x = W/2
 --  	accept_button.id = "accept"
 --  	accept_button.y = AlertContentText.y+AlertContentText.contentHeight+22
 --  	--accept_button.hasBackground = true
-- --accept_button.strokeWidth = 1
-- --AlertGroup:insert(accept_button)
-- --accept_button:addEventListener("touch",onProcessButtonTouch)


-- --  reject_button = display.newRect( AlertGroup, 0,0 ,200, EditBoxStyle.height)
-- 	reject_button = display.newImageRect(AlertGroup,"res/assert/negative_alert.png",200, EditBoxStyle.height)
--   	--reject_button:setStrokeColor(0,0,0,0.7)
--   	--reject_button:setFillColor(0,0,0,0.3)
--   	--reject_button.cornerRadius = 2
--   	reject_button.id = "reject"
--   	reject_button.x = accept_button.x
--   	reject_button.y = accept_button.y + accept_button.contentHeight+15
--   	--reject_button.hasBackground = true
-- 	--reject_button.strokeWidth = 1
-- 	--reject_button:addEventListener("touch",onProcessButtonTouch)