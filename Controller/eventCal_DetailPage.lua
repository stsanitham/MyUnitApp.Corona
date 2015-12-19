----------------------------------------------------------------------------------
--
-- eventCal_DetailPage
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")
local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local Applicationconfig = require("Utils.ApplicationConfig")
local widget = require( "widget" )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,PageTitle,titleBar,titleBar_icon,titleBar_text

local menuBtn

local detail_value = {}

local RecentTab_Topvalue = 105

local prority_enum = {"High","Normal","Low"}

local purpose_enum = {"FACIAL","ON_THE_GO","DOUBLE_FACIAL","CLASS","TEAM_BUILDING","TRAINING","SHOW","MEETING","FOLLOW_UP","CUSTOMER_SERVICE","TWO_DAY_FOLLOWUP","TWO_WEEK_FOLLOWUP","TWO_MONTH_FOLLOWUP","OTHER","COLOR_APPT","FAMILY","BOOKING","INIT_APPT","RESCHEDULE","FULLCIRCLE"}



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

	local value = ""
	
	if stringValue == "FACIAL" then

		value = "Facial"

	elseif stringValue == "ON_THE_GO" then

		value = "On the Go"

	elseif stringValue == "DOUBLE_FACIAL" then

		value = "Double Facial"

	elseif stringValue == "CLASS" then

		value = "Class"

	elseif stringValue == "TEAM_BUILDING" then

		value = "Team Building"

	elseif stringValue == "TRAINING" then

		value = "Training"

	elseif stringValue == "SHOW" then

		value = "Show"

	elseif stringValue == "MEETING" then

		value = "Meeting"

	elseif stringValue == "FOLLOW_UP" then

		value = "Follow Up"

	elseif stringValue == "CUSTOMER_SERVICE" then

		value = "Customer Service"

	elseif stringValue == "TWO_DAY_FOLLOWUP" then

		value = "2 Day Follow up"

	elseif stringValue == "TWO_WEEK_FOLLOWUP" then

		value = "2 Week Follow up"

	elseif stringValue == "TWO_MONTH_FOLLOWUP" then

		value = "2 Month Follow up"

	elseif stringValue == "OTHER" then

		value = "Other"

	elseif stringValue == "COLOR_APPT" then

		value = "Color Appointment"

	elseif stringValue == "FAMILY" then

		value = "Family Time"

	elseif stringValue == "BOOKING" then

		value = "Booking"

	elseif stringValue == "INIT_APPT" then

		value = "Initial Appointment"

	elseif stringValue == "RESCHEDULE" then

		value = "Reschedule"

	elseif stringValue == "FULLCIRCLE" then

		value = "Full Circle"


	end





return value
end

--------------------------------------------------


-----------------Function-------------------------

function makeTimeStamp(dateString)
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

