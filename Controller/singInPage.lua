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
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
require( "Webservice.ServiceManager" )


--------------- Initialization -------------------

local W = display.contentWidth;
local H = display.contentHeight
--Display object--
local Background,BgText

--Snack--
local Snack;

--TextField--
local Unitnumber_field,UserName,Password

--Button--
local forgettBtn,signinBtn,requestBtn

--------------------------------------------------

openPage="signInPage"


-----------------Function-------------------------


	local function touchBg( event )
		if event.phase == "began" then

			elseif event.phase == "ended" then

			native.setKeyboardFocus(nil)

		end
		return true
	end

	local function SetError( displaystring, object )

									if object.id == "Password" then
										object.isSecure = false
									end
									object.text=displaystring
									object.size=9
									object.alpha=1
									object:setTextColor(1,0,0)


	end


	local function loginProcess( Request_response )

		if Request_response.RequestAccessStatus == 5 then

			local UnitNumberOrDirectorName,EmailAddess,PhoneNumber,Status,UserId,GoogleUsername,GoogleTokenSecret,GoogleUserId,AccessToken
			local FacebookUsername,FacebookAccessToken
			local TwitterUsername,TwitterToken,TwitterTokenSecret
			local profileImageUrl,ContactId
			local ContactDisplay,LanguageId,CountryId


			if Request_response.MyUnitBuzzContacts.EmailAddress then

				local EmailTxt = Request_response.MyUnitBuzzContacts.EmailAddress

					if EmailTxt:len() > 26 then

						EmailTxt= EmailTxt:sub(1,26).."..."

					end


			end

		

			if Request_response.UnitNumber then
				UnitNumberOrDirectorName = Request_response.UnitNumber
			else
				UnitNumberOrDirectorName=""
			end



			if Request_response.MyUnitBuzzContacts.EmailAddress then

				EmailAddess = Request_response.MyUnitBuzzContacts.EmailAddress
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

			if Request_response.GoogleSettings.GoogleUsername ~= nil then

				GoogleUsername = Request_response.GoogleSettings.GoogleUsername

			else
				GoogleUsername=""
			end

			if Request_response.GoogleSettings.GoogleToken ~= nil then
				GoogleToken = Request_response.GoogleSettings.GoogleToken
			else
				GoogleToken=""
			end

			if Request_response.GoogleSettings.GoogleTokenSecret ~= nil then
				GoogleTokenSecret = Request_response.GoogleSettings.GoogleTokenSecret
			else
				GoogleTokenSecret=""
			end

			if Request_response.GoogleSettings.GoogleUserId ~= nil then

				GoogleUserId = Request_response.GoogleSettings.GoogleUserId
			else
				GoogleUserId=""
			end

	else

		GoogleUsername=""
		GoogleToken=""
		GoogleTokenSecret=""
		GoogleUserId=""

	end
	if Request_response.FacebookSettings then


			if Request_response.FacebookSettings.FacebookUsername ~= nil then
				FacebookUsername = Request_response.FacebookSettings.FacebookUsername
			else
				FacebookUsername=""
			end

			if Request_response.FacebookSettings.FacebookAccessToken ~= nil then
				FacebookAccessToken = Request_response.FacebookSettings.FacebookAccessToken
			else
				FacebookAccessToken=""
			end
	else

		FacebookUsername=""
		FacebookAccessToken=""

	end

	if Request_response.TwitterSettings then
			if Request_response.TwitterSettings.TwitterUsername ~= nil then
				TwitterUsername = Request_response.TwitterSettings.TwitterUsername
			else
				TwitterUsername=""
			end

			if Request_response.TwitterSettings.TwitterToken ~= nil then
				TwitterToken = Request_response.TwitterSettings.TwitterToken
			else
				TwitterToken=""
			end

			if Request_response.TwitterSettings.TwitterTokenSecret ~= nil then
				TwitterTokenSecret = Request_response.TwitterSettings.TwitterTokenSecret
			else
				TwitterTokenSecret=""
			end

	else

		TwitterUsername=""
		TwitterToken=""
		TwitterTokenSecret=""

	end  

	if Request_response.MyUnitBuzzContacts then

			if Request_response.MyUnitBuzzContacts.ImagePath ~= nil then
				profileImageUrl = Request_response.MyUnitBuzzContacts.ImagePath
			else
				profileImageUrl=""
			end
	else
				profileImageUrl=""
	end

				if Request_response.MyUnitBuzzUserSetting.ContactDisplay ~= nil then
				ContactDisplay = Request_response.MyUnitBuzzUserSetting.ContactDisplay
			else
				ContactDisplay=""
			end

			if Request_response.MyUnitBuzzUserSetting.LanguageId ~= nil then
				LanguageId = Request_response.MyUnitBuzzUserSetting.LanguageId
			else
				LanguageId=""
			end

			if Request_response.MyUnitBuzzUserSetting.CountryId ~= nil then
				CountryId = Request_response.MyUnitBuzzUserSetting.CountryId
			else
				CountryId=""
			end
			

			FirstName = Request_response.MyUnitBuzzContacts.FirstName


			Director_Name = Request_response.MyUnitBuzzContacts.LastName
			
			

				if Request_response.MyUnitBuzzContacts.FirstName then

					Director_Name = Request_response.MyUnitBuzzContacts.FirstName.." "..Request_response.MyUnitBuzzContacts.LastName

				end

			

			Director_Name = string.gsub( Director_Name, "'", "''" )


			local tablesetup = [[DROP TABLE logindetails;]]
			db:exec( tablesetup )

			local tablesetup = [[CREATE TABLE IF NOT EXISTS logindetails (id INTEGER PRIMARY KEY autoincrement, UnitNumberOrDirector, EmailAddess, PhoneNumber, Status, UserId, GoogleUsername, GoogleToken, GoogleTokenSecret, GoogleUserId, FacebookUsername, FacebookAccessToken, TwitterUsername, TwitterToken, TwitterTokenSecret, ProfileImageUrl, AccessToken, ContactId, ContactDisplay, LanguageId, CountryId, MemberName, MemberEmail );]]
			db:exec( tablesetup )

			local insertQuery = [[INSERT INTO logindetails VALUES (NULL, ']]..UnitNumberOrDirectorName..[[',']]..EmailAddess..[[',']]..PhoneNumber..[[',']]..Status..[[',']]..UserId..[[',']]..GoogleUsername..[[',']]..GoogleToken..[[',']]..GoogleTokenSecret..[[',']]..GoogleUserId..[[',']]..FacebookUsername..[[',']]..FacebookAccessToken..[[',']]..TwitterUsername..[[',']]..TwitterToken..[[',']]..TwitterTokenSecret..[[',']]..profileImageUrl..[[',']]..AccessToken..[[',']]..ContactId..[[',']]..ContactDisplay..[[',']]..LanguageId..[[',']]..CountryId..[[',']]..Director_Name..[[',']]..Request_response.MyUnitBuzzContacts.EmailAddress..[[');]]
			db:exec( insertQuery )

			local options = {
			effect = "slideLeft",
			time =500,
			}


		composer.gotoScene( "Controller.flapMenu" )

		elseif(Request_response.RequestAccessStatus == 6) then



			if Request_response.FailStatus == "NOUNITNUMBER" then

					--local alert = native.showAlert(  ForgotPassword.PageTitle,LoginPage.ErrorMessage, { "OK" } )

					SetError(LoginPage.setError_Unitnumber,Unitnumber_field)


			else


				local alert = native.showAlert( LoginPage.ErrorTitle,LoginPage.ErrorMessage, { CommonWords.ok } )

			end


		end
	end

	local function signInRequest(  )

		local Request_response

		--native.setKeyboardFocus(nil)


		function get_loginresponse(response)

			loginProcess(response)

		end


		local Device_OS = system.getInfo("platformName")
		local Unique_Id = system.getInfo("deviceID")
		--local Manufacturer = system.getInfo("targetAppStore")
		local Model = system.getInfo("model")
		local Version = system.getInfo("appVersionString")
		local GCM = GCMValue


		if AppName == "DirectorApp" then

			Webservice.LOGIN_ACCESS(Device_OS,Unique_Id,Model,Version,GCM,Unitnumber_value,UserName.text,Password.text,get_loginresponse)
		else
			Webservice.LOGIN_ACCESS(Device_OS,Unique_Id,Model,Version,GCM,Unitnumber_field.text,UserName.text,Password.text,get_loginresponse)
		end



	end


	local function textfield( event )

		if ( event.phase == "began" ) then

			event.target:setTextColor(color.black)

			current_textField = event.target;


			current_textField.size=14

			if "*" == event.target.text:sub(1,1) then
				event.target.text=""
			end

			if(current_textField.id == "Password") then

				
						current_textField.isSecure=true


			end


			elseif  event.phase == "ended"  then


			elseif event.phase == "submitted" then


				if current_textField.id == "Unit Number / Director name" then

					native.setKeyboardFocus( nil )

					native.setKeyboardFocus( UserName )

				elseif current_textField.id == "User name or Email address" then

					native.setKeyboardFocus( nil )

					native.setKeyboardFocus( Password )

				elseif current_textField.id == "Password" then

					native.setKeyboardFocus( nil )

				end



	

			elseif ( event.phase == "editing" ) then
				

				if(current_textField.id == "Password") then

					

					if event.text:len() > 12 then

						event.target.text = event.text:sub(1,12)

					end

		

				end

						local dotFlag = string.find(event.text,"%.")

						if event.text == "" or dotFlag then
						
						end

						  	end

						  end





								


								local signinBtnRelease = function( event )

								if event.phase == "began" then
									display.getCurrentStage():setFocus( event.target )
									native.setKeyboardFocus(nil)
									elseif event.phase == "ended" then
									display.getCurrentStage():setFocus( nil )
									local validation = true


									if AppName ~= "DirectorApp" then
										if Unitnumber_field.text == "" or Unitnumber_field.text == Unitnumber_field.id or Unitnumber_field.text == LoginPage.setError_Unitnumber or Unitnumber_field.value == 0 then
											validation=false
											SetError(LoginPage.setError_Unitnumber,Unitnumber_field)
										end
									end


									if UserName.text == "" or UserName.text == UserName.id or UserName.text == LoginPage.setError_UserName then
										validation=false
										SetError(LoginPage.setError_UserName,UserName)

									else
										if not Utils.emailValidation(UserName.text) then
										validation=false
										SetError(LoginPage.setError_UserName,UserName)

									end

									end


									if Password.text == "" or Password.text == Password.id or Password.text == LoginPage.setError_Password or Password.text:len() < 6 then
										validation=false
										SetError(LoginPage.setError_Password,Password)

									end

									

									if(validation == true) then

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

										local options = {
										    effect = "slideLeft",
										    time = 600,
										}

										composer.gotoScene( "Controller.forgetPasswordPage", options )


										elseif event.target.id == "request" then

											local options = {
										    effect = "slideLeft",
										    time = 600,
										}

											composer.gotoScene( "Controller.request_Access_Page", options)

										end

									end

									return true
								end 

			local pushTest = function( event )
			    if notificationFlag == false then
			    	Unitnumber_field.isVisible=true
					UserName.isVisible=true
					Password.isVisible=true
			    else
			    	Unitnumber_field.isVisible=false
					UserName.isVisible=false
					Password.isVisible=false

			    end
			end


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	
	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	signinBanner = display.newImageRect(sceneGroup,"res/assert/banner.png",W,175)
	signinBanner.x=W/2;signinBanner.y=signinBanner.contentHeight/2

	signinBanner_text = display.newImageRect(sceneGroup,"res/assert/signin-page-logo.png",278/2,62/2)
	signinBanner_text.x=signinBanner.x;signinBanner_text.y=signinBanner.y

	signin_lbl = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,native.systemFont,sp_commonLabel.textSize)
	signin_lbl.x=signin_lbl.contentWidth/2+30;signin_lbl.y=signinBanner.y+signinBanner.contentHeight/2+30
	Utils.CssforTextView(signin_lbl,sp_header)	

	UnitNumber_bg = display.newRect(sceneGroup, W/2, H/2, W-60, EditBoxStyle.height)
	UnitNumber_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UnitNumber_bg.contentHeight)
	UnitNumber_seprator.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+35;UnitNumber_seprator.y=UnitNumber_bg.y
	UnitNumber_drawLeft = display.newImageRect(sceneGroup,"res/assert/unite-number.png",24/1.5,24/1.5)
	UnitNumber_drawLeft.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+UnitNumber_drawLeft.contentWidth;UnitNumber_drawLeft.y=UnitNumber_bg.y



	UserName_bg = display.newRect(sceneGroup, W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight )

	if AppName == "DirectorApp" then
		UnitNumber_bg.isVisible=false
		UnitNumber_seprator.isVisible=false
		UnitNumber_drawLeft.isVisible=false

		UserName_bg.x=UnitNumber_bg.x;UserName_bg.y=UnitNumber_bg.y
	else
		Unitnumber_field = native.newTextField(0, 0, W-100, EditBoxStyle.height)
		Unitnumber_field.id = "Unit Number / Director name"
		Unitnumber_field.placeholder = LoginPage.Unitnumber_placeholder
		Unitnumber_field.anchorX=0
		Unitnumber_field.size=14	
		Unitnumber_field.value=""
		Unitnumber_field:setReturnKey( "next" )
		--Utils.CssforTextField(Unitnumber_field,sp_fieldValue)	


		Unitnumber_field.hasBackground = false
		Unitnumber_field.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+40;Unitnumber_field.y=UnitNumber_bg.y
		sceneGroup:insert(Unitnumber_field)
	end

	UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+35;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UserName_drawLeft.x=UserName_bg.x-UserName_bg.contentWidth/2+UserName_drawLeft.contentWidth;UserName_drawLeft.y=UserName_bg.y

	UserName =  native.newTextField(0, 0, W-100, EditBoxStyle.height)
	UserName.id = "User name or Email address"
	UserName.placeholder = LoginPage.UserName_placeholder
	UserName.anchorX=0
	UserName.size=14
	UserName.value=""
	UserName:setReturnKey( "next" )
	UserName.hasBackground = false
	UserName.inputType = "email"
	sceneGroup:insert(UserName)
	UserName.x=UserName_bg.x-UserName_bg.contentWidth/2+40;UserName.y=UserName_bg.y

	Password_bg = display.newRect(sceneGroup, W/2, UserName_bg.y+UserName_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight)
	Password_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,Password_bg.contentHeight)
	Password_seprator.x=Password_bg.x-Password_bg.contentWidth/2+35;Password_seprator.y=Password_bg.y
	Password_drawLeft = display.newImageRect(sceneGroup,"res/assert/psw.png",24/1.5,24/1.5)

	Password_drawLeft.x=Password_bg.x-Password_bg.contentWidth/2+Password_drawLeft.contentWidth;Password_drawLeft.y=Password_bg.y

	Password = native.newTextField(0, 0, W-100, EditBoxStyle.height)
	Password.id = "Password"
	Password.anchorX=0
	Password.size=14
	Password.value=""
	Password:setReturnKey( "done" )
	Password.placeholder = LoginPage.Password_placeholder
	--Password.isSecure = true;	
	Password.hasBackground = false
	sceneGroup:insert(Password)
	Password.x=Password_bg.x-Password_bg.contentWidth/2+40;Password.y=Password_bg.y

	forgettBtn = display.newText(sceneGroup,LoginPage.Forget_Button,0,0,native.systemFont,12)
	forgettBtn.x=Password_bg.x+Password_bg.contentWidth/2-forgettBtn.contentWidth/2-5
	forgettBtn.y=Password_bg.y+Password_bg.contentHeight/2+10
	Utils.CssforTextView(forgettBtn,sp_labelName_small)	

	forgettBtn.id="forget"
	forgettBtn_drawLeft	= display.newImageRect(sceneGroup,"res/assert/forgot-psw.png",14,14)
	forgettBtn_drawLeft.x=forgettBtn.x-forgettBtn.contentWidth/2-forgettBtn_drawLeft.contentWidth/2-3;forgettBtn_drawLeft.y=forgettBtn.y


	signinBtn = display.newRect(sceneGroup,0,0,W-60,35)
	signinBtn.x=W/2;signinBtn.y = forgettBtn.y+38
	signinBtn.width = W-60
	signinBtn:setFillColor( Utils.convertHexToRGB(sp_primarybutton.Background_Color) )
	signinBtn.id="signin"

	signinBtn_text = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,native.systemFont,16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y
	Utils.CssforTextView(signinBtn_text,sp_primarybutton)	


	requestBtn = display.newText(sceneGroup,LoginPage.Request_Button,0,0,native.systemFont,14)
	requestBtn.x=W/2
	requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+40
	requestBtn:setFillColor(Utils.convertHexToRGB(color.blue))
	requestBtn.id="request"
	--requestBtn.isVisible=false

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	
		if event.params then
			list_response_total = event.params.responseValue
		end

		local Version = system.getInfo( "appVersionString" )

		local path = system.pathForFile( "version.txt", system.DocumentsDirectory )


		local file, errorString = io.open( path, "w" )

		if not file then
		    -- Error occurred; output the cause
		    print( "File error: " .. errorString )
		else
		    -- Write data to file
		    file:write( Version )
		    -- Close the file handle
		    io.close( file )
		end

		file = nil

		ga.enterScene("SignIn")

		elseif phase == "did" then

			composer.removeHidden()


			Unitnumber_field:addEventListener( "userInput", textfield )
			UserName:addEventListener( "userInput", textfield )
			Password:addEventListener( "userInput", textfield )

			Background:addEventListener("touch",touchBg)

			forgettBtn:addEventListener("touch",touchAction)
			requestBtn:addEventListener("touch",touchAction)

			signinBtn:addEventListener("touch",signinBtnRelease)
			signinBtn_text:addEventListener("touch",signinBtnRelease)


		
			Runtime:addEventListener( "enterFrame", pushTest )


		end	
	end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

				if event.phase == "will" then



				elseif phase == "did" then

					Runtime:removeEventListener( "enterFrame", pushTest )

					
					Background:removeEventListener("touch",touchBg)

					forgettBtn:removeEventListener("touch",touchAction)
					requestBtn:removeEventListener("touch",touchAction)

					signinBtn:removeEventListener("touch",signinBtnRelease)
					signinBtn_text:removeEventListener("touch",signinBtnRelease)



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