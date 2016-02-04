----------------------------------------------------------------------------------
--
-- addevent
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local Utility = require( "Utils.Utility" )
local timePicker = require( "Controller.timePicker" )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="eventCalenderPage"

local eventTime = 0

local EventnameGroup = display.newGroup( )
local EventnameFlag = false
local EventnameArray = {"Appointment","Call","Party","Task","Family Time"}

local leftPadding = 20

local AddeventGroup = display.newGroup( )

local AddeventArray = {}

local saveBtn

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


local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			if event.target.id == "bg" then


			elseif event.target.id == "back" then

				composer.hideOverlay()

			end

	end

return true

end



------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.id="bg"

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	
	titleBar = display.newRect(sceneGroup,W/2,tabBar.y+tabBar.contentHeight/2,W,30)
		titleBar.anchorY=0
		titleBar:setFillColor(Utils.convertHexToRGB(color.tabbar))

		titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
		titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+10
		titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
		titleBar_icon.anchorY=0
		titleBar_icon.id="back"

		titleBar_text = display.newText(sceneGroup,"New Event",0,0,native.systemFont,0)
		titleBar_text.x=titleBar_icon.x+titleBar_icon.contentWidth+5
		titleBar_text.y=titleBar.y+titleBar.contentHeight/2-titleBar_text.contentHeight/2
		titleBar_text.anchorX=0;titleBar_text.anchorY=0
		titleBar_text.id = "back"
		Utils.CssforTextView(titleBar_text,sp_subHeader)
		MainGroup:insert(sceneGroup)


		saveBtn_BG = display.newRect( sceneGroup, titleBar.x+titleBar.contentWidth/2-40, titleBar.y+titleBar.contentHeight/2, 50, 20 )
		saveBtn_BG:setFillColor( Utils.convertHexToRGB(color.tabbar) )
		saveBtn_BG:setStrokeColor( 0.4 )
		saveBtn_BG.strokeWidth=1
		saveBtn = display.newText( sceneGroup, "Save",saveBtn_BG.x,saveBtn_BG.y,native.systemFont,14 )


	
		--Form Design---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="eventtype"
		AddeventArray[#AddeventArray].anchorY=0
		AddeventArray[#AddeventArray].alpha=0.01
		AddeventGroup:insert(AddeventArray[#AddeventArray])


		SelectEventLbl = display.newText(AddeventGroup,"Event Type",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		SelectEventLbl.anchorX=0
		SelectEventLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		SelectEventLbl.x=leftPadding
		SelectEventLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		SelectEvent = display.newText(AddeventGroup,"Appointment",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		SelectEvent.alpha=0.7
		SelectEvent.anchorX=0
		SelectEvent:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		SelectEvent.x=W/2
		SelectEvent.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2


	  	SelectEvent_icon = display.newImageRect(AddeventGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	SelectEvent_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	SelectEvent_icon.y=SelectEvent.y

	  	--------

	



sceneGroup:insert( AddeventGroup )

MainGroup:insert(sceneGroup)
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		eventTime = event.params.details

		print( os.date( "%m/%d/%Y" ,  eventTime )) 

		----What----

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-40, 28)
		AddeventArray[#AddeventArray].id="what"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])

		What = native.newTextField(W/2, AddeventArray[#AddeventArray].y, AddeventArray[#AddeventArray].contentWidth, AddeventArray[#AddeventArray].contentHeight)
		What.id="What"
		What.size=14
		What.anchorY=0
		What.hasBackground = false
		What:setReturnKey( "next" )
		What.placeholder="What"
		AddeventGroup:insert(What)


	  	----------

	  	----AllDay----

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="allday"
		AddeventArray[#AddeventArray].anchorY=0
		AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])

		alldayLbl = display.newText(AddeventGroup,"All Day",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		alldayLbl.anchorX=0
		alldayLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		alldayLbl.x=leftPadding
		alldayLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

			local allday_onOffSwitch = widget.newSwitch {
				style = "onOff",
				initialSwitchState = false
			}
			allday_onOffSwitch.x=alldayLbl.x+alldayLbl.contentWidth+allday_onOffSwitch.contentWidth/2+5
			allday_onOffSwitch.y = alldayLbl.y
			AddeventGroup:insert( allday_onOffSwitch )

	  	--------------



		titleBar_icon:addEventListener("touch",TouchAction)
		titleBar_text:addEventListener("touch",TouchAction)
  		Background:addEventListener( "touch", TouchAction )
		menuBtn:addEventListener("touch",menuTouch)
		
	end	
	
MainGroup:insert(sceneGroup)

end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then



		elseif phase == "did" then

			composer.removeHidden()

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