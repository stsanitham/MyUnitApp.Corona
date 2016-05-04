	----------------------------------------------------------------------------------
--
-- event Calender Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local toast = require('plugin.toast')

local Utility = require( "Utils.Utility" )

local Processingdate
local ProcessingCount_total = 0
local ProcessingCount = 0 

local weekViewTouchFlag = false

local BackFlag = false

local weekViewGroup = display.newGroup( )

local pickerGroup = display.newGroup( )

local weekCalendertimimgs = {}

local parentPosition = {}

local currentweek=0

local weekView_bg,weekView_leftArrow,weekView_rightArrow,weekView_header

local Header_parentTitle,Header_parent_leftDraw,Header_parent_leftText,Header_parent_centerText

local addEventBtn

local langid,countryid

local HeaderDetails = {}


local headerGroup = display.newGroup( )

--------------- Initialization -------------------


local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

		langid = row.LanguageId
		countryid = row.CountryId
		

end



local W = display.contentWidth;H= display.contentHeight

local Background,BgText

--Button

local menuBtn,topBg,topToday_btnBg,topToday_btnlabel,searchhBg,search,weekView,calenderView,calenderView_bg,pickerWheel,picker_btnBg,picker_Done,menuTouch_s

local ParentShow = true

local CalendarName,CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic

local DateWise_response = {}

local defalutCalenderView = "agendaWeek" --"month","agendaDay"

local event_groupArray = {}

local scrollView

local week = display.newGroup( )

local RecentTab_Topvalue = 70

local pickerWheel,picker_btnBg,picker_Done

