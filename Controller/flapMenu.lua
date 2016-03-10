----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

require( "res.value.style" )
local Utility = require( "Utils.Utility" )
require( "Webservice.ServiceManager" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local menuArray_display = {}

local space_value = 27 

local profilePic,UserEmail;

local profilePic_path




--------------------------------------------------


-----------------Function-------------------------

local function unrequire( m )
     print( "unrequire" )
     package.loaded[m] = nil
        _G[m] = nil
        package.loaded["res.value.string_es_Us"] = nil

      return true
end

local function closeDetails( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

	end

	return true

end

local function MenuTouchAction(event)
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            flapScroll:takeFocus( event )
        end

	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )


		if event.target.id == "logout" then
					local function onComplete( event )
						if event.action == "clicked" then
						        local i = event.index
						    if i == 1 then

						        	function get_logout(response)

						        		if response == 5 then

								        	slideAction()
											for j=MainGroup.numChildren, 1, -1 do 
												display.remove(MainGroup[MainGroup.numChildren])
												MainGroup[MainGroup.numChildren] = nil
											end

								            
											local tablesetup = [[DROP TABLE logindetails;]]
											db:exec( tablesetup )

										composer.gotoScene( "Controller.singInPage" )

										else

											slideAction()

						        		end


						        	end
						     local logout_Userid,logout_ContactId,logout_AccessToken,logout_uniqueId

						    for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

				  				logout_Userid = row.UserId
				  				logout_ContactId = row.ContactId
				  				logout_AccessToken = row.AccessToken
				  				logout_uniqueId = system.getInfo("deviceID")
				  				
	      					end


		        			Webservice.LogOut(logout_Userid,logout_ContactId,logout_AccessToken,logout_uniqueId,get_logout)

				        elseif i == 2 then
				            --cancel
				        end
				    end
				end

			-- Show alert with two buttons
			local alert = native.showAlert( "Log out", FlapMenu.Alert, { FlapMenu.LOG_OUT , FlapMenu.CANCEL }, onComplete )	
			
				return true
				
			end

			for i = 1, #menuArray_display do

				menuArray_display[i].alpha=0.01

			end

			event.target.alpha=1
			

			slideAction()


			if openPage ~= event.target.id then

				for j=MainGroup.numChildren, 1, -1 do 
					display.remove(MainGroup[MainGroup.numChildren])
					MainGroup[MainGroup.numChildren] = nil
				end
				composer.removeHidden(true)

				if event.target.name == "GRANT" or event.target.name == "DENY" or event.target.name == "OPEN" or event.target.name == "ADDREQUEST" then

					local option={
						params = {status=event.target.name}
					}
					composer.gotoScene( "Controller."..event.target.id,option )

				else

					composer.gotoScene( "Controller."..event.target.id )

				end

			else
				if event.target.name == "GRANT" or event.target.name == "DENY" or event.target.name == "OPEN" or event.target.name == "ADDREQUEST" then

					print( '123' )
					reloadInvitAccess(event.target.name)

				end

			end



			--end
		end
		return true

	end
------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view


    local found=false
    db:exec([[select * from sqlite_master where name='logindetails';]],
    function(...) found=true return 0 end)

    if found then

        for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

        langid = row.LanguageId
        countryid = row.CountryId

        profilePic_path = row.ProfileImageUrl

        loginFlag=true

					Director_Name = row.MemberName

					EmailAddress = row.MemberEmail


					---Check Facebook , Twitter and Google+----

					if row.GoogleUsername ~="" and row.GoogleToken ~="" and row.GoogleTokenSecret ~="" and row.GoogleUserId ~="" then

						isGoogle=true

					end

					if row.FacebookUsername ~="" and row.FacebookAccessToken ~="" then

						isFacebook=true

					end


					if row.TwitterUsername ~="" and row.TwitterToken ~="" and row.TwitterTokenSecret ~="" then

						isTwitter=true

					end





					------------------
        

        end

    if package.loaded["res.value.string_es_Us"] then print( "spani finish" ) unrequire("res.value.string_es_Us") end
    if package.loaded["res.value.string_fr_Ca"] then print( "string_fr_Ca finish" ) unrequire("res.value.string_fr_Ca") end
    if package.loaded["res.value.string_en_Ca"] then print( "string_en_Ca finish" ) unrequire("res.value.string_en_Ca") end
    if package.loaded["res.value.string"] then print( "string finish" ) unrequire("res.value.string") end
    

    if langid == "2"  and countryid == "1" then

        MyUnitBuzzString = require( "res.value.string_es_Us" )

    elseif langid == "3"  and countryid == "2" then

        MyUnitBuzzString = require( "res.value.string_fr_Ca" )

    elseif langid == "4" and countryid == "2" then

        MyUnitBuzzString = require( "res.value.string_en_Ca" )

    else

        MyUnitBuzzString = require( "res.value.string")

    end



    else

        MyUnitBuzzString = require( "res.value.string" )

    end



	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		elseif phase == "did" then

			panel.background = display.newRect( 0, 0, panel.width, panel.height )
			panel.background:setFillColor( Utils.convertHexToRGB(sp_Flatmenu_HeaderBg.Background_Color) )
			panel:insert( panel.background )

			panel.flapTopBg = display.newImageRect("res/assert/flapTopBg.jpg",panel.width,150)
			panel.flapTopBg.anchorY=0;panel.flapTopBg.y=-panel.width
			panel:insert( panel.flapTopBg )
 

		local profilePic 

			profilePic = display.newImageRect("res/assert/usericon.png",65,60)
			profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+5;profilePic.y=panel.flapTopBg.y+panel.flapTopBg.contentHeight/2-35
			profilePic.anchorY=0
			profilePic.anchorX=0
			panel:insert( profilePic )

		if profilePic_path ~= nil then 

			local downloadid = network.download(ApplicationConfig.IMAGE_BASE_URL..""..profilePic_path,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else

						if profilePic then profilePic:removeSelf( );profilePic=nil end

						print("response file "..img_event.response.filename)
						profilePic = display.newImageRect(img_event.response.filename,system.TemporaryDirectory,80,65)
						--profilePic.width=65;profilePic.height=65
						profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+5;profilePic.y=panel.flapTopBg.y+panel.flapTopBg.contentHeight/2-35
						profilePic.anchorY=0
						profilePic.anchorX=0

						local mask = graphics.newMask( "res/assert/mask1.png" )

						profilePic:setMask( mask )

						--profilePic.maskX = profilePic.x
						--profilePic.maskY = profilePic.y

						panel:insert( profilePic )
						
    				--event.row:insert(img_event.target)
    			end

    			end, profilePic_path:match( "([^/]+)$" ), system.TemporaryDirectory)
		else
			profilePic = display.newImageRect("res/assert/usericon.png",65,60)
			profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+5;profilePic.y=panel.flapTopBg.y+panel.flapTopBg.contentHeight/2-35
			profilePic.anchorY=0
			profilePic.anchorX=0
			panel:insert( profilePic )

		end

			profileName = display.newText(Director_Name,0,0,245,0,native.systemFont,15)
			profileName.x=profilePic.x
			profileName.anchorX=0
			profileName.y=profilePic.y+profilePic.contentHeight+15
			Utils.CssforTextView(profileName,sp_Flatmenu_labelName)
			panel:insert( profileName )

			profileEmail = display.newText("",0,0,250,0,native.systemFont,15)
			profileEmail.x=profilePic.x
			profileEmail.anchorX=0
			profileEmail.anchorY=0
			Utils.CssforTextView(profileEmail,sp_Flatmenu_fieldValue)
			profileEmail.y=profileName.y+profileName.contentHeight-5
			panel:insert( profileEmail )


			if EmailAddress ~= nil then

							local EmailTxt = EmailAddress

								if EmailTxt:len() > 26 then

									EmailTxt= EmailTxt:sub(1,26).."..."

								end

						profileEmail.text = EmailTxt

			end


		--[[	--HomePage

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=panel.flapTopBg.y+panel.flapTopBg.contentHeight-5
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Home"
			menuArray_display[#menuArray_display].id="LandingPage"

			Event_icon = display.newImageRect("res/assert/calen.png",15,15)
			Event_icon.anchorX = 0
			Event_icon.x=-panel.width/2+5
			Event_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Event_icon )

			Event_text = display.newText(FlapMenu.Home,0,0,"Open Sans Regular",16)
			Event_text.anchorX = 0
			Event_text.x=Event_icon.x+Event_icon.contentWidth+5
			Event_text.y = Event_icon.y
			Utils.CssforTextView(Event_text,sp_Flatmenu_subHeader)
			panel:insert( Event_text )]]

			 flapScroll = widget.newScrollView(
			    {
			        top = 0,
			        left = 0,
			        width = panel.width,
			        height = 350,
			        hideBackground=true,
			        horizontalScrollDisabled=true
			        -- scrollWidth = 600,
			        -- scrollHeight = 800,
			        -- listener = scrollListener
			    }
			)
			 flapScroll.anchorY=0
			-- flapScroll.anchorX=0
			-- flapScroll.y = panel.flapTopBg.y+panel.flapTopBg.contentHeight-5
			flapScroll.x=panel.x;flapScroll.y=-panel.width/2+20
			panel:insert( flapScroll )
			--EventCalender

			
			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=0
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "EventCalender"
			menuArray_display[#menuArray_display].id="eventCalenderPage"

			Event_icon = display.newImageRect("res/assert/calen.png",15,15)
			Event_icon.anchorX = 0
			Event_icon.x=5
			Event_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Event_icon )

			Event_text = display.newText(EventCalender.PageTitle,0,0,"Open Sans Regular",16)
			Event_text.anchorX = 0
			Event_text.x=Event_icon.x+Event_icon.contentWidth+5
			Event_text.y = Event_icon.y
			Utils.CssforTextView(Event_text,sp_Flatmenu_subHeader)
			flapScroll:insert( Event_text )

			-----

			--CareerPath

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].height
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "CareerPath"
			menuArray_display[#menuArray_display].id="careerPathPage"


			Career_icon = display.newImageRect("res/assert/carrer.png",15,15)
			Career_icon.anchorX = 0
			Career_icon.x=5
			Career_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Career_icon )

			Career_text = display.newText(CareerPath.PageTitle,0,0,"Open Sans Regular",16)
			Career_text.anchorX = 0
			Career_text.x=Career_icon.x+Career_icon.contentWidth+5
			Career_text.y = Career_icon.y
			Utils.CssforTextView(Career_text,sp_Flatmenu_subHeader)
			flapScroll:insert( Career_text )

			-----

			--Goals

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Goals"
			menuArray_display[#menuArray_display].id="goalsPage"


			Goals_icon = display.newImageRect("res/assert/goals.png",15,15)
			Goals_icon.anchorX = 0
			Goals_icon.x=5
			Goals_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Goals_icon )

			Goals_text = display.newText(Goals.PageTitle,0,0,"Open Sans Regular",16)
			Goals_text.anchorX = 0
			Utils.CssforTextView(Goals_text,sp_Flatmenu_subHeader)
			Goals_text.x=Goals_icon.x+Goals_icon.contentWidth+5
			Goals_text.y = Goals_icon.y
			
			flapScroll:insert( Goals_text )

			-----

			--Resource

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Resource"

			menuArray_display[#menuArray_display].id="resourcePage"


			Resource_icon = display.newImageRect("res/assert/resource.png",15,15)
			Resource_icon.anchorX = 0
			Resource_icon.x=5
			Resource_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Resource_icon )

			Resource_text = display.newText(ResourceLibrary.PageTitle ,0,0,"Open Sans Regular",16)
			Resource_text.anchorX = 0
			Resource_text.x=Resource_icon.x+Resource_icon.contentWidth+5
			Resource_text.y = Resource_icon.y
			Utils.CssforTextView(Resource_text,sp_Flatmenu_subHeader)
			flapScroll:insert( Resource_text )

			-----

			--Image Library

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Image_Library"
			menuArray_display[#menuArray_display].id="imageLibPage"


			img_lib_icon = display.newImageRect("res/assert/library.png",15,15)
			img_lib_icon.anchorX = 0
			img_lib_icon.x=5
			img_lib_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( img_lib_icon )

			img_lib_text = display.newText(ImageLibrary.PageTitle ,0,0,"Open Sans Regular",16)
			img_lib_text.anchorX = 0
			img_lib_text.x=img_lib_icon.x+img_lib_icon.contentWidth+5
			img_lib_text.y = img_lib_icon.y
			
			flapScroll:insert( img_lib_text )

			-----


			--Message

			if IsOwner == true then

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Message"
			menuArray_display[#menuArray_display].id="messagePage"

			message_icon = display.newImageRect("res/assert/message.png",15,15)
			message_icon.anchorX = 0
			message_icon:setFillColor(1,1,1)
			message_icon.x=5
			message_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( message_icon )

			message_text = display.newText(Message.PageTitle ,0,0,"Open Sans Regular",16)
			message_text.anchorX = 0
			message_text.x=message_icon.x+message_icon.contentWidth+5
			message_text.y = message_icon.y
			
			flapScroll:insert( message_text )

--Invite/Access

			rect = display.newRect(0,0,panel.width,1)
			rect.x = menuArray_display[#menuArray_display].x;
			rect.anchorX=0
			rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
			rect:setFillColor(0)
			flapScroll:insert( rect )

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display].name = "Social"
			menuArray_display[#menuArray_display].id="social"



				socilaLbl = display.newText("Invite/Access",0,0,panel.contentWidth,0,native.systemFontBold,16)
				socilaLbl.anchorX = 0
				socilaLbl.x=5
				socilaLbl.y= rect.y+15
				flapScroll:insert( socilaLbl )

			--Contacts with Access

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "GRANT"
			menuArray_display[#menuArray_display].id="inviteAndaccessPage"

			invite_icon = display.newImageRect("res/assert/contacts-access.png",15,15)
			invite_icon.anchorX = 0
			invite_icon:setFillColor(1,1,1)
			invite_icon.x=5
			invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( invite_icon )

			invite_text = display.newText("Contacts with Access" ,0,0,"Open Sans Regular",16)
			invite_text.anchorX = 0
			invite_text.x=invite_icon.x+invite_icon.contentWidth+5
			invite_text.y = invite_icon.y
			
			flapScroll:insert( invite_text )

			---Denied Access

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "DENY"
			menuArray_display[#menuArray_display].id="inviteAndaccessPage"

			invite_icon = display.newImageRect("res/assert/DENIDE-ACC.png",15,15)
			invite_icon.anchorX = 0
			invite_icon:setFillColor(1,1,1)
			invite_icon.x=5
			invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( invite_icon )

			invite_text = display.newText("Denied Access" ,0,0,"Open Sans Regular",16)
			invite_text.anchorX = 0
			invite_text.x=invite_icon.x+invite_icon.contentWidth+5
			invite_text.y = invite_icon.y
			
			flapScroll:insert( invite_text )

			--Pending Requests

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "OPEN"
			menuArray_display[#menuArray_display].id="inviteAndaccessPage"

			invite_icon = display.newImageRect("res/assert/PENDING.png",15,15)
			invite_icon.anchorX = 0
			invite_icon:setFillColor(1,1,1)
			invite_icon.x=5
			invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( invite_icon )

			invite_text = display.newText("Pending Requests" ,0,0,"Open Sans Regular",16)
			invite_text.anchorX = 0
			invite_text.x=invite_icon.x+invite_icon.contentWidth+5
			invite_text.y = invite_icon.y
			
			flapScroll:insert( invite_text )

			--Team Member without Access

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "ADDREQUEST"
			menuArray_display[#menuArray_display].id="inviteAndaccessPage"

			invite_icon = display.newImageRect("res/assert/team-men-Access.png",15,15)
			invite_icon.anchorX = 0
			invite_icon:setFillColor(1,1,1)
			invite_icon.x=5
			invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( invite_icon )

			invite_text = display.newText("Team Member without Access" ,0,0,"Open Sans Regular",16)
			invite_text.anchorX = 0
			invite_text.x=invite_icon.x+invite_icon.contentWidth+5
			invite_text.y = invite_icon.y
			
			flapScroll:insert( invite_text )

				--[[]	--Add New Access

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Add New Access"
			menuArray_display[#menuArray_display].id="inviteAndaccessPage"

			invite_icon = display.newImageRect("res/assert/message.png",15,15)
			invite_icon.anchorX = 0
			invite_icon:setFillColor(1,1,1)
			invite_icon.x=5
			invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( invite_icon )

			invite_text = display.newText("Add New Access" ,0,0,"Open Sans Regular",16)
			invite_text.anchorX = 0
			invite_text.x=invite_icon.x+invite_icon.contentWidth+5
			invite_text.y = invite_icon.y
			
			flapScroll:insert( invite_text )]]

			end

			-----


			rect = display.newRect(0,0,panel.width,1)
			rect.x = menuArray_display[#menuArray_display].x;
			rect.anchorX=0
			rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
			rect:setFillColor(0)
			flapScroll:insert( rect )


		if isGoogle == true or isFacebook == true or isTwitter == true then


			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display].name = "Social"
			menuArray_display[#menuArray_display].id="social"



				socilaLbl = display.newText(FlapMenu.Social_Media,0,0,panel.contentWidth,0,native.systemFontBold,16)
				socilaLbl.anchorX = 0
				socilaLbl.x=5
				socilaLbl.y= rect.y+15
				flapScroll:insert( socilaLbl )


		end


		if isFacebook == true then

			



		--Facebook

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=socilaLbl.y+socilaLbl.contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Facebook"
			menuArray_display[#menuArray_display].id="facebookPage"


			Facebook_icon = display.newImageRect("res/assert/facebook.png",15,15)
			Facebook_icon.anchorX = 0
			Facebook_icon.x=5
			Facebook_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Facebook_icon )

			Facebook_text = display.newText(Facebook.PageTitle,0,0,"Open Sans Regular",16)
			Facebook_text.anchorX = 0
			Facebook_text.x=Facebook_icon.x+Facebook_icon.contentWidth+5
			Facebook_text.y = Facebook_icon.y
			
			flapScroll:insert( Facebook_text )

			-----


		end

		if isTwitter == true then
			--Twitter

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Twitter"
			menuArray_display[#menuArray_display].id="twitterPage"


			Twitter_icon = display.newImageRect("res/assert/twitter.png",15,15)
			Twitter_icon.anchorX = 0
			Twitter_icon.x=5
			Twitter_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Twitter_icon )

			Twitter_text = display.newText(Twitter.PageTitle,0,0,"Open Sans Regular",16)
			Twitter_text.anchorX = 0
			Twitter_text.x=Twitter_icon.x+Twitter_icon.contentWidth+5
			Twitter_text.y = Twitter_icon.y
			
			flapScroll:insert( Twitter_text )

			-----
		end

		if isGoogle == true then

					--Google +

					menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
					menuArray_display[#menuArray_display].anchorY=0
					menuArray_display[#menuArray_display].anchorX=0
					menuArray_display[#menuArray_display].alpha=0.01
					menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
					menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
					flapScroll:insert( menuArray_display[#menuArray_display] )
					menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
					menuArray_display[#menuArray_display].name = "Google +"
					menuArray_display[#menuArray_display].id="googlePlusPage"

					Google_icon = display.newImageRect("res/assert/google+.png",15,15)
					Google_icon.anchorX = 0
					Google_icon.x=5
					Google_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
					flapScroll:insert( Google_icon )

					Googl_text = display.newText(Google_Plus.PageTitle,0,0,"Open Sans Regular",16)
					Googl_text.anchorX = 0
					Googl_text.x=Google_icon.x+Google_icon.contentWidth+5
					Googl_text.y = Google_icon.y

					flapScroll:insert( Googl_text )

			end


					rect = display.newRect(0,0,panel.width,1)
					rect.x = menuArray_display[#menuArray_display].x;
					rect.anchorX=0
					rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
					rect:setFillColor(0)
					flapScroll:insert( rect )

					--rect.isVisible=false




					--Logout

					menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
					menuArray_display[#menuArray_display].anchorY=0
					menuArray_display[#menuArray_display].anchorX=0
					menuArray_display[#menuArray_display].alpha=0.01
					menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
					menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
					flapScroll:insert( menuArray_display[#menuArray_display] )
					menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
					menuArray_display[#menuArray_display].name = "Logout"
					menuArray_display[#menuArray_display].id="logout"


					Logout_icon = display.newImageRect("res/assert/logout.png",15,15)
					Logout_icon.anchorX = 0
					Logout_icon.x=5
					Logout_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
					flapScroll:insert( Logout_icon )

					Logout_text = display.newText(FlapMenu.PageTitle,0,0,"Open Sans Regular",16)
					Logout_text.anchorX = 0
					Utils.CssforTextView(Logout_text,sp_Flatmenu_subHeader)
					Logout_text.x=Logout_icon.x+Logout_icon.contentWidth+5
					Logout_text.y = Logout_icon.y


					flapScroll:insert( Logout_text )

			-----


			composer.gotoScene( "Controller.eventCalenderPage" )
			--composer.gotoScene( "Controller.careerPathDetailPage", options )
		end	

		MainGroup:insert(sceneGroup)

	end
	

		function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


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