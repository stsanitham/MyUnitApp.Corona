----------------------------------------------------------------------------------
--
-- careerPathDetailPage.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )



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

--------------------------------------------------


-----------------Function-------------------------



local function bgTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
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
				pageTitle = display.newText(sceneGroup,"Career Path",0,0,native.systemFont,18)
				pageTitle.anchorX = 0 ;pageTitle.anchorY=0
				pageTitle.x=leftPadding;pageTitle.y = tabBar.y+tabBar.contentHeight/2+10
				pageTitle:setFillColor(0)

				

				titleBar = display.newRect(sceneGroup,W/2,pageTitle.y+pageTitle.contentHeight+5,W,30)
				titleBar.anchorY=0
				titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

				titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
				titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+10
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

				if(Details.DateOfBirth ~= nil) then

					local birthday_icon = display.newImageRect(sceneGroup,"res/assert/user.png",15,15)
					birthday_icon.anchorX = 0 ;birthday_icon.anchorY=0
					birthday_icon.x=25
					birthday_icon.y=titleBar.y+titleBar.contentHeight+10

					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.DateOfBirth,0,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=birthday_icon.x+birthday_icon.contentWidth+5
					Details_Display[#Details_Display].y = birthday_icon.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].name = "birthDay"
				end

				if(Details.AnniversariesDate ~= nil) then

					local anniversari_icon = display.newImageRect(sceneGroup,"res/assert/user.png",15,15)
					anniversari_icon.anchorX = 0 ;anniversari_icon.anchorY=0
					anniversari_icon.x=Details_Display[#Details_Display].x-anniversari_icon.contentWidth-5
					anniversari_icon.y=Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+15


					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.AnniversariesDate,0,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=anniversari_icon.x+anniversari_icon.contentWidth+5
					Details_Display[#Details_Display].y = anniversari_icon.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].name = "Anniversarie"
				end
				if(Details.RecruitedDate ~= nil) then

					local RecruitedDate = display.newText(sceneGroup,"When Recruited",0,0,150,0,native.systemFont,16)
					RecruitedDate.anchorX = 0 ;RecruitedDate.anchorY=0
					RecruitedDate:setFillColor(0)
					RecruitedDate.x=leftPadding
					RecruitedDate.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+30

					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.RecruitedDate,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].y = RecruitedDate.y 
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].name = "RecruitedDate"
				end

				if(Details.ConsultantNumber ~= nil) then

					local ConsultantNumber = display.newText(sceneGroup,"Consultant No",0,0,150,0,native.systemFont,16)
					ConsultantNumber.anchorX = 0 ;ConsultantNumber.anchorY=0
					ConsultantNumber:setFillColor(0)
					ConsultantNumber.x=leftPadding
					ConsultantNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10

					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.ConsultantNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = ConsultantNumber.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "ConsultantNumber"
				end

				if(Details.UnitNumber ~= nil) then

					
					local UnitNumber = display.newText(sceneGroup,"Unit No",0,0,150,0,native.systemFont,16)
					UnitNumber.anchorX = 0 ;UnitNumber.anchorY=0
					UnitNumber:setFillColor(0)
					UnitNumber.x=leftPadding
					UnitNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10

					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.UnitNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = UnitNumber.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "UnitNumber"
				end

				if(Details.RecruiterNumber ~= nil) then

					local RecruiterNumber = display.newText(sceneGroup,"Recruiter No",0,0,150,0,native.systemFont,16)
					RecruiterNumber.anchorX = 0 ;RecruiterNumber.anchorY=0
					RecruiterNumber:setFillColor(0)
					RecruiterNumber.x=leftPadding
					RecruiterNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10


					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.RecruiterNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruiterNumber.y 
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "RecruiterNumber"
				end

				if(Details.RecruiterName ~= nil) then

					local RecruiterName = display.newText(sceneGroup,"Recruiter Name",0,0,150,0,native.systemFont,16)
					RecruiterName.anchorX = 0 ;RecruiterName.anchorY=0
					RecruiterName:setFillColor(0)
					RecruiterName.x=leftPadding
					RecruiterName.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10

					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.RecruiterName,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruiterName.y
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "RecruiterName"
				end

				if(Details.CareerProgress ~= nil) then

					local CareerProgress = display.newText(sceneGroup,"Career Progress",0,0,150,0,native.systemFont,16)
					CareerProgress.anchorX = 0 ;CareerProgress.anchorY=0
					CareerProgress:setFillColor(0)
					CareerProgress.x=leftPadding
					CareerProgress.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10


					Details_Display[#Details_Display+1] = display.newText(sceneGroup,Details.CareerProgress,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = CareerProgress.y 
					Details_Display[#Details_Display]:setFillColor(0)
					Details_Display[#Details_Display].size = 16
					Details_Display[#Details_Display].name = "CareerProgress"
				end


				if Details.ImagePath ~= nil then
					Image = display.newImage(sceneGroup,"career"..contactId..".png",system.TemporaryDirectory)

				end

				if not Image then
					Image = display.newImageRect(sceneGroup,"res/assert/twitter_placeholder.png",80,80)
				end

				Image.width = 60;Image.height = 60
				Image.x=W/2+100;Image.y=H/2-100


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