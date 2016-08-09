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

		if "*" == event.target.text:sub(1,1) then
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
							SetError(LoginPage.setError_Unitnumber,UnitnumberField)
						end
					end



					if UserName.text == "" then


						validation=false
						SetError(LoginPage.setError_UserName,UserName)
					else

						if not Utils.emailValidation(UserName.text) then
							validation=false
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

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=5;BgText.y=20
	BgText.anchorX=0

	backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
	backBtn_bg.x=25;backBtn_bg.y=tabBar.y+tabBar.contentHeight+5
	backBtn_bg.alpha=0.01

	backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
	backBtn.x=20;backBtn.y=tabBar.y+tabBar.contentHeight+5
	backBtn.xScale=-1



	page_title = display.newText(sceneGroup,ForgotPassword.PageTitle,0,0,native.systemFont,18)
	page_title.x=backBtn.x+18;page_title.y=backBtn.y
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))


	UnitNumber_bg = display.newRect(sceneGroup, W/2, H/2-120, W-60, EditBoxStyle.height)
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

		UnitnumberField = native.newTextField(W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth-50, UnitNumber_bg.contentHeight )
		UnitnumberField.id = "Unit Number / Director name"
		UnitnumberField.anchorX=0
		UnitnumberField.placeholder=LoginPage.Unitnumber_placeholder
		UnitnumberField.value=""
		UnitnumberField.size=14
		UnitnumberField:setReturnKey( "next" )
		UnitnumberField.hasBackground=false
		sceneGroup:insert(UnitnumberField)
		UnitnumberField.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+40;UnitnumberField.y=UnitNumber_bg.y

	end
	

	UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+38;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UserName_drawLeft.x=UserName_bg.x-UserName_bg.contentWidth/2+UserName_drawLeft.contentWidth;UserName_drawLeft.y=UserName_bg.y

	UserName = native.newTextField( W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth-50, UnitNumber_bg.contentHeight )
	UserName.id = "Username / Email"
	UserName.anchorX=0
	UserName.hasBackground=false
	UserName.value=""
	UserName.size=14
	UserName:setReturnKey( "done" )
	UserName.placeholder=LoginPage.UserName_placeholder
	sceneGroup:insert(UserName)
	UserName.x=UserName_bg.x-UserName_bg.contentWidth/2+40;UserName.y=UserName_bg.y

	
	signinBtn = display.newRect(sceneGroup,0,0,W-60,35)
	signinBtn.x=W/2;signinBtn.y = UserName_bg.y+48
	signinBtn.width = W-180
	sceneGroup:insert(signinBtn)
	signinBtn.id="signin"
	signinBtn:setFillColor( Utils.convertHexToRGB(sp_primarybutton.Background_Color) )
	signinBtn_text = display.newText(sceneGroup,CommonWords.submit,0,0,native.systemFont,16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y

	signinBtn.action=true
	signinBtn_text.action=true


	requestBtn = display.newText(sceneGroup,LoginPage.Request_Button,0,0,native.systemFont,16)
	requestBtn.x=W/2
	requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+20
	requestBtn:setFillColor(Utils.convertHexToRGB(color.blue))
	requestBtn.id="request"
	--requestBtn.isVisible=false

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
		requestBtn:addEventListener("touch",touchAction)
		signinBtn:addEventListener("touch",signinBtnRelease)
		signinBtn_text:addEventListener("touch",signinBtnRelease)
		backBtn_bg:addEventListener("touch",backAction)
		page_title:addEventListener("touch",backAction)

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