----------------------------------------------------------------------------------
--
-- eventCal_DetailPage
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")
local Utility = require( "Utils.Utility" )
require( "Controller.genericAlert" )
local Applicationconfig = require("Utils.ApplicationConfig")
local widget = require( "widget" )
local status = "normal"

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background1,BgText,PageTitle,titleBar,titleBar_icon,titleBar_text

local menuBtn

local detail_value = {}

local BackFlag = false

local parantValue

local TicklerId,CalendarId,CalendarName,id

local RecentTab_Topvalue = 105

local prority_enum = {EventCalender.High,EventCalender.Normal,EventCalender.Low}

local purpose_enum = {"FACIAL","ON_THE_GO","DOUBLE_FACIAL","CLASS","TEAM_BUILDING","TRAINING","SHOW","MEETING","FOLLOW_UP","CUSTOMER_SERVICE","TWO_DAY_FOLLOWUP","TWO_WEEK_FOLLOWUP","TWO_MONTH_FOLLOWUP","OTHER","COLOR_APPT","FAMILY","BOOKING","INIT_APPT","RESCHEDULE","FULLCIRCLE"}

local deleteEvent_icon,editEvent_icon

local eventResponse = {}

local with_enum = {
	"CALENDAR",
	"APPT",
	"CALL",
	"PARTY",
	"TASK",
	"FAMY",
	"NONE"
}

openPage="eventCalenderPage"

local display_details = {}

local function getPurpose( stringValue )

	local value = EventCalender[stringValue]

	return value

end

--------------------------------------------------


-----------------Function-------------------------

local function makeTimeStamp(dateString)
	local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
	local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin =
	dateString:match(pattern)
	local timestamp = os.time( {year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false} )
	return timestamp
end



local function bgTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

	end

	return true
end




local function closeDetails( event )
	
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		
		composer.hideOverlay( "slideRight", 300 )

	end

	return true

end




function get_DeleteTicklerEvent( response )
	
	if response.OperationStatus == 0 then

		status = "deleted"

		composer.hideOverlay( "slideRight", 300 )

	else

	end

end




