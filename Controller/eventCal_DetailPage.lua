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



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,PageTitle,titleBar,titleBar_icon,titleBar_text

local menuBtn

local detail_value = {}

local prority_enum = {"HIGH","NORMAL","LOW"}
local purpose_enum = {"FACIAL","ON_THE_GO","DOUBLE_FACIAL","CLASS","TEAM_BUILDING","TRAINING","SHOW","MEETING","FOLLOW_UP","CUSTOMER_SERVICE","TWO_DAY_FOLLOWUP","TWO_WEEK_FOLLOWUP","TWO_MONTH_FOLLOWUP","OTHER","COLOR_APPT","FAMILY","BOOKING","INIT_APPT","RESCHEDULE","FULLCIRCLE"}


openPage="eventCalenderPage"

local display_details = {}

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

	PageTitle = display.newText(sceneGroup,"Event calendar",0,0,native.systemFont,18)
	PageTitle.anchorX = 0 ;PageTitle.anchorY=0
	PageTitle.x=8;PageTitle.y = tabBar.y+tabBar.contentHeight/2+10
	PageTitle:setFillColor(0)

	titleBar = display.newRect(sceneGroup,W/2,PageTitle.y+PageTitle.contentHeight+5,W,30)
	titleBar.anchorY=0
	titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
	titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+10
	titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
	titleBar_icon.anchorY=0

	titleBar_text = display.newText(sceneGroup," ",0,0,native.systemFont,18)
	titleBar_text.x=titleBar_icon.x+titleBar_icon.contentWidth+5
	titleBar_text.y=titleBar.y+titleBar.contentHeight/2-titleBar_text.contentHeight/2
	titleBar_text.anchorX=0;titleBar_text.anchorY=0

	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			titleBar_icon:addEventListener("touch",closeDetails)
			titleBar_text:addEventListener("touch",closeDetails)
			Background:addEventListener("touch",bgTouch)
			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)

			if event.params then

				detail_value = event.params.details

				print(json.encode(detail_value))

				local timeGMT = makeTimeStamp( detail_value.date )

				function get_ticklereventByid(response)

					print("123")
					Details=response

					----When----

					titleBar_text.text = Details.title


					display_details[#display_details+1] = display.newText(sceneGroup,"When",0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15;display_details[#display_details].y=titleBar.y+titleBar.contentHeight+30
					display_details[#display_details].anchorX=0


					display_details[#display_details+1] = display_details[#display_details+1]
					display_details[#display_details] = display.newText(sceneGroup,os.date( "%B %d, %Y" , timeGMT ),0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=titleBar.y+titleBar.contentHeight+30
					display_details[#display_details].anchorX=0
					display_details[#display_details].id="when"

				------------------

				----Where----

				if Details.Location ~= nil then

					display_details[#display_details+1] = display.newText(sceneGroup,"Where",0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0


					display_details[#display_details+1] = display.newText(sceneGroup,Details.Location,0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y
					display_details[#display_details].anchorX=0
					display_details[#display_details].id="where"

				end
				------------------

				----Description----

				if Details.Description ~= nil then

					display_details[#display_details+1] = display.newText(sceneGroup,"Description",0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0


					display_details[#display_details+1] = display.newText(sceneGroup,Details.Description,0,0,W-50,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15;display_details[#display_details].y=display_details[#display_details-1].y+15
					display_details[#display_details].anchorX=0
					display_details[#display_details].anchorY=0
					display_details[#display_details].id="Description"
				end
				------------------


				----With----

				if Details.Contact ~= nil then

					local temp = Details.Contact

					display_details[#display_details+1] = display.newText(sceneGroup,"Appointment With",0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0


					display_details[#display_details+1] = display.newText(sceneGroup,temp.FirstName.." "..temp.LastName,0,0,W-50,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
					display_details[#display_details].anchorX=0
					display_details[#display_details].anchorY=0
					display_details[#display_details].id="Description"
				end
				------------------

					----Purpose----

					if Details.AppointmentPurpose ~= nil then

						display_details[#display_details+1] = display.newText(sceneGroup,"Purpose",0,0,native.systemFont,16)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
						display_details[#display_details].x=15
						display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
						display_details[#display_details].anchorX=0


						display_details[#display_details+1] = display.newText(sceneGroup,Details.AppointmentPurpose,0,0,W-50,0,native.systemFont,16)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
						display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
						display_details[#display_details].anchorX=0
						display_details[#display_details].anchorY=0
						display_details[#display_details].id="Purpose"
					end
				------------------

				----Priority----

				if Details.Priority ~= nil then

					display_details[#display_details+1] = display.newText(sceneGroup,"Priority",0,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=15
					display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
					display_details[#display_details].anchorX=0


					display_details[#display_details+1] = display.newText(sceneGroup,prority_enum[Details.Priority+1],0,0,W-50,0,native.systemFont,16)
					display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
					display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
					display_details[#display_details].anchorX=0
					display_details[#display_details].anchorY=0
					display_details[#display_details].id="Priority"
				end
				------------------

					----Attachment----

					if Details.AttachmentName ~= nil then

						display_details[#display_details+1] = display.newText(sceneGroup,"Attachment",0,0,native.systemFont,16)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
						display_details[#display_details].x=15
						display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
						display_details[#display_details].anchorX=0


						display_details[#display_details+1] = display.newText(sceneGroup,Details.AttachmentName,0,0,200,0,native.systemFont,16)
						display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.blue))
						display_details[#display_details].x=W/2-15;display_details[#display_details].y=display_details[#display_details-1].y-8
						display_details[#display_details].anchorX=0
						display_details[#display_details].anchorY=0
						display_details[#display_details].value = Details.MuUnitBuzzAttachmentPath
						display_details[#display_details].id="Attachment"
						display_details[#display_details]:addEventListener("touch",AttachmentDownload)
					end
				------------------
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