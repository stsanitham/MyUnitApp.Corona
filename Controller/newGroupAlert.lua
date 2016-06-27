local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )


openPage="newGroupAlert"

local leftPadding = 10

local W = display.contentWidth;H= display.contentHeight




local function touchBg( event )

	if event.phase == "began" then

		elseif event.phase == "ended" then

		native.setKeyboardFocus(nil)

	end
	return true
end


function GroupNamePopup()

	if NewGroupAlert.numChildren ~= nil then
		for j=NewGroupAlert.numChildren, 1, -1 do 
			display.remove(NewGroupAlert[NewGroupAlert.numChildren])
			NewGroupAlert[NewGroupAlert.numChildren] = nil
		end
	end

	NewGroupAlert.isVisible = true

	NewGroupAlert=display.newGroup( )
	print("coming here")

	Background = display.newImageRect(NewGroupAlert,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.alpha = 0.28
	Background:addEventListener("touch",touchBg)

	AlertTop_bg = display.newRect(NewGroupAlert,leftPadding_value + 140, H/2-11, W-20, 160 )
	AlertTop_bg:setFillColor(0,0,0)
	AlertTop_bg:setStrokeColor(0,0,0,0.5)
	AlertTop_bg.strokeWidth = 0.4
	AlertTop_bg.isVisible=false
	AlertTop_bg:addEventListener("touch",touchBg)

	AlertTop = display.newRect(W/2,H/2-106.1,299,30)
	AlertTop:setStrokeColor(0,0,0,0.8)
	AlertTop.strokeWidth = 0.51
	AlertTop:setFillColor(Utils.convertHexToRGB(color.Gray))
	NewGroupAlert:insert(AlertTop)

	AlertText = display.newText("Group Name" ,0,0,native.systemFontBold,15)
	AlertText.anchorX=0
	AlertText.x=20;AlertText.y=AlertTop.y
	AlertText:setFillColor(0,0,0)
	NewGroupAlert:insert(AlertText)

	alertList = display.newRect(leftPadding_value + 140, H/2 -10.62, W-22, 158 )
	alertList.strokeWidth=1
	alertList.y = H/2 -10.62
	alertList:setStrokeColor(0,0,0,0.5)
	NewGroupAlert:insert(alertList)

	GroupPic = display.newImageRect("res/assert/usericon.png",55,50)
	GroupPic.x= 20
	GroupPic.y = alertList.y-70
	GroupPic.anchorY=0
	GroupPic.anchorX=0
	NewGroupAlert:insert( GroupPic )

	GroupSubjectHelpText=  display.newText("Please provide group subject" ,0,0,native.systemFontBold,15)
	GroupSubjectHelpText.anchorX=0
	GroupSubjectHelpText.x=GroupPic.x + GroupPic.contentWidth+10
	GroupSubjectHelpText.y=GroupPic.y + 25
	GroupSubjectHelpText:setFillColor(0,0,0)
	NewGroupAlert:insert(GroupSubjectHelpText)

	GroupSubject =  native.newTextField( W/2+3, GroupPic.y + 20, W-40, 25)
	GroupSubject.id="groupSubject"
	GroupSubject.y = GroupPic.y + GroupPic.contentHeight+25
	GroupSubject.size=14
	GroupSubject.anchorX = 0
	GroupSubject.x = 20
	GroupSubject:setReturnKey( "done" )
	GroupSubject.hasBackground = false	
	GroupSubject.placeholder = "Type group subject here..."
	NewGroupAlert:insert(GroupSubject)

	CancelButton = display.newImageRect(NewGroupAlert,"res/assert/positive_alert.png" ,100, EditBoxStyle.height)
	CancelButton.x = 55
	CancelButton.anchorX = 0
	CancelButton.id = "cancelstep"
	CancelButton.y = GroupSubject.y+GroupSubject.contentHeight+20

	cancelbutton_text = display.newText("Cancel",0,0,native.systemFont,14)
	cancelbutton_text.x=CancelButton.x+50
	cancelbutton_text.y=CancelButton.y
	cancelbutton_text:setFillColor(0,0,0)
	NewGroupAlert:insert(cancelbutton_text)

	AcceptButton = display.newImageRect(NewGroupAlert,"res/assert/negative_alert.png" ,100, EditBoxStyle.height)
	AcceptButton.x = CancelButton.x + CancelButton.contentWidth+10
	AcceptButton.anchorX = 0
	AcceptButton.id = "nextstep"
	AcceptButton.y = GroupSubject.y+GroupSubject.contentHeight+20

	acceptbutton_text = display.newText("Next",0,0,native.systemFont,14)
	acceptbutton_text.x=AcceptButton.x+50
	acceptbutton_text.y=AcceptButton.y
	acceptbutton_text:setFillColor(0,0,0)
	NewGroupAlert:insert(acceptbutton_text)

end



