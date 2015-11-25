----------------------------------------------------------------------------------
--
-- careerPathDetailPage.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
require( "Parser.GET_ACTIVE_TEAMMEMBERS" )

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,contactId

local Details = {}

local Details_Display = {}

openPage="careerPathPage"

local leftPadding = 10

local mainView = display.newGroup()

--------------------------------------------------


-----------------Function-------------------------
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

		mainView.isVisible=false

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

			if event.params then

				contactId = event.params.contactId
			end

			--contactId= "321239"

			Details = GetActiveTeammemberDetails(contactId)

			Details_Display[#Details_Display+1] = display.newText(mainView,"Career Path",0,0,native.systemFontBold,18)
			Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
			Details_Display[#Details_Display].x=leftPadding;Details_Display[#Details_Display].y = tabBar.y+tabBar.contentHeight/2+10
			Details_Display[#Details_Display]:setFillColor(0)

			if(Details.FirstName ~= nil and Details.LastName ~= nil) then
				Details_Display[#Details_Display+1] = display.newText(mainView,"< "..Details.FirstName.." "..Details.LastName,0,0,native.systemFontBold,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=Details_Display[#Details_Display-1].x
				Details_Display[#Details_Display].y = Details_Display[#Details_Display-1].y+Details_Display[#Details_Display-1].contentHeight+10
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].name = "userName"
				Details_Display[#Details_Display]:addEventListener("touch",closeDetails)
			end

			if(Details.DateOfBirth ~= nil) then

				local birthday_icon = display.newImageRect(mainView,"res/assert/user.png",15,15)
				birthday_icon.anchorX = 0 ;birthday_icon.anchorY=0
				birthday_icon.x=Details_Display[#Details_Display].x
				birthday_icon.y=Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+15

				Details_Display[#Details_Display+1] = display.newText(mainView,Details.DateOfBirth,0,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=birthday_icon.x+birthday_icon.contentWidth+5
				Details_Display[#Details_Display].y = birthday_icon.y
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].name = "birthDay"
			end

			if(Details.AnniversariesDate ~= nil) then

				local anniversari_icon = display.newImageRect(mainView,"res/assert/user.png",15,15)
				anniversari_icon.anchorX = 0 ;anniversari_icon.anchorY=0
				anniversari_icon.x=Details_Display[#Details_Display].x-anniversari_icon.contentWidth-5
				anniversari_icon.y=Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+15


				Details_Display[#Details_Display+1] = display.newText(mainView,Details.AnniversariesDate,0,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=anniversari_icon.x+anniversari_icon.contentWidth+5
				Details_Display[#Details_Display].y = anniversari_icon.y
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].name = "Anniversarie"
			end
			if(Details.RecruitedDate ~= nil) then

				local RecruitedDate = display.newText(mainView,"When Recruited",0,0,150,0,native.systemFont,16)
				RecruitedDate.anchorX = 0 ;RecruitedDate.anchorY=0
				RecruitedDate:setFillColor(0)
				RecruitedDate.x=leftPadding
				RecruitedDate.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+30

				Details_Display[#Details_Display+1] = display.newText(mainView,Details.RecruitedDate,0,0,160,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=W/2
				Details_Display[#Details_Display].size = 16
				Details_Display[#Details_Display].y = RecruitedDate.y 
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].name = "RecruitedDate"
			end

			if(Details.ConsultantNumber ~= nil) then

				local ConsultantNumber = display.newText(mainView,"Consultant No",0,0,150,0,native.systemFont,16)
				ConsultantNumber.anchorX = 0 ;ConsultantNumber.anchorY=0
				ConsultantNumber:setFillColor(0)
				ConsultantNumber.x=leftPadding
				ConsultantNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10

				Details_Display[#Details_Display+1] = display.newText(mainView,Details.ConsultantNumber,0,0,160,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=W/2
				Details_Display[#Details_Display].y = ConsultantNumber.y
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].size = 16
				Details_Display[#Details_Display].name = "ConsultantNumber"
			end

			if(Details.UnitNumber ~= nil) then

				
				local UnitNumber = display.newText(mainView,"Unit No",0,0,150,0,native.systemFont,16)
				UnitNumber.anchorX = 0 ;UnitNumber.anchorY=0
				UnitNumber:setFillColor(0)
				UnitNumber.x=leftPadding
				UnitNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10

				Details_Display[#Details_Display+1] = display.newText(mainView,Details.UnitNumber,0,0,160,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=W/2
				Details_Display[#Details_Display].y = UnitNumber.y
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].size = 16
				Details_Display[#Details_Display].name = "UnitNumber"
			end

			if(Details.RecruiterNumber ~= nil) then

				local RecruiterNumber = display.newText(mainView,"Recruiter No",0,0,150,0,native.systemFont,16)
				RecruiterNumber.anchorX = 0 ;RecruiterNumber.anchorY=0
				RecruiterNumber:setFillColor(0)
				RecruiterNumber.x=leftPadding
				RecruiterNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10


				Details_Display[#Details_Display+1] = display.newText(mainView,Details.RecruiterNumber,0,0,160,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=W/2
				Details_Display[#Details_Display].y = RecruiterNumber.y 
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].size = 16
				Details_Display[#Details_Display].name = "RecruiterNumber"
			end

			if(Details.RecruiterName ~= nil) then

				local RecruiterName = display.newText(mainView,"Recruiter Name",0,0,150,0,native.systemFont,16)
				RecruiterName.anchorX = 0 ;RecruiterName.anchorY=0
				RecruiterName:setFillColor(0)
				RecruiterName.x=leftPadding
				RecruiterName.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10

				Details_Display[#Details_Display+1] = display.newText(mainView,Details.RecruiterName,0,0,160,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=W/2
				Details_Display[#Details_Display].y = RecruiterName.y
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].size = 16
				Details_Display[#Details_Display].name = "RecruiterName"
			end

			if(Details.CareerProgress ~= nil) then

				local CareerProgress = display.newText(mainView,"Career Progress",0,0,150,0,native.systemFont,16)
				CareerProgress.anchorX = 0 ;CareerProgress.anchorY=0
				CareerProgress:setFillColor(0)
				CareerProgress.x=leftPadding
				CareerProgress.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10


				Details_Display[#Details_Display+1] = display.newText(mainView,Details.CareerProgress,0,0,160,0,native.systemFont,18)
				Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
				Details_Display[#Details_Display].x=W/2
				Details_Display[#Details_Display].y = CareerProgress.y 
				Details_Display[#Details_Display]:setFillColor(0)
				Details_Display[#Details_Display].size = 16
				Details_Display[#Details_Display].name = "CareerProgress"
			end


			if Details.ImagePath ~= nil then
				Image = display.newImage(mainView,"career"..contactId..".png",system.TemporaryDirectory)

			end

			if not Image then
				Image = display.newImageRect(mainView,"res/assert/twitter_placeholder.png",80,80)
			end

			Image.width = 80;Image.height = 80
			Image.x=W/2+100;Image.y=H/2-120


			below_tab = display.newRect(sceneGroup,W/2,H-40,W,40)
			below_tab.anchorY=0

			below_mail = display.newImageRect(sceneGroup,"res/assert/user.png",30,30)
			below_mail.anchorY=0
			below_mail.x=below_tab.x-90
			below_mail.y=below_tab.y+5

			if Details.HomePhoneNumber ~= nil then
				below_call = display.newImageRect(sceneGroup,"res/assert/user.png",30,30)
				below_call.anchorY=0
				below_call.x=below_tab.x
				below_call.y=below_tab.y+5
				below_call.id=Details.HomePhoneNumber
			end	

		--if Details.ContactsAddress[1] ~= nil then

		below_map = display.newImageRect(sceneGroup,"res/assert/user.png",30,30)
		below_map.anchorY=0
		below_map.x=below_tab.x+90
		below_map.y=below_tab.y+5
		--	below_map.id = Details.ContactsAddress
		--end


		--[[myMap = native.newMapView( 20, 20, 280, 360 )
		myMap.x = display.contentCenterX
		myMap.y = display.contentCenterY

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
				imageFile =  "res/assert/forgot-psw.png",
			    -- Alternatively, this looks in the specified directory for the image file
			    -- imageFile = { filename="someImage.png", baseDir=system.TemporaryDirectory }
				}
local result, errorMessage = myMap:addMarker( event.latitude, event.longitude , options )
end

end

myMap:requestLocation( "1900 Embarcadero Road, Palo Alto, CA", locationHandler )]]



below_map:addEventListener("touch",MapShowing)
menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)


end	

sceneGroup:insert(mainView)

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