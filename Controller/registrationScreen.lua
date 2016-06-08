----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
require( "res.value.style" )
require( "Webservice.ServiceManager" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local specialRecognitionListArray = {}

local refresh_list

local leftPadding = 15

local BackFlag = false

openPage="registartionScreen"


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



local function onTimer ( event )

	print( "event time completion" )

	BackFlag = false

end



local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

        	if BackFlag == false then

        		Utils.SnackBar(ChatPage.PressAgain)

        		BackFlag = true

        		timer.performWithDelay( 3000, onTimer )

                return true

            elseif BackFlag == true then

			 os.exit() 

            end
            
        end

    end

        return false
 end






local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

			native.setKeyboardFocus( nil )

	 elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling

        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            scrollView:takeFocus( event )
        end
    
	elseif event.phase == "ended" then

	print("ttttt")

		native.setKeyboardFocus( nil )

		List.isVisible = false
		List_bg.isVisible = false



    end
				
end





local function backAction( event )

		if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

			display.getCurrentStage():setFocus( nil )

			CreateAccountBtn.isVisible = true
			CreateAccountBtn_text.isVisible = true

			backBtn_bg.isVisible = false
			backBtn.isVisible = false
			page_title.isVisible = false
			FirstName_bg.isVisible = false
			FirstName.isVisible = false
			FirstName_bottom.isVisible = false
			Name_bg.isVisible = false
			Name_bottom.isVisible = false
			Name.isVisible = false
			Email_bg.isVisible = false
			Email_bottom.isVisible = false
			Email.isVisible = false
			Phone_bg.isVisible = false
			Phone_bottom.isVisible = false
			Phone.isVisible = false

			Marykay_id.isVisible = false
			Marykay_id_helptext.isVisible = false
			Marykay_bg.isVisible = false
			Marykay.isVisible = false
			Marykay_bottom.isVisible = false
			Country_bg.isVisible = false
			Country.isVisible = false
			Country_bottom.isVisible = false
			Language_bg.isVisible = false
			Language.isVisible = false
			Language_bottom.isVisible = false
			Position_bg.isVisible = false
			Position.isVisible = false
			Position_bottom.isVisible = false
			registerBtn.isVisible = false
			registerBtn_lbl.isVisible = false
			registerBtn.isVisible = false

		end

		return true

end





------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.height/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	
	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=5;BgText.y=20
	BgText.anchorX=0

	-- backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
	-- backBtn_bg.x=25;backBtn_bg.y=BgText.y+BgText.contentHeight/2+26
	-- backBtn_bg.alpha=0.01

	-- backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
	-- backBtn.x=20;backBtn.y=BgText.y+BgText.contentHeight/2+20
	-- backBtn.xScale=-1
	-- backBtn.anchorY=0

	-- page_title = display.newText(sceneGroup,RequestAccess.PageTitle,0,0,native.systemFont,18)
	-- page_title.x=backBtn.x+18;page_title.y=backBtn.y+8
	-- page_title.anchorX=0
	-- page_title:setFillColor(Utils.convertHexToRGB(color.Black))

	-- NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent , 0,0,0,0,native.systemFontBold,16)
	-- NoEvent.x=W/2;NoEvent.y=H/2
	-- NoEvent.isVisible=false
	-- NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )


	CreateAccountBtn = display.newRect(sceneGroup,0,0,W,35)
	CreateAccountBtn.x=W/2;CreateAccountBtn.y = H - 35
	CreateAccountBtn.width = W
	CreateAccountBtn.anchorY = 0
	CreateAccountBtn:setFillColor( 0,0,0,0.4 )
	CreateAccountBtn.id="create_account"

	CreateAccountBtn_text = display.newText(sceneGroup,RegistrationScreen.CreateAccount,0,0,native.systemFont,16)
	CreateAccountBtn_text.anchorX = 0
	CreateAccountBtn_text.anchorY = 0
	CreateAccountBtn_text.x=CreateAccountBtn.x-65
	CreateAccountBtn_text.y=CreateAccountBtn.y+8
	CreateAccountBtn_text:setFillColor(0)


    MainGroup:insert(sceneGroup)

end





