local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )


openPage="DeleteMessageGroup"

local leftPadding = 10

local W = display.contentWidth;H= display.contentHeight





local function touchBg( event )

	if event.phase == "began" then

		elseif event.phase == "ended" then

		native.setKeyboardFocus(nil)

	end
	return true
end



function GetDeleteMessageAlertPopup()

	if DeleteMessageGroup.numChildren ~= nil then
		for j=DeleteMessageGroup.numChildren, 1, -1 do 
			display.remove(DeleteMessageGroup[DeleteMessageGroup.numChildren])
			DeleteMessageGroup[DeleteMessageGroup.numChildren] = nil
		end
	end

	DeleteMessageGroup.isVisible = true

	Background = display.newImageRect(DeleteMessageGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.alpha = 0.35
	Background:addEventListener("touch",touchBg)

	AlertTop_bg = display.newRect(DeleteMessageGroup,leftPadding_value + 140, H/2-11, W-20, 160 )
	AlertTop_bg:setFillColor(0,0,0)
	AlertTop_bg:setStrokeColor(0,0,0)
	AlertTop_bg.strokeWidth = 0.4
	AlertTop_bg.isVisible=false
	AlertTop_bg:addEventListener("touch",touchBg)

	AlertTop = display.newRect(W/2,H/2-106.1,299,30)
	AlertTop:setStrokeColor(0,0,0,0.5)
	AlertTop.strokeWidth = 0.51
	AlertTop:setFillColor(Utils.convertHexToRGB(color.Gray))
	DeleteMessageGroup:insert(AlertTop)

	AlertText = display.newText(MessagePage.DeleteText,0,0,native.systemFontBold,15)
	AlertText.anchorX=0
	AlertText.x=20;AlertText.y=AlertTop.y
	AlertText:setFillColor(1,1,1)
	DeleteMessageGroup:insert(AlertText)

	alertList = display.newRect(leftPadding_value + 140, H/2 -10.62, W-22, 158 )
	alertList.strokeWidth=1
	alertList:setStrokeColor(Utils.convertHexToRGB(color.LtyGray))
	DeleteMessageGroup:insert(alertList)

	AlertContentText = display.newText(MessagePage.DeleteConfirmText,0,0,W-25,0,native.systemFont,14)
	AlertContentText.x = 17
	AlertContentText.anchorX= 0
	AlertContentText.height = 30
	AlertContentText.y=AlertTop.y+AlertTop.contentHeight+10
	AlertContentText:setFillColor(0,0,0)
	DeleteMessageGroup:insert(AlertContentText)


------------------------------remove or block buttons------------------------------------------

accept_button = display.newImageRect(DeleteMessageGroup,"res/assert/positive_alert.png" ,200, EditBoxStyle.height)
accept_button.x = W/2
accept_button.id = "accept"
accept_button.y = AlertContentText.y+AlertContentText.contentHeight+22
	--accept_button:addEventListener("touch",onProcessButtonTouch)

	accept_button_text = display.newText(DeleteMessageGroup,MessagePage.ToDelete,0,0,native.systemFont,14)
	accept_button_text.x=accept_button.x
	accept_button_text.y=accept_button.y
	accept_button_text:setFillColor(0,0,0)



	reject_button = display.newImageRect(DeleteMessageGroup,"res/assert/negative_alert.png",200, EditBoxStyle.height)
	reject_button.id = "reject"
	reject_button.x = accept_button.x
	reject_button.y = accept_button.y + accept_button.contentHeight+15
	--reject_button:addEventListener("touch",onProcessButtonTouch)

	reject_button_text = display.newText(DeleteMessageGroup,MessagePage.NotToDelete,0,0,native.systemFont,14)
	reject_button_text.x=reject_button.x + 15
	reject_button_text.y=reject_button.y
	reject_button_text:setFillColor(0,0,0)


	MainGroup:insert(DeleteMessageGroup)


end





