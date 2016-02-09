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

local selectContactGroup = {"--Select Contact Group--"}

local contactgroup = {"Contact","Lead","Customer","Team Member"}

local leftPadding = 10

local AddeventGroup = display.newGroup( )

local AddeventArray = {}

local saveBtn

local CalendarId,allDay

local RecentTab_Topvalue = 70

local TicklerType = "APPT"

local List

local searchArray = {}

local searchArraytotal = {}

local searchList

local QuickContactList = {}

local appointmentGroup = display.newGroup()
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

local function AddAttachmentLbl( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )



	end

return true

end



local function searchRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth


    local rowTitle = display.newText( row, searchArray[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 25
    rowTitle.y = rowHeight * 0.5

	row.name = searchArray[row.index]
end

local function searchTouch(event) 
    print(event.phase)

    local row = event.row

    if event.phase == 'tap' or event.phase == 'release' then

		searchList:deleteAllRows()
		searchList.isVisible = false

		searchList.textFiled.text = row.name

		searchList.textFiled.value = row.index - 1

		native.setKeyboardFocus( nil )

    end
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
    rowTitle.x = W-rowWidth
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

    	Where.isVisible = true
    	What.isVisible = true
		Description.isVisible = true
    	List_bg.isVisible = false
		List:deleteAllRows()
		QuickContactList:deleteAllRows()
		List.isVisible = false
		QuickContactList.isVisible = false
		List.textFiled.text = row.name
		List.textFiled.value = row.index - 1



    end
end

local function QuickTouch(event) 
    print(event.phase)

    local row = event.row

    if event.phase == 'tap' or event.phase == 'release' then

    	
		QuickContactList:deleteAllRows()
		QuickContactList:deleteAllRows()
		QuickContactList.isVisible = false
		QuickContactList.isVisible = false
		List.textFiled.text = row.name
		List.textFiled.value = row.index - 1



    end
end

local function CreateList(event,list,bg)
					

					list.x = event.target.x
					list.y = event.target.y+event.target.contentHeight
					list.width =event.target.contentWidth+2

					bg.x = event.target.x
					bg.y = event.target.y+event.target.contentHeight
					bg.width =event.target.contentWidth+2
					bg.height =list.contentHeight+2


				


					list:deleteAllRows()

				

					for i = 1, #List.arrayName do

					    -- Insert a row into the tableView
					    list:insertRow(
					        {
					            isCategory = false,
					            rowHeight = 36,
					            rowColor = { default={0.9}, over={0.8} },
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

local function saveQuickcontact()
	
	function get_saveQuickcontact( response )
		
	end
	Webservice.CreateQuickcContact(Ap_firstName.text,Ap_lastName.text,Ap_email.text,Ap_phone.text,Ap_contactLbl.text,get_saveQuickcontact)
end


local function Ap_scrollAction( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			if event.target.id == "bg" then

			elseif event.target.id == "save" then

				saveQuickcontact()

			elseif event.target.id == "selectcontact" then

				if QuickContactList.isVisible == false then

					QuickContactList.isVisible = true
					List.arrayName = selectContactGroup
					List.textFiled = Ap_selectcontactLbl
					QuickContactList_bg.isVisible = false
					CreateList(event,QuickContactList,QuickContactList_bg)
			
				else

					QuickContactList_bg.isVisible = false
					QuickContactList:deleteAllRows()
					QuickContactList.isVisible = false

				end


			elseif event.target.id == "contact" then

				if QuickContactList.isVisible == false then
					QuickContactList.isVisible = true

					QuickContactList.x = event.target.x
					QuickContactList.y = event.target.y
					QuickContactList.width =event.target.contentWidth
					List.arrayName = contactgroup
					List.textFiled = Ap_contactLbl
					QuickContactList_bg.isVisible = false
				CreateList(event,QuickContactList,QuickContactList_bg)
					
				else
					QuickContactList.isVisible = false
					QuickContactList:deleteAllRows()
					QuickContactList.isVisible = false

				end

			elseif event.target.id =="cancel" then

					What.isVisible = true
					Where.isVisible = true
					Description.isVisible = true
					AppintmentWith.isVisible = true
					Addinvitees.isVisible = true

					Ap_firstName.isVisible = false
					Ap_lastName.isVisible = false
					Ap_email.isVisible = false
					Ap_phone.isVisible = false
					appointmentGroup.isVisible = false



			end


		end

return true
end

local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )


	 elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling

        print(dy)
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            scrollView:takeFocus( event )
        end
    
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

				
			elseif event.target.id == "AppintmentWith_plus" then

				if appointmentGroup.isVisible == true then

					What.isVisible = true
					Where.isVisible = true
					Description.isVisible = true
					AppintmentWith.isVisible = true
					Addinvitees.isVisible = true

					Ap_firstName.isVisible = false
					Ap_lastName.isVisible = false
					Ap_email.isVisible = false
					Ap_phone.isVisible = false
					appointmentGroup.isVisible = false

				else

					What.isVisible = false
					Where.isVisible = false
					Description.isVisible = false
					AppintmentWith.isVisible = false
					Addinvitees.isVisible = false

					Ap_firstName.isVisible = true
					Ap_lastName.isVisible = true
					Ap_email.isVisible = true
					Ap_phone.isVisible = true
					appointmentGroup.isVisible = true

				end



			elseif event.target.id == "fromTime" then
					AppintmentWith.isVisible = false
					Where.isVisible = false
					Description.isVisible = false
				
				function getValue(time)

					Event_from_time.text = time
					AppintmentWith.isVisible = true
					Where.isVisible = true
					Description.isVisible = true

				end
				timePicker.getTimeValue(getValue)

			elseif event.target.id == "totime" then

					AppintmentWith.isVisible = false
					Where.isVisible = false
					Description.isVisible = false
				
				function getValue(time)

					Event_to_time.text = time
					AppintmentWith.isVisible = true
					Where.isVisible = true
					Description.isVisible = true

				end
				timePicker.getTimeValue(getValue)
			

			elseif event.target.id == "purpose" then

				if List.isVisible == false then
					List.isVisible = true
					List.x = event.target.x
					List.y = event.target.y+event.target.contentHeight+1.3
					List.width =event.target.contentWidth
					List.arrayName = purposeArray
					List.textFiled = PurposeLbl
					List_bg.isVisible = true
					CreateList(event,List,List_bg)
					
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
						List_bg.isVisible = true
						CreateList(event,List,List_bg)
						
				else
						List_bg.isVisible = false
						List:deleteAllRows()
						List.isVisible = false

				end

			elseif event.target.id == "addattachment" then

					AddAttachment(event.target)
			elseif event.target.id == "eventtype" then

				if List.isVisible == false then

						What.isVisible = false
						List.isVisible = true
						List.x = event.target.x
						List.y = event.target.y+event.target.contentHeight+1.3
						List.width =event.target.contentWidth
						List.arrayName = EventnameArray
						List.textFiled = SelectEvent
						List_bg.isVisible = true
						CreateList(event,List,List_bg)
						
				else
						What.isVisible = true
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

function get_Contact( response )


	for i=1,#response do

		if response[i].FirstName ~= nil then
			searchArray[#searchArray+1] = response[i].FirstName.." "..response[i].LastName
			searchArraytotal[#searchArraytotal+1] = response[i].FirstName.." "..response[i].LastName
			
		elseif response[i].LastName ~= nil then

			searchArray[#searchArray+1] = response[i].LastName
			searchArraytotal[#searchArraytotal+1] = response[i].FirstName.." "..response[i].LastName


		end

		
	end

			
end

local function searchfunction( event )

    if ( event.phase == "began" ) then
        -- user begins editing defaultField
        print( event.text )

        if event.taget.id == "appintmentwith" then

        	Addinvitees.isVisible = false

        end


    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with defaultField text
        print( event.target.text )

        Addinvitees.isVisible = true

    elseif ( event.phase == "editing" ) then

    	if event.text:len() == 1 then
    		print("len")

    		for i=1,#searchArraytotal do
				searchArraytotal[i]=nil
			end

			Webservice.GetContact(event.text,get_Contact)

		elseif event.text:len() == 0 then

				Addinvitees.isVisible = true
				searchList:deleteAllRows()


		else

			Addinvitees.isVisible = false

			print(#searchArray)
			for i=1,#searchArray do
				searchArray[i]=nil
			end

			for i=1,#searchArraytotal do
	

				if string.find(searchArraytotal[i]:lower(),event.text:lower()) ~= nil then

					print("here  "..searchArraytotal[i],event.text)

					searchArray[#searchArray+1] = searchArraytotal[i]

				end

			end
		

				searchList:deleteAllRows()

					for i = 1, #searchArray do

					    -- Insert a row into the tableView
					    searchList:insertRow(
					        {
					            isCategory = false,
					            rowHeight = 36,
					            rowColor = { default={0.8}, over={0.6} },
					        }
					    )
					end


		end

		searchList.isVisible = true
		searchList.x = event.target.x
		searchList.y = event.target.y+event.target.contentHeight+1.3
		searchList.width =event.target.contentWidth


			searchList.textFiled = event.target

	

    	--searchArray
    end
end

	local function addevent_scrollListener(event )

		    local phase = event.phase
		    if ( phase == "began" ) then 
		    elseif ( phase == "moved" ) then 


			local x, y = scrollView:getContentPosition()

			print(y)
			if y > -40 then
				What.isVisible = true
			else
				What.isVisible = false
			end

		    elseif ( phase == "ended" ) then 
		    end

		    -- In the event a scroll limit is reached...
		    if ( event.limitReached ) then
		        if ( event.direction == "up" ) then print( "Reached bottom limit" )
		        elseif ( event.direction == "down" ) then print( "Reached top limit" )
		        elseif ( event.direction == "left" ) then print( "Reached right limit" )
		        elseif ( event.direction == "right" ) then print( "Reached left limit" )
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
			bottomPadding = 150,
			friction = .3,
   			listener = addevent_scrollListener,
}
	sceneGroup:insert( scrollView )
	
		--Form Design---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, 0, W-20, 28)
		AddeventArray[#AddeventArray].id="eventtype"
		AddeventArray[#AddeventArray].anchorY=0
		AddeventArray[#AddeventArray].alpha=0.01
		AddeventGroup:insert(AddeventArray[#AddeventArray])
		AddeventArray[#AddeventArray]:addEventListener( "touch", TouchAction )


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


	
		AppintmentWith = native.newTextField(0, AddeventArray[#AddeventArray].y, AddeventArray[#AddeventArray].contentWidth-30, AddeventArray[#AddeventArray].contentHeight)
		AppintmentWith.id="appintmentwith"
		AppintmentWith.size=14
		AppintmentWith.anchorY=0
		AppintmentWith.anchorX=0
		AppintmentWith.x=leftPadding
		AppintmentWith.hasBackground = false
		AppintmentWith:setReturnKey( "next" )
		AppintmentWith.placeholder="Appintment With"
		AddeventGroup:insert(AppintmentWith)
		AppintmentWith:addEventListener( "userInput", searchfunction )
		

	  	AppintmentWith_icon = display.newImageRect(AddeventGroup,"res/assert/icon-close.png",30/1.5,30/1.5 )
	  	AppintmentWith_icon.rotation=45
	  	AppintmentWith_icon.id="AppintmentWith_plus"
	  	AppintmentWith_icon.x=AddeventArray[#AddeventArray].x+AddeventArray[#AddeventArray].contentWidth/2-15
	  	AppintmentWith_icon.y=AddeventArray[#AddeventArray].y+AddeventArray[#AddeventArray].contentHeight/2
	  	AppintmentWith_icon:addEventListener( "touch", TouchAction )
	  	--------

	  	--Addinvitees---

		AddeventArray[#AddeventArray+1] = display.newRect( W/2, titleBar.y+titleBar.height+10, W-20, 28)
		AddeventArray[#AddeventArray].id="Addinvitees"
		AddeventArray[#AddeventArray].anchorY=0
		--AddeventArray[#AddeventArray].alpha=0.01
		AddeventArray[#AddeventArray].y = AddeventArray[#AddeventArray-1].y+AddeventArray[#AddeventArray-1].contentHeight+10
		AddeventGroup:insert(AddeventArray[#AddeventArray])


		Addinvitees = native.newTextField(0, AddeventArray[#AddeventArray].y, AddeventArray[#AddeventArray].contentWidth-30, AddeventArray[#AddeventArray].contentHeight)
		Addinvitees.id="addinvitees"
		Addinvitees.size=14
		Addinvitees.anchorY=0
		Addinvitees.anchorX=0
		Addinvitees.x=leftPadding
		Addinvitees.hasBackground = false
		Addinvitees:setReturnKey( "next" )
		Addinvitees.placeholder="Add Invitees"
		AddeventGroup:insert(Addinvitees)
		Addinvitees:addEventListener( "userInput", searchfunction )

		

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
		AddeventArray[#AddeventArray]:addEventListener( "touch", TouchAction )


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

	---searchList---

	  	searchList_bg = display.newRect( AddeventGroup, 200, 200, 104, 304 )
		searchList_bg:setFillColor( 0 )
		searchList_bg.anchorY = 0


	  	searchList = widget.newTableView(
		    {
		        left = 200,
		        top = 200,
		        height = 100,
		        width = 300,
		        onRowRender = searchRender,
		        onRowTouch = searchTouch,
		        hideBackground = true,
		        isBounceEnabled = false,
		        noLines = true,

		       -- listener = scrollListener
		    }
		)
	  	searchList.anchorX=0
	  	searchList.anchorY=0
	  	searchList.isVisible = false

	  	searchList_bg.anchorX = 0
	  	searchList_bg.isVisible = false

	  	----------------

  	



	  	AddeventGroup:insert( List )
	  	AddeventGroup:insert( searchList )

	  	appoitmentAdd_Background = display.newRect(appointmentGroup,W/2,H/2,W,H)
	  	appoitmentAdd_Background.id="bg";appoitmentAdd_Background.alpha=0.01
	  	appoitmentAdd_Background:addEventListener("touch",Ap_scrollAction)

	  	appoitmentAdd_bg = display.newRect(appointmentGroup,W/2,H/2,W-60,H-140)
	  	appoitmentAdd_bg:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )
		appoitmentAdd_bg.strokeWidth = 1

		appoitmentAdd_header = display.newRect(appointmentGroup,W/2,H/2,W-60,40)
		appoitmentAdd_header.y=appoitmentAdd_bg.y-appoitmentAdd_bg.contentHeight/2+appoitmentAdd_header.contentHeight/2
		appoitmentAdd_header:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		appoitmentAdd_headertitle = display.newText(appointmentGroup,"Add Quick Customer",0,0,native.systemFont,16)
		appoitmentAdd_headertitle.x=appoitmentAdd_header.x;appoitmentAdd_headertitle.y=appoitmentAdd_header.y


		Ap_firstName = native.newTextField(0,0,W-100,30)
		Ap_firstName.id="AP_firstname"
		Ap_firstName.size=14
		Ap_firstName.anchorY=0
		Ap_firstName.x=appoitmentAdd_bg.x
		Ap_firstName.y = appoitmentAdd_header.y+appoitmentAdd_header.contentHeight/2+20
		Ap_firstName:setReturnKey( "next" )
		Ap_firstName.placeholder="First Name"
		appointmentGroup:insert(Ap_firstName)

		Ap_lastName = native.newTextField(0,0,W-100,30)
		Ap_lastName.id="AP_lastname"
		Ap_lastName.size=14
		Ap_lastName.anchorY=0
		Ap_lastName.x=appoitmentAdd_bg.x
		Ap_lastName.y = Ap_firstName.y+Ap_firstName.contentHeight+10
		Ap_lastName:setReturnKey( "next" )
		Ap_lastName.placeholder="Last Name"
		appointmentGroup:insert(Ap_lastName)

		Ap_email = native.newTextField(0,0,W-100,30)
		Ap_email.id="email"
		Ap_email.size=14
		Ap_email.anchorY=0
		Ap_email.x=appoitmentAdd_bg.x
		Ap_email.y = Ap_lastName.y+Ap_lastName.contentHeight+10
		Ap_email:setReturnKey( "next" )
		Ap_email.placeholder="Email Address"
		appointmentGroup:insert(Ap_email)

		Ap_phone = native.newTextField(0,0,W-100,30)
		Ap_phone.id="AP_lastname"
		Ap_phone.size=14
		Ap_phone.anchorY=0
		Ap_phone.x=appoitmentAdd_bg.x
		Ap_phone.y = Ap_email.y+Ap_email.contentHeight+10
		Ap_phone:setReturnKey( "next" )
		Ap_phone.placeholder="Cell"
		appointmentGroup:insert(Ap_phone)


		selectcontactGroup_bg = display.newRect( W/2, titleBar.y+titleBar.height+10, W-100,30)
		selectcontactGroup_bg.anchorY=0
		selectcontactGroup_bg.strokeWidth=1
		selectcontactGroup_bg:setStrokeColor(Utils.convertHexToRGB(color.tabBarColor))
		--selectcontactGroup_bg.alpha=0.01
		selectcontactGroup_bg.y = Ap_phone.y+Ap_phone.contentHeight+10
		selectcontactGroup_bg.id="selectcontact"
		appointmentGroup:insert(selectcontactGroup_bg)
		selectcontactGroup_bg:addEventListener( "touch", Ap_scrollAction )


		Ap_selectcontactLbl = display.newText(appointmentGroup,"Select Contact Group",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		Ap_selectcontactLbl.anchorX=0
		Ap_selectcontactLbl.value=0
		Ap_selectcontactLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		Ap_selectcontactLbl.x=selectcontactGroup_bg.x-selectcontactGroup_bg.contentWidth/2+5
		Ap_selectcontactLbl.y=selectcontactGroup_bg.y+selectcontactGroup_bg.contentHeight/2

		

	  	Ap_selectcontactLbl_icon = display.newImageRect(appointmentGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	Ap_selectcontactLbl_icon.x=selectcontactGroup_bg.x+selectcontactGroup_bg.contentWidth/2-15
	  	Ap_selectcontactLbl_icon.y=selectcontactGroup_bg.y+selectcontactGroup_bg.contentHeight/2


	  	contactGroup_bg = display.newRect( W/2, titleBar.y+titleBar.height+10, W-100,30)
		contactGroup_bg.anchorY=0
		contactGroup_bg.strokeWidth=1
		contactGroup_bg:setStrokeColor(Utils.convertHexToRGB(color.tabBarColor))
		--selectcontactGroup_bg.alpha=0.01
		contactGroup_bg.y = selectcontactGroup_bg.y+selectcontactGroup_bg.contentHeight+10
		contactGroup_bg.id="contact"
		appointmentGroup:insert(contactGroup_bg)
		contactGroup_bg:addEventListener( "touch", Ap_scrollAction )


		Ap_contactLbl = display.newText(appointmentGroup,"Contact",AddeventArray[#AddeventArray].x-AddeventArray[#AddeventArray].contentWidth/2+15,AddeventArray[#AddeventArray].y,native.systemFont,14 )
		Ap_contactLbl.anchorX=0
		Ap_contactLbl.value=0
		Ap_contactLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		Ap_contactLbl.x=contactGroup_bg.x-contactGroup_bg.contentWidth/2+5
		Ap_contactLbl.y=contactGroup_bg.y+contactGroup_bg.contentHeight/2

		

	  	Ap_contactLbl_icon = display.newImageRect(appointmentGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	Ap_contactLbl_icon.x=contactGroup_bg.x+contactGroup_bg.contentWidth/2-15
	  	Ap_contactLbl_icon.y=contactGroup_bg.y+contactGroup_bg.contentHeight/2

	  	Ap_saveBtn = display.newRect(appointmentGroup,0,0,80,30)
	  	Ap_saveBtn.x = W/2-W/3
	  	Ap_saveBtn.anchorX=0
	  	Ap_saveBtn.id="save"
	  	Ap_saveBtn.y = appoitmentAdd_bg.y+appoitmentAdd_bg.contentHeight/2-Ap_saveBtn.contentHeight/2-10
	  	Ap_saveBtn:setFillColor(0,1,0)
	  	Ap_saveBtn:addEventListener("touch",Ap_scrollAction)

	  	Ap_saveBtntxt = display.newText(appointmentGroup,"Save",0,0,native.systemFont,16)
	  	Ap_saveBtntxt.x = Ap_saveBtn.x+Ap_saveBtn.contentWidth/2
	  	Ap_saveBtntxt.y = Ap_saveBtn.y

	  	Ap_cancelBtn = display.newRect(appointmentGroup,0,0,80,30)
	  	Ap_cancelBtn.x = W/2+10
	  	Ap_cancelBtn.id = "cancel"
	  	Ap_cancelBtn.anchorX=0
	  	Ap_cancelBtn.y = appoitmentAdd_bg.y+appoitmentAdd_bg.contentHeight/2-Ap_cancelBtn.contentHeight/2-10
	  	Ap_cancelBtn:setFillColor(1,0,0)
	  	Ap_cancelBtn:addEventListener("touch",Ap_scrollAction)

	  	Ap_cancelBtntxt = display.newText(appointmentGroup,"Cancel",0,0,native.systemFont,16)
	  	Ap_cancelBtntxt.x = Ap_cancelBtn.x+Ap_cancelBtn.contentWidth/2
	  	Ap_cancelBtntxt.y = Ap_cancelBtn.y


	  		  		---QuickContactList---

	  	QuickContactList_bg = display.newRect( appointmentGroup, 200, 200, 104, 304 )
		QuickContactList_bg:setFillColor( 0 )
		QuickContactList_bg.anchorY = 0
		QuickContactList_bg.isVisible=false


	  	QuickContactList = widget.newTableView(
		    {
		        left = 200,
		        top = 200,
		        height = 100,
		        width = 300,
		        onRowRender = onRowRender,
		        onRowTouch = QuickTouch,
		        hideBackground = true,
		        isBounceEnabled = false,
		        noLines = true,

		       -- listener = scrollListener
		    }
		)
	  	--QuickContactList.anchorX=0
	  	QuickContactList.anchorY=0
	  	QuickContactList.isVisible = false

	 -- 	QuickContactList.anchorX = 0
	  	QuickContactList.isVisible = false

	  	appointmentGroup:insert(QuickContactList)
	  	----------------


		Ap_firstName.isVisible = false
		Ap_lastName.isVisible = false
		Ap_email.isVisible = false
		Ap_phone.isVisible = false
	  	appointmentGroup.isVisible = false
	 

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

			composer.removeHidden()

			if List then List:removeSelf( );List=nil end
			if searchList then searchList:removeSelf( );searchList=nil end
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