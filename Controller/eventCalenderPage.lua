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


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

--Button

local menuBtn

local ParentShow = true

openPage="eventCalenderPage"

local DateWise_response = {}

local defalutCalenderView = "agendaWeek" --"month","agendaDay"

local event_groupArray = {}

local scrollView

local RecentTab_Topvalue = 70

--------------------------------------------------


-----------------Function-------------------------

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
local timeGMT = makeTimeStamp( response.date )


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

local title = display.newText( tempGroup,response.title, background.x+10, background.y,180,0, native.systemFontBold, 11 )
--title.anchorY=0
title:setFillColor(Utility.convertHexToRGB(color.tabBarColor))

background.height = background.contentHeight+title.height
title.y=background.y+background.contentHeight/2

local line = display.newRect(tempGroup,W/2,background.y,W,1)
line.y=background.y+background.contentHeight-line.contentHeight
line:setFillColor(Utility.convertHexToRGB(color.LtyGray))

local time = display.newText(tempGroup,os.date( "%I:%M \n  %p" , timeGMT ),0,0,native.systemFontBold,14)
time.x=30
time.y=background.y+background.contentHeight/2
time:setFillColor(Utility.convertHexToRGB(color.Black))

local leftDraw_line = display.newRect(tempGroup,background.x-100,background.y-2,2,background.contentHeight+2)
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
	
	
	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


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

			local CalendarId = response[1].CalendarId
			local UserId = response[1].UserId 

			local IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic


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


			local startdate
			local enddate

			local Processingdate
			local ProcessingCount_total = 0
			local ProcessingCount = 0 


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


	function get_TicklerEvents(response)
		DateWise_response=response

		date = dateSplit(DateWise_response[1].date)


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

end





Webservice.Get_All_MyCalendars(get_allCalender)



menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)




end

MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then


		elseif phase == "did" then

			for j=1,#event_groupArray do 
				event_groupArray[j]:removeSelf()
				event_groupArray[j] = nil
			end

			event_groupArray=nil


			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

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