local function EditOption( event )

	if event.phase == "ended" then

			local function onComplete( event1 ) 

				    if event1 == 1 then

				    	Webservice.DeleteTicklerEvent(TicklerId,CalendarId,CalendarName,id,get_DeleteTicklerEvent)
				       
				    elseif event1 == 2 then
				    	--Details
				    	
				    end
						
			end


			if detail_value.IsRecurrence == true then

				if event.target.id == "delete" then

					local option ={
								 {content=CommonWords.ok,positive=true},
								}
							genericAlert.createNew(EventCalender.PageTitle,EventCalender.RecurringDeleteAlert,option)


				elseif event.target.id == "edit" then

					local option ={
								 {content=CommonWords.ok,positive=true},
								}
							genericAlert.createNew(EventCalender.PageTitle,EventCalender.RecurringEditAlert,option)
					
				end

			else

				if event.target.id == "delete" then

					local option ={
								 {content=CommonWords.ok,positive=true},
								{content=CommonWords.cancel,positive=false}
								}
					genericAlert.createNew(EventCalender.PageTitle, EventCalender.DeleteAlert,option,onComplete)

					--local alert = native.showAlert(EventCalender.DeleteTitle, EventCalender.DeleteAlert , { CommonWords.ok , CommonWords.cancel }, onComplete )

				elseif event.target.id == "edit" then

					status="edit"

					composer.hideOverlay()
					
				end

			end

		end

		return true

	end
	



	
	local function AttachmentDownload( event )

		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			system.openURL( ApplicationConfig.IMAGE_BASE_URL..""..event.target.value )

		end

		return true
	end




	local function onKeyEventDetail( event )

		local phase = event.phase
		local keyName = event.keyName

		if phase == "up" then

			if keyName=="back" then

				composer.hideOverlay( "slideRight", 300 )
				
				return true
				
			end

		end

		return false
	end



		------------------------------------------------------

		function scene:create( event )

			local sceneGroup = self.view

			-- Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
			-- Background.x=W/2;Background.y=H/2

			Background = display.newRect(sceneGroup,0,0,W,H)
			Background.x=W/2;Background.y=H/2
			Background:setFillColor(1,1,1)
			Background:addEventListener("touch",bgTouch)

			tabBar = display.newImageRect(sceneGroup,"res/assert/banner.png",W,110)
			tabBar.y=tabBar.contentHeight/2
			tabBar.x=W/2

			menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
			menuBtn.anchorX=0
			menuBtn.x=16;menuBtn.y=20;

			menuTouch_s = display.newRect( sceneGroup, 0, menuBtn.y, 135, 50 )
			menuTouch_s.anchorX=0
			menuTouch_s.alpha=0.01


			BackIcon = display.newImageRect(sceneGroup,"res/assert/back_icon.png",36/2,30/2)
			BackIcon.x=16;BackIcon.y=tabBar.y+tabBar.contentHeight/2-25
			BackIcon.anchorX=0


			title = display.newText(sceneGroup,"",0,0,"Roboto-Regular",18.5)
			title.anchorX = 0
			title.x=50;title.y = tabBar.y+tabBar.contentHeight/2-25
			title:setFillColor(1,1,1)


			editEvent_icon = display.newImageRect(sceneGroup,"res/assert/editicon.png",55,55)
			editEvent_icon.x = W - 43;editEvent_icon.y=tabBar.y+tabBar.contentHeight/2
			editEvent_icon.id="edit"
			editEvent_icon.isVisible = true
			
			deleteEvent_icon = display.newImageRect( sceneGroup, "res/assert/delete.png", 27,27 )
			deleteEvent_icon.x= W/2 - 15
			deleteEvent_icon.y= Background.y+Background.contentHeight/2 - 45
			deleteEvent_icon.anchorX = 0
			deleteEvent_icon.isVisible = true
			deleteEvent_icon:setFillColor(0,0,0,0.5)
			deleteEvent_icon.anchorY = 0
			deleteEvent_icon.id="delete"

			editEvent_icon:addEventListener( "touch", EditOption )
			deleteEvent_icon:addEventListener( "touch", EditOption )


			if not IsOwner then

				deleteEvent_icon.isVisible = false
				editEvent_icon.isVisible = false

			end

			MainGroup:insert(sceneGroup)

	end



		function scene:show( event )

			local sceneGroup = self.view
			local phase = event.phase

			parantValue = event

			if phase == "will" then

				scrollView = widget.newScrollView
				{
					top = RecentTab_Topvalue+110,
					left = 0,
					width = W,
					height =H-105-105,
					hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
					hideScrollBar=true,
					-- listener = scrollListener
				}
				scrollView.anchorY=0
				scrollView.y=RecentTab_Topvalue+45

				sceneGroup:insert(scrollView)


			elseif phase == "did" then

				BackIcon:addEventListener("touch",closeDetails)
				title:addEventListener("touch",closeDetails)
				
				menuBtn:addEventListener("touch",menuTouch)
				menuTouch_s:addEventListener("touch",menuTouch)
				
				--BgText:addEventListener("touch",menuTouch)
				Runtime:addEventListener("key",onKeyEventDetail)

						if event.params then

								detail_value = event.params.details

								print(json.encode(detail_value))

								local timeGMT = Utils.makeTimeStamp( detail_value.date )

							function get_ticklereventByid(response)

								Details=response

								local leftAllign = 10


								local tzoffset

								if Details.TimeZone == "Eastern Standard Time" then
									tzoffset = "-04:00:00"

								elseif Details.TimeZone == "Hawaiian Standard Time" then
									tzoffset = "-10:00:00"

								elseif Details.TimeZone == "Alaskan Standard Time" then
									tzoffset = "-09:00:00"

								elseif Details.TimeZone == "Mountain Standard Time" then
									tzoffset = "-06:00:00"

								elseif Details.TimeZone == "Pacific Standard Time" then
									tzoffset = "-07:00:00"

								elseif Details.TimeZone == "Central Standard Time" then
									tzoffset = "-05:00:00"

								elseif Details.TimeZone == "US Mountain Standard Time" then
									tzoffset = "-06:00:00"
								else
									tzoffset = "local"
								end

								local start_timeGMT = Utils.makeTimeStamp( detail_value.startdate.." "..tzoffset )
								local end_timeGMT = Utils.makeTimeStamp( detail_value.enddate.." "..tzoffset )


								Details.startdate = detail_value.startdate

								Details.enddate = detail_value.enddate

								TicklerId = Details.TicklerId
								CalendarId = Details.CalendarId
								CalendarName = Details.CalendarName
								id = Details.id

				----When----

		title.text = Details.title

		if title.text:len() > 15 then

			title.text = title.text:sub(1,15).."..."

		end


		display_details[#display_details+1] = display.newText(EventCalender.When,0,0,"Roboto-Regular",14)
		display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))

		display_details[#display_details].x=leftAllign+6;display_details[#display_details].y=tabBar.y+tabBar.contentHeight/2-100
		display_details[#display_details].anchorX=0
		scrollView:insert( display_details[#display_details] )

		local monthstart = Utils.GetMonth(os.date( "%b" ,start_timeGMT  ))
		local monthend = Utils.GetMonth(os.date( "%b" ,end_timeGMT ))

		local value 
		if CommonWords.language == "Canada English" then

			value = os.date( " %d " ,start_timeGMT  )..monthstart..os.date(", %Y" , start_timeGMT ).." to ".. os.date( "%d " ,start_timeGMT)..monthend..os.date( ", %Y" ,start_timeGMT  )

		else

			value = monthstart..os.date( " %d, %Y" ,start_timeGMT ).." to "..monthend..os.date( " %d, %Y" ,end_timeGMT   )

		end

		display_details[#display_details+1] = display_details[#display_details+1]
		display_details[#display_details] = display.newText(value,0,0,220,0,"Roboto-Regular",14)
		display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.Black))

		display_details[#display_details].x=W/2-46;display_details[#display_details].y=tabBar.y+tabBar.contentHeight/2-100
		display_details[#display_details].anchorX=0
		scrollView:insert( display_details[#display_details] )
		display_details[#display_details].id="when"

		------------------

		-----Timings-----




		local time 

		if Details.allDay == false then

			
			time = "("..os.date("%I:%M %p" ,start_timeGMT  ).." to "..os.date( "%I:%M %p" ,end_timeGMT  )..")"

		else

			time ="(ALL DAY)"

		end

		display_details[#display_details+1] = display.newText(time,0,0,210,0,"Roboto-Light",12.5)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-46;display_details[#display_details].y=display_details[#display_details-1].y+16
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="time"
		scrollView:insert( display_details[#display_details] )



		--------------------

		----Where----
		if Details.TicklerType ~= 4 then

			if Details.Location ~= nil or Details.PhoneNumber ~= nil or Details.Location ~= "" then

				display_details[#display_details+1] = display.newText(EventCalender.Where,0,0,"Roboto-Regular",14)
				display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
				display_details[#display_details].x=leftAllign+6
				display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+21
				display_details[#display_details].anchorX=0
				scrollView:insert( display_details[#display_details] )


				display_details[#display_details+1] = display.newText("",0,0,180,0,"Roboto-Regular",14)
				display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
				display_details[#display_details].x=W/2-46;display_details[#display_details].y=display_details[#display_details-1].y-8
				display_details[#display_details].anchorX=0
				display_details[#display_details].anchorY=0
				display_details[#display_details].id="where"
				scrollView:insert( display_details[#display_details] )

			end


			if Details.TicklerType == 2 then

				display_details[#display_details-1].text = EventCalender.Phone
				display_details[#display_details].text = Details.PhoneNumber
			else

				display_details[#display_details].text = Details.Location


			end

		end
		------------------

		----Description----

		if Details.Description ~= nil and Details.Description ~= "" then

			display_details[#display_details+1] = display.newText(EventCalender.Description,0,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
			display_details[#display_details].x=leftAllign+6
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+21
			display_details[#display_details].anchorX=0
			scrollView:insert( display_details[#display_details] )


			display_details[#display_details+1] = display.newText(Details.Description,0,0,193,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
			display_details[#display_details].x=W/2-46;display_details[#display_details].y=display_details[#display_details-1].y-8
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].id="Description"
			scrollView:insert( display_details[#display_details] )
		end

		------------------


		----With----------

		if Details.Contact ~= nil then

			local temp = Details.Contact

			display_details[#display_details+1] = display.newText(EventCalender.Appointment_With,0,0,90,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
			display_details[#display_details].x=leftAllign+6
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+21
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0

			if display_details[#display_details-1].id == "Description" then

				if display_details[#display_details-1].height > 60 then

					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height +15
				end

			end


			if Details.TicklerType == 1 then

				display_details[#display_details].text = EventCalender.Appointment_With


					if display_details[#display_details].text == EventCalender.Appointment_With then

					    display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+5

				    end

			elseif Details.TicklerType == 2 then

				display_details[#display_details].text = EventCalender.Call_With

			elseif Details.TicklerType == 3 then

				display_details[#display_details].text = EventCalender.Hostess

			elseif Details.TicklerType == 4 then

				display_details[#display_details].text = EventCalender.Linked_to


			end

			scrollView:insert( display_details[#display_details] )


			local name

			if temp.FirstName  ~= nil then
				name = temp.FirstName.." "..temp.LastName
			else
				name = temp.LastName
			end

			display_details[#display_details+1] = display.newText(name,0,0,180,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
			display_details[#display_details].x=W/2-46
			display_details[#display_details].y=display_details[#display_details-1].y
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].id="app_with"
			scrollView:insert( display_details[#display_details] )


		end


		------------------



		if Details.TicklerType ~= 4  then

		----Purpose-------

		if Details.AppointmentPurpose ~= nil then

			display_details[#display_details+1] = display.newText(EventCalender.Purpose,0,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
			display_details[#display_details].x=leftAllign+6
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+21
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			scrollView:insert( display_details[#display_details] )


			if display_details[#display_details-1].id == "Description" then

				if display_details[#display_details-1].height > 60 then

					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
				end

			end


			display_details[#display_details+1] = display.newText(getPurpose(purpose_enum[Details.AppointmentPurpose+1]),0,0,150,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
			display_details[#display_details].x=W/2-46;display_details[#display_details].y=display_details[#display_details-1].y
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].id="Purpose"
			scrollView:insert( display_details[#display_details] )

	   end


	end
		------------------



		----Priority------

		if Details.Priority ~= nil then

			display_details[#display_details+1] = display.newText(EventCalender.Priority,0,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
			display_details[#display_details].x=leftAllign+6
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+21
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			scrollView:insert( display_details[#display_details] )


			if display_details[#display_details-1].id == "Description" then

				if display_details[#display_details-1].height > 60 then

					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
				end

			end


			display_details[#display_details+1] = display.newText(prority_enum[Details.Priority+1],0,0,180,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
			display_details[#display_details].x=W/2-46;display_details[#display_details].y=display_details[#display_details-1].y
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].id="Priority"
			scrollView:insert( display_details[#display_details] )
			
		end
		------------------

		

		----Attachment----

		if Details.AttachmentName ~= nil then

			display_details[#display_details+1] = display.newText(EventCalender.Attachment,0,0,"Roboto-Regular",14)
			display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
			display_details[#display_details].x=leftAllign+6
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+21
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			scrollView:insert( display_details[#display_details] )


			if display_details[#display_details-1].id == "Description" then

				if display_details[#display_details-1].height > 60 then

					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
				end

			end


			display_details[#display_details+1] = display.newText(Details.AttachmentName,0,0,180,0,"Roboto-Regular",14)
			local AttachName
			if display_details[#display_details].width > 35 then

				AttachName = Details.AttachmentName:sub( 1,12 ).."..."..Details.AttachmentName:sub( Details.AttachmentName:len()-4,Details.AttachmentName:len() )
				
			else

				AttachName = Details.AttachmentName
				
			end

			display_details[#display_details].text = AttachName
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.blue))
			display_details[#display_details].x=W/2-46;display_details[#display_details].y=display_details[#display_details-1].y
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].value = Details.MuUnitBuzzAttachmentPath
			display_details[#display_details].id="Attachment"
			scrollView:insert( display_details[#display_details] )
			display_details[#display_details]:addEventListener("touch",AttachmentDownload)
			

			sample = display.newText(AttachName,0,0,"Roboto-Regular",14)
			sample.isVisible=false

			local line = display.newLine(  display_details[#display_details].x, display_details[#display_details].y+15, display_details[#display_details].x+sample.contentWidth, display_details[#display_details].y+15  )
			line:setStrokeColor( Utils.convertHexToRGB(color.blue) )
			line.strokeWidth = 1
			scrollView:insert( line )
		end
		------------------

		-- display_details[#display_details]:addEventListener("touch",AttachmentDownload)



		display_details[#display_details+1] = display.newText(EventCalender.Attachment,0,0,"Roboto-Regular",14)
		display_details[#display_details]:setFillColor(Utility.convertHexToRGB(color.LtyGray))
		display_details[#display_details].x=leftAllign+6
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+21
		display_details[#display_details].anchorX=0


		if display_details[#display_details-1].id == "Description" then

			if display_details[#display_details-1].height > 60 then

				display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
			end

		end
		
		scrollView:insert( display_details[#display_details] )
		display_details[#display_details].isVisible=false
	end

	Webservice.Get_TicklerEventsById(detail_value.id,get_ticklereventByid)

end

end	

MainGroup:insert(sceneGroup)

end





function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		if status == "edit" then
			event.parent:resumeGame(status,Details)

		elseif status == "deleted" then
			event.parent:resumeGame(status,Details)
		else
			status="back"
			event.parent:resumeGame(status)
		end

	elseif phase == "did" then
		
		menuBtn:removeEventListener("touch",menuTouch)
		--BgText:removeEventListener("touch",menuTouch)
		menuTouch_s:removeEventListener("touch",menuTouch)

		Runtime:removeEventListener( "key", onKeyEventDetail )

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