function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		Runtime:addEventListener( "key", onKeyEvent )


				function createAccount( event )

					if event.phase == "began" then

							display.getCurrentStage():setFocus( event.target )

					elseif event.phase == "ended" then

							display.getCurrentStage():setFocus( nil )

							if event.target.id == "create_account" then

								
										backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
										backBtn_bg.x=25;backBtn_bg.y=BgText.y+BgText.contentHeight/2+26
										backBtn_bg.alpha=0.01

										backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
										backBtn.x=20;backBtn.y=BgText.y+BgText.contentHeight/2+20
										backBtn.xScale=-1
										backBtn.anchorY=0
										backBtn:setFillColor(0)

										page_title = display.newText(sceneGroup,"Registration",0,0,native.systemFont,18)
										page_title.x=backBtn.x+18;page_title.y=backBtn.y+8
										page_title.anchorX=0
										page_title:setFillColor(Utils.convertHexToRGB(color.Black))

										CreateAccountBtn.isVisible = false
										CreateAccountBtn_text.isVisible = false



								-------------------------------------- first name -------------------------------------------

										FirstName_bg = display.newRect(W/2, page_title.y+35, W-20, 25)
										FirstName_bg.y =  page_title.y+35
										FirstName_bg.alpha = 0.01
										sceneGroup:insert(FirstName_bg)


										FirstName = native.newTextField(W/2+3, page_title.y+35, W-20, 25)
										FirstName.id="First Name"
										FirstName.size=14	
										FirstName.y =  page_title.y+35
										FirstName.hasBackground = false
										FirstName:setReturnKey( "next" )
										FirstName.placeholder=RequestAccess.FirstName_placeholder
										sceneGroup:insert(FirstName)

										FirstName_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										FirstName_bottom.x=W/2
										FirstName_bottom.y= FirstName.y+13

								-------------------------------------Last name ----------------------------------------------

										Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
										Name_bg.y = FirstName_bg.y+FirstName_bg.height+7
										Name_bg.alpha = 0.01
										sceneGroup:insert(Name_bg)

									
										Name = native.newTextField( W/2+3, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
										Name.id="Last Name"
										Name.y = FirstName_bg.y+FirstName_bg.height+7
										Name.size=14
										Name:setReturnKey( "next" )
										Name.hasBackground = false	
										Name.placeholder = RequestAccess.LastName_placeholder
										sceneGroup:insert(Name)

										Name_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Name_bottom.x=W/2
										Name_bottom.y= Name.y+13



								----------------------------------Email address---------------------------------
										Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+7, W-20, 25 )
										Email_bg.alpha = 0.01
										sceneGroup:insert(Email_bg)


										Email = native.newTextField(W/2+3, Name_bg.y+Name_bg.height+7, W-20, 25 )
										Email.id="Email"
										Email.size=14	
										Email:setReturnKey( "next" )
										Email.hasBackground = false
										Email.placeholder=RequestAccess.EmailAddress_placeholder
										sceneGroup:insert(Email)


										Email_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Email_bottom.x=W/2
										Email_bottom.y= Email.y+13


								-----------------------------------phone------------------------------------------
										Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.height+7, W-20, 25)
										Phone_bg.alpha = 0.01
										sceneGroup:insert(Phone_bg)

									
										Phone = native.newTextField(W/2+3, Email_bg.y+Email_bg.height+7, W-20, 25)
										Phone.id="Phone"
										Phone.size=14	
										Phone:setReturnKey( "next" )
										Phone.hasBackground = false
										Phone.placeholder=RequestAccess.Phone_placeholder
										Phone.inputType = "number"
										sceneGroup:insert(Phone)


										Phone_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Phone_bottom.x=W/2
										Phone_bottom.y= Phone.y+13


								-----------------------------------Marykay_id------------------------------------------

										Marykay_id = display.newText(sceneGroup,"Mary Kay Id",0,0,native.systemFont,14)
										Marykay_id.x=13;Marykay_id.y=Phone_bottom.y+18
										Marykay_id.anchorX=0
										Marykay_id:setFillColor(Utils.convertHexToRGB(color.Black))


									    Marykay_id_helptext = display.newText(sceneGroup,"http://www.marykay.com/",0,0,native.systemFont,12)
										Marykay_id_helptext.x=13;Marykay_id_helptext.y=Marykay_id.y+20
										Marykay_id_helptext.anchorX=0
										Marykay_id_helptext:setFillColor(Utils.convertHexToRGB(color.Black))


										Marykay_bg = display.newRect(W/2, Marykay_id_helptext.y+Marykay_id_helptext.height+12, W-20, 25)
										Marykay_bg.alpha = 0.01
										sceneGroup:insert(Marykay_bg)

										Marykay = native.newTextField(W/2+3, Marykay_id_helptext.y+Marykay_id_helptext.height+12, W-20, 25)
										Marykay.id="Marykay_Id"
										Marykay.size=14	
										Marykay:setReturnKey( "next" )
										Marykay.hasBackground = false
										sceneGroup:insert(Marykay)

										Marykay_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Marykay_bottom.x=W/2
										Marykay_bottom.y= Marykay.y+13


							    ------------------------------   Country and its dropdown   --------------------------------



							            Country_bg = display.newRect(W/2, Marykay_bg.y+Marykay_bg.height+12, W-20, 28)
										Country_bg.alpha = 0.01
										Country_bg.id = "country_bg"
										Country_bg:addEventListener( "touch", TouchAction )
										sceneGroup:insert(Country_bg)


										Countrytxt = display.newText(sceneGroup,"Country",13,Marykay_bg.y+Marykay_bg.height+12,native.systemFont,14 )
										Countrytxt.anchorX=0
										Countrytxt.value=0
										Countrytxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
										Countrytxt.x=leftPadding
										Countrytxt.y=Marykay_bg.y+Marykay_bg.height+12


										Country_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Country_bottom.x=W/2
										Country_bottom.y= Countrytxt.y+13


										CountryLbl = display.newText(sceneGroup,"USA",W/2,Marykay_bg.y+Marykay_bg.height+12,native.systemFont,14 )
										CountryLbl.anchorX=0
										CountryLbl.value=0
										CountryLbl.id="country_name"
										CountryLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
										CountryLbl.x=W/2 - 10
										CountryLbl.y=Marykay_bg.y+Marykay_bg.height+12


									    Country_icon = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
									  	Country_icon.x=W-20
									  	Country_icon:setFillColor(0)
									  	Country_icon.y=Marykay_bg.y+Marykay_bg.height+12





								 ------------------------------   Language and its dropdown   --------------------------------


							            Language_bg = display.newRect(W/2, Country_bg.y+Country_bg.height+12, W-20, 28)
										Language_bg.alpha = 0.01
										sceneGroup:insert(Language_bg)

										Languagetxt = display.newText(sceneGroup,"Language",13,Country_bg.y+Country_bg.height+12,native.systemFont,14 )
										Languagetxt.anchorX=0
										Languagetxt.value=0
										Languagetxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
										Languagetxt.x=leftPadding
										Languagetxt.y=Country_bg.y+Country_bg.height+12

										Language_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Language_bottom.x=W/2
										Language_bottom.y= Languagetxt.y+13


										LanguageLbl = display.newText(sceneGroup,"- Select Language -",W/2,Country_bg.y+Country_bg.height+12,native.systemFont,14 )
										LanguageLbl.anchorX=0
										LanguageLbl.value=0
										LanguageLbl.id="language"
										LanguageLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
										LanguageLbl.x=W/2 - 12
										LanguageLbl.y=Country_bg.y+Country_bg.height+12


									    Language_icon = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
									  	Language_icon.x=W-20
									  	Language_icon:setFillColor(0)
									  	Language_icon.y=Country_bg.y+Country_bg.height+12


								 ------------------------------   Country and its dropdown   --------------------------------


							            Position_bg = display.newRect(W/2, Language_bg.y+Language_bg.height+12, W-20, 28)
										Position_bg.alpha = 0.01
										sceneGroup:insert(Position_bg)

										Positiontxt = display.newText(sceneGroup,"Position",13,Language_bg.y+Language_bg.height+12,native.systemFont,14 )
										Positiontxt.anchorX=0
										Positiontxt.value=0
										Positiontxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
										Positiontxt.x=leftPadding
										Positiontxt.y=Language_bg.y+Language_bg.height+12

										Position_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
										Position_bottom.x=W/2
										Position_bottom.y= Positiontxt.y+13


										PositionLbl = display.newText(sceneGroup,"- Select Position -",W/2,Language_bg.y+Language_bg.height+12,native.systemFont,14 )
										PositionLbl.anchorX=0
										PositionLbl.value=0
										PositionLbl.id="position"
										PositionLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
										PositionLbl.x=W/2 - 12
										PositionLbl.y=Language_bg.y+Language_bg.height+12


									    Position_icon = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
									  	Position_icon.x=W-20
									  	Position_icon:setFillColor(0)
									  	Position_icon.y=Language_bg.y+Language_bg.height+12



								  ---------------------    submit button   ---------------------------------------------------


										registerBtn = display.newRect( 0,0,0,0 )
										registerBtn.x=W/2-15;registerBtn.y = Position_bg.y+Position_bg.height/2+40
										registerBtn.width=100
										registerBtn.height=30
										registerBtn.anchorX=0
										registerBtn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
										sceneGroup:insert(registerBtn)
										registerBtn.id="Register"


										registerBtn_lbl = display.newText( sceneGroup,"Register",0,0,native.systemFont,16 )
										registerBtn_lbl.y=registerBtn.y
										registerBtn_lbl.anchorX=0

										registerBtn.width = registerBtn_lbl.contentWidth+15
										registerBtn.x=W/2-registerBtn.contentWidth/2
										registerBtn_lbl.x = registerBtn.x+5



										local options = {
										    width = 25,
										    height = 25,
										    numFrames = 4,
										    sheetContentWidth = 50,
										    sheetContentHeight = 50
										}

										local submit_spinnerSingleSheet = graphics.newImageSheet( "res/assert/requestProcess.png", options )

										submit_spinner = widget.newSpinner
										{
										    width = 25,
										    height = 25,
										    deltaAngle = 10,
										    sheet = submit_spinnerSingleSheet,
										    startFrame = 1,
										    incrementEvery = 20
										}


										submit_spinner.isVisible=false
										submit_spinner.x=registerBtn_lbl.x+registerBtn_lbl.contentWidth+15
										submit_spinner.y=registerBtn.y

										--registerBtn:addEventListener( "touch", sumbitBtnRelease )


										-- cancelBtn = display.newRect( 0,0,0,0 )
										-- cancelBtn.x=W/2;cancelBtn.y = Position_bg.y+Position_bg.height/2+30
										-- cancelBtn.width=100
										-- cancelBtn.height=30
										-- cancelBtn.anchorX=0
										-- cancelBtn:setFillColor( 0,0,0.5 )
										-- sceneGroup:insert(cancelBtn)
										-- cancelBtn.id="Register"


										-- cancelBtn_lbl = display.newText( sceneGroup,"Cancel",0,0,native.systemFont,13 )
										-- cancelBtn_lbl.y=registerBtn.y
										-- cancelBtn_lbl.x = W - 55
										-- cancelBtn_lbl:setFillColor( 0,0,0.5 )
										-- cancelBtn_lbl.anchorX=0


										backBtn_bg:addEventListener("touch",backAction)
		                                page_title:addEventListener("touch",backAction)




									  	List_bg = display.newRect( sceneGroup, 200, 200, 104, 304 )
										List_bg:setFillColor( 0 )


									  	List = widget.newTableView(
										    {
										        left = 200,
										        top = 200,
										        height = 100,
										        width = 300,
										        onRowRender = onRowRender,
										        onRowTouch = onRowTouch,
										        hideBackground = true,
										        isBounceEnabled = false,
										        noLines = true,

										       -- listener = scrollListener
										    }
										)

									  	List.anchorY=0
									  	List.isVisible = false

									  	List_bg.anchorY = 0
									  	List_bg.isVisible = false
				







							end

					end

				return true

				end



		CreateAccountBtn:addEventListener("touch",createAccount)
		
	end	
	
MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		Runtime:removeEventListener( "key", onKeyEvent )

		CreateAccountBtn:removeEventListener("touch",createAccount)


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