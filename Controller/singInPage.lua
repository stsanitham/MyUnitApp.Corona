----------------------------------------------------------------------------------
--
-- SingIn Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local outerGroup = display.newGroup()
local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

--Display object--
local Background,BgText

--TextField--
local UnitNumber,UserName,Password

--Button--
local forgettBtn,signinBtn,requestBtn



--------------------------------------------------


-----------------Function-------------------------


local function textListener( event )

    if ( event.phase == "began" ) then

		if event.target.id == "password" then
			event.target.isSecure = true
		end

    	event.target.text=""
		event.target:resizeFontToFitHeight()
		event.target:setTextColor(color.black)

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
      

    elseif ( event.phase == "editing" ) then
      
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

local validation = true
native.setKeyboardFocus(nil)

	if UnitNumber.text == "" then
		validation=false
		SetError("* Enter the Unit Number",UnitNumber)
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
			composer.gotoScene( "Controller.eventCalenderPage", "slideLeft", Splash_TimeOut )

	end


end

local function touchAction( event )

	if event.phase == "began" then
		event.target.alpha = 0.5
        display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then
		event.target.alpha = 1
		display.getCurrentStage():setFocus( nil )

		if event.target.id == "forget" then

		

		elseif event.target.id == "request" then

		

		end

	end

return true
end 


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newRect(sceneGroup,W/2,H/2,W,H)

	BgText = display.newText(sceneGroup,"MyUnit App",0,0,native.systemFont,integer.TITLE_TEXT_SIZE)
	BgText:setFillColor( Utils.convertHexToRGB(color.black))
	BgText.x=15;BgText.y=15
	BgText.anchorX=0;BgText.anchorY=0


UnitNumber_bg = display.newRect(sceneGroup, W/2, H/2-120, W-20, 30)
UnitNumber_bg.fill = { type="image", filename="res/assert/textfield.jpg" }

UnitNumber = native.newTextField(UnitNumber_bg.x,UnitNumber_bg.y,UnitNumber_bg.contentWidth,UnitNumber_bg.contentHeight )
UnitNumber.hasBackground = false
UnitNumber.placeholder = "Unit Number / Director name"
UnitNumber:resizeFontToFitHeight()
sceneGroup:insert(UnitNumber)


UserName_bg = display.newRect(sceneGroup, W/2, UnitNumber.y+UnitNumber.contentHeight/2+35, W-20, 30 )
UserName_bg.fill = { type="image", filename="res/assert/textfield.jpg" }

UserName = native.newTextField( UserName_bg.x,UserName_bg.y,UserName_bg.contentWidth,UserName_bg.contentHeight )
UserName.hasBackground = false
UserName.placeholder = "User Name or Email address"
UserName:resizeFontToFitHeight()
sceneGroup:insert(UserName)


Password_bg = display.newRect(sceneGroup, W/2, UserName.y+UserName.contentHeight/2+35, W-20, 30)
Password_bg.fill = { type="image", filename="res/assert/textfield.jpg" }

Password = native.newTextField( Password_bg.x,Password_bg.y,Password_bg.contentWidth,Password_bg.contentHeight )
Password.hasBackground = false
Password.placeholder = "Password"
Password.id="password"
Password:resizeFontToFitHeight()
sceneGroup:insert(Password)

forgettBtn = display.newText(sceneGroup,"Forget?",0,0,native.systemFont,FontSize)
forgettBtn.x=Password.x+Password.contentWidth/2-forgettBtn.contentWidth/2
forgettBtn.y=Password.y+Password.contentHeight/2+20
forgettBtn:setFillColor(Utils.convertHexToRGB(color.blue))
forgettBtn.id="forget"


signinBtn = widget.newButton
{
	defaultFile = "res/assert/signin.png",
	overFile = "res/assert/signinover.png",
	label = "Sign in",
	labelColor = 
	{ 
		default = { 1 },
	},
	emboss = true,
	onRelease = signinBtnRelease,
}
signinBtn.x=W/2;signinBtn.y = forgettBtn.y+25
sceneGroup:insert(signinBtn)
signinBtn.id="signin"


requestBtn = display.newText(sceneGroup,"Request Access",0,0,native.systemFont,FontSize)
requestBtn.x=W/2
requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+30
requestBtn:setFillColor(Utils.convertHexToRGB(color.blue))
requestBtn.id="request"


end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	elseif phase == "did" then

		forgettBtn:addEventListener("touch",touchAction)
		requestBtn:addEventListener("touch",touchAction)

		UnitNumber:addEventListener( "userInput", textListener )
		UserName:addEventListener( "userInput", textListener )
		Password:addEventListener( "userInput", textListener )
	end	

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