----------------------------------------------------------------------------------
--
-- event Calender Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")


local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )

local Processingdate
local ProcessingCount_total = 0
local ProcessingCount = 0 

local pickerGroup = display.newGroup( )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

--Button

local menuBtn,topBg,topToday_btnBg,topToday_btnlabel,searchhBg,search,weekView,calenderView,calenderView_bg,pickerWheel,picker_btnBg,picker_Done,menuTouch_s

local ParentShow = true

local CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic

local DateWise_response = {}

local defalutCalenderView = "agendaWeek" --"month","agendaDay"

local event_groupArray = {}

local scrollView

local RecentTab_Topvalue = 70

local pickerWheel,picker_btnBg,picker_Done

local labels = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }
local monthArray={ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }

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

print(os.date( "%d" ))

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

function scene:resumeGame()
    search.isVisible=true
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
			display.getCurrentStage():setFocus( nil )


			local options = {
			isModal = true,
			effect = "slideLeft",
			time = 500,
			params = {
			details = event.target.value
		}
	}

	search.isVisible=false
	composer.showOverlay( "Controller.eventCal_DetailPage", options )


end

return true
end

function makeTimeStamp(dateString)
	local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
	local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin =
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


event_groupArray[#event_groupArray+1] = display.newGroup()

local tempGroup = event_groupArray[#event_groupArray]

local bgheight = 45
--os.date("!%Y-%m-%dT%H:%m:%S")
local timeGMT = Utils.makeTimeStamp( response.date )


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


parentTitle.anchorY = 0
parentTitle.x=W/2;parentTitle.y=tempHeight
parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))		

local parent_leftDraw = display.newImageRect(tempGroup,"res/assert/calendar.png",32/2,32/2)
parent_leftDraw.x=parentTitle.x-parentTitle.contentWidth/2+15;parent_leftDraw.y=parentTitle.y+parentTitle.contentHeight/2

local parent_leftText = display.newText(tempGroup,os.date( "%A" , timeGMT ),0,0,native.systemFont,10)
parent_leftText.x=parent_leftDraw.x+parent_leftDraw.contentWidth/2+2
parent_leftText.y=parent_leftDraw.y
parent_leftText.anchorX=0

local parent_centerText = display.newText(tempGroup,os.date( "%B %d, %Y" , timeGMT ),0,0,native.systemFontBold,14)
parent_centerText.x=W/2
parent_centerText.y=parent_leftDraw.y

background.y=parentTitle.y+background.contentHeight/2

end

local title = display.newText( tempGroup,response.title, background.x+20, background.y,180,0, native.systemFontBold, 11 )
--title.anchorY=0
title:setFillColor(Utility.convertHexToRGB(color.tabBarColor))

background.height = background.contentHeight+title.height
title.y=background.y+background.contentHeight/2

local line = display.newRect(tempGroup,W/2,background.y,W,1)
line.y=background.y+background.contentHeight-line.contentHeight
line:setFillColor(Utility.convertHexToRGB(color.LtyGray))

local time = display.newText(tempGroup,os.date( "%I:%M \n  %p" , timeGMT ),0,0,80,0,native.systemFontBold,12)
time.x=45
time.y=background.y+background.contentHeight/2
time:setFillColor(Utility.convertHexToRGB(color.Black))

if response.allDay == true then
	time.text="ALL DAY"
end

local leftDraw_line = display.newRect(tempGroup,background.x-90,background.y-2,2,background.contentHeight+2)
leftDraw_line:setFillColor(Utility.convertHexToRGB(color.tabBarColor))
leftDraw_line.anchorY=0

local leftDraw_img = display.newImageRect(tempGroup,"res/assert/arrow(calen-page).png",30,25)
leftDraw_img.x=leftDraw_line.x;leftDraw_img.y=leftDraw_line.y+leftDraw_line.contentHeight/2