local function AttachmentDownload( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		system.openURL( ApplicationConfig.IMAGE_BASE_URL..""..event.target.value )

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


	PageTitle = display.newText(sceneGroup,EventCalender.PageTitle,0,0,sp_header.Font_Weight,sp_header.Font_Size_ios)
	PageTitle.anchorX = 0 ;PageTitle.anchorY=0
	PageTitle.x=8;PageTitle.y = tabBar.y+tabBar.contentHeight/2+3
	PageTitle:setFillColor(Utils.convertHexToRGB(sp_header.Text_Color))

	titleBar = display.newRect(sceneGroup,W/2,PageTitle.y+PageTitle.contentHeight+5,W,30)
	titleBar.anchorY=0
	titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
	titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+10
	titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
	titleBar_icon.anchorY=0

	titleBar_text = display.newText(sceneGroup," ",0,0,sp_subHeader.Font_Weight,sp_subHeader.Font_Size_ios)
	titleBar_text.x=titleBar_icon.x+titleBar_icon.contentWidth+5
	titleBar_text.y=titleBar.y+titleBar.contentHeight/2-titleBar_text.contentHeight/2
	titleBar_text.anchorX=0;titleBar_text.anchorY=0
	titleBar_text:setFillColor(Utils.convertHexToRGB(sp_subHeader.Text_Color))
	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
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

			if event.params then

				detail_value = event.params.details

				print(json.encode(detail_value))

				local timeGMT = makeTimeStamp( detail_value.date )

				function get_ticklereventByid(response)

					Details=response

					----When----

					titleBar_text.text = Details.title


					display_details[#display_details+1] = display.newText(EventCalender.When,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
					display_details[#display_details].x=15;display_details[#display_details].y=titleBar.y-45
					display_details[#display_details].anchorX=0
					scrollView:insert( display_details[#display_details] )

					display_details[#display_details+1] = display_details[#display_details+1]
					display_details[#display_details] = display.newText(os.date( "%B %d, %Y" , timeGMT ),0,0,180,0,sp_fieldValue.Font_Weight,sp_fieldValue.Font_Size_ios)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_fieldValue.Text_Color))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=titleBar.y-45
					display_details[#display_details].anchorX=0
					scrollView:insert( display_details[#display_details] )
					display_details[#display_details].id="when"

				------------------

				-----Timings-----

				

					print("allday false")

					local start_timeGMT = makeTimeStamp( Details.startdate )
					local end_timeGMT = makeTimeStamp( Details.enddate )

					local time 

					if Details.allDay == false then

					time = "( "..os.date( "%I:%M %p" , start_timeGMT ).." to "..os.date( "%I:%M %p" , end_timeGMT ).." )"

					else

						time ="(ALL DAY)"

					end

					display_details[#display_details+1] = display.newText(time,0,0,180,0,native.systemFont,14)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y+20
					display_details[#display_details].anchorX=0
					display_details[#display_details].id="time"
					scrollView:insert( display_details[#display_details] )



				


				--------------------

				----Where----

				if Details.Location ~= nil or Details.PhoneNumber ~= nil then

					display_details[#display_details+1] = display.newText(EventCalender.Where,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0
					scrollView:insert( display_details[#display_details] )


					display_details[#display_details+1] = display.newText("",0,0,180,0,native.systemFont,14)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y
					display_details[#display_details].anchorX=0
					display_details[#display_details].id="where"
					scrollView:insert( display_details[#display_details] )


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
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0
					scrollView:insert( display_details[#display_details] )


					display_details[#display_details+1] = display.newText(Details.Description,0,0,W-30,0,native.systemFont,14)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15;display_details[#display_details].y=display_details[#display_details-1].y+15
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
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0
										display_details[#display_details].anchorY=0



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
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y
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
						display_details[#display_details].x=15
						display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
						display_details[#display_details].anchorX=0
						scrollView:insert( display_details[#display_details] )




						display_details[#display_details+1] = display.newText(getPurpose(purpose_enum[Details.AppointmentPurpose+1]),0,0,150,0,native.systemFont,14)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
						display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
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
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0
					scrollView:insert( display_details[#display_details] )


					display_details[#display_details+1] = display.newText(prority_enum[Details.Priority+1],0,0,180,0,native.systemFont,14)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
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
						display_details[#display_details].x=15
						display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
						display_details[#display_details].anchorX=0
						scrollView:insert( display_details[#display_details] )


						display_details[#display_details+1] = display.newText(Details.AttachmentName,0,0,180,0,native.systemFont,14)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.blue))
						display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
						display_details[#display_details].anchorX=0
						display_details[#display_details].anchorY=0
						display_details[#display_details].value = Details.MuUnitBuzzAttachmentPath
						display_details[#display_details].id="Attachment"
						scrollView:insert( display_details[#display_details] )
						display_details[#display_details]:addEventListener("touch",AttachmentDownload)

						sample = display.newText(Details.AttachmentName,0,0,native.systemFont,14)
						sample.isVisible=false

						local line = display.newLine(  display_details[#display_details].x, display_details[#display_details].y+15, display_details[#display_details].x+sample.contentWidth, display_details[#display_details].y+15  )
						line:setStrokeColor( Utils.convertHexToRGB(color.blue) )
						line.strokeWidth = 1
						scrollView:insert( line )
					end
				------------------

						display_details[#display_details+1] = display.newText(EventCalender.Attachment,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
						display_details[#display_details].x=15
						display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
						display_details[#display_details].anchorX=0
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


		elseif phase == "did" then
			event.parent:resumeGame()
			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)
					menuTouch_s:removeEventListener("touch",menuTouch)


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