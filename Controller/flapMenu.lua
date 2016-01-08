----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

require( "res.value.style" )
local Utility = require( "Utils.Utility" )

local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local menuArray_display = {}

local space_value = 30

local profilePic,UserEmail;


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

		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )


		if event.target.id == "logout" then
				local function onComplete( event )
					   if event.action == "clicked" then
					        local i = event.index
					        if i == 1 then

					        	slideAction()
								for j=MainGroup.numChildren, 1, -1 do 
									display.remove(MainGroup[MainGroup.numChildren])
									MainGroup[MainGroup.numChildren] = nil
								end

					            local options = {
								    params = { responseValue=UnitnumberList}
								}




								local tablesetup = [[DROP TABLE logindetails;]]
								db:exec( tablesetup )

							composer.gotoScene( "Controller.singInPage", options )
			        elseif i == 2 then
			            --cancel
			        end
			    end
			end

		-- Show alert with two buttons
		local alert = native.showAlert( "Log out", FlapMenu.Alert, { FlapMenu.LOG_OUT , FlapMenu.CANCEL }, onComplete )	
			return
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
			composer.gotoScene( "Controller."..event.target.id )
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

        loginFlag=true

					Director_Name = row.MemberName

					EmailAddress = row.MemberEmail
        

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


			profilePic = display.newImageRect("res/assert/career-user.png",62,56)
			profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+10;profilePic.y=panel.flapTopBg.y+panel.flapTopBg.contentHeight/2-40
			profilePic.anchorY=0
			profilePic.anchorX=0
			panel:insert( profilePic )

			profileName = display.newText(Director_Name,0,0,245,0,native.systemFont,15)
			profileName.x=profilePic.x
			profileName.anchorX=0
			profileName.y=profilePic.y+profilePic.contentHeight+10
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

			

			--EventCalender

			
			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=panel.flapTopBg.y+panel.flapTopBg.contentHeight-5
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "EventCalender"
			menuArray_display[#menuArray_display].id="eventCalenderPage"

			Event_icon = display.newImageRect("res/assert/calen.png",15,15)
			Event_icon.anchorX = 0
			Event_icon.x=-panel.width/2+5
			Event_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Event_icon )

			Event_text = display.newText(EventCalender.PageTitle,0,0,"Open Sans Regular",16)
			Event_text.anchorX = 0
			Event_text.x=Event_icon.x+Event_icon.contentWidth+5
			Event_text.y = Event_icon.y
			Utils.CssforTextView(Event_text,sp_Flatmenu_subHeader)
			panel:insert( Event_text )

			-----

			--CareerPath

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "CareerPath"
			menuArray_display[#menuArray_display].id="careerPathPage"


			Career_icon = display.newImageRect("res/assert/carrer.png",15,15)
			Career_icon.anchorX = 0
			Career_icon.x=-panel.width/2+5
			Career_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Career_icon )

			Career_text = display.newText(CareerPath.PageTitle,0,0,"Open Sans Regular",16)
			Career_text.anchorX = 0
			Career_text.x=Career_icon.x+Career_icon.contentWidth+5
			Career_text.y = Career_icon.y
			Utils.CssforTextView(Career_text,sp_Flatmenu_subHeader)
			panel:insert( Career_text )

			-----

			--Goals

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Goals"
			menuArray_display[#menuArray_display].id="goalsPage"


			Goals_icon = display.newImageRect("res/assert/goals.png",15,15)
			Goals_icon.anchorX = 0
			Goals_icon.x=-panel.width/2+5
			Goals_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Goals_icon )

			Goals_text = display.newText(Goals.PageTitle,0,0,"Open Sans Regular",16)
			Goals_text.anchorX = 0
			Utils.CssforTextView(Goals_text,sp_Flatmenu_subHeader)
			Goals_text.x=Goals_icon.x+Goals_icon.contentWidth+5
			Goals_text.y = Goals_icon.y
			
			panel:insert( Goals_text )

			-----

			--Resource

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Resource"

			menuArray_display[#menuArray_display].id="resourcePage"


			Resource_icon = display.newImageRect("res/assert/resource.png",15,15)
			Resource_icon.anchorX = 0
			Resource_icon.x=-panel.width/2+5
			Resource_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Resource_icon )

			Resource_text = display.newText(ResourceLibrary.PageTitle ,0,0,"Open Sans Regular",16)
			Resource_text.anchorX = 0
			Resource_text.x=Resource_icon.x+Resource_icon.contentWidth+5
			Resource_text.y = Resource_icon.y
			Utils.CssforTextView(Resource_text,sp_Flatmenu_subHeader)
			panel:insert( Resource_text )

			-----

			--Image Library

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Image_Library"
			menuArray_display[#menuArray_display].id="imageLibPage"


			img_lib_icon = display.newImageRect("res/assert/library.png",15,15)
			img_lib_icon.anchorX = 0
			img_lib_icon.x=-panel.width/2+5
			img_lib_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( img_lib_icon )

			img_lib_text = display.newText(ImageLibrary.PageTitle ,0,0,"Open Sans Regular",16)
			img_lib_text.anchorX = 0
			img_lib_text.x=img_lib_icon.x+img_lib_icon.contentWidth+5
			img_lib_text.y = img_lib_icon.y
			
			panel:insert( img_lib_text )

		--[[	-----

			rect = display.newRect(0,0,panel.width,1)
			rect.x = menuArray_display[#menuArray_display].x;
			rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
			rect:setFillColor(0)
			panel:insert( rect )

			socilaLbl = display.newText(FlapMenu.Social_Media,0,0,panel.contentWidth,0,"Open Sans Regular",16)
			socilaLbl.anchorX = 0
			socilaLbl.x=-panel.width/2+5
			socilaLbl.y= rect.y+15
			socilaLbl.alpha=0.6
			panel:insert( socilaLbl )



		--Facebook

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=socilaLbl.y+socilaLbl.contentHeight
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Facebook"
			menuArray_display[#menuArray_display].id="facebookPage"


			Facebook_icon = display.newImageRect("res/assert/facebook.png",15,15)
			Facebook_icon.anchorX = 0
			Facebook_icon.x=-panel.width/2+5
			Facebook_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Facebook_icon )

			Facebook_text = display.newText(Facebook.PageTitle,0,0,"Open Sans Regular",16)
			Facebook_text.anchorX = 0
			Facebook_text.x=Facebook_icon.x+Facebook_icon.contentWidth+5
			Facebook_text.y = Facebook_icon.y
			
			panel:insert( Facebook_text )

			-----
			--Twitter

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].alpha=0.01
			menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
			panel:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Twitter"
			menuArray_display[#menuArray_display].id="twitterPage"


			Twitter_icon = display.newImageRect("res/assert/twitter.png",15,15)
			Twitter_icon.anchorX = 0
			Twitter_icon.x=-panel.width/2+5
			Twitter_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			panel:insert( Twitter_icon )

			Twitter_text = display.newText(Twitter.PageTitle,0,0,"Open Sans Regular",16)
			Twitter_text.anchorX = 0
			Twitter_text.x=Twitter_icon.x+Twitter_icon.contentWidth+5
			Twitter_text.y = Twitter_icon.y
			
			panel:insert( Twitter_text )

			-----

					--Google +

					menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
					menuArray_display[#menuArray_display].anchorY=0
					menuArray_display[#menuArray_display].alpha=0.01
					menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
					menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
					panel:insert( menuArray_display[#menuArray_display] )
					menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
					menuArray_display[#menuArray_display].name = "Google +"
					menuArray_display[#menuArray_display].id="googlePlusPage"


					Google_icon = display.newImageRect("res/assert/google+.png",15,15)
					Google_icon.anchorX = 0
					Google_icon.x=-panel.width/2+5
					Google_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
					panel:insert( Google_icon )

					Googl_text = display.newText(Google_Plus.PageTitle,0,0,"Open Sans Regular",16)
					Googl_text.anchorX = 0
					Googl_text.x=Google_icon.x+Google_icon.contentWidth+5
					Googl_text.y = Google_icon.y

					panel:insert( Googl_text )

					]]

					rect = display.newRect(0,0,panel.width,1)
					rect.x = menuArray_display[#menuArray_display].x;
					rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
					rect:setFillColor(0)
					panel:insert( rect )

					--rect.isVisible=false


					--Logout

					menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
					menuArray_display[#menuArray_display].anchorY=0
					menuArray_display[#menuArray_display].alpha=0.01
					menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
					menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
					panel:insert( menuArray_display[#menuArray_display] )
					menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
					menuArray_display[#menuArray_display].name = "Logout"
					menuArray_display[#menuArray_display].id="logout"


					Logout_icon = display.newImageRect("res/assert/logout.png",15,15)
					Logout_icon.anchorX = 0
					Logout_icon.x=-panel.width/2+5
					Logout_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
					panel:insert( Logout_icon )

					Logout_text = display.newText(FlapMenu.PageTitle,0,0,"Open Sans Regular",16)
					Logout_text.anchorX = 0
					Utils.CssforTextView(Logout_text,sp_Flatmenu_subHeader)
					Logout_text.x=Logout_icon.x+Logout_icon.contentWidth+5
					Logout_text.y = Logout_icon.y


					panel:insert( Logout_text )

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