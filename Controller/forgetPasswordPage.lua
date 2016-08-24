----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local Utility = require( "Utils.Utility" )
require( "Webservice.ServiceManager" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local backBtn,UnitnumberField,UserName


--------------------------------------------------


-----------------Function-------------------------

local function bgTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		native.setKeyboardFocus(nil)
	end

	return true
end


local function SetError( displaystring, object )

	if object.id == "password" then
		object.isSecure = false
	end

	object.text=displaystring
	object.size=10
	object:setTextColor(1,0,0)

end


local function textfield( event )

	if ( event.phase == "began" ) then

		event.target:setTextColor(color.black)

		current_textField = event.target;

		current_textField.size=14	

		print(event.target.text)

		print(UserName_mandatory.text:sub(1,1))

		if "E" == event.target.text:sub(1,1) then
			event.target.text=""
		end


	elseif ( event.phase == "ended" ) then


	elseif (event.phase == "submitted" ) then

		if(current_textField.id == "Unit Number / Director name") then

			native.setKeyboardFocus( UserName )

		else

			native.setKeyboardFocus( nil )

		end
		

	elseif ( event.phase == "editing" ) then

		if(current_textField.id == "Unit Number / Director name") then


			if event.text:len() > 50 then

				event.target.text = event.text:sub(1,50)

			end

			local temp = event.text

			local tempvalue = temp:sub(temp:len(),temp:len())

			if(tempvalue == "(") then
				event.text = event.text:sub( 1, event.text:len()-1)
			end
		elseif (current_textField.id == "Username / Email") then
			if event.text:len() > 100 then

				event.target.text = event.text:sub(1,100)

			end
		end

	end

end



local function forgotAction( Request_response )

	if Request_response == "SUCCESS" then

		local alert = native.showAlert( ForgotPassword.PageTitle,ForgotPassword.SuccessMsg, { CommonWords.ok } )

		local options = {
			effect = "slideRight",
			time = 600,
			params = { responseValue=list_response_total}
		}
		composer.gotoScene( "Controller.singInPage", options )

	elseif Request_response == "NOUNITNUMBER" then

					--local alert = native.showAlert(  ForgotPassword.PageTitle,LoginPage.ErrorMessage, { "OK" } )

					UnitNumber_mandatory.isVisible = true

					SetError(LoginPage.setError_Unitnumber,UnitnumberField)


				else

					local alert = native.showAlert(  ForgotPassword.PageTitle,ForgotPassword.InvalidUser, { "OK" } )

				end

			end

			
			
			local function signInRequest(  )

				local Request_response

				native.setKeyboardFocus(nil)

				function get_forgotpassword( response )

					signinBtn.action=true
					signinBtn_text.action=true
					Request_response = response
					forgotAction(Request_response)
				end

				if AppName == "DirectorApp" then

					Webservice.Forget_Password(Unitnumber_value,UserName.text,get_forgotpassword)

				else

					Webservice.Forget_Password(UnitnumberField.text,UserName.text,get_forgotpassword)

				end

			end

			

			local function backAction( event )
				if event.phase == "began" then

					display.getCurrentStage():setFocus( event.target )

					elseif event.phase == "ended" then
					
					display.getCurrentStage():setFocus( nil )

					local options = {
						effect = "slideRight",
						time = 600,	  
					}

					composer.gotoScene( "Controller.singInPage", options )
				end

				return true

			end

			local signinBtnRelease = function( event )
				if event.phase == "began" then

					display.getCurrentStage():setFocus( event.target )
					if event.target.action == false then

						display.getCurrentStage():setFocus( nil )
						return false

					end

					elseif event.phase == "ended" then
					display.getCurrentStage():setFocus( nil )

					print( "sign in request" )
					signinBtn.action=false
					signinBtn_text.action=false

					local validation = true
					native.setKeyboardFocus(nil)

					if AppName ~= "DirectorApp" then

						if UnitnumberField.text == "" or UnitnumberField.text == nil then
							validation=false
							UnitNumber_mandatory.isVisible = true
							SetError(LoginPage.setError_Unitnumber,UnitnumberField)
						end
					end



					if UserName.text == "" then
						validation=false
						UserName_mandatory.isVisible = true
						SetError(LoginPage.setError_UserName,UserName)
					else

						if not Utils.emailValidation(UserName.text) then
							validation=false
							UserName_mandatory.isVisible = true
							SetError(LoginPage.setError_UserName,UserName)

						end
					end

					if(validation == true) then

						signInRequest()
					else
						signinBtn.action=true

					end


				end


				return true
			end

			local function touchAction( event )

				if event.phase == "began" then
					display.getCurrentStage():setFocus( event.target )
					elseif event.phase == "ended" then
					display.getCurrentStage():setFocus( nil )
					if event.target.id == "request" then

						local options = {
							effect = "slideLeft",
							time = 600,
						}

						composer.gotoScene( "Controller.request_Access_Page", options)
					end
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

						local options = {
							effect = "slideRight",
							time = 600,	  
						}

						composer.gotoScene( "Controller.singInPage", options )

						return true

					end
					
				end

				return false
			end




------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newRect(sceneGroup,0,0,W,H)
	Background.x=W/2;Background.y=H/2

	local signinBanner = display.newRect(sceneGroup,0,0,W,H/4)
	signinBanner.x=W/2;signinBanner.y=signinBanner.contentHeight/2
	signinBanner:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

	local signinBanner_text = display.newImageRect(sceneGroup,"res/assert/signin-page-logo.png",278/1.5,62/1.5)
	signinBanner_text.x=signinBanner.x;signinBanner_text.y=signinBanner.y


	local signinUser = display.newImageRect(sceneGroup,"res/assert/prof_img.png",80,80)
	signinUser.x = signinBanner.x+80;signinUser.y=signinBanner.y+signinBanner.contentHeight/2

	backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
	backBtn_bg.x=20;backBtn_bg.y=backBtn_bg.y+15
	backBtn_bg.alpha=0.01

	backBtn = display.newImageRect(sceneGroup,"res/assert/back_icon.png",36/2,30/2)
	backBtn.x=20;backBtn.y=backBtn_bg.y



	page_title = display.newText(sceneGroup,ForgotPassword.PageTitle:upper( ),0,0,"Roboto-Bold",18)
	page_title.x=20;page_title.y=signinBanner.y+signinBanner.contentHeight/2+30
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))


	UnitNumber_bg = display.newLine(sceneGroup, W/2-120, H/2-20, W/2+120, H/2-20)
	UnitNumber_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
	UnitNumber_bg.strokeWidth = 1
	--UnitNumber_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UnitNumber_bg.contentHeight)
	--UnitNumber_seprator.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+35;UnitNumber_seprator.y=UnitNumber_bg.y

	UnitNumber_drawLeft = display.newImageRect(sceneGroup,"res/assert/signin_img.png",74/2,63/2)
	UnitNumber_drawLeft.x=UnitNumber_bg.x+22;UnitNumber_drawLeft.y=UnitNumber_bg.y-22

	UnitNumber_mandatory = display.newText(sceneGroup,"*",0,0,"Roboto-Light",14)
	if isAndroid then
		UnitNumber_mandatory.x=UnitNumber_drawLeft.x+UnitNumber_drawLeft.contentWidth/2+15
		UnitNumber_mandatory.y=UnitNumber_bg.y-UnitNumber_mandatory.contentHeight/2-11
	elseif isIos then
		UnitNumber_mandatory.x=UnitNumber_drawLeft.x+UnitNumber_drawLeft.contentWidth/2+9
		UnitNumber_mandatory.y=UnitNumber_bg.y-UnitNumber_mandatory.contentHeight/2-9
	end
	UnitNumber_mandatory:setTextColor( 1, 0, 0 )


	UserName_bg = display.newLine(sceneGroup, W/2-120, UnitNumber_bg.y+50, W/2+120, UnitNumber_bg.y+50)
	UserName_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
	UserName_bg.strokeWidth = 1

	if AppName == "DirectorApp" then

		UnitNumber_bg.isVisible=false
		UnitNumber_seprator.isVisible=false
		UnitNumber_drawLeft.isVisible=false

		UserName_bg.x=UnitNumber_bg.x;UserName_bg.y=UnitNumber_bg.y
	else

		UnitnumberField = native.newTextField(W/2+29, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth-50,  EditBoxStyle.height+3 )
		UnitnumberField.id = "Unit Number / Director name"
		UnitnumberField.placeholder=LoginPage.Unitnumber_placeholder
		UnitnumberField.value=""
		UnitnumberField.font=native.newFont("Roboto-Light",14)
		UnitnumberField.y=UnitNumber_bg.y-16
		UnitnumberField:setReturnKey( "next" )
		UnitnumberField.hasBackground=false
		sceneGroup:insert(UnitnumberField)

	end
	

	--UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	--UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+38;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/gender_img.png",70/2,63/2)
	UserName_drawLeft.x=UserName_bg.x+22;UserName_drawLeft.y=UserName_bg.y-22

	UserName_mandatory = display.newText(sceneGroup,"*",0,0,"Roboto-Light",14)

	if isAndroid then
		UserName_mandatory.x=UserName_drawLeft.x+UserName_drawLeft.contentWidth/2+15
		UserName_mandatory.y=UserName_bg.y-UserName_mandatory.contentHeight/2-11
	elseif isIos then
		UserName_mandatory.x=UserName_drawLeft.x+UserName_drawLeft.contentWidth/2+9
		UserName_mandatory.y=UserName_bg.y-UserName_mandatory.contentHeight/2-9
	end

	UserName_mandatory:setTextColor( 1, 0, 0 )

	UserName = native.newTextField( W/2+28,0, UnitNumber_bg.contentWidth-50, EditBoxStyle.height+3 )
	UserName.id = "Username / Email"
	UserName.hasBackground=false
	UserName.value=""
	UserName.font=native.newFont("Roboto-Light",14)
	UserName:setReturnKey( "done" )
	UserName.y=UserName_bg.y-16
	UserName.placeholder=LoginPage.UserName_placeholder
	sceneGroup:insert(UserName)

	

	signinBtn = display.newImageRect(sceneGroup,"res/assert/white_btnbg.png",550/2,50)
	signinBtn.x=W/2;signinBtn.y = UserName.y+UserName.contentHeight+40
	signinBtn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
	signinBtn.id="signin"


	signinBtn_text = display.newText(sceneGroup,CommonWords.submit,0,0,"Roboto-Regular",16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y
	Utils.CssforTextView(signinBtn_text,sp_primarybutton)	



	signinBtn.action=true
	signinBtn_text.action=true


	requestBtn = display.newText(sceneGroup,LoginPage.Request_Button:upper( ),0,0,"Roboto-Bold",16)
	requestBtn.x=W/2
	requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+50
	requestBtn:setFillColor(Utils.convertHexToRGB(color.secondaryColor))
	requestBtn.id="request"
	--requestBtn.isVisible=false


	cancelBtn = display.newImageRect("res/assert/white_btnbg.png",550/5,50/2)
    cancelBtn.x=W/2;cancelBtn.y = requestBtn.y+35
    cancelBtn:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
    cancelBtn.alpha=0.2
    sceneGroup:insert(cancelBtn)
    cancelBtn.id="request"

    cancelBtn_lbl = display.newText( "Click Here",0,0,"Roboto-Regular",13 )
    cancelBtn_lbl.y= cancelBtn.y
    cancelBtn_lbl.x = cancelBtn.x
    cancelBtn_lbl.id = "request"
    cancelBtn_lbl:setFillColor( Utils.convertHexToRGB(color.Black)  )
    sceneGroup:insert(cancelBtn_lbl)

	MainGroup:insert(sceneGroup)

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		ga.enterScene("ForgotPassword")
		
	elseif phase == "did" then

		Background:addEventListener("touch",bgTouch)
		UnitnumberField:addEventListener( "userInput", textfield )
		UserName:addEventListener( "userInput", textfield )
		cancelBtn:addEventListener("touch",touchAction)
		signinBtn:addEventListener("touch",signinBtnRelease)
		signinBtn_text:addEventListener("touch",signinBtnRelease)
		--cancelBtn:addEventListener("touch",backAction)
		backBtn_bg:addEventListener("touch",backAction)

		Runtime:addEventListener( "key", onKeyEvent )


		composer.removeHidden()

	end	

	MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
	elseif phase == "did" then

		Runtime:removeEventListener( "key", onKeyEvent )

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