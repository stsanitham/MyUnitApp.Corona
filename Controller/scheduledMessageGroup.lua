local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )


openPage="ScheduledMessageGroup"

local leftPadding = 10

local W = display.contentWidth;H= display.contentHeight





local function touchBg( event )

		if event.phase == "began" then

		elseif event.phase == "ended" then

				native.setKeyboardFocus(nil)

		end
		return true
end



function GetScheduleMessageAlertPopup()

		if ScheduledMessageGroup.numChildren ~= nil then
			 for j=ScheduledMessageGroup.numChildren, 1, -1 do 
								display.remove(ScheduledMessageGroup[ScheduledMessageGroup.numChildren])
								ScheduledMessageGroup[ScheduledMessageGroup.numChildren] = nil
			 end
		end

		ScheduledMessageGroup.isVisible = true

        Background = display.newImageRect(ScheduledMessageGroup,"res/assert/background.jpg",W,H)
	    Background.x=W/2;Background.y=H/2
	    Background.alpha = 0.35
	    Background:addEventListener("touch",touchBg)

	    AlertTop_bg = display.newRect(ScheduledMessageGroup,leftPadding_value + 140, H/2-11, W-20, 160 )
	    AlertTop_bg:setFillColor(0,0,0)
	    AlertTop_bg:setStrokeColor(0,0,0)
	    AlertTop_bg.strokeWidth = 0.4
	    AlertTop_bg.isVisible=false
	    AlertTop_bg:addEventListener("touch",touchBg)

	    AlertTop = display.newRect(W/2,H/2-85,299,30)
  	    AlertTop:setStrokeColor(0,0,0,0.5)
  	    AlertTop.strokeWidth = 0.51
	    AlertTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	    ScheduledMessageGroup:insert(AlertTop)

	    AlertText = display.newText(MessagePage.ScheduleText,0,0,native.systemFontBold,15)
	    AlertText.anchorX=0
	    AlertText.x=20;AlertText.y=AlertTop.y
	    AlertText:setFillColor(1,1,1)
	    ScheduledMessageGroup:insert(AlertText)


		Alertclose_icon = display.newImageRect("res/assert/icon-close.png",20,20)
		Alertclose_icon.x= W - 40
		Alertclose_icon.anchorX=0
		Alertclose_icon.id = "closealert"
		Alertclose_icon.anchorY=0
		Alertclose_icon.y= AlertText.y - 10
		ScheduledMessageGroup:insert(Alertclose_icon)


		alertList = display.newRect(leftPadding_value + 140, H/2 -10.62, W-22, 118 )
		alertList.strokeWidth=1
        alertList:setStrokeColor(Utils.convertHexToRGB(color.LtyGray))
	    ScheduledMessageGroup:insert(alertList)

	    AlertContentText = display.newText("",0,0,W-20,0,native.systemFont,14)
	    AlertContentText.x = 20
	    AlertContentText.anchorX= 0
	    AlertContentText.y=AlertTop.y+AlertTop.contentHeight+10
	    AlertContentText:setFillColor(0,0,0)
	    ScheduledMessageGroup:insert(AlertContentText)



		Date_bg = display.newRect( leftPadding_value+65, AlertTop.y+AlertTop.contentHeight+15, W-200, 25)
		Date_bg:setStrokeColor( 0, 0, 0 , 0.3 )
        Date_bg.strokeWidth = 1
        Date_bg.y = AlertTop.y+AlertTop.contentHeight+20
		Date_bg:setFillColor( 0,0,0,0 )
		Date_bg.id="date"
		ScheduledMessageGroup:insert(Date_bg)


		Date = display.newText("",Date_bg.x+10,Date_bg.y,Date_bg.contentWidth,Date_bg.height,native.systemFont,14 )
		Date.text = MessagePage.ScheduleDate
		Date.value = "Date"
		Date.id="date"
		Date.alpha=0.9
		Date:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		Date.y=Date_bg.y+5
	    ScheduledMessageGroup:insert(Date)

  		
  		DateSelect_icon = display.newImageRect(ScheduledMessageGroup,"res/assert/arrow2.png",14,9 )
  		DateSelect_icon.x=Date_bg.x+Date_bg.contentWidth/2-15
  		DateSelect_icon.y=Date_bg.y


		Andsymbol_text = display.newText(ScheduledMessageGroup," @ ",0,0,native.systemFont,15)
		Andsymbol_text.x=Date_bg.x + Date_bg.width/2 + 15
		Andsymbol_text.y=Date_bg.y
		Andsymbol_text:setFillColor(0,0,0)



		Time_bg = display.newRect( W/2+75, AlertTop.y+AlertTop.contentHeight+20, W-200, 25)
		Time_bg:setStrokeColor( 0, 0, 0 , 0.3 )
        Time_bg.strokeWidth = 1
        Time_bg.y = Andsymbol_text.y
		Time_bg:setFillColor( 0,0,0,0 )
		Time_bg.id="time"
		ScheduledMessageGroup:insert(Time_bg)


		Time = display.newText("",Time_bg.x+10,Time_bg.y,Time_bg.contentWidth,Time_bg.height,native.systemFont,14 )
		Time.text = MessagePage.ScheduleTime
		Time.value = "time"
		Time.id="time"
		Time.alpha=0.9
		Time:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		Time.y=Time_bg.y+5
	    ScheduledMessageGroup:insert(Time)

  		
  		TimeSelect_icon = display.newImageRect(ScheduledMessageGroup,"res/assert/arrow2.png",14,9 )
  		TimeSelect_icon.x=Time_bg.x+Time_bg.contentWidth/2-15
  		TimeSelect_icon.y=Time_bg.y



------------------------------remove or block buttons------------------------------------------

    acceptschedule_button = display.newImageRect(ScheduledMessageGroup,"res/assert/positive_alert.png" ,245, EditBoxStyle.height)
  	acceptschedule_button.x = W/2
  	acceptschedule_button.id = "set-time"
  	acceptschedule_button.y = AlertContentText.y+AlertContentText.contentHeight+42

	acceptschedule_button_text = display.newText(ScheduledMessageGroup,MessagePage.ScheduleButtonText,0,0,acceptschedule_button.width - 40,30,native.systemFont,14)
	acceptschedule_button_text.x=acceptschedule_button.x + 25
	acceptschedule_button_text.height = 30
	acceptschedule_button_text.y=acceptschedule_button.y
	acceptschedule_button_text:setFillColor(0,0,0)

	acceptschedule_button.height = acceptschedule_button_text.contentHeight+10


	MainGroup:insert(ScheduledMessageGroup)


   end





