----------------------------------------------------------------------------------
--
-- careerPathDetailPage.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )




--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,pageTitle,changeList_order_icon

local menuBtn,contactId

local Details = {}

local Details_Display = {}

openPage="careerPathPage"

local leftPadding = 10

local myMap,map_close

local Image,below_tab,below_mail,below_call,below_map

local mapGroup = display.newGroup()

local phoneNum = ""

local RecentTab_Topvalue

local ProfileImage,careerDetail_scrollview

--------------------------------------------------


-----------------Function-------------------------

makeTimeStamp_career = function ( dateString )

	local pattern = "(%d+)%/(%d+)%/(%d+)T(%d+):(%d+):(%d+)"

	local month, day, year , hour, minute, seconds, tzoffset, offsethour, offsetmin =
	dateString:match(pattern)
	local timestamp = os.time( {year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false} )

	return timestamp;
end


local function bgTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
	end

	return true

end


local function observableScroll( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then 

    	if event.direction ~= nil then

    	-- print("Direction : "..event.direction)

    	 	if event.direction == "up" then

    	 		if TrasitionBar.yScale >= 0.2 then


    	 			event.target:scrollTo( "top" , { time=0})

    	 			--display.getCurrentStage():setFocus(nil)

    	 			--ProfileImage.yScale=ProfileImage.yScale-0.05

    	 			TrasitionBar.yScale=TrasitionBar.yScale-0.05

    	 			TrasitionBar.alpha=TrasitionBar.alpha+0.08


    	 			careerDetail_scrollview.y=TrasitionBar.y+TrasitionBar.contentHeight

    	 			local temp = RecentTab_Topvalue - careerDetail_scrollview.y

    	 			print("Height : "..temp)

  	 			

    	 		else


    	 		end

    	 	elseif event.direction == "down" then

    	 			if TrasitionBar.yScale <= 1 then


    	 			event.target:scrollTo( "top" , { time=0})

    	 			--display.getCurrentStage():setFocus(nil)

    	 			--ProfileImage.yScale=ProfileImage.yScale+0.05


    	 			careerDetail_scrollview.y=TrasitionBar.y+TrasitionBar.contentHeight

    	 			TrasitionBar.yScale=TrasitionBar.yScale+0.05

    	 			TrasitionBar.alpha=TrasitionBar.alpha-0.08

    	 			local temp = RecentTab_Topvalue - careerDetail_scrollview.y

    	 			print("Height : "..temp)

  	 			

    	 		else


    	 		end

    	 	end


    	end


  

    elseif ( phase == "ended" ) then print( "Scroll view was released" )
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




local function phoneCallFunction( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		system.openURL( "tel:"..event.target.id )
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

local function MapShowing( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		print("MapShowing")

		if event.target.id == "close" then
			mapGroup.isVisible=false
			myMap.isVisible=false
		else
			mapGroup.isVisible=true
			myMap.isVisible=true
		end
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


	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then


				contactId = event.params.contactId

	

			--contactId= "321239"
			function get_avtiveTeammemberDetails( response)

				Details = response
						

				titleBar = display.newRect(sceneGroup,W/2,tabBar.y+tabBar.contentHeight/2,W,30)
				titleBar.anchorY=0
				titleBar.isVisible=false

				titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


								

				if Details.ImagePath ~= nil then
					ProfileImage = display.newImage(sceneGroup,"career"..contactId..".png",system.TemporaryDirectory)

				end

				if not ProfileImage then
					ProfileImage = display.newImageRect(sceneGroup,"res/assert/detail_defalut.jpg",80,80)
				end

				ProfileImage.width = W;ProfileImage.height = 180
				ProfileImage.x=W/2;ProfileImage.y=titleBar.y
				ProfileImage.anchorY=0

				TrasitionBar = display.newRect(sceneGroup,ProfileImage.x,ProfileImage.y,ProfileImage.width,ProfileImage.height)
				TrasitionBar.anchorY=0
				TrasitionBar.alpha=0
				TrasitionBar:setFillColor(Utils.convertHexToRGB("#B6B6B6"))

				titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
				titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+15
				titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
				titleBar_icon.anchorY=0
				titleBar_icon:addEventListener("touch",closeDetails)




				if(Details.FirstName ~= nil ) then

					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.FirstName.." "..Details.LastName,0,0,native.systemFont,18)

				else
					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.LastName,0,0,native.systemFont,18)
				end
				Details_Display[#Details_Display].x=titleBar_icon.x+titleBar_icon.contentWidth+5
				Details_Display[#Details_Display].y=titleBar.y+titleBar.contentHeight/2-Details_Display[#Details_Display].contentHeight/2
				Details_Display[#Details_Display].anchorX=0;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].name = "userName"
				Details_Display[#Details_Display]:addEventListener("touch",closeDetails)



				RecentTab_Topvalue = ProfileImage.y+ProfileImage.contentHeight

					careerDetail_scrollview = widget.newScrollView
					{
					top = 0,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue+ProfileImage.contentHeight,
					--hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
					listener = observableScroll
				}

				--spinner_show()
				careerDetail_scrollview.y=RecentTab_Topvalue
				careerDetail_scrollview.x=W/2
				careerDetail_scrollview.anchorY=0
				sceneGroup:insert(careerDetail_scrollview)



				if(Details.DateOfBirth ~= nil) then

					local birthday_icon = display.newImageRect("res/assert/birthday.png",22,24)
					birthday_icon.anchorX = 0 ;birthday_icon.anchorY=0
					birthday_icon.x=leftPadding
					birthday_icon.y=20
					careerDetail_scrollview:insert( birthday_icon )

					local timeGMT = makeTimeStamp_career(Details.DateOfBirth.."T00:00:00")

					Details_Display[#Details_Display+1] = display.newText(os.date( "%B %d, %Y" , timeGMT ),0,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=birthday_icon.x+birthday_icon.contentWidth+5
					Details_Display[#Details_Display].y = birthday_icon.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].name = "birthDay"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.AnniversariesDate ~= nil) then

					local anniversari_icon = display.newImageRect("res/assert/anniversary.png",22,18)
					anniversari_icon.anchorX = 0 ;anniversari_icon.anchorY=0
					anniversari_icon.x=leftPadding
					anniversari_icon.y=Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+15
					careerDetail_scrollview:insert( anniversari_icon )

					local timeGMT = makeTimeStamp_career(Details.AnniversariesDate.."T00:00:00")

					Details_Display[#Details_Display+1] = display.newText(os.date( "%B %d, %Y" , timeGMT ),0,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=anniversari_icon.x+anniversari_icon.contentWidth+5
					Details_Display[#Details_Display].y = anniversari_icon.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].name = "Anniversarie"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end


			
				-----------Details_Display---------

				if(Details.RecruitedDate ~= nil) then

					local RecruitedDate = display.newText("When Recruited",0,0,150,0,native.systemFont,16)
					RecruitedDate.anchorX = 0 ;RecruitedDate.anchorY=0
					RecruitedDate:setFillColor(0)
					RecruitedDate.x=leftPadding
					RecruitedDate.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( RecruitedDate )



					local timeGMT = Utils.makeTimeStamp(Details.RecruitedDate)

					Details_Display[#Details_Display+1] = display.newText(os.date( "%B %d, %Y" , timeGMT ),0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].y = RecruitedDate.y 
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].name = "RecruitedDate"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.ConsultantNumber ~= nil) then

					local ConsultantNumber = display.newText("Consultant No",0,0,150,0,native.systemFont,16)
					ConsultantNumber.anchorX = 0 ;ConsultantNumber.anchorY=0
					ConsultantNumber:setFillColor(0)
					ConsultantNumber.x=leftPadding
					ConsultantNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( ConsultantNumber )

					Details_Display[#Details_Display+1] = display.newText(Details.ConsultantNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = ConsultantNumber.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "ConsultantNumber"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.UnitNumber ~= nil) then

					
					local UnitNumber = display.newText("Unit No",0,0,150,0,native.systemFont,16)
					UnitNumber.anchorX = 0 ;UnitNumber.anchorY=0
					UnitNumber:setFillColor(0)
					UnitNumber.x=leftPadding
					UnitNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( UnitNumber )

					Details_Display[#Details_Display+1] = display.newText(Details.UnitNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = UnitNumber.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "UnitNumber"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.RecruiterNumber ~= nil) then

					local RecruiterNumber = display.newText("Recruiter No",0,0,150,0,native.systemFont,16)
					RecruiterNumber.anchorX = 0 ;RecruiterNumber.anchorY=0
					RecruiterNumber:setFillColor(0)
					RecruiterNumber.x=leftPadding
					RecruiterNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( RecruiterNumber )


					Details_Display[#Details_Display+1] = display.newText(Details.RecruiterNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruiterNumber.y 
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "RecruiterNumber"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.RecruiterName ~= nil) then

					local RecruiterName = display.newText("Recruiter Name",0,0,150,0,native.systemFont,16)
					RecruiterName.anchorX = 0 ;RecruiterName.anchorY=0
					RecruiterName:setFillColor(0)
					RecruiterName.x=leftPadding
					RecruiterName.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( RecruiterName )

					Details_Display[#Details_Display+1] = display.newText(Details.RecruiterName,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruiterName.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "RecruiterName"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.CareerProgress ~= nil) then

					local CareerProgress = display.newText("Career Progress",0,0,150,0,native.systemFont,16)
					CareerProgress.anchorX = 0 ;CareerProgress.anchorY=0
					CareerProgress:setFillColor(0)
					CareerProgress.x=leftPadding
					CareerProgress.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( CareerProgress )


					Details_Display[#Details_Display+1] = display.newText(Details.CareerProgress,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = CareerProgress.y 
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "CareerProgress"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end


				Details_Display[#Details_Display+1] = display.newRect( W/2, Details_Display[#Details_Display].y+30, W, 5)
				Details_Display[#Details_Display].isVisible=false
				careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				

				below_tab = display.newRect(sceneGroup,W/2,H-30,W,30)
				below_tab.anchorY=0

				below_mail = display.newImageRect(sceneGroup,"res/assert/mail.png",33/2,25/2)
				below_mail.x=below_tab.x-90
				below_mail.y=below_tab.y+below_tab.contentHeight/2

				
				if Details.HomePhoneNumber ~= nil then
					phoneNum = Details.HomePhoneNumber 
				end
				if Details.WorkPhoneNumber ~= nil then
					phoneNum = Details.WorkPhoneNumber 
				end
				if Details.OtherPhoneNumber ~= nil then
					phoneNum = Details.OtherPhoneNumber 
				end

				if phoneNum ~= "" then
					below_call = display.newImageRect(sceneGroup,"res/assert/phone.png",32/2,32/2)
					below_call.x=below_tab.x
					below_call.y=below_tab.y+below_tab.contentHeight/2
					below_call.id=phoneNum
					below_call:addEventListener("touch",phoneCallFunction)
				end	

				if Details.ContactsAddress ~= nil then

					below_map = display.newImageRect(sceneGroup,"res/assert/map.png",20/2,32/2)
					below_map.x=below_tab.x+90
					below_map.y=below_tab.y+below_tab.contentHeight/2
					below_map.id = "map"
					below_map:addEventListener("touch",MapShowing)



					if environment == "simulator" then
						myMap = display.newRect(mapGroup,20, 20, 280, 300)
						myMap.x = display.contentCenterX
						myMap.y = display.contentCenterY+50
					else

						myMap = native.newMapView( display.contentCenterX, display.contentCenterY+50, 280, 300 )
						mapGroup:insert(myMap)
						myMap.isVisible=false

						local function locationHandler( event )

							if ( event.isError ) then
								print( "Map Error: " .. event.errorMessage )
							else
								print( "The specified string is at: " .. event.latitude .. "," .. event.longitude )
								myMap:setCenter( event.latitude, event.longitude )

								local options = 
								{ 
								title = "Location", 
								subtitle = "Loc", 
								imageFile =  "res/assert/map.png",
							}
							local result, errorMessage = myMap:addMarker( event.latitude, event.longitude , options )
						end

					end

					myMap:requestLocation( "1900 Embarcadero Road, Palo Alto, CA", locationHandler )
				end

				map_close = display.newImageRect(mapGroup,"res/assert/psw.png",30,30)
				map_close.x=myMap.x+myMap.contentWidth/2+10
				map_close.y=myMap.y-myMap.contentHeight/2-10
				map_close.id="close"
				map_close:addEventListener("touch",MapShowing)

				sceneGroup:insert(mapGroup)
				mapGroup.isVisible=false
			end


			Background:addEventListener("touch",bgTouch)
			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)


		end	

		MainGroup:insert(sceneGroup)

			Webservice.GET_ACTIVE_TEAMMEMBERDETAILS(contactId,get_avtiveTeammemberDetails)

	end

	

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		if myMap then myMap:removeSelf();myMap=nil;map_close:removeSelf();map_close=nil end

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