----------------------------------------------------------------------------------
--
-- eventCal_DetailPage
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")
local Utility = require( "Utils.Utility" )
local Applicationconfig = require("Utils.ApplicationConfig")
local widget = require( "widget" )

local status = "normal"
--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,PageTitle,titleBar,titleBar_icon,titleBar_text

local menuBtn

local detail_value = {}

local BackFlag = false

local parantValue

local TicklerId,CalendarId,CalendarName,id

local RecentTab_Topvalue = 105

local prority_enum = {EventCalender.High,EventCalender.Normal,EventCalender.Low}

local purpose_enum = {"FACIAL","ON_THE_GO","DOUBLE_FACIAL","CLASS","TEAM_BUILDING","TRAINING","SHOW","MEETING","FOLLOW_UP","CUSTOMER_SERVICE","TWO_DAY_FOLLOWUP","TWO_WEEK_FOLLOWUP","TWO_MONTH_FOLLOWUP","OTHER","COLOR_APPT","FAMILY","BOOKING","INIT_APPT","RESCHEDULE","FULLCIRCLE"}

local deleteEvent_icon

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
			local function onComplete( event )  
				if event.action == "clicked" then

				    local i = event.index
				    if i == 1 then

				    	Webservice.DeleteTicklerEvent(TicklerId,CalendarId,CalendarName,id,get_DeleteTicklerEvent)
				       
				    elseif i == 2 then
				    	--Details

				    	
				    end
				end
			end

			if detail_value.IsRecurrence == true then 

				if event.target.id == "delete" then

					local alert = native.showAlert(EventCalender.PageTitle, "You can delete this Recurring Event only on the web" , { CommonWords.ok } )

				elseif event.target.id == "edit" then
					
					local alert = native.showAlert(EventCalender.PageTitle, "You can edit this Recurring Event only on the web" , { CommonWords.ok } )
				end

			else

				if event.target.id == "delete" then

						local alert = native.showAlert(EventCalender.DeleteTitle, EventCalender.DeleteAlert , { CommonWords.ok , CommonWords.cancel }, onComplete )

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

		title_bg = display.newRect(sceneGroup,0,0,W,30)
		title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
		title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )


		title = display.newText(sceneGroup,EventCalender.PageTitle,0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=5;title.y = title_bg.y
		title:setFillColor(0)



		titleBar = display.newRect(sceneGroup,W/2,title_bg.y+title_bg.contentHeight/2,W,30)
		titleBar.anchorY=0
		titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
		titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+10
		titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
		titleBar_icon.anchorY=0

		titleBar_text = display.newText(sceneGroup," ",0,0,native.systemFont,0)
		titleBar_text.x=titleBar_icon.x+titleBar_icon.contentWidth+5
		titleBar_text.y=titleBar.y+titleBar.contentHeight/2-titleBar_text.contentHeight/2
		titleBar_text.anchorX=0;titleBar_text.anchorY=0
		Utils.CssforTextView(titleBar_text,sp_subHeader)
		MainGroup:insert(sceneGroup)

		deleteEvent_icon = display.newImageRect( sceneGroup, "res/assert/delete.png", 20,16 )
		deleteEvent_icon.x=titleBar.x+titleBar.contentWidth/2-20
		deleteEvent_icon.y=titleBar.y+titleBar.contentHeight/2
		deleteEvent_icon.id="delete"
		deleteEvent_icon:addEventListener( "touch", EditOption )

		editEvent_icon = display.newImageRect( sceneGroup, "res/assert/edit.png", 20,20 )
		editEvent_icon.x=titleBar.x+titleBar.contentWidth/2-45
		editEvent_icon.y=titleBar.y+titleBar.contentHeight/2
		editEvent_icon.id="edit"
		editEvent_icon:addEventListener( "touch", EditOption )

		if not IsOwner then

			deleteEvent_icon.isVisible = false
			editEvent_icon.isVisible = false

		end

		end



		function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase

		parantValue = event

		if phase == "will" then

		scrollView = widget.newScrollView
		{
		top = RecentTab_Topvalue,
		left = 0,
		width = W,
		height =H-105,
		hideBackground = true,
		isBounceEnabled=false,
		horizontalScrollingDisabled = false,
		verticalScrollingDisabled = false,
		hideScrollBar=true,

		-- listener = scrollListener
		}
		scrollView.anchorY=0
		scrollView.y=RecentTab_Topvalue
		--scrollView.anchorX=0

		sceneGroup:insert(scrollView)


		elseif phase == "did" then

		titleBar_icon:addEventListener("touch",closeDetails)
		titleBar_text:addEventListener("touch",closeDetails)
		Background:addEventListener("touch",bgTouch)
		menuBtn:addEventListener("touch",menuTouch)
		menuTouch_s:addEventListener("touch",menuTouch)

		BgText:addEventListener("touch",menuTouch)

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

		titleBar_text.text = Details.title

			if titleBar_text.text:len() > 25 then

					titleBar_text.text = titleBar_text.text:sub(1,25).."..."

				end


		display_details[#display_details+1] = display.newText(EventCalender.When,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAllign;display_details[#display_details].y=titleBar.y-45
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
		display_details[#display_details] = display.newText(value,0,0,220,0,sp_fieldValue.Font_Weight,sp_fieldValue.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_fieldValue.Text_Color))
		display_details[#display_details].x=W/2-28;display_details[#display_details].y=titleBar.y-45
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

		display_details[#display_details+1] = display.newText(time,0,0,210,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-28;display_details[#display_details].y=display_details[#display_details-1].y+16
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="time"
		scrollView:insert( display_details[#display_details] )






		--------------------

		----Where----
		 if Details.TicklerType ~= 4 then

		if Details.Location ~= nil or Details.PhoneNumber ~= nil or Details.Location ~= "" then

		display_details[#display_details+1] = display.newText(EventCalender.Where,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAllign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
		display_details[#display_details].anchorX=0
		scrollView:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText("",0,0,180,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-28;display_details[#display_details].y=display_details[#display_details-1].y-5
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

		display_details[#display_details+1] = display.newText(EventCalender.Description,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAllign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
		display_details[#display_details].anchorX=0
		scrollView:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(Details.Description,0,0,W-30,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=leftAllign;display_details[#display_details].y=display_details[#display_details-1].y+15
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="Description"
		scrollView:insert( display_details[#display_details] )
		end
		------------------


		----With----

		if Details.Contact ~= nil then

		local temp = Details.Contact

		display_details[#display_details+1] = display.newText(EventCalender.Appointment_With,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAllign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+20
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0

		if display_details[#display_details-1].id == "Description" then

			if display_details[#display_details-1].height > 60 then

				display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
			end

		end


		if Details.TicklerType == 1 then

			display_details[#display_details].text = EventCalender.Appointment_With

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

		display_details[#display_details+1] = display.newText(name,0,0,180,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-28
		display_details[#display_details].y=display_details[#display_details-1].y
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="app_with"
		scrollView:insert( display_details[#display_details] )


		end
		------------------

		if Details.TicklerType ~= 4 then


		----Purpose----

		if Details.AppointmentPurpose ~= nil then

			display_details[#display_details+1] = display.newText(EventCalender.Purpose,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
			display_details[#display_details].x=leftAllign
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+20
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			scrollView:insert( display_details[#display_details] )


		if display_details[#display_details-1].id == "Description" then

			if display_details[#display_details-1].height > 60 then

				display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
			end

		end




			display_details[#display_details+1] = display.newText(getPurpose(purpose_enum[Details.AppointmentPurpose+1]),0,0,150,0,native.systemFont,14)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
			display_details[#display_details].x=W/2-28;display_details[#display_details].y=display_details[#display_details-1].y
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].id="Purpose"
			scrollView:insert( display_details[#display_details] )


		end

		end
		------------------

		----Priority----

		if Details.Priority ~= nil then

		display_details[#display_details+1] = display.newText(EventCalender.Priority,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAllign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+20
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		scrollView:insert( display_details[#display_details] )


		if display_details[#display_details-1].id == "Description" then

			if display_details[#display_details-1].height > 60 then

				display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
			end

		end


		display_details[#display_details+1] = display.newText(prority_enum[Details.Priority+1],0,0,180,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-28;display_details[#display_details].y=display_details[#display_details-1].y
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="Priority"
		scrollView:insert( display_details[#display_details] )
		
		end
		------------------

		----Attachment----

		if Details.AttachmentName ~= nil then

			display_details[#display_details+1] = display.newText(EventCalender.Attachment,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
			display_details[#display_details].x=leftAllign
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+20
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			scrollView:insert( display_details[#display_details] )


		if display_details[#display_details-1].id == "Description" then

			if display_details[#display_details-1].height > 60 then

				display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height - 15
			end

		end


			display_details[#display_details+1] = display.newText(Details.AttachmentName,0,0,180,0,native.systemFont,14)
			local AttachName
			if display_details[#display_details].width > 35 then

				AttachName = Details.AttachmentName:sub( 1,12 ).."..."..Details.AttachmentName:sub( Details.AttachmentName:len()-4,Details.AttachmentName:len() )
			
			else

				AttachName = Details.AttachmentName
				
			end

			display_details[#display_details].text = AttachName
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.blue))
			display_details[#display_details].x=W/2-28;display_details[#display_details].y=display_details[#display_details-1].y
			display_details[#display_details].anchorX=0
			display_details[#display_details].anchorY=0
			display_details[#display_details].value = Details.MuUnitBuzzAttachmentPath
			display_details[#display_details].id="Attachment"
			scrollView:insert( display_details[#display_details] )
			display_details[#display_details]:addEventListener("touch",AttachmentDownload)
			

			sample = display.newText(AttachName,0,0,native.systemFont,14)
			sample.isVisible=false

			local line = display.newLine(  display_details[#display_details].x, display_details[#display_details].y+15, display_details[#display_details].x+sample.contentWidth, display_details[#display_details].y+15  )
			line:setStrokeColor( Utils.convertHexToRGB(color.blue) )
			line.strokeWidth = 1
			scrollView:insert( line )
		end
		------------------



			display_details[#display_details+1] = display.newText(EventCalender.Attachment,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
			display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
			display_details[#display_details].x=leftAllign
			display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].height+20
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
		BgText:removeEventListener("touch",menuTouch)
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