local right_img = display.newImageRect(tempGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
right_img.anchorX=0
right_img.x=background.x+background.contentWidth/2-30;right_img.y=leftDraw_line.y+leftDraw_line.contentHeight/2

tempGroup.value = response
tempGroup:addEventListener("touch",listTouch)

scrollView:insert(tempGroup)

end




local function eventList(  )

	NoEvent.isVisible=false

	function get_TicklerEvents(response)
		DateWise_response=response


		for j=#event_groupArray, 1, -1 do 
			display.remove(event_groupArray[#event_groupArray])
			event_groupArray[#event_groupArray] = nil
		end


		if #DateWise_response == 0 then

			NoEvent.isVisible=true


			--return false
		else

		end

		if DateWise_response[1] then

		date = dateSplit(DateWise_response[1].date)

	end



		


		for i = 1, #DateWise_response do


			date = dateSplit(DateWise_response[i].date)

	

			local function eventCalen_display_process()

				--print("Compare : "..Processingdate..":"..date)



				if Processingdate == date then

					--print("final : "..DateWise_response[i].title)
					

					display_calenderList(DateWise_response[i])

				else

					ProcessingCount = ProcessingCount+1

					if ProcessingCount_total >= ProcessingCount then

						ParentShow = true

						local temp = os.date( '*t' )
						temp.day=temp.day+ProcessingCount
						Processingdate = dateSplit(os.date( "!%Y-%m-%dT%H:%m:%S" , os.time( temp )))
						eventCalen_display_process()

					else
						print("finish")
					end

				end
			end

			eventCalen_display_process()

		end

	end

	Webservice.Get_TicklerEvents(CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic,get_TicklerEvents)

end


local function calenderTouch( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
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
		local t = os.date( '*t' )


		--pickerWheel._view._columns[1]:scrollToIndex( tonumber(os.date( "%m" )) )
		--pickerWheel._view._didTap = true
        --startIndex = tonumber(os.date( "%d" )),

       -- startIndex = 5,


		startdate = os.date( "!%m/%d/%Y" , os.time( t )).." 12:00:00 AM"
		enddate = os.date( "!%m/%d/%Y" , os.time( t )).." 11:59:59 PM"
		Processingdate = dateSplit(os.date( "!%Y-%m-%dT%H:%m:%S" , os.time( t )))
		ParentShow=true
		eventList()

	end

	return true

end 
local function calenderAction( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
			pickerGroup.isVisible=false

		local values = pickerWheel:getValues()

		-- Get the value for each column in the wheel (by column index)
		local selectedMonth = values[1].value
		local selectedDay = values[2].value
		local selectedYear = values[3].value


		selectedMonth = table.indexOf( monthArray, values[1].value )
		selectedDay = values[2].value 
		selectedYear = values[3].value

		startdate =  selectedMonth.."/"..selectedDay.."/"..selectedYear.." 12:00:00 AM"
		enddate = selectedMonth.."/"..selectedDay.."/"..selectedYear.." 11:59:59 PM"
		print("start date : "..startdate )
		Processingdate = selectedYear.."-"..selectedMonth.."-"..selectedDay

		--dateSplit(os.date( "!%Y-%m-%dT%H:%m:%S" , os.time( t )))
		ParentShow=true
		eventList()	

	end

	return true

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

	menuTouch_s = display.newRect( sceneGroup, 0, BgText.y, 135, 40 )
	menuTouch_s.anchorX=0
	menuTouch_s.alpha=0.01



	NoEvent = display.newText( sceneGroup, "No events to show", 0,0,0,0,native.systemFontBold,16)
	NoEvent.x=W/2;NoEvent.y=H/2
	NoEvent.isVisible=false
	NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
	
	topBg = display.newRect(sceneGroup,W/2,tabBar.y+tabBar.contentHeight/2,W,30)
	topBg.anchorY=0
	topBg:setFillColor(Utils.convertHexToRGB(color.Bggray))

	topToday_btnBg = display.newRect(sceneGroup,topBg.x-topBg.contentWidth/2+10,topBg.y+topBg.contentHeight/2,60,22)
	topToday_btnBg.anchorX=0
	topToday_btnBg:setFillColor(Utils.convertHexToRGB(color.today_blue))

	topToday_btnlabel = display.newText(sceneGroup,EventCalender.Today,0,0,native.systemFontBold,12)
	topToday_btnlabel.x=topToday_btnBg.x+topToday_btnBg.contentWidth/2;topToday_btnlabel.y=topToday_btnBg.y
	MainGroup:insert(sceneGroup)



	searchhBg = display.newRect(sceneGroup,W/2+5,topToday_btnBg.y,180,22)
	searchLeftDraw = display.newImageRect(sceneGroup,"res/assert/search(gray).png",16/1.2,18/1.2)
	searchLeftDraw.x=searchhBg.x+searchhBg.contentWidth/2-searchLeftDraw.contentWidth
	searchLeftDraw.y=searchhBg.y

	search =  native.newTextField( searchhBg.x-searchhBg.contentWidth/2, searchhBg.y, searchhBg.contentWidth-25, 22 )
	search.anchorX=0
	search.hasBackground = false
	sceneGroup:insert(search)

	weekView = display.newImageRect(sceneGroup,"res/assert/list(gray).png",27/1.2,19/1.2)
	weekView.x=searchhBg.x+searchhBg.contentWidth/2+20
	weekView.y=searchhBg.y

	searchLeftDraw.isVisible=false
	searchhBg.isVisible=false
	search.isVisible=false
	weekView.isVisible=false

	calenderView = display.newImageRect(sceneGroup,"res/assert/calender(gray).png",24/1.2,24/1.2)
	calenderView.x=weekView.x+weekView.contentWidth/2+18
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

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		openPage="eventCalenderPage"

		elseif phase == "did" then

			composer.removeHidden()

			
			scrollView = widget.newScrollView
			{
			top = RecentTab_Topvalue,
			left = 0,
			width = W,
			height =H-RecentTab_Topvalue,
			hideBackground = true,
			isBounceEnabled=false,
			horizontalScrollingDisabled = false,
			verticalScrollingDisabled = false,
			hideScrollBar=true,

			   -- listener = scrollListener
			}

			sceneGroup:insert(scrollView)

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


			startdate = os.date( "!%m/%d/%YT%H:%m:%S %p" , os.time( t ))

			Processingdate = os.date( "!%Y-%m-%d" , os.time( t ))

			startdate = dateSplit(startdate).." 12:00:00 AM"


			if defalutCalenderView == "agendaWeek" then

			ProcessingCount_total = 7

			t.day = t.day + 7


			enddate = os.date( "!%m/%d/%Y" , os.time( t )).." 11:59:59 PM"

			elseif defalutCalenderView == "month" then

			ProcessingCount_total = 30

			t.day = t.day + 30
		--!%Y-%m-%dT%H:%m:%S

		enddate = os.date( "!%m/%d/%Y" , os.time( t )).." 11:59:59 PM"

		elseif defalutCalenderView == "agendaDay" then

		ProcessingCount_total = 0

		t.day = t.day


		enddate = os.date( "!%m/%d/%Y" , os.time( t )).." 11:59:59 PM"
	end


	eventList()

	
end	

end





Webservice.Get_All_MyCalendars(get_allCalender)



menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)
menuTouch_s:addEventListener("touch",menuTouch)
topToday_btnBg:addEventListener("touch",todayAction)
topToday_btnlabel:addEventListener("touch",todayAction)
calenderView_bg:addEventListener("touch",calenderTouch)
picker_Done:addEventListener( "touch", calenderAction )

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

		event_groupArray=nil


		menuBtn:removeEventListener("touch",menuTouch)
		BgText:removeEventListener("touch",menuTouch)
		menuTouch_s:removeEventListener("touch",menuTouch)



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