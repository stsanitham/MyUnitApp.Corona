----------------------------------------------------------------------------------
--
-- SingIn Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local outerGroup = display.newGroup()
local Utility = require( "Utils.Utility" )
local style = require("res.value.style")
local string = require("res.value.string")
require( "Parser.REQUEST_ACCESS" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local json = require("json")


--------------- Initialization -------------------

local W = display.contentWidth;
local H = display.contentHeight
local signInGroup = display.newGroup()
--Display object--
local Background,BgText

--Snack--
local Snack;

--TextField--
local UnitNumber,UserName,Password

--Button--
local forgettBtn,signinBtn,requestBtn



--------------------------------------------------


-----------------Function-------------------------

local function SnackFun( event )

	timer.cancel(event.source);event.source = nil

	for i=1,snackGroup.numChildren do
		snackGroup[snackGroup.numChildren]:removeSelf();snackGroup[snackGroup.numChildren]=nil
	end
end

local function touchBg( event )
	if event.phase == "began" then

		elseif event.phase == "ended" then

		native.setKeyboardFocus(nil)

	end
	return true
end

local function signInRequest(  )

	local Request_response

	spinner_show()
	
	if AppName == "DirectorApp" then

		Request_response = LOGIN_ACCESS(Unitnumber_value,UserName.text,Password.text)

		spinner_hide()

	else
		Request_response = LOGIN_ACCESS(UnitNumber.text,UserName.text,Password.text)


		spinner_hide()

	end


	if Request_response.RequestAccessStatus == 5 then

		local UnitNumberOrDirectorName,EmailAddess,PhoneNumber,Status,UserId,GoogleUsername,GoogleTokenSecret,GoogleUserId,AccessToken
		local FacebookUsername,FacebookAccessToken
		local TwitterUsername,TwitterToken,TwitterTokenSecret
		local profileImageUrl,ContactId

		if Request_response.UnitNumberOrDirectorName then
			UnitNumberOrDirectorName = Request_response.UnitNumberOrDirectorName
		else
			UnitNumberOrDirectorName=""
		end



		if Request_response.MyUnitBuzzContacts.EmailAddess then
			EmailAddess = Request_response.MyUnitBuzzContacts.EmailAddess
		else
			EmailAddess=""
		end

		if Request_response.MyUnitBuzzContacts.PhoneNumber then
			PhoneNumber = Request_response.MyUnitBuzzContacts.PhoneNumber
		else
			PhoneNumber=""
		end
		if Request_response.MyUnitBuzzContacts.Status then
			Status = Request_response.MyUnitBuzzContacts.Status
		else
			Status=""
		end
		print("User id : "..Request_response.UserAccess.UserId)
		if Request_response.UserAccess.UserId then
			UserId = Request_response.UserAccess.UserId
		else
			UserId=""
		end

		if Request_response.UserAccess.AccessToken then
			AccessToken = Request_response.UserAccess.AccessToken
		else
			AccessToken=""
		end


		if Request_response.UserAccess.ContactId then
			ContactId = Request_response.UserAccess.ContactId
		else
			ContactId=""
		end

		
		
		if Request_response.GoogleSettings ~= nil then
			GoogleUsername = Request_response.GoogleSettings.GoogleUsername
		else
			GoogleUsername=""
		end

		if Request_response.GoogleSettings ~= nil then
			GoogleToken = Request_response.GoogleSettings.GoogleToken
		else
			GoogleToken=""
		end

		if Request_response.GoogleSettings ~= nil then
			GoogleTokenSecret = Request_response.GoogleSettings.GoogleTokenSecret
		else
			GoogleTokenSecret=""
		end

		if Request_response.GoogleSettings ~= nil then
			GoogleUserId = Request_response.GoogleSettings.GoogleUserId
		else
			GoogleUserId=""
		end

		if Request_response.FacebookSettings ~= nil then
			FacebookUsername = Request_response.FacebookSettings.FacebookUsername
		else
			FacebookUsername=""
		end

		if Request_response.FacebookSettings ~= nil then
			FacebookAccessToken = Request_response.FacebookSettings.FacebookAccessToken
		else
			FacebookAccessToken=""
		end

		if Request_response.TwitterSettings ~= nil then
			TwitterUsername = Request_response.TwitterSettings.TwitterUsername
		else
			TwitterUsername=""
		end

		if Request_response.TwitterSettings ~= nil then
			TwitterToken = Request_response.TwitterSettings.TwitterToken
		else
			TwitterToken=""
		end

		if Request_response.TwitterSettings ~= nil then
			TwitterTokenSecret = Request_response.TwitterSettings.TwitterTokenSecret
		else
			TwitterTokenSecret=""
		end

		if Request_response.Profile.profileImageUrl ~= nil then
			profileImageUrl = Request_response.Profile.profileImageUrl
		else
			profileImageUrl=""
		end



		--[[print("EmailAddess : "..EmailAddess)
		print("PhoneNumber : "..PhoneNumber)
		print("Status : "..Status)
		print("UserId : "..UserId)
		print("GoogleUsername : "..GoogleUsername)
		print("GoogleTokenSecret : "..GoogleTokenSecret)
		print("GoogleUserId : "..GoogleUserId)
		print("FacebookUsername : "..FacebookUsername)
		print("FacebookAccessToken : "..FacebookAccessToken)
		print("TwitterToken : "..TwitterToken)
		print("TwitterTokenSecret : "..TwitterTokenSecret)
		--		print("profileImageUrl : "..profileImageUrl)]]

		local insertQuery = [[INSERT INTO logindetails VALUES (NULL, ']]..UnitNumberOrDirectorName..[[',']]..EmailAddess..[[',']]..PhoneNumber..[[',']]..Status..[[',']]..UserId..[[',']]..GoogleUsername..[[',']]..GoogleToken..[[',']]..GoogleTokenSecret..[[',']]..GoogleUserId..[[',']]..FacebookUsername..[[',']]..FacebookAccessToken..[[',']]..TwitterUsername..[[',']]..TwitterToken..[[',']]..TwitterTokenSecret..[[',']]..profileImageUrl..[[',']]..AccessToken..[[',']]..ContactId..[[');]]
		db:exec( insertQuery )

		print("after here")
		local options = {
		effect = "slideLeft",
		time =500,
		params = { Flag = "Login",value = Request_response }
	}


	composer.gotoScene( "Controller.LandingPage", options )
	elseif(Request_response.RequestAccessStatus == 6) then
		Utils.SnackBar(Request_response.FailStatus)

		SnackTimer = timer.performWithDelay( 1000, SnackFun )

	end

end

local function scroll(scroll_value)

	signInGroup.y=signInGroup.y+scroll_value

end

local function textListener( event )

	if ( event.phase == "began" ) then

		print("key")
		if event.target.id == "password" then
			scroll(-100)
			event.target.isSecure = true
		elseif event.target.id == "username" then
			scroll(-100)
		end

		event.target.text=""
		event.target:resizeFontToFitHeight()
		event.target:setTextColor(color.black)




	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		if event.target.id == "password" then
			scroll(100)
		elseif event.target.id == "username" then
			scroll(100)
		end

	elseif ( event.phase == "editing" ) then
			local myNum = 8 -- max characters 	
        	--print(string.len(event.text))

	end
	end


	local function SetError( displaystring, object )

		if object.id == "password" then
			object.isSecure = false
		end
		object.text=displaystring
		object.size=10
		object:setTextColor(1,0,0)


	end


	local signinBtnRelease = function( event )

	if event.phase == "began" then
		print("123")
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		local validation = true
		native.setKeyboardFocus(nil)

		if AppName ~= "DirectorApp" then
			--[[if Unitnumber.text == "" then
				validation=false
				SetError("* Enter the Unit Number",UnitNumber)
				end]]
			end

			if UserName.text == "" then
				validation=false
				SetError("* Enter the email",UserName)
			else

				if not Utils.emailValidation(UserName.text) then
					validation=false
					SetError("* Enter the valid email",UserName)

				end
			end

			if Password.text == "" then
				validation=false
				SetError("* Enter the password",Password)

			end

			if(validation == true) then
				print("sign in validation complete")

				signInRequest()

			end


		end



		return true
	end

	local function touchAction( event )

		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			if event.target.id == "forget" then



				elseif event.target.id == "request" then

					composer.gotoScene( "Controller.request_Access_Page", "slideLeft", 800 )

				end

			end

			return true
		end 


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	if event.params then

		print("sign in")

		Snack = event.params.Snack

		Utils.SnackBar(Snack)

		SnackTimer = timer.performWithDelay( 1000, SnackFun )

	end

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	signinBanner = display.newImageRect(sceneGroup,"res/assert/banner.png",W,175)
	signinBanner.x=W/2;signinBanner.y=signinBanner.contentHeight/2

	signinBanner_text = display.newText(sceneGroup,"My UnitBuzz",0,0,native.systemFontBold,26)
	signinBanner_text.x=signinBanner.x;signinBanner_text.y=signinBanner.y

	signin_lbl = display.newText(sceneGroup,"Sign In",0,0,native.systemFont,sp_commonLabel.textSize)
	signin_lbl.x=signin_lbl.contentWidth/2+30;signin_lbl.y=signinBanner.y+signinBanner.contentHeight/2+30
	signin_lbl:setFillColor( Utility.convertHexToRGB(sp_commonLabel.textColor))

	

	UnitNumber_bg = display.newRect(sceneGroup, W/2, H/2, W-60, EditBoxStyle.height)
	UnitNumber_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UnitNumber_bg.contentHeight)
	UnitNumber_seprator.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+35;UnitNumber_seprator.y=UnitNumber_bg.y
	UnitNumber_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UnitNumber_drawLeft.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+UnitNumber_drawLeft.contentWidth;UnitNumber_drawLeft.y=UnitNumber_bg.y



	UserName_bg = display.newRect(sceneGroup, W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight )

	if AppName == "DirectorApp" then
		UnitNumber_bg.isVisible=false
		UnitNumber_seprator.isVisible=false
		UnitNumber_drawLeft.isVisible=false

		UserName_bg.x=UnitNumber_bg.x;UserName_bg.y=UnitNumber_bg.y
	else

	end

	UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+35;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UserName_drawLeft.x=UserName_bg.x-UserName_bg.contentWidth/2+UserName_drawLeft.contentWidth;UserName_drawLeft.y=UserName_bg.y



	Password_bg = display.newRect(sceneGroup, W/2, UserName_bg.y+UserName_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight)
	Password_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,Password_bg.contentHeight)
	Password_seprator.x=Password_bg.x-Password_bg.contentWidth/2+35;Password_seprator.y=Password_bg.y
	Password_drawLeft = display.newImageRect(sceneGroup,"res/assert/psw.png",24/1.5,24/1.5)
	Password_drawLeft.x=Password_bg.x-Password_bg.contentWidth/2+Password_drawLeft.contentWidth;Password_drawLeft.y=Password_bg.y


	forgettBtn = display.newText(sceneGroup,LoginPage.Forget_Button,0,0,native.systemFont,12)
	forgettBtn.x=Password_bg.x+Password_bg.contentWidth/2-forgettBtn.contentWidth/2-5
	forgettBtn.y=Password_bg.y+Password_bg.contentHeight/2+10
	forgettBtn:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	forgettBtn.id="forget"
	forgettBtn_drawLeft	= display.newImageRect(sceneGroup,"res/assert/forgot-psw.png",14,14)
	forgettBtn_drawLeft.x=forgettBtn.x-forgettBtn.contentWidth/2-forgettBtn_drawLeft.contentWidth/2-3;forgettBtn_drawLeft.y=forgettBtn.y




	signinBtn = display.newImageRect(sceneGroup,"res/assert/signin.jpg",W-60,35)
	signinBtn.x=W/2;signinBtn.y = forgettBtn.y+38
	signinBtn.width = W-60
	sceneGroup:insert(signinBtn)
	signinBtn.id="signin"
	signinBtn_text = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,native.systemFont,16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y


	requestBtn = display.newText(sceneGroup,LoginPage.Request_Button,0,0,native.systemFont,16)
	requestBtn.x=W/2
	requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+20
	requestBtn:setFillColor(Utils.convertHexToRGB(color.blue))
	requestBtn.id="request"


	signInGroup:insert(sceneGroup)
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		UnitNumber = native.newTextField(UnitNumber_bg.x+20,UnitNumber_bg.y,UnitNumber_bg.contentWidth-40,UnitNumber_bg.contentHeight )
		UnitNumber.hasBackground = false
		UnitNumber.size = EditBoxStyle.textSize
		UnitNumber.placeholder = LoginPage.Unitnumber_placeholder

		sceneGroup:insert(UnitNumber)

		UserName = native.newTextField( UserName_bg.x+20,UserName_bg.y,UserName_bg.contentWidth-40,UserName_bg.contentHeight )
		UserName.id = "username"
		
		if AppName == "DirectorApp" then
			UnitNumber.isVisible = false
			UserName.x=UserName.x;UserName.y=UserName.y
		else
			UnitNumber.isVisible = true
		end

		UserName.hasBackground = false
		UserName.size = EditBoxStyle.textSize
		UserName.placeholder = LoginPage.UserName_placeholder
		sceneGroup:insert(UserName)

		Password = native.newTextField( Password_bg.x+20,Password_bg.y,Password_bg.contentWidth-40,Password_bg.contentHeight )
		Password.hasBackground = false
		Password.size = EditBoxStyle.textSize
		Password.placeholder = LoginPage.Password_placeholder
		Password.id="password"
		sceneGroup:insert(Password)


--[[UnitNumber.text = "12345"
UserName.text = "malarkodi.sellamuthu@w3magix.com"
Password.text = "123123"]]

		elseif phase == "did" then
			Background:addEventListener("touch",touchBg)

			forgettBtn:addEventListener("touch",touchAction)
			requestBtn:addEventListener("touch",touchAction)

			signinBtn:addEventListener("touch",signinBtnRelease)
			signinBtn_text:addEventListener("touch",signinBtnRelease)

			UnitNumber:addEventListener( "userInput", textListener )
			UserName:addEventListener( "userInput", textListener )
			Password:addEventListener( "userInput", textListener )
		end	
		signInGroup:insert(sceneGroup)
	end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


			elseif phase == "did" then

				forgettBtn:removeEventListener("touch",touchAction)
				requestBtn:removeEventListener("touch",touchAction)

				UnitNumber:removeEventListener( "userInput", textListener )
				UserName:removeEventListener( "userInput", textListener )
				Password:removeEventListener( "userInput", textListener )

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