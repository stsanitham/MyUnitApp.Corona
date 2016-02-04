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

			elseif event.target.id == "eventname" then

				if EventnameGroup.isVisible == true then

					EventnameGroup.isVisible = false

				else
					EventnameGroup.isVisible = true

				end


				print( "event name" )

			elseif event.target.id == "fromTime" then

				Event_Description.isVisible = false

				function getValue(time)

					Event_from_time.text = time
					Event_Description.isVisible = true

				end
				timePicker.getTimeValue(getValue)

				



			elseif event.target.id == "toTime" then

					Event_Description.isVisible = false

				function getValue(time)

					Event_to_time.text = time
					Event_Description.isVisible = true

				end
				timePicker.getTimeValue(getValue)

			elseif event.target.id == "close_eventname" then

				EventnameGroup.isVisible = false

			end

	end

return true

end




local function Eventname_Render( event )

    local row = event.row

    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth



    local rowTitle = display.newText(row, EventnameArray[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
    rowTitle.anchorX = 0
    rowTitle.x = 5
    rowTitle.y = rowHeight * 0.5


    row.name=EventnameArray[row.index]

end

local function Eventname_Touch( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then



		elseif ( "release" == phase ) then
			
			if EventnameGroup.isVisible == true then

				EventnameGroup.isVisible=false

				SelectEvent.text = row.name

			

			end

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

		titleBar_text = display.newText(sceneGroup,"Add Event",0,0,native.systemFont,0)
		titleBar_text.x=titleBar_icon.x+titleBar_icon.contentWidth+5
		titleBar_text.y=titleBar.y+titleBar.contentHeight/2-titleBar_text.contentHeight/2
		titleBar_text.anchorX=0;titleBar_text.anchorY=0
		titleBar_text.id = "back"
		Utils.CssforTextView(titleBar_text,sp_subHeader)
		MainGroup:insert(sceneGroup)


		--Form Design---

		SelectEvent_bg = display.newRect( W/2, titleBar.y+titleBar.height, W, 28)
		SelectEvent_bg.id="eventname"
		SelectEvent_bg.anchorY=0
		sceneGroup:insert(SelectEvent_bg)

		SelectEvent = display.newText("",SelectEvent_bg.x-SelectEvent_bg.contentWidth/2+15,SelectEvent_bg.y,native.systemFont,14 )
		SelectEvent.text = "Appointment"
		SelectEvent.value = "eventname"
		SelectEvent.id="eventname"
		SelectEvent.alpha=0.7
		SelectEvent:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		SelectEvent.y=SelectEvent_bg.y+SelectEvent_bg.contentHeight/2
		SelectEvent.anchorX=0

		sceneGroup:insert(SelectEvent)

	  	SelectEvent_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
	  	SelectEvent_icon.x=SelectEvent_bg.x+SelectEvent_bg.contentWidth/2-15
	  	SelectEvent_icon.y=SelectEvent.y

		  	---Event name---

	  		EventnameTop_bg = display.newRect( EventnameGroup, SelectEvent_bg.x, H/2-5, 202, 206 )
	  		EventnameTop_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	  		EventnameTop = display.newRect(EventnameGroup,W/2,H/2-160,200,30)
	  		EventnameTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	  		EventnameTop.y=EventnameTop_bg.y-EventnameTop_bg.contentHeight/2+EventnameTop.contentHeight/2

	  		EventnameText = display.newText(EventnameGroup,"Select Event Name",0,0,native.systemFont,16)
	  		EventnameText.x=EventnameTop.x;EventnameText.y=EventnameTop.y


	  		EventnameClose = display.newImageRect(EventnameGroup,"res/assert/cancel.png",19,19)
	  		EventnameClose.x=EventnameTop.x+EventnameTop.contentWidth/2-15;EventnameClose.y=EventnameTop.y
	  		EventnameClose.id="close"

	  		EventnameClose_bg = display.newRect(EventnameGroup,0,0,30,30)
	  		EventnameClose_bg.x=EventnameTop.x+EventnameTop.contentWidth/2-15;EventnameClose_bg.y=EventnameTop.y
	  		EventnameClose_bg.id="close_eventname"
	  		EventnameClose_bg.alpha=0.01


	  	EventnameList = widget.newTableView
	  		{
	  		left = 0,
	  		top = -50,
	  		height = 150,
	  		width = 200,
	  		onRowRender = Eventname_Render,
	  		onRowTouch = Eventname_Touch,
	  		--hideBackground = true,
	  		noLines=true,
	  		hideScrollBar=true,
	  		isBounceEnabled=false,

	  	}

	  	EventnameList.x=SelectEvent_bg.x
	  	EventnameList.y=EventnameTop.y+EventnameTop.height/2
	  	EventnameList.height = 200
	  	EventnameList.width = SelectEvent_bg.contentWidth
	  	EventnameList.anchorY=0
	  	EventnameGroup.isVisible=false

	  	EventnameGroup:insert(EventnameList)
		

	---------------

			for i = 1, #EventnameArray do
				    -- Insert a row into the tableView
				    EventnameList:insertRow{ rowHeight = 35,
				    rowColor = { default={ 1,1,1}, over={ 0, 0, 0, 0.1 } }

				}
			end

		------------------




MainGroup:insert(sceneGroup)
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		eventTime = event.params.details

		print( os.date( "%m/%d/%Y" ,  eventTime )) 

		--------------What---------------

		Event_whatLbl = display.newText(sceneGroup,"What",0,0,W/2,0,native.systemFont,14)
		Event_whatLbl.anchorX=0
		Event_whatLbl.x=10;Event_whatLbl.y = SelectEvent_bg.y+SelectEvent_bg.contentHeight+25
		Event_whatLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))


		Event_what_bg = display.newRect(sceneGroup,W/2,0,W/2+50,30)
		Event_what_bg.anchorX=0
		Event_what_bg.x=W/2-W/3+20;Event_what_bg.y = Event_whatLbl.y
		Event_what_bg:setFillColor(1)


		Event_what = native.newTextField(Event_what_bg.x+5,Event_what_bg.y+5,Event_what_bg.contentWidth,28)
		Event_what.anchorX=0
		Event_what.size=14
		Event_what.placeholder="What"
		Event_what.id="what"
		Event_what.hasBackground = false
		Event_what:setReturnKey( "done" )
		sceneGroup:insert( Event_what)

		-----------------------------------

		--------------Where---------------

		Event_whereLbl = display.newText(sceneGroup,"Where",0,0,W/2,0,native.systemFont,14)
		Event_whereLbl.anchorX=0
		Event_whereLbl.x=10;Event_whereLbl.y = Event_what_bg.y+Event_what_bg.contentHeight+10
		Event_whereLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))


		Event_where_bg = display.newRect(sceneGroup,W/2,0,W/2+50,30)
		Event_where_bg.anchorX=0
		Event_where_bg.x=W/2-W/3+20;Event_where_bg.y = Event_whereLbl.y
		Event_where_bg:setFillColor(1)


		Event_where = native.newTextField(Event_where_bg.x+5,Event_where_bg.y+5,Event_where_bg.contentWidth,28)
		Event_where.anchorX=0
		Event_where.size=14
		Event_where.placeholder="Where"
		Event_where.id="where"
		Event_where.hasBackground = false
		Event_where:setReturnKey( "done" )
		sceneGroup:insert( Event_where)

		-----------------------------------

		--------------From---------------

		Event_fromLbl = display.newText(sceneGroup,"From",0,0,W/2,0,native.systemFont,14)
		Event_fromLbl.anchorX=0
		Event_fromLbl.x=10;Event_fromLbl.y = Event_where_bg.y+Event_where_bg.contentHeight+10
		Event_fromLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))

		Event_from_datebg = display.newRect(sceneGroup,0,0,W/2,30)
		Event_from_datebg.anchorX=0
		Event_from_datebg.x= Event_fromLbl.x+20;Event_from_datebg.y= Event_fromLbl.y+Event_fromLbl.contentHeight+Event_from_datebg.contentHeight/2-5

		Event_from_date = display.newText(sceneGroup,os.date( "%b %d, %Y" ,eventTime ),0,0,native.systemFont,14)
		Event_from_date.anchorX=0
		Event_from_date:setFillColor( 0 )
		Event_from_date.x= Event_from_datebg.x+5;Event_from_date.y= Event_from_datebg.y


		Event_from_timebg = display.newRect(sceneGroup,0,0,80,30)
		Event_from_timebg.anchorX=0
		Event_from_timebg.id="fromTime"
		Event_from_timebg.x= Event_from_datebg.x+Event_from_datebg.contentWidth+5;Event_from_timebg.y= Event_fromLbl.y+Event_fromLbl.contentHeight+Event_from_timebg.contentHeight/2-5

		local TimeZone = Utils.GetWeek(os.date( "%p" , eventTime ))

		Event_from_time = display.newText(sceneGroup,os.date( "%I:%M \n  "..TimeZone , eventTime ),0,0,native.systemFont,14)
		Event_from_time.anchorX=0
		Event_from_time:setFillColor( 0 )
		Event_from_time.x= Event_from_timebg.x+5;Event_from_time.y= Event_from_timebg.y

		-----------------------------------


		--------------To---------------

		Event_toLbl = display.newText(sceneGroup,"To",0,0,W/2,0,native.systemFont,14)
		Event_toLbl.anchorX=0
		Event_toLbl.x=10;Event_toLbl.y = Event_from_datebg.y+Event_from_datebg.contentHeight
		Event_toLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))

		Event_to_datebg = display.newRect(sceneGroup,0,0,W/2,30)
		Event_to_datebg.anchorX=0
		Event_to_datebg.x= Event_toLbl.x+20;Event_to_datebg.y= Event_toLbl.y+Event_toLbl.contentHeight+Event_to_datebg.contentHeight/2-5

		Event_to_date = display.newText(sceneGroup,os.date( "%b %d, %Y" ,eventTime ),0,0,native.systemFont,14)
		Event_to_date.anchorX=0
		Event_to_date:setFillColor( 0 )
		Event_to_date.x= Event_to_datebg.x+5;Event_to_date.y= Event_to_datebg.y


		Event_to_timebg = display.newRect(sceneGroup,0,0,80,30)
		Event_to_timebg.anchorX=0
		Event_to_timebg.id="toTime"
		Event_to_timebg.x= Event_to_datebg.x+Event_to_datebg.contentWidth+5;Event_to_timebg.y= Event_toLbl.y+Event_toLbl.contentHeight+Event_to_timebg.contentHeight/2-5

		local TimeZone = Utils.GetWeek(os.date( "%p" , eventTime ))

		Event_to_time = display.newText(sceneGroup,os.date( "%I:%M \n  "..TimeZone , eventTime ),0,0,native.systemFont,14)
		Event_to_time.anchorX=0
		Event_to_time:setFillColor( 0 )
		Event_to_time.x= Event_to_timebg.x+5;Event_to_time.y= Event_to_timebg.y

		-----------------------------------


		---All Day check box----

		alldaySwitch = widget.newSwitch {
	    left = Event_toLbl.x,
	    top = Event_to_datebg.y+20,
	    style = "checkbox",
	    id = "Checkbox button",
	    onPress = checkboxSwitchListener,
		}
		sceneGroup:insert( alldaySwitch )

		alldaySwitch.width=28;alldaySwitch.height=25

		alldaySwitchtxt = display.newText(sceneGroup,"All Day",0,0,native.systemFont,14)
		alldaySwitchtxt.anchorX=0
		alldaySwitchtxt:setFillColor( 0 )
		alldaySwitchtxt.x= alldaySwitch.x+alldaySwitch.contentWidth/2+5;alldaySwitchtxt.y= alldaySwitch.y

		-------------


		--------------Description---------------

		Event_DescriptionLbl = display.newText(sceneGroup,"Description",0,0,W/2,0,native.systemFont,14)
		Event_DescriptionLbl.anchorX=0
		Event_DescriptionLbl.anchorY=0
		Event_DescriptionLbl.x=10;Event_DescriptionLbl.y = alldaySwitchtxt.y+alldaySwitchtxt.contentHeight+5
		Event_DescriptionLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))


		Event_Description_bg = display.newRect(sceneGroup,W/2,0,W/2+50,90)
		Event_Description_bg.anchorX=0
		Event_Description_bg.anchorY=0
		Event_Description_bg.x=W/2-W/3+35;Event_Description_bg.y = Event_DescriptionLbl.y-Event_DescriptionLbl.contentHeight/2+10
		Event_Description_bg:setFillColor(1)


		Event_Description = native.newTextField(Event_Description_bg.x+5,Event_Description_bg.y,Event_Description_bg.contentWidth,90)
		Event_Description.anchorX=0
		Event_Description.anchorY=0
		Event_Description.size=14
		Event_Description.placeholder="Description"
		Event_Description.id="Description"
		Event_Description.hasBackground = false
		Event_Description:setReturnKey( "done" )
		sceneGroup:insert( Event_Description)

		-----------------------------------


		titleBar_icon:addEventListener("touch",TouchAction)
		titleBar_text:addEventListener("touch",TouchAction)
  		EventnameClose_bg:addEventListener("touch",TouchAction)

  		Event_from_timebg:addEventListener("touch",TouchAction)
		Event_to_timebg:addEventListener("touch",TouchAction)
		--SelectEvent_bg:addEventListener( "touch", TouchAction )
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