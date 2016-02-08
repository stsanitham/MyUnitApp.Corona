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

local priorityArray = {"Low","Normal","High"}

local purposeArray = {"Booking","Color Appointment","Customer Service","Double Facial","Facial","Follow Up","Full Circle","Initial Appointment","On the Go","Training","Team Building","Reschedule","2 Day Follow up","2 Week Follow up","2 Month Follow up","Other"}

local repeatList = {"Does not repeat","Daily","Every weekday (Mon-Fri)","Every Mon., Wed., and Fri","Every Tues., and Thurs.","Weekly","Monthly","Yearly"}

local leftPadding = 10

local AddeventGroup = display.newGroup( )

local AddeventArray = {}

local saveBtn

local CalendarId,allDay

local RecentTab_Topvalue = 70

local TicklerType = "APPT"

local List

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

local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( row, List.arrayName[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 10
    rowTitle.y = rowHeight * 0.5


    local tick = display.newImageRect( row, "res/assert/tick.png", 20,20 )
    tick.x = rowWidth - 30
    tick.y = rowHeight * 0.5

    if List.textFiled.text == List.arrayName[row.index] then

    else
    	tick.isVisible = false
    end


    row.name = List.arrayName[row.index]
end

local function onRowTouch(event) 
    print(event.phase)

    local row = event.row

    if event.phase == 'tap' or event.phase == 'release' then

    	List_bg.isVisible = false
		List:deleteAllRows()
		List.isVisible = false

		List.textFiled.text = row.name

		List.textFiled.value = row.index - 1

    end
end

local function CreateList(event)
	List_bg.isVisible = true
					List_bg.x = event.target.x
					List_bg.y = event.target.y+event.target.contentHeight
					List_bg.width =event.target.contentWidth+2
					List_bg.height = List.contentHeight+2


					List:deleteAllRows()

					for i = 1, #List.arrayName do

					    -- Insert a row into the tableView
					    List:insertRow(
					        {
					            isCategory = false,
					            rowHeight = 36,
					            rowColor = { default={1}, over={0.8} },
					        }
					    )
					end

end

local function get_CreateTickler( response )
	print("event Added")

	if response.TicklerId ~= nil then

		if response.TicklerId > 0 then

			local alert = native.showAlert(  EventCalender.PageTitle,"Event Added", { "OK" } )

		end

	end
end


local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			if event.target.id == "bg" then


			elseif event.target.id == "back" then

				composer.hideOverlay()

			elseif event.target.id == "save" then

				if allDay == true then

					EventFrom_time = "00:00"
					EventTo_time = "00:00"
				else
					EventFrom_time = Event_from_time.text
					EventTo_time = Event_to_time.text
				end

				local startdate = Event_from_date.text.." "..EventFrom_time
				local enddate = Event_to_date.text.." "..EventTo_time


				print( startdate) 


				--CalendarId,CalendarName,TicklerType,TicklerStatus,title,startdate,enddate,starttime,endtime,allDay,Location,Description,AppointmentPurpose,AppointmentPurposeOther,Priority
				print( "PriorityLbl : "..PriorityLbl.value )

				Webservice.CreateTickler(CalendarId,CalendarName,TicklerType,"OPEN",What.text,startdate,enddate,EventFrom_time,EventTo_time,allDay,Where.text,Description.text,PurposeLbl.value,"",PriorityLbl.value,get_CreateTickler)


			elseif event.target.id == "fromTime" then

					Where.isVisible = false
					Description.isVisible = false
				
				function getValue(time)

					Event_from_time.text = time
					Where.isVisible = true
					Description.isVisible = true

				end
				timePicker.getTimeValue(getValue)

			elseif event.target.id == "totime" then


					Where.isVisible = false
					Description.isVisible = false
				
				function getValue(time)

					Event_to_time.text = time
					Where.isVisible = true
					Description.isVisible = true

				end
				timePicker.getTimeValue(getValue)
			elseif event.target.id =="repeat" then

				if List.isVisible == false then
					List.isVisible = true
					List.x = event.target.x
					List.y = event.target.y+event.target.contentHeight+1.3
					List.width =event.target.contentWidth
					List.arrayName = repeatList
					List.textFiled = repeatLbl
					Where.isVisible = false
					Description.isVisible = false
					
					CreateList(event)
					
				else
					Where.isVisible = true
					Description.isVisible = true
					List_bg.isVisible = false
					List:deleteAllRows()
					List.isVisible = false

				end

			elseif event.target.id == "purpose" then

				if List.isVisible == false then
					List.isVisible = true
					List.x = event.target.x
					List.y = event.target.y+event.target.contentHeight+1.3
					List.width =event.target.contentWidth
					List.arrayName = purposeArray
					List.textFiled = PurposeLbl
					
					CreateList(event)
					
				else
					List_bg.isVisible = false
					List:deleteAllRows()
					List.isVisible = false

				end

			elseif event.target.id == "priority" then

				if List.isVisible == false then
						List.isVisible = true
						List.x = event.target.x
						List.y = event.target.y+event.target.contentHeight+1.3
						List.width =event.target.contentWidth
						List.arrayName = priorityArray
						List.textFiled = PriorityLbl
						
						CreateList(event)
						
				else
						List_bg.isVisible = false
						List:deleteAllRows()
						List.isVisible = false

				end

			end

	end

return true

end

local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    if switch.isOn == false then

    	allDay=true
	    Event_from_timebg.isVisible = false
		Event_from_time.isVisible = false
		Event_to_timebg.isVisible = false
		Event_to_time.isVisible = false
	else
		allDay=false
		Event_from_timebg.isVisible = true
		Event_from_time.isVisible = true
		Event_to_timebg.isVisible = true
		Event_to_time.isVisible = true

	end
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
		saveBtn_BG.id = "save"
		saveBtn = display.newText( sceneGroup, "Save",saveBtn_BG.x,saveBtn_BG.y,native.systemFont,14 )



				scrollView = widget.newScrollView
			{
			top = RecentTab_Topvalue,
			left = 0,
			width = W,
			height =H-RecentTab_Topvalue,
			hideBackground = true,
			isBounceEnabled=false,
			horizontalScrollDisabled = true,
			bottomPadding = 200,
   			--listener = Facebook_scrollListener,
}
	sceneGroup:insert( scrollView )
	
		--Form Design---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, 0, W-20, 28)
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




	
scrollView:insert( AddeventGroup)



MainGroup:insert(sceneGroup)
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		eventTime = event.params.details

		CalendarId = event.params.calendarId

		CalendarName = event.params.calendarName

		print( os.date( "%m/%d/%Y" ,  eventTime )) 

		----What----

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
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
				initialSwitchState = false,
				 onPress = onSwitchPress,
			}
			allDay=false
			allday_onOffSwitch.x=alldayLbl.x+alldayLbl.contentWidth+allday_onOffSwitch.contentWidth/2+5
			allday_onOffSwitch.y = alldayLbl.y
			AddeventGroup:insert( allday_onOffSwitch )

	  	--------------

	  	--------------From---------------

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="when"
		AddeventArray[#AddeventArray].anchorY=0
		AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])

		Event_fromLbl = display.newText(AddeventGroup,"When",0,0,0,0,native.systemFont,14)
		Event_fromLbl.anchorX=0
		Event_fromLbl.x=leftPadding
		Event_fromLbl.y = AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2
		Event_fromLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))

		Event_from_datebg = display.newRect(AddeventGroup,0,0,W/2,30)
		Event_from_datebg.anchorX=0
		Event_from_datebg.x=Event_fromLbl.x+Event_fromLbl.contentWidth+5
		Event_from_datebg.y= Event_fromLbl.y

		Event_from_date = display.newText(AddeventGroup,os.date( "%m/%d/%Y" ,eventTime ),0,0,native.systemFont,14)
		Event_from_date.anchorX=0
		Event_from_date:setFillColor( 0 )
		Event_from_date.x= Event_from_datebg.x+5;Event_from_date.y= Event_from_datebg.y


		Event_from_timebg = display.newRect(AddeventGroup,0,0,80,30)
		Event_from_timebg.anchorX=0
		Event_from_timebg.id="fromTime"
		Event_from_timebg.x= Event_from_datebg.x+Event_from_datebg.contentWidth+5;Event_from_timebg.y= Event_from_datebg.y

		local TimeZone = Utils.GetWeek(os.date( "%p" , eventTime ))

		Event_from_time = display.newText(AddeventGroup,os.date( "%I:%M "..TimeZone , eventTime ),0,0,native.systemFont,14)
		Event_from_time.anchorX=0
		Event_from_time:setFillColor( 0 )
		Event_from_time.x= Event_from_timebg.x+5;Event_from_time.y= Event_from_timebg.y

		-----------------------------------


	  	--------------To---------------

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="to"
		AddeventArray[#AddeventArray].anchorY=0
		AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])

		Event_toLbl = display.newText(AddeventGroup,"To",0,0,0,0,native.systemFont,14)
		Event_toLbl.anchorX=0
		Event_toLbl.x=leftPadding;Event_toLbl.y = AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2
		Event_toLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))

		Event_to_datebg = display.newRect(AddeventGroup,0,0,W/2,30)
		Event_to_datebg.anchorX=0
		Event_to_datebg.x=Event_from_datebg.x
		Event_to_datebg.y= Event_toLbl.y

		Event_to_date = display.newText(AddeventGroup,os.date( "%m/%d/%Y" ,eventTime ),0,0,native.systemFont,14)
		Event_to_date.anchorX=0
		Event_to_date:setFillColor( 0 )
		Event_to_date.x= Event_to_datebg.x+5;Event_to_date.y= Event_to_datebg.y


		Event_to_timebg = display.newRect(AddeventGroup,0,0,80,30)
		Event_to_timebg.anchorX=0
		Event_to_timebg.id="totime"
		Event_to_timebg.x= Event_to_datebg.x+Event_to_datebg.contentWidth+5;Event_to_timebg.y= Event_to_datebg.y

		local TimeZone = Utils.GetWeek(os.date( "%p" , eventTime ))

		Event_to_time = display.newText(AddeventGroup,os.date( "%I:%M "..TimeZone , eventTime ),0,0,native.systemFont,14)
		Event_to_time.anchorX=0
		Event_to_time:setFillColor( 0 )
		Event_to_time.x= Event_to_timebg.x+5;Event_to_time.y= Event_to_timebg.y

		-----------------------------------

		--repeat---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="repeat"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])
		AddeventArray[#AddeventArray]:addEventListener( "touch", TouchAction )


		repeatLbl = display.newText(AddeventGroup,"Repeat",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		repeatLbl.anchorX=0
		repeatLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		repeatLbl.x=leftPadding+5
		repeatLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		Repeat = display.newText(AddeventGroup,repeatList[1],AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		Repeat.alpha=0.7
		Repeat.anchorX=0
		Repeat:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		Repeat.x=W/2
		Repeat.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2


	  	repeat_icon = display.newImageRect(AddeventGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	repeat_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	repeat_icon.y=Repeat.y

	  	--------

	  	----Where----

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="where"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])

		Where = native.newTextField(W/2, AddeventArray[#AddeventArray].y, AddeventArray[#AddeventArray].contentWidth, AddeventArray[#AddeventArray].contentHeight)
		Where.id="where"
		Where.size=14
		Where.anchorY=0
		Where.hasBackground = false
		Where:setReturnKey( "next" )
		Where.placeholder="Where"
		AddeventGroup:insert(Where)


	  	----------

	  	----Description----

	  	AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 80)
		AddeventArray[#AddeventArray].id="description"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])

		Description = native.newTextField(W/2, AddeventArray[#AddeventArray].y, AddeventArray[#AddeventArray].contentWidth, AddeventArray[#AddeventArray].contentHeight)
		Description.id="description"
		Description.size=14
		Description.anchorY=0
		Description.hasBackground = false
		Description:setReturnKey( "next" )
		Description.placeholder="Description"
		AddeventGroup:insert(Description)


	  	----------

	  	--AppintmentWith---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="appintmentwith"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])


		AppintmentWithLbl = display.newText(AddeventGroup,"AppintmentWith",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		AppintmentWithLbl.anchorX=0
		AppintmentWithLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		AppintmentWithLbl.x=leftPadding+5
		AppintmentWithLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		

	  	AppintmentWith_icon = display.newImageRect(AddeventGroup,"res/assert/icon-close.png",30/1.5,30/1.5 )
	  	AppintmentWith_icon.rotation=45
	  	AppintmentWith_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	AppintmentWith_icon.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

	  	--------

	  	--Addinvitees---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="Addinvitees"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])


		AddinviteesLbl = display.newText(AddeventGroup,"Add Invitees",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		AddinviteesLbl.anchorX=0
		AddinviteesLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		AddinviteesLbl.x=leftPadding+5
		AddinviteesLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		

	  	Addinvitees_icon = display.newImageRect(AddeventGroup,"res/assert/icon-close.png",30/1.5,30/1.5 )
	  	Addinvitees_icon.rotation=45
	  	Addinvitees_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	Addinvitees_icon.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

	  	--------

	  	--Purpose---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="purpose"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])
		AddeventArray[#AddeventArray]:addEventListener( "touch", TouchAction )


		PurposeLbl = display.newText(AddeventGroup,"Purpose",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		PurposeLbl.anchorX=0
		PurposeLbl.value=0
		PurposeLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		PurposeLbl.x=leftPadding+5
		PurposeLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		

	  	Purpose_icon = display.newImageRect(AddeventGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	Purpose_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	Purpose_icon.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

	  	--------

	  	--Priority---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="priority"
		AddeventArray[#AddeventArray].anchorY=0
		AddeventArray[#AddeventArray].value = 0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])
		AddeventArray[#AddeventArray]:addEventListener( "touch", TouchAction )


		PriorityLbl = display.newText(AddeventGroup,"Low",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		PriorityLbl.anchorX=0
		PriorityLbl.value=0
		PriorityLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		PriorityLbl.x=leftPadding+5
		PriorityLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		

	  	Priority_icon = display.newImageRect(AddeventGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	Priority_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	Priority_icon.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

	  	--------


	  	--Add Attachment---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="addattachment"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])


		AddAttachmentLbl = display.newText(AddeventGroup,"Add Attachment",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		AddAttachmentLbl.anchorX=0
		AddAttachmentLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		AddAttachmentLbl.x=leftPadding+5
		AddAttachmentLbl.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

		

	  	AddAttachment_icon = display.newImageRect(AddeventGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	AddAttachment_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	AddAttachment_icon.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2

	  	--------


	  	---Common List---

	  	List_bg = display.newRect( AddeventGroup, 200, 200, 104, 304 )
		List_bg:setFillColor( 0 )


	  	List = widget.newTableView(
		    {
		        left = 200,
		        top = 200,
		        height = 100,
		        width = 300,
		        onRowRender = onRowRender,
		        onRowTouch = onRowTouch,
		        hideBackground = true,
		        isBounceEnabled = false,
		        noLines = true,

		       -- listener = scrollListener
		    }
		)

	  	List.anchorY=0
	  	List.isVisible = false

	  	List_bg.anchorY = 0
	  	List_bg.isVisible = false
	  	----------------

	  	AddeventGroup:insert( List )


		titleBar_icon:addEventListener("touch",TouchAction)
		titleBar_text:addEventListener("touch",TouchAction)
  		Background:addEventListener( "touch", TouchAction )
		menuBtn:addEventListener("touch",menuTouch)

		Event_from_timebg:addEventListener("touch",TouchAction)
		Event_to_timebg:addEventListener("touch",TouchAction)
		saveBtn_BG:addEventListener("touch",TouchAction)
		
	end	
	
MainGroup:insert(sceneGroup)

end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			if List then List:removeSelf( );List=nil end
			if scrollView then scrollView:removeSelf( );scrollView=nil end


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