local monthArray={ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
local weekLbl = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"}
local days = {}
local years = {}

-- Populate the "days" table
for d = 1, 31 do
    days[d] = d
end

-- Populate the "years" table
for y = 1, 48 do
    years[y] = (os.date( "%Y" )-5) + y
end

-- Configure the picker wheel columns
local columnData = 
{
    -- Months
    { 
        align = "right",
        width = 140,
        startIndex =tonumber(os.date( "%m" )),
        labels = monthArray
    },
    -- Days
    {
        align = "center",
        width = 60,
        startIndex = tonumber(os.date( "%d" )),
        labels = days
    },
    -- Years
    {
        align = "center",
        width = 80,
        startIndex = 5,
        labels = years
    }
}



--------------------------------------------------


-----------------Function-------------------------



local function onTimer ( event )

	print( "event time completion" )

	BackFlag = false

end


	local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

        	print("keyName....")

        	if BackFlag == false then

        		Utils.SnackBar(ChatPage.PressAgain)

        		BackFlag = true

        		timer.performWithDelay( 2000, onTimer )

                return true

            elseif BackFlag == true then

			 os.exit() 

            end
            
        end

    end

        return false
 end





local function listTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

		elseif ( event.phase == "moved" ) then
			local dy = math.abs( ( event.y - event.yStart ) )

			if ( dy > 10 ) then
				display.getCurrentStage():setFocus( nil )
				scrollView:takeFocus( event )
			end

			elseif event.phase == "ended" then
			search.text = ""
			NoEvent.text = EventCalender.NoEvent
			native.setKeyboardFocus( nil )
			display.getCurrentStage():setFocus( nil )

			if event.target.id == "addEvent" then

				print( "add event" )

				print( os.date( "%m/%d/%Y" ,  event.target.value )) 

				local options = {
					isModal = true,
					effect = "slideLeft",
					time = 10,
					params = {
					details = event.target.value,
					calendarId = CalendarId,
					calendarName = CalendarName,
				}
			}

			search.isVisible=false

			Runtime:removeEventListener( "key", onKeyEvent )

			composer.showOverlay( "Controller.addEventPage", options )


			else

					local options = {
					isModal = true,
					effect = "slideLeft",
					time = 500,
					params = {
					details = event.target.value
				}
			}

			search.isVisible=false

			Runtime:removeEventListener( "key", onKeyEvent )

			composer.showOverlay( "Controller.eventCal_DetailPage", options )

			end


end

return true
end


function makeTimeStamp(dateString)


	local pattern = "(%d+)%/(%d+)%/(%d+)"
	local month,day,year,hour,minute,seconds, tzoffset =
	dateString:match(pattern)

	local timestamp = os.time( {year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false} )
	return timestamp
end

local function dateSplit(date)
	local Date_value = date

	Date_value = Date_value:sub(1,string.find(Date_value,"T")-1)

	return Date_value

end




local function display_calenderList(response)

if headerGroup then

	for j=#headerGroup, 1, -1 do 
				display.remove(headerGroup[#headerGroup])
				headerGroup[#headerGroup] = nil
	end

end

		


event_groupArray[#event_groupArray+1] = display.newGroup()

local tempGroup = event_groupArray[#event_groupArray]

local bgheight = 45
--os.date("%Y-%m-%dT%H:%m:%S")

       print( "***************************** : "..response.date) 

       
local timeGMT = Utils.makeTimeStampwithOffset( response.date )


--date_value = os.date( "%A" , timeGMT )
local tempHeight = 0 

local background = display.newRect(tempGroup,0,0,W,bgheight)

if(event_groupArray[#event_groupArray-1]) ~= nil then
	--here
	tempHeight = event_groupArray[#event_groupArray-1][1].y + event_groupArray[#event_groupArray-1][1].height

end


background.anchorY = 0
background.x=W/2;background.y=tempHeight
background.alpha=0.01

local parentTitle;

if ParentShow == true then
	ParentShow = false


	parentTitle = display.newRect(tempGroup,0,0,W,bgheight/2)
	if(event_groupArray[#event_groupArray-1]) ~= nil then
	--here
	tempHeight = event_groupArray[#event_groupArray-1][1].y + event_groupArray[#event_groupArray-1][1].height-2
	end
HeaderDetails[#HeaderDetails+1] = {}
HeaderDetails[#HeaderDetails].Position = tempHeight
HeaderDetails[#HeaderDetails].Time = timeGMT
parentPosition[#parentPosition+1] = tempHeight
parentTitle.anchorY = 0
parentTitle.x=W/2;parentTitle.y=tempHeight
parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))		

local parent_leftDraw = display.newImageRect(tempGroup,"res/assert/calendar.png",32/2,32/2)
parent_leftDraw.x=parentTitle.x-parentTitle.contentWidth/2+15;parent_leftDraw.y=parentTitle.y+parentTitle.contentHeight/2


local parent_leftText = display.newText(tempGroup,Utils.GetWeek(os.date( "%A" , timeGMT )),0,0,native.systemFont,11)
parent_leftText.x=parent_leftDraw.x+parent_leftDraw.contentWidth/2+2
parent_leftText.y=parent_leftDraw.y
Utils.CssforTextView(parent_leftText,sp_fieldValue_small)
parent_leftText.anchorX=0

local parent_centerText = display.newText(tempGroup,os.date( "%b %d, %Y" , timeGMT ),0,0,native.systemFont,14)
parent_centerText.x=W/2
parent_centerText.y=parent_leftDraw.y
Utils.CssforTextView(parent_centerText,sp_subHeader)


local month = Utils.GetMonth(os.date( "%b" , timeGMT ))
 
if CommonWords.language == "Canada English" then

	parent_centerText.text = os.date( " %d " , timeGMT )..month..os.date( ", %Y" , timeGMT )

else

	parent_centerText.text = month..os.date( " %d, %Y" , timeGMT )

end



background.y=parentTitle.y+background.contentHeight/2


---Header----

if tempHeight == 0 then

	Header_parentTitle = display.newRect(headerGroup,0,0,W,bgheight/2)
	Header_parentTitle.anchorY = 0
	Header_parentTitle.x=W/2;Header_parentTitle.y=weekView_bg.y+weekView_bg.contentHeight
	Header_parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))

	Header_parent_leftDraw = display.newImageRect(headerGroup,"res/assert/calendar.png",32/2,32/2)
	Header_parent_leftDraw.x=Header_parentTitle.x-Header_parentTitle.contentWidth/2+15;Header_parent_leftDraw.y=Header_parentTitle.y+Header_parentTitle.contentHeight/2

	Header_parent_leftText = display.newText(headerGroup,Utils.GetWeek(os.date( "%A" , timeGMT )),0,0,native.systemFont,11)
	Header_parent_leftText.x=Header_parent_leftDraw.x+Header_parent_leftDraw.contentWidth/2+2
	Header_parent_leftText.y=Header_parent_leftDraw.y
	Utils.CssforTextView(Header_parent_leftText,sp_fieldValue_small)
	Header_parent_leftText.anchorX=0

	Header_parent_centerText = display.newText(headerGroup,os.date( "%b %d, %Y" , timeGMT ),0,0,native.systemFont,14)
	Header_parent_centerText.x=W/2
	Header_parent_centerText.y=Header_parent_leftDraw.y
	Utils.CssforTextView(Header_parent_centerText,sp_subHeader)

	local month = Utils.GetMonth(os.date( "%b" , timeGMT ))
 
	if CommonWords.language == "Canada English" then

		Header_parent_centerText.text = os.date( " %d " , timeGMT )..month..os.date( ", %Y" , timeGMT )

	else

		Header_parent_centerText.text = month..os.date( " %d, %Y" , timeGMT )

	end

	headerGroup.alpha=0


end

----

end

local title = display.newText( tempGroup,response.title, background.x-60, background.y,180,0, native.systemFont, 11 )
title.anchorX=0
Utils.CssforTextView(title,sp_CommonTitle)

background.height = background.contentHeight+title.height
title.y=background.y+background.contentHeight/2

local line = display.newRect(tempGroup,W/2,background.y,W,1)
line.y=background.y+background.contentHeight-line.contentHeight
line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


local leftDraw_line = display.newImageRect(tempGroup,"res/assert/eventSeprator.png",22,63)
leftDraw_line.anchorY=0
leftDraw_line.height = background.height+5
leftDraw_line.x=W/4;leftDraw_line.y=background.y-5

local Timezone = Utils.GetWeek(os.date( "%p" , timeGMT ))

local time = display.newText(tempGroup,Utils.getTime( timeGMT,"%I:%M \n  "..Timezone,response.TimeZone ),0,0,80,0,native.systemFontBold,12)
time.x=W/6
time.y=background.y+background.contentHeight/2
Utils.CssforTextView(time,sp_Date_Time)


if response.allDay == true then
	time.text="ALL DAY"
end


--[[local leftDraw_img = display.newImageRect(tempGroup,"res/assert/arrow(calen-page).png",22,19)
leftDraw_img.x=leftDraw_line.x+5;leftDraw_img.y=leftDraw_line.y+leftDraw_line.contentHeight/2]]

local right_img = display.newImageRect(tempGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
right_img.anchorX=0
right_img.x=background.x+background.contentWidth/2-30;right_img.y=leftDraw_line.y+leftDraw_line.contentHeight/2

tempGroup.value = response
tempGroup:addEventListener("touch",listTouch)

scrollView:insert(tempGroup)
addEventBtn:toFront( )
end

local function createEventlist(responevalue,timeValue)


print( "**"..#responevalue  )

DateWise_response=responevalue

		local function onTimer( event )
			   weekViewTouchFlag=false
		end

		weekswipeTimer = timer.performWithDelay( 600, onTimer )
			
		ProcessingCount =0 

		if event_groupArray then 
			for j=#event_groupArray, 1, -1 do 
				display.remove(event_groupArray[#event_groupArray])
				event_groupArray[#event_groupArray] = nil
			end
		end

		

		if  DateWise_response == nil then

			NoEvent.isVisible=true

			return false
		end

		

		if #DateWise_response == 0 then

			NoEvent.isVisible=true


			return false
		else

		end

			Processingdate = dateSplit(DateWise_response[1].date)

		for i = 1, #DateWise_response do


			date = dateSplit(DateWise_response[i].date)


			local function eventCalen_display_process()


				if Processingdate == date then

					processCount=0

					display_calenderList(DateWise_response[i])

				else

			
					ProcessingCount = ProcessingCount+1

					if ProcessingCount_total >= ProcessingCount then


						ParentShow = true


						timeValue.day=timeValue.day+1

						Processingdate = dateSplit(DateWise_response[i].date)

						eventCalen_display_process()

					else
						print("finish")
						
					end

				end
			end

			eventCalen_display_process()

		end


		scrollView:scrollTo( "top",{ time=200 } )


end


local function searchEventlist(DateWise_response,timeValue,searchText)



HaveField = false

--DateWise_response=response

print( DateWise_response )

					
		ProcessingCount =0 

		for j=#event_groupArray, 1, -1 do 
			display.remove(event_groupArray[#event_groupArray])
			event_groupArray[#event_groupArray] = nil
		end

		

		if  DateWise_response == nil then

			NoEvent.isVisible=true

			return false
		end

		if #DateWise_response == 0 then

			NoEvent.isVisible=true


			return false
		else

		end

		
		
	

		for i = 1, #DateWise_response do

			local parentHave = false

			date = dateSplit(DateWise_response[i].date)

			local timeGMT = Utils.makeTimeStampwithOffset( DateWise_response[i].date )

			if string.find( os.date( "%B %d, %Y" , timeGMT ):upper( ), searchText:upper( )) ~= nil then

				parentHave = true

			end

			local function eventCalen_display_process()


				if Processingdate == date then

					processCount=0

						
						if parentHave == true then

							HaveField = true

							display_calenderList(DateWise_response[i])

						else

							if parentHave then

								HaveField = true

								display_calenderList(DateWise_response[i])

							else

								if string.find( DateWise_response[i].title:upper( ), searchText:upper( )) ~= nil then

									HaveField = true

									display_calenderList(DateWise_response[i])
																		
								end

							

							end
							

						end


				else

					
					ProcessingCount = ProcessingCount+1

					if ProcessingCount_total >= ProcessingCount then


						ParentShow = true


						timeValue.day=timeValue.day+1

						Processingdate = dateSplit(DateWise_response[i].date)

						--print(Processingdate,ProcessingCount,timeValue.day)

						eventCalen_display_process()

					else
						print("finish")
						
					end

				end
			end



			eventCalen_display_process()

		end

			if HaveField == false then

				NoEvent.isVisible=true

				NoEvent.text = EventCalender.NoRecord


			else
				NoEvent.text = EventCalender.NoEvent

				NoEvent.isVisible=false
			end

		scrollView:scrollTo( "top",{ time=200 } )


end


local function eventList( timeValue )

	NoEvent.isVisible=false


	function get_TicklerEvents(response)

		print( "***************************************************")

		createEventlist(response,timeValue)



	end

	Webservice.Get_TicklerEvents(CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic,get_TicklerEvents)

end

local function dayTouch(event)
	if event.phase == "ended" then
		search.text = ""
		NoEvent.text = EventCalender.NoEvent
		native.setKeyboardFocus( nil )

		for i=1,week.numChildren do

			if week[i].Processingdate == os.date( "%Y-%m-%d" ,os.time(os.date( '*t' ))) then

			else
				Utils.CssforTextView(week[i][1],sp_labelName)

			end

		end


		event.target[1]:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

		print("checking : ".. event.target.Processingdate,os.date( "%Y-%m-%d" ,os.time(os.date( '*t' ))) )

		if event.target.Processingdate == os.date( "%Y-%m-%d" ,os.time(os.date( '*t' ))) then
			event.target[1]:setFillColor( 0,0,1 )
		end
		
		startdate = event.target.startdate
		enddate = event.target.enddate
		Processingdate = event.target.Processingdate
		ParentShow=true
		weekViewTouchFlag = true

		print( os.date( "%m/%d/%Y" ,  os.time(event.target.value) )) 

		eventList(event.target.value)

		local timeGMT = makeTimeStamp( startdate )

		addEventBtn.value = timeGMT

	end

return true

end



local function creatWeek( weekfirstDay,flagValue )
	--todaydate =  os.date( "%m/%d/%Y" , os.time( t ) )

	for j=week.numChildren, 1, -1 do 
   		display.remove(week[week.numChildren])
    	week[week.numChildren] = nil
	end 


weekViewGroup:insert( week )

local month = Utils.GetMonth(os.date( "%b" , os.time( weekfirstDay ) ))

if CommonWords.language == "Canada English" then

	weekView_header.text = os.date( " %d " , os.time( weekfirstDay )  )..month..os.date( ", %Y" , os.time( weekfirstDay )  ).." - "

else

	weekView_header.text = month..os.date( " %d, %Y" , os.time( weekfirstDay ) ).." - "

end



weekfirstDay.day = weekfirstDay.day - 1
	
	weekStartX = weekView_leftArrow.x
	

	for i=1,7 do

		local Week_Group = display.newGroup( )


		weekfirstDay.day = weekfirstDay.day + 1
		local day = display.newText(Week_Group,Utils.GetWeek(weekLbl[i]),0,0,native.systemFont,12)
		weekStartX = weekStartX +35
		day.x = weekStartX;day.y=weekView_bg.y+weekView_bg.contentHeight/2
		Utils.CssforTextView(day,sp_labelName)


		local date = display.newText(Week_Group,os.date( "%d" , os.time( weekfirstDay ) ),0,0,native.systemFont,12)
		date.x = day.x;date.y=day.y+17
		Utils.CssforTextView(date,sp_fieldValue)

		if os.date( "%m/%d/%Y" , os.time( weekfirstDay )) == os.date( "%m/%d/%Y" ,os.time(os.date( '*t' ))) then
			day:setFillColor( 0,0,1 )
			addEventBtn.value = os.time(weekfirstDay)

		end

		Week_Group.id=i



		Week_Group.startdate = os.date( "%m/%d/%Y" , os.time( weekfirstDay )).." 12:00:00 AM"
		Week_Group.enddate = os.date( "%m/%d/%Y" , os.time( weekfirstDay )).." 11:59:59 PM"
		Week_Group.Processingdate  = dateSplit(os.date( "%Y-%m-%dT%H:%m:%S" , os.time( weekfirstDay )))
		Week_Group.value =  weekfirstDay 

		
		if i == 7 then

			local month = Utils.GetMonth(os.date( "%b" , os.time( weekfirstDay ) ))

			if CommonWords.language == "Canada English" then

				   weekView_header.text =  weekView_header.text..os.date( " %d " , os.time( weekfirstDay )  )..month..os.date( ", %Y" , os.time( weekfirstDay )  )

			else

				   weekView_header.text = weekView_header.text..os.date( month.." %d, %Y" , os.time( weekfirstDay ) )

			end

		end

		Week_Group:addEventListener( "touch", dayTouch )

		week:insert( Week_Group )

	end

	weekfirstDay.day=weekfirstDay.day-7

		if flagValue then
			eventList(weekfirstDay)
		end

end
local function searchListener( event )

    if ( event.phase == "began" ) then
        -- user begins editing defaultField
        print( event.text )

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with defaultField text
        print( event.target.text )
        search.text = ""
        NoEvent.text = EventCalender.NoEvent
        native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then


 				local searchweektime = os.date( '*t' )

				searchweektime.day = searchweektime.day - os.date( "%w" ) 

				searchweektime.day = searchweektime.day+(7*currentweek)

				Processingdate = os.date( "%Y-%m-%d" , os.time( searchweektime ))

				ParentShow = true

				print( "123 : "..json.encode(DateWise_response ))

    			searchEventlist(DateWise_response,searchweektime,event.text)

    end
end


local function calenderTouch( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		search.text = ""
		NoEvent.text = EventCalender.NoEvent
		native.setKeyboardFocus( nil )
		if pickerGroup.isVisible == true then
	

		else
			pickerGroup:toFront()
			pickerGroup.isVisible=true
		end

	end

	return true

end 

local function todayAction( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		search.text = ""
		NoEvent.text = EventCalender.NoEvent
		native.setKeyboardFocus( nil )

		local temp = os.date( '*t' )
		temp.day = temp.day - os.date( "%w" ) 
		weekViewTouchFlag=true
		Processingdate = os.date( "%Y-%m-%d" , os.time( t ))
		ParentShow=true
		currentweek = 0
		creatWeek(temp,false)

		NoEvent.isVisible=false

	local function get_GetUpComingEvents( response )


		local Upcoming = os.date( '*t' )
		Processingdate = dateSplit(os.date( "%Y-%m-%dT%H:%m:%S" , os.time( Upcoming )))
		ParentShow=true
		weekViewTouchFlag = true
		print("Processingdate : "..Processingdate)
		createEventlist(response,Upcoming)
	end


	Webservice.Get_GetUpComingEvents(get_GetUpComingEvents)

	end

	return true

end





local function weekViewSwipe( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		print("currentweek .. "..currentweek)
		search.text = ""
		NoEvent.text = EventCalender.NoEvent
		native.setKeyboardFocus( nil )

		if weekViewTouchFlag == false then

			print("calling")

					if event.target.id  == "leftSwipe" then


						if currentweek <= 1 then
							weekView_leftArrow.alpha = 0.5
						else
							weekView_leftArrow.alpha = 1
						end

						if currentweek >= 1 then


		
						weekViewTouchFlag = true

						local weekViewSwipevalue_left = os.date( '*t' )

						weekViewSwipevalue_left.day = weekViewSwipevalue_left.day - os.date( "%w" ) 

						currentweek = currentweek - 1 

						weekViewSwipevalue_left.day = weekViewSwipevalue_left.day+(7*currentweek)

						--weekViewSwipevalue_left.day = weekViewSwipevalue_left.day-7

						startdate = os.date( "%m/%d/%Y" , os.time( weekViewSwipevalue_left )).." 12:00:00 AM"

						weekViewSwipevalue_left.day = weekViewSwipevalue_left.day+6

						enddate = os.date( "%m/%d/%Y" , os.time( weekViewSwipevalue_left )).." 11:59:59 PM"

						weekViewSwipevalue_left.day = weekViewSwipevalue_left.day-6	

						Processingdate = dateSplit(os.date( "%Y-%m-%dT%H:%m:%S" , os.time( weekViewSwipevalue_left )))

						ParentShow=true

				
				
						creatWeek(weekViewSwipevalue_left,true)

						
							

						end
					

					elseif event.target.id == "rightSwipe" then

						weekView_leftArrow.alpha = 1
						
						weekViewTouchFlag = true

						local weekViewSwipevalue = os.date( '*t' )

						weekViewSwipevalue.day = weekViewSwipevalue.day - os.date( "%w" ) 

						currentweek = currentweek +1 

						weekViewSwipevalue.day = weekViewSwipevalue.day+(7*currentweek)



						startdate = os.date( "%m/%d/%Y" , os.time( weekViewSwipevalue )).." 12:00:00 AM"

						weekViewSwipevalue.day = weekViewSwipevalue.day+6

						enddate = os.date( "%m/%d/%Y" , os.time( weekViewSwipevalue )).." 11:59:59 PM"

						weekViewSwipevalue.day = weekViewSwipevalue.day-6

						Processingdate = dateSplit(os.date( "%Y-%m-%dT%H:%m:%S" , os.time( weekViewSwipevalue )))

						ParentShow=true

						--eventList(weekViewSwipevalue)

						print(startdate,enddate)

						creatWeek(weekViewSwipevalue,true)

						

					end

			end


	end

	return true

end


local function calenderAction( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		search.text = ""
		NoEvent.text = EventCalender.NoEvent
		native.setKeyboardFocus( nil )
			pickerGroup.isVisible=false

		local values = pickerWheel:getValues()

		-- Get the value for each column in the wheel (by column index)
		local selectedMonth = values[1].value
		local selectedDay = values[2].value
		local selectedYear = values[3].value


		selectedMonth = tostring(table.indexOf( monthArray, values[1].value ))
		selectedDay = tostring(values[2].value)
		selectedYear = tostring(values[3].value)

		if selectedMonth:len() == 1 then
			selectedMonth = "0"..selectedMonth
		end
		if selectedDay:len() == 1 then
			selectedDay = "0"..selectedDay
		end

		if startdate ~= selectedMonth.."/"..selectedDay.."/"..selectedYear.." 12:00:00 AM" then
				startdate =  selectedMonth.."/"..selectedDay.."/"..selectedYear.." 12:00:00 AM"
				enddate = selectedMonth.."/"..selectedDay.."/"..selectedYear.." 11:59:59 PM"
				print("start date : "..startdate )
				Processingdate = selectedYear.."-"..selectedMonth.."-"..selectedDay
				print("Processingdate : "..Processingdate )
				--dateSplit(os.date( "%Y-%m-%dT%H:%m:%S" , os.time( t )))
				ParentShow=true

				local temp = os.date( '*t' )



				eventList(temp)	

		end

	end

	return true

end 

local function unrequire( m )
 print( "unrequire" )
 package.loaded[m] = nil
    _G[m] = nil
 	package.loaded["res.value.string_es_Us"] = nil

  return true
end


	local function EventCalender_scrollListener( event )

		    local phase = event.phase


		    print( "here" )
		    if ( phase == "began" ) then 
		    elseif ( phase == "moved" ) then
			
				headerGroup.alpha=1
		

				for i=1,#HeaderDetails do

					if HeaderDetails[i-1] ~= nil then

					local xView, yView = scrollView:getContentPosition()

					print( yView,HeaderDetails[i].Position)

					if -(yView) < tonumber(HeaderDetails[i].Position) then

						print( -(yView),HeaderDetails[i].Position )

							Header_parent_leftText.text = Utils.GetWeek(os.date( "%A" , HeaderDetails[i-1].Time ))

							Header_parent_centerText.text = os.date( "%b %d, %Y" , HeaderDetails[i-1].Time )


						return true

					end

				end

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

		MyUnitBuzzString = nil

		openPage="eventCalenderPage"

	print( langid,countryid )

	--("res.value.string")

	if package.loaded["res.value.string_es_Us"] then print( "spani finish" ) unrequire("res.value.string_es_Us") end
	if package.loaded["res.value.string_fr_Ca"] then print( "string_fr_Ca finish" ) unrequire("res.value.string_fr_Ca") end
	if package.loaded["res.value.string_en_Ca"] then print( "string_en_Ca finish" ) unrequire("res.value.string_en_Ca") end
	if package.loaded["res.value.string"] then print( "string finish" ) unrequire("res.value.string") end
	

	if langid == "2"  and countryid == "1" then

		MyUnitBuzzString = require( "res.value.string_es_Us" )

	elseif langid == "3"  and countryid == "2" then

		MyUnitBuzzString = require( "res.value.string_fr_Ca" )

	elseif langid == "4" and countryid == "2" then

		MyUnitBuzzString = require( "res.value.string_en_Ca" )

	else

		MyUnitBuzzString = require( "res.value.string")

	end


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

	menuTouch_s = display.newRect( sceneGroup, 0, BgText.y, 135, 40 )
	menuTouch_s.anchorX=0
	menuTouch_s.alpha=0.01



	NoEvent = display.newText( sceneGroup, EventCalender.NoEvent , 0,0,0,0,native.systemFontBold,16)
	NoEvent.x=W/2;NoEvent.y=H/2
	NoEvent.isVisible=false
	NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
	
	topBg = display.newRect(sceneGroup,W/2,tabBar.y+tabBar.contentHeight/2,W,30)
	topBg.anchorY=0
	topBg:setFillColor(Utils.convertHexToRGB(color.Bggray))

	topToday_btnBg = display.newRect(sceneGroup,topBg.x-topBg.contentWidth/2+10,topBg.y+topBg.contentHeight/2,80,22)
	topToday_btnBg.anchorX=0
	topToday_btnBg:setFillColor(Utils.convertHexToRGB(sp_Calender_btn.Background_Color))

	topToday_btnlabel = display.newText(sceneGroup,EventCalender.Upcoming,0,0,native.systemFontBold,12)
	topToday_btnlabel.x=topToday_btnBg.x+topToday_btnBg.contentWidth/2;topToday_btnlabel.y=topToday_btnBg.y
	Utils.CssforTextView(topToday_btnlabel,sp_Calender_btn)
	MainGroup:insert(sceneGroup)



	searchhBg = display.newRect(sceneGroup,W/2+25,topToday_btnBg.y,180,22)
	searchLeftDraw = display.newImageRect(sceneGroup,"res/assert/search(gray).png",16/1.2,18/1.2)
	searchLeftDraw.x=searchhBg.x+searchhBg.contentWidth/2-searchLeftDraw.contentWidth
	searchLeftDraw.y=searchhBg.y

	search =  native.newTextField( searchhBg.x-searchhBg.contentWidth/2, searchhBg.y, searchhBg.contentWidth-25, 24 )
	search.anchorX=0
	search.size=14
	--search:resizeFontToFitHeight()
	search:setReturnKey( "search" )
	search.placeholder = CommonWords.search
	search.hasBackground = false
	sceneGroup:insert(search)



	calenderView = display.newImageRect(sceneGroup,"res/assert/calender(gray).png",24/1.2,24/1.2)
	calenderView.x=W-25
	calenderView.y=searchhBg.y

	calenderView_bg = display.newRect( sceneGroup, calenderView.x, calenderView.y, 35, 35 )
	calenderView_bg.alpha=0.01

sceneGroup:insert( pickerGroup )
pickerGroup.isVisible=false
	-- Create the widget
pickerWheel = widget.newPickerWheel
{
    top = display.contentHeight - 222,
    columns = columnData
}

pickerGroup:insert(pickerWheel)

picker_btnBg = display.newRect( pickerGroup, W/2, pickerWheel.y-pickerWheel.contentHeight/2-15, W, 30 )

picker_Done = display.newText( pickerGroup, CommonWords.done, 0, 0, native.systemFont, 20 )
picker_Done:setFillColor(Utils.convertHexToRGB(color.today_blue))
picker_Done.x=picker_btnBg.x+100;picker_Done.y=picker_btnBg.y



end


function scene:resumeGame(value)

	if value == "back" then

		print( "^^^^^^^^^^^^^^^^^^^^^^" )

	Runtime:addEventListener( "key", onKeyEvent )

    search.isVisible=true

	

		local function waitTimer( event )
			if openPage=="eventCalenderPage" then
					local tempvalue = os.date( '*t' )
					tempvalue.day = tempvalue.day - os.date( "%w" ) 
					weekViewTouchFlag=true
					ParentShow=true

					
					creatWeek(tempvalue,true)

			end
		end

		timer.performWithDelay( 500, waitTimer )


	end

		
end




function scene:resumeGame(value,EditArray)


				print( "*********test*********" )



    if value == "edit" then


				local options = {
					isModal = true,
					effect = "slideLeft",
					time = 100,
					params = {
					
					Details = EditArray

				}
			}



			composer.showOverlay( "Controller.addEventPage", options )

	elseif value == "details" then

		print( "@@@@@@@@@@@@@@@@@@@" )


			local options = {
					isModal = true,
					effect = "slideLeft",
					time = 10,
					params = {
					details = EditArray
				}
			}

		composer.showOverlay( "Controller.eventCal_DetailPage", options )

	elseif value == "back" then

			Runtime:addEventListener( "key", onKeyEvent )

    search.isVisible=true

		local function waitTimer( event )
			if openPage=="eventCalenderPage" then


			local tempvalue = os.date( '*t' )
					tempvalue.day = tempvalue.day - os.date( "%w" ) 
					startdate = os.date( "%m/%d/%Y" , os.time( tempvalue )).." 12:00:00 AM"

					tempvalue.day = tempvalue.day + 7

					enddate = os.date( "%m/%d/%Y" , os.time( tempvalue )).." 11:59:59 PM"
					local temp = os.date( '*t' )
					temp.day = temp.day - os.date( "%w" ) 
					weekViewTouchFlag=true
					ParentShow=true
					creatWeek(temp,true)

			end
		end

		timer.performWithDelay( 500, waitTimer )

		

    end

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		

		ga.enterScene("EventCalender")


--toast.show('Toast is done!', {duration = 'long', gravity = 'BottomCenter', offset = {0, 128}})  

		elseif phase == "did" then

			composer.removeHidden()

			
			scrollView = widget.newScrollView
			{
			top = 0,
			left = 0,
			width = W,
			height =H-RecentTab_Topvalue-60,
			hideBackground = true,
			isBounceEnabled=false,
			horizontalScrollingDisabled = false,
			verticalScrollingDisabled = false,
			hideScrollBar=true,
			friction = .6,
			listener = EventCalender_scrollListener
			}

			sceneGroup:insert(scrollView)
			scrollView.anchorY=0
			scrollView.y = RecentTab_Topvalue+60

			sceneGroup:insert( headerGroup )

			function get_allCalender(response)


			if response ~= nil then


				if(response[1].DefaultCalendarViewMain ~= nil and response[1].DefaultCalendarViewMain == "WEEK") then

				defalutCalenderView = "agendaWeek"

				elseif(response[1].DefaultCalendarViewMain ~= nil and response[1].DefaultCalendarViewMain == "MONTH") then

				defalutCalenderView = "month"

				elseif(response[1].DefaultCalendarViewMain ~= nil and response[1].DefaultCalendarViewMain == "DAY") then

				defalutCalenderView = "agendaDay"

			end

			CalendarId = response[1].CalendarId
			UserId = response[1].UserId
			CalendarName = response[1].CalendarName

				--defalutCalenderView = "agendaDay"

			if response[1].IsShowAppointment then

				IsShowAppointment="true"

			else

				IsShowAppointment="false"

			end

			if response[1].IsShowCall then

				IsShowCall="true"

			else

				IsShowCall="false"

			end

			if response[1].IsShowParty then

				IsShowParty="true"

			else

				IsShowParty="false"

			end
			if response[1].IsShowTask then

				IsShowTask="true"

			else

				IsShowTask="false"

			end
			if response[1].IsShowFamilyTime then

				IsShowFamilyTime="true"

			else

				IsShowFamilyTime="false"

			end
			if response[1].IsPublic then

				IsPublic="true"

			else

				IsPublic="true"

			end


			local t = os.date( '*t' )


			t.day = t.day - os.date( "%w" ) 


			ProcessingCount_total = 7



			startdate = os.date( "%m/%d/%YT%H:%m:%S %p" , os.time( t ))

			t.day = t.day + 6

			Processingdate = os.date( "%Y-%m-%d" , os.time( t ))


			startdate = dateSplit(startdate).." 12:00:00 AM"

			enddate = os.date( "%m/%d/%Y" , os.time( t )).." 11:59:59 PM"


			

local temp = os.date( '*t' )
temp.day = temp.day - os.date( "%w" ) 
weekViewTouchFlag=true
creatWeek(temp,true)

	
end	

end





Webservice.Get_All_MyCalendars(get_allCalender)


sceneGroup:insert( weekViewGroup )


weekView_bg = display.newRect( weekViewGroup,W/2,topBg.y+topBg.contentHeight,W,60)
weekView_bg.anchorY=0
weekView_bg:setFillColor( 0.9,0.7,0.8 )

weekView_header = display.newText( weekViewGroup,"", 0, 0, native.systemFont, 14 )
weekView_header.x=W/2;weekView_header.y=weekView_bg.y+10
Utils.CssforTextView(weekView_header,sp_helpText)


weekView_leftArrow_bg = display.newRect( weekViewGroup, 0,0,30,45 )
weekView_leftArrow_bg.x= weekView_bg.x-weekView_bg.contentWidth/2+20
weekView_leftArrow_bg.y = weekView_bg.y+weekView_bg.contentHeight/2
weekView_leftArrow_bg.alpha=0.01
weekView_leftArrow_bg.id = "leftSwipe"
weekView_leftArrow_bg:addEventListener( "touch", weekViewSwipe )


weekView_leftArrow = display.newImageRect( weekViewGroup, "res/assert/right-arrow(gray-).png",15,30 )
weekView_leftArrow.xScale=-1
weekView_leftArrow.alpha=0.5
weekView_leftArrow.x=weekView_bg.x-weekView_bg.contentWidth/2+20
weekView_leftArrow.y=weekView_bg.y+weekView_bg.contentHeight/2+weekView_leftArrow.contentHeight/2-5	


weekView_rightArrow_bg = display.newRect( weekViewGroup, 0,0,30,45 )
weekView_rightArrow_bg.x=weekView_bg.x+weekView_bg.contentWidth/2-20
weekView_rightArrow_bg.y=weekView_bg.y+weekView_bg.contentHeight/2
weekView_rightArrow_bg.alpha=0.01
weekView_rightArrow_bg.id = "rightSwipe"
weekView_rightArrow_bg:addEventListener( "touch", weekViewSwipe )

weekView_rightArrow = display.newImageRect( weekViewGroup, "res/assert/right-arrow(gray-).png",15,30 )
weekView_rightArrow.x=weekView_bg.x+weekView_bg.contentWidth/2-20
weekView_rightArrow.y=weekView_bg.y+weekView_bg.contentHeight/2+weekView_leftArrow.contentHeight/2-5

addEventBtn = display.newImageRect( sceneGroup, "res/assert/addevent.png", 66/1.5,66/1.7 )
addEventBtn.x=W/2+W/3;addEventBtn.y=H-40;addEventBtn.id="addEvent"


if IsOwner == false then
	addEventBtn.alpha=0
end

	
menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)
menuTouch_s:addEventListener("touch",menuTouch)
topToday_btnBg:addEventListener("touch",todayAction)
topToday_btnlabel:addEventListener("touch",todayAction)
calenderView_bg:addEventListener("touch",calenderTouch)
picker_Done:addEventListener( "touch", calenderAction )
search:addEventListener( "userInput", searchListener )
addEventBtn:addEventListener( "touch", listTouch )

Runtime:addEventListener( "key", onKeyEvent )


end

MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then



		for j=1,#event_groupArray do 
			event_groupArray[j]:removeSelf()
			event_groupArray[j] = nil
		end

		for j=#headerGroup, 1, -1 do 
			display.remove(headerGroup[#headerGroup])
			headerGroup[#headerGroup] = nil
		end
		event_groupArray=nil
		headerGroup=nil


		menuBtn:removeEventListener("touch",menuTouch)
		BgText:removeEventListener("touch",menuTouch)
		menuTouch_s:removeEventListener("touch",menuTouch)

		Runtime:removeEventListener( "key", onKeyEvent )



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