----------------------------------------------------------------------------------
--
-- request access
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
require( "Webservice.ServiceManager" )
local scene = composer.newScene()
require( "Utils.Utility" )
local style = require("res.value.style")
local List_array = {}
local json = require("json")
local mkRank_id = 0
local current_textField,defalut
local rankGroup = display.newGroup()
local RequestFromStatus = ""
local unitnumberflag = false
require( "Controller.genericAlert" )

--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

--Display Object
local Background,BgText,tabBar,backBtn,page_title,MKRank,rankText_icon,sumbitBtn_lbl

--EditText Background
local FirstName_bg,Name_bg,Email_bg,Phone_bg,MKRank_bg,Comment_bg,DirectorName_bg,DirectorEmail_bg

--EditText
local FirstName,Name,Email,Phone,UnitNumber,Comment,DirectorName,DirectorEmail,UnitNumber_mandatory,Name_mandatory,Email_mandatory,Phone_mandatory,DirectorName_mandatory,DirectorEmail_mandatory

--Spinner
local submit_spinner

--Button
local sumbitBtn,scrollView

openPage="requestAccessPage"

--Rank group
local rankList,rankTop,rankClose,rankText

--Bollean
local listFlag= false

--------------------------------------------------


-----------------Function-------------------------

local function rankToptouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		if event.target.id == "close" then
			rankGroup.isVisible=false

			FirstName.isVisible=true
			Name.isVisible=true
			Email.isVisible=true
			Phone.isVisible=true
			UnitNumber.isVisible=true
			Comment.isVisible=true
			DirectorName.isVisible = true
			DirectorEmail.isVisible = true


			if unitnumberflag == true then

				DirectorName.isVisible = true
				DirectorEmail.isVisible = true

			end

		end

	end

	return true
end

local function touchBg( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
			native.setKeyboardFocus(nil)

	end
	return true
end

local function backAction( event )
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )
		local options = {
			effect = "slideRight",
			time = 600,
			params = { responseValue=list_response_total}
		}
		composer.gotoScene( "Controller.singInPage", options )

		
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


local function alertFun(value,flag)


	local function onComplete( event )

		
		--if event.action == "clicked" then
			local i = event
			if i == 1 then  

				if flag == 1 then

					local options = {
						effect = "slideRight",
						time = 600,
						params = { responseValue=list_response_total}
					}
					composer.gotoScene( "Controller.singInPage", options )

				end
				
			end
		--end
	end

	UnitNumber.isVisible=false;FirstName.isVisible=false;Name.isVisible=false;Email.isVisible=false
	Phone.isVisible=false;Comment.isVisible=false;DirectorName.isVisible=false;DirectorEmail.isVisible=false

	local option ={
					{content=CommonWords.ok,positive=true},
				}
	genericAlert.createNew( RequestAccess.PageTitle, value,option,onComplete)

	--local alert = native.showAlert( RequestAccess.PageTitle , value, { CommonWords.ok }, onComplete )

end	



local function createField()

	
	native.setKeyboardFocus(nil)
	input = native.newTextField(W/2+3, Email_bg.y+Email_bg.height+7, W-20, 25)
	
	return input
end



local function RequestProcess()

	if  submit_spinner.isVisible == false then

		submit_spinner.isVisible=true
		--sumbitBtn.width = sumbitBtn.contentWidth+20
		sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
		submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15

		--sumbitBtn.width = sumbitBtn_lbl.contentWidth+40
		--sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
		sumbitBtn_lbl.x = sumbitBtn.x
		submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15

		submit_spinner:start( )


		function get_requestAccess(response)

			Request_response = response

			print("response after unit number validation ",Request_response)

			submit_spinner.isVisible=false
			--sumbitBtn.width = sumbitBtn_lbl.width+20
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
			--sumbitBtn.width = sumbitBtn_lbl.contentWidth+15
			--sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
			sumbitBtn_lbl.x = sumbitBtn.x

			submit_spinner:stop( )

			UnitNumber.text = ""
			DirectorName.text = ""
			DirectorEmail.text = ""
			FirstName.text = ""
			Name.text = ""
			Email.text = ""
			Phone.text = ""
			MKRank.text = RequestAccess.MKRank_placeholder
			MKRank.value = RequestAccess.MKRank_placeholder
			Comment.text = ""

			
			if Request_response == "REQUEST"  then

				alertFun(RequestAccess.REQUEST,0)

			elseif Request_response == "FIRSTREQUEST" then

				alertFun(RequestAccess.FIRSTREQUEST,1)

			elseif Request_response == "MUBNOTAGREE" then

				alertFun(RequestAccess.MUBNOTAGREE,1)	

			elseif Request_response == "OPEN" then

				alertFun(RequestAccess.OPEN,1)
				
			elseif Request_response == "GRANT" then

				alertFun(RequestAccess.GRANT,1)

			elseif Request_response == "SUCCESS" then

				alertFun(RequestAccess.FIRSTREQUEST,1)

			elseif Request_response == "NOUNITNUMBER" then

				SetError(RequestAccess.NOUNITNUMBER,UnitNumber)

			elseif Request_response == "BLOCK"  then

				alertFun(RequestAccess.BLOCK,0)

			elseif Request_response == "DENY" then

				alertFun(RequestAccess.DENY,0)

			elseif Request_response == "FAIL" then

				alertFun(RequestAccess.FAIL,0)
			end

		end

		print("unit number@@@@@@@@@@@@@@@@@@@@@@@ : "..UnitNumber.text)
		
		if AppName == "DirectorApp" then

			print("Open page name : "..openPage)

			Webservice.REQUEST_ACCESS(openPage,RequestFromStatus,"","","","",FirstName.text,Name.text,Email.text,Phone.text,UnitNumber.text,"",mkRank_id,Comment.text,"",get_requestAccess)

		else
			Webservice.REQUEST_ACCESS(openPage,RequestFromStatus,"","",DirectorName.text,DirectorEmail.text,FirstName.text,Name.text,Email.text,Phone.text,UnitNumber.text,"",mkRank_id,Comment.text,"",get_requestAccess)
			
		end

	end

end



function NO_UNITNUMBER_FUNCTION(responseUnitValue,directorname,directoremail)

	print("inside the function of 'has no unit number' ")

	DirectorName_bg.isVisible = true
	DirectorName.isVisible = true
	DirectorEmail.isVisible = true
	DirectorEmail_bg.isVisible = true

	if directorname == nil and directoremail == nil then

		print("both the values are nil")

		DirectorName.text = ""

		DirectorEmail.text = ""

	end


end



function HAS_UNITNUMBER_FUNCTION(responseUnitValue,directorname,directoremail)

	print("inside the function of 'has unit number'")

	DirectorName_bg.isVisible = true
	DirectorName.isVisible = true
	DirectorEmail.isVisible = true
	DirectorEmail_bg.isVisible = true

	
	DirectorName:setTextColor(0)
	DirectorName.size=14
	DirectorEmail:setTextColor(0)
	DirectorEmail.size=14
	DirectorName.text = directorname
	print(DirectorName.text)
	DirectorEmail.text = directoremail
	print(DirectorEmail.text)


	
	
	            --validationCheck()

	        end



	        function getunitnumberresponse(response)

	        	Request_response = response

	        	RequestFromStatus = Request_response.RequestAccessStatus

	        	print(RequestFromStatus)


	        	directorname = Request_response.DirectorName

	        	directoremail = Request_response.EmailAddress

	        	print(directorname)

	        	print(directoremail)


	        	if Request_response.RequestAccessStatus == "NOTINUNITWISE" then

	        		NO_UNITNUMBER_FUNCTION(RequestFromStatus,directorname,directoremail)
	        		unitnumberflag = true

						-- if (FirstName.text~=nil or FirstName.text ~="") or (Name.text ~=nil or Name.text ~="")

						-- or (Email.text~=nil or Email.text ~="") or (DirectorName.text ~=nil or DirectorName.text ~="") or (DirectorEmail.text ~=nil or DirectorEmail.text ~="") then

						-- FirstName.text = ""

						-- Name.text = ""

						-- Email.text = ""

						-- DirectorName.text = ""

						-- DirectorEmail.text = ""

						-- end	

					elseif Request_response.RequestAccessStatus == "UNITNOEXIST" then

						HAS_UNITNUMBER_FUNCTION(RequestFromStatus, directorname, directoremail)
						unitnumberflag = false

						if DirectorName_mandatory.isVisible == true then

							DirectorName_mandatory.isVisible = false

						end

						if DirectorEmail_mandatory.isVisible == true then

							DirectorEmail_mandatory.isVisible = false

						end


				-- if (FirstName.text~=nil or FirstName.text ~="") or (Name.text ~=nil or Name.text ~="")

				-- 		or (Email.text~=nil or Email.text ~="") then

				-- 		FirstName.text = ""

				-- 		Name.text = ""

				-- 		Email.text = ""

				-- 		end	


			end


		end





		local function textfield( event )

			if ( event.phase == "began" ) then

				testflag = true

				event.target:setTextColor(color.black)

				current_textField = event.target;


				current_textField.size=14

				if "E" == event.target.text:sub(1,1) then
					event.target.text=""
				end

				if(event.target.id == "Comments") then
					scrollTo( -100 )
					event.target.text = ""

				end
				

			elseif ( event.phase == "submitted" ) then

				if current_textField then

					if testflag == true then

						testflag = false

						if(event.target.id == "Unit Number / Director name") then
							
							Webservice.GET_UNITWISE_REGISTER(UnitNumber.text, getunitnumberresponse)

						end
					end

					if testflag == true then

						testflag = false

						if(current_textField.id == "Unit Number / Director name") then
							
							Webservice.GET_UNITWISE_REGISTER(UnitNumber.text, getunitnumberresponse)

						end
					end


					if(event.target.id == "Comments") then

						scrollTo( 0 )

						native.setKeyboardFocus( nil )

					elseif event.target.id == "Unit Number / Director name" then

						native.setKeyboardFocus( FirstName )


					elseif(event.target.id == "First Name") then

						native.setKeyboardFocus(Name)


					elseif(event.target.id == "Last Name") then

						native.setKeyboardFocus(Email)


					elseif(event.target.id == "Email") then

						native.setKeyboardFocus( nil )

						native.setKeyboardFocus(Phone)


					elseif(event.target.id == "Phone") then

						native.setKeyboardFocus(Comment)


					elseif (event.target.id == "Director Name") then

						native.setKeyboardFocus( nil )

						native.setKeyboardFocus( DirectorEmail )


					elseif (event.target.id == "Director Email") then

						native.setKeyboardFocus( nil )

					end

				end

				scrollTo( 0 )
				

				elseif event.phase == "ended" then

				scrollTo( 0 )

				if testflag == true then

					testflag = false

					if(current_textField.id == "Unit Number / Director name") then
						
						Webservice.GET_UNITWISE_REGISTER(UnitNumber.text, getunitnumberresponse)

					end
				end

				event.target:setSelection(event.target.text:len(),event.target.text:len())

				if testflag == true then

					testflag = false

					if(event.target.id == "Unit Number / Director name") then
						
						Webservice.GET_UNITWISE_REGISTER(UnitNumber.text, getunitnumberresponse)

					end
				end

				if(event.target.id == "Comments") then

					scrollTo( 0 )
					
					native.setKeyboardFocus( nil )
					
				end



			elseif ( event.phase == "editing" ) then

					if event.target.id == "Comments" then
								if event.text:len() > 160 then

									event.target.text = event.target.text:sub(1,160)

								end

					else

								if event.text:len() > 50 then

									event.target.text = event.target.text:sub(1,50)

								end

					end



				    if(event.target.id == "Comments") then
       --  					if event.text:len() > 160 then

							-- 	event.target.text = event.target.text:sub(1,160)

							-- end

							scrollTo( -100 )

							if (event.newCharacters=="\n") then
								native.setKeyboardFocus( nil )
							end


					elseif(event.target.id =="Phone") then

							local text = event.target.text

							if event.target.text:len() > event.startPosition then

								text = event.target.text:sub(1,event.startPosition )

							end


							local maskingValue =Utils.PhoneMasking(tostring(text))

							
							event.target.text=maskingValue

							event.target:setSelection(maskingValue:len()+1,maskingValue:len()+1)

							
					end
						
				end	

			end



				
				local function onRowRender( event )

				local row = event.row

				local rowHeight = row.contentHeight
				local rowWidth = row.contentWidth

				local rowTitle = display.newText(row, List_array[row.index][1], 0, 0,280,38, nil, 14 )
				rowTitle:setFillColor( 0 )
				rowTitle.anchorX = 0
				rowTitle.x = 5
				rowTitle.y = rowHeight * 0.5+5


   --[[ local line = display.newLine( 0,row.contentHeight,row.contentWidth,row.contentHeight )
    row:insert(line)
    line:setStrokeColor( 0, 0, 0, 1 )
    line.strokeWidth = 0.8]]

    row.rowValue = List_array[row.index][2]

    row.text=List_array[row.index][1]

end


local function onRowTouch( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

		--work
		MKRank.alpha=1
		MKRank.text =row.text

		if MKRank.text:len() > 36 then

			MKRank.text= MKRank.text:sub(1,36).."..."

		end

		

		mkRank_id = row.rowValue

	elseif ( "release" == phase ) then
		
		if rankGroup then

			rankGroup.isVisible=false

			FirstName.isVisible=true
			Name.isVisible=true
			Email.isVisible=true
			Phone.isVisible=true
			UnitNumber.isVisible=true
			Comment.isVisible=true
			DirectorName.isVisible = true
			DirectorEmail.isVisible = true

			if unitnumberflag == true then

				DirectorName.isVisible = true
				DirectorEmail.isVisible = true


			end


		end

	end
end




local sumbitBtnRelease = function( event )

	if event.phase == "began" then


		elseif event.phase == "ended" then
		local validation = true

		native.setKeyboardFocus(nil)

		if Name.text=="" or Name.text == Name.id then
			validation=false
			SetError(RequestAccess.Name_error,Name)
		end


		if unitnumberflag == true then

			if DirectorName.text == "" or DirectorName.text == DirectorName.id then
				validation=false
				DirectorName_mandatory.isVisible = true
				SetError(RequestAccess.DirectorName_error,DirectorName)
			end

			if DirectorEmail.text == "" or DirectorEmail.text == DirectorEmail.id then
				validation=false
				DirectorEmail_mandatory.isVisible = true
				SetError(RequestAccess.DirectorEmail_error,DirectorEmail)
			else

				if not Utils.emailValidation(DirectorEmail.text) then
					validation=false
					DirectorEmail_mandatory.isVisible = true
					SetError(RequestAccess.DirectorEmailValidation_error,DirectorEmail)

				end
			end

		end


		if Email.text:sub(1,1) == "*" or Email.text == Email.id then
			validation=false
			SetError(RequestAccess.Email_error,Email)
		else

			if not Utils.emailValidation(Email.text) then
				validation=false
				SetError(RequestAccess.EmailValidation_error,Email)

			end

		end

		if Phone.text:sub(1,1) == "*" or Phone.text == PopupGroup.PhoneNumRequired or Phone.text == Phone.id or Phone.text:len() < 14  then
			validation=false
			SetError(RequestAccess.Phone_error,Phone)
		end

		if AppName ~= "DirectorApp" then
			if UnitNumber.text == "" or UnitNumber.text == nil then
				validation=false
				SetError(RequestAccess.UnitNumber_error,UnitNumber)
			end
		end


			--[[if MKRank.text == "" or MKRank.text == MKRank.value then
				validation=false
				--SetError("* Select MKRank",MKRank)
			end
			]]

			if(validation == true) then
				
				RequestProcess()



			end

		end
		return true
	end



	local function rankTouch( event )
		if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "moved" then
			local dx = math.abs( event.x - event.xStart )
			local dy = math.abs( event.y - event.yStart )
			if dx > 5 or dy > 5 then
				display.getCurrentStage():setFocus( nil )
				native.setKeyboardFocus(nil)
        	--scrollView:takeFocus( event )
        end
        elseif event.phase == "ended" then
        display.getCurrentStage():setFocus( nil )

        if event.target.id == "MKrank" then
        	native.setKeyboardFocus( nil )

        	if listFlag == false then
        		listFlag=true
        		if rankGroup then
        			rankGroup.isVisible=true
        			FirstName.isVisible=false
        			Name.isVisible=false
        			Email.isVisible=false
        			Phone.isVisible=false
        			UnitNumber.isVisible=false
        			Comment.isVisible=false

        			DirectorName.isVisible = false
        			DirectorEmail.isVisible = false

					--DirectorName_bottom.isVisible = false
					--DirectorEmail_bottom.isVisible = false

				-- if unitnumberflag == true then

				-- 	DirectorName.isVisible = true
				-- 	DirectorEmail.isVisible = true

				-- end

			end

		elseif listFlag == true then

			rankGroup.isVisible=false

			listFlag=false

		end

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

	display.setDefault( "background", 1, 1, 1 )

	Background = display.newRect(sceneGroup,W/2,H/2,W,H)

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.height/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))
	
	BgText = display.newImageRect(sceneGroup,"res/assert/logo.png",398/4,81/4)
	BgText.x=W/2;BgText.y=20

	local tabImage = display.newImageRect( sceneGroup, "res/assert/setting_icon1.png", 111/2,111/2 )
	tabImage.x=W/2+W/3;tabImage.y=tabBar.y+tabBar.contentHeight/2
	--BgText.anchorX=0

	backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
	backBtn_bg.x=25;backBtn_bg.y=BgText.y
	backBtn_bg.alpha=0.01

	backBtn = display.newImageRect(sceneGroup,"res/assert/back_icon.png",36/2,30/2)
	backBtn.x=20;backBtn.y=BgText.y
	--backBtn.xScale=-1

	page_title = display.newText(sceneGroup,RequestAccess.PageTitle:upper( ),0,0,"Roboto-Bold",18)
	page_title.x=backBtn.x;page_title.y=backBtn.y+45
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))
	


	if AppName ~= "DirectorApp" then

		UnitNumber_bg = display.newLine(sceneGroup, W/2-150, page_title.y+48, W/2+150, page_title.y+48)
		UnitNumber_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
		UnitNumber_bg.strokeWidth = 1


		UnitNumber_mandatory = display.newText("*",0,0,"Roboto-Light",14)
        UnitNumber_mandatory.x=15
        UnitNumber_mandatory.y=UnitNumber_bg.y-UnitNumber_mandatory.contentHeight/2-15
        UnitNumber_mandatory:setTextColor( 1, 0, 0 )
        sceneGroup:insert(UnitNumber_mandatory)


		UnitNumber = native.newTextField(W/2+7, page_title.y+35, W-20, 25 )
		UnitNumber.id = "Unit Number / Director name"
		UnitNumber.value=""
		UnitNumber.font=native.newFont("Roboto-Light",14)
		UnitNumber:setReturnKey( "next" )
		UnitNumber.hasBackground = false
		UnitNumber.placeholder=LoginPage.Unitnumber_placeholder
		sceneGroup:insert(UnitNumber)

		-- UnitNumber_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		-- UnitNumber_bottom.x=W/2
		-- UnitNumber_bottom.y= page_title.y+45

	end


-------------------------------------- first name -------------------------------------------

FirstName_bg = display.newLine(sceneGroup, W/2-150, UnitNumber_bg.y+35, W/2+150, UnitNumber_bg.y+35)
FirstName_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
FirstName_bg.strokeWidth = 1

-- FirstName_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
-- FirstName_bottom.x=W/2
-- FirstName_bottom.y= UnitNumber_bg.y+UnitNumber_bg.height+16

FirstName = native.newTextField(W/2+7, UnitNumber_bg.y+UnitNumber_bg.height+7, W-20, 25)
FirstName.id="First Name"
FirstName.font=native.newFont("Roboto-Light",14)
FirstName.y = UnitNumber_bg.y+UnitNumber_bg.height+18
FirstName.hasBackground = false
FirstName:setReturnKey( "next" )
FirstName.placeholder=RequestAccess.FirstName_placeholder
sceneGroup:insert(FirstName)

-------------------------------------Last name ----------------------------------------------

Name_bg = display.newLine(sceneGroup, W/2-150, FirstName_bg.y+35, W/2+150, FirstName_bg.y+35)
Name_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
Name_bg.strokeWidth = 1

-- Name_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
-- Name_bottom.x=W/2
-- Name_bottom.y= FirstName_bg.y+FirstName_bg.height+16

Name_mandatory = display.newText("*",0,0,"Roboto-Light",14)
Name_mandatory.x=15
Name_mandatory.y=Name_bg.y-Name_mandatory.contentHeight/2-15
Name_mandatory:setTextColor( 1, 0, 0 )
sceneGroup:insert(Name_mandatory)

Name = native.newTextField( W/2+7, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
Name.id="Last Name"
Name.y = FirstName_bg.y+FirstName_bg.height+18
Name.font=native.newFont("Roboto-Light",14)
Name:setReturnKey( "next" )
Name.hasBackground = false	
Name.placeholder = RequestAccess.LastName_placeholder
sceneGroup:insert(Name)


----------------------------------Email address---------------------------------

Email_bg = display.newLine(sceneGroup, W/2-150, Name_bg.y+35, W/2+150, Name_bg.y+35)
Email_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
Email_bg.strokeWidth = 1

-- Email_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
-- Email_bottom.x=W/2
-- Email_bottom.y= Name_bg.y+Name_bg.height+16

Email_mandatory = display.newText("*",0,0,"Roboto-Light",14)
Email_mandatory.x=15
Email_mandatory.y=Email_bg.y-Email_mandatory.contentHeight/2-15
Email_mandatory:setTextColor( 1, 0, 0 )
sceneGroup:insert(Email_mandatory)

Email = native.newTextField(W/2+7, Name_bg.y+Name_bg.height+7, W-20, 25 )
Email.id="Email"
Email.font=native.newFont("Roboto-Light",14)
Email:setReturnKey( "next" )
Email.y = Name_bg.y+Name_bg.height+18
Email.hasBackground = false
Email.placeholder=RequestAccess.EmailAddress_placeholder
sceneGroup:insert(Email)


-----------------------------------phone------------------------------------------

Phone_bg = display.newLine(sceneGroup, W/2-150, Email_bg.y+35, W/2+150, Email_bg.y+35)
Phone_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
Phone_bg.strokeWidth = 1

Phone_mandatory = display.newText("*",0,0,"Roboto-Light",14)
Phone_mandatory.x=15
Phone_mandatory.y=Phone_bg.y-Phone_mandatory.contentHeight/2-15
Phone_mandatory:setTextColor( 1, 0, 0 )
sceneGroup:insert(Phone_mandatory)

-- Phone_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
-- Phone_bottom.x=W/2
-- Phone_bottom.y= Email_bg.y+Email_bg.height+16

Phone = native.newTextField(W/2+7, Email_bg.y+Email_bg.height+7, W-20, 25)
Phone.id="Phone"
Phone.font=native.newFont("Roboto-Light",14)
Phone.y = Email_bg.y+Email_bg.height+18
Phone:setReturnKey( "next" )
Phone.hasBackground = false
Phone.placeholder=RequestAccess.Phone_placeholder
Phone.inputType = "number"
sceneGroup:insert(Phone)


-----------------------------------MK rank----------------------------------------

MKRank_bg = display.newLine(sceneGroup, W/2-150, Phone_bg.y+35, W/2+150, Phone_bg.y+35)
MKRank_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
MKRank_bg.strokeWidth = 1
MKRank_bg.id="MKrank"

MKRank = display.newText("",MKRank_bg.x+7,MKRank_bg.y,MKRank_bg.contentWidth,Phone.height,native.systemFont,14 )
MKRank.text = RequestAccess.MKRank_placeholder
MKRank.value = RequestAccess.MKRank_placeholder
MKRank.id="MKrank"
MKRank.alpha=0.3
MKRank:setFillColor( Utils.convertHexToRGB(color.Black))
MKRank.y=MKRank_bg.y-10
MKRank.x=MKRank_bg.x+MKRank_bg.contentWidth/2+10
--MKRank.size=20
sceneGroup:insert(MKRank)

rankText_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
rankText_icon.x=MKRank_bg.x+MKRank_bg.contentWidth-25
rankText_icon.y=MKRank_bg.y-18



----------------------comments --------------------------------------

Comment_bg = display.newLine(sceneGroup, W/2-150, MKRank_bg.y+75, W/2+150, MKRank_bg.y+75)
Comment_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
Comment_bg.strokeWidth = 1
Comment_bg.id="MKrank"

Comment = native.newTextBox(W/2+7, Comment_bg.y-25, W-20, 50 )
Comment.placeholder=RequestAccess.Comment_placeholder
Comment.isEditable = true
Comment.font=native.newFont("Roboto-Light",14)
Comment.id = "Comments"
Comment.hasBackground = false
Comment:setReturnKey( "next" )
sceneGroup:insert(Comment)


-------------------------Director name----------------------------------

DirectorName_bg = display.newLine(sceneGroup, W/2-150, Comment_bg.y+35, W/2+150, Comment_bg.y+35)
DirectorName_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
DirectorName_bg.strokeWidth = 1

-- DirectorName_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
-- DirectorName_bottom.x=W/2
-- DirectorName_bottom.y= Comment_bg.y+Comment_bg.height - 5

DirectorName_mandatory = display.newText("*",0,0,"Roboto-Light",14)
DirectorName_mandatory.x=15
DirectorName_mandatory.y=DirectorName_bg.y-DirectorName_mandatory.contentHeight/2-14
DirectorName_mandatory:setTextColor( 1, 0, 0 )
DirectorName_mandatory.isVisible = false
sceneGroup:insert(DirectorName_mandatory)

DirectorName = native.newTextField(W/2+7, Comment_bg.y+Comment_bg.height+10, W-20, 25)
DirectorName.id="Director Name"
DirectorName.font=native.newFont("Roboto-Light",14)
DirectorName.y = DirectorName_bg.y-15
DirectorName.hasBackground = false
DirectorName:setReturnKey( "next" )
DirectorName.isVisible = true
DirectorName.placeholder=RequestAccess.DirectorName_placeholder
sceneGroup:insert(DirectorName)


--------------------------Director email-------------------------------

DirectorEmail_bg = display.newLine(sceneGroup, W/2-150, DirectorName_bg.y+35, W/2+150, DirectorName_bg	.y+35)
DirectorEmail_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
DirectorEmail_bg.strokeWidth = 1

-- DirectorEmail_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
-- DirectorEmail_bottom.x=W/2
-- DirectorEmail_bottom.y= DirectorName_bg.y+DirectorName_bg.height+16

DirectorEmail_mandatory = display.newText("*",0,0,"Roboto-Light",14)
DirectorEmail_mandatory.x=15
DirectorEmail_mandatory.y=DirectorEmail_bg.y-DirectorEmail_mandatory.contentHeight/2-14
DirectorEmail_mandatory:setTextColor( 1, 0, 0 )
DirectorEmail_mandatory.isVisible = false
sceneGroup:insert(DirectorEmail_mandatory)

DirectorEmail = native.newTextField(W/2+7, DirectorName_bg.y+DirectorName_bg.height+10, W-20, 25)
DirectorEmail.id="Director Email"
DirectorEmail.font=native.newFont("Roboto-Light",14)
DirectorEmail.y = DirectorEmail_bg.y-15
DirectorEmail.hasBackground = false
DirectorEmail.isVisible = true
DirectorEmail:setReturnKey( "done" )
DirectorEmail.placeholder=RequestAccess.DirectorEmail_placeholder
sceneGroup:insert(DirectorEmail)


---------------------submit button------------------------------------

sumbitBtn = display.newImageRect("res/assert/white_btnbg.png",550/1.8,100/2)
sumbitBtn.x=W/2;sumbitBtn.y = DirectorEmail_bg.y+DirectorEmail_bg.height/2+40
--sumbitBtn.anchorX=0
sumbitBtn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
sceneGroup:insert(sumbitBtn)
sumbitBtn.id="Submit"

sumbitBtn_lbl = display.newText( sceneGroup,CommonWords.submit,0,0,native.systemFont,16 )
sumbitBtn_lbl.y=sumbitBtn.y
sumbitBtn_lbl.x = sumbitBtn.x

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
submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
submit_spinner.y=sumbitBtn.y

sumbitBtn:addEventListener( "touch", sumbitBtnRelease )

MainGroup:insert(sceneGroup)


end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		function GetListArray(response)


			for i=1,#response do

				List_array[i] = {}
				List_array[i][1] = response[i].MkRankLevel
				List_array[i][2] = response[i].MkRankId

			end


  		---Listview---

  		rankTop_bg = display.newRect( rankGroup, MKRank_bg.x+MKRank_bg.contentWidth/2, H/2-10, MKRank_bg.contentWidth, 290 )
  		rankTop_bg:setFillColor(Utils.convertHexToRGB(color.primaryColor))
  		rankTop_bg.anchorY=0

  		rankTop = display.newRect(rankGroup,W/2+2,H/2-160,304,30)
  		rankTop:setFillColor(Utils.convertHexToRGB(color.primaryColor))
  		rankTop_bg.y = rankTop.y+rankTop.contentHeight/2

  		rankText = display.newText(rankGroup,RequestAccess.MKRank_placeholder,0,0,native.systemFont,16)
  		rankText.x=rankTop.x;rankText.y=rankTop.y


  		rankClose = display.newImageRect(rankGroup,"res/assert/cancel.png",19,19)
  		rankClose.x=rankTop.x+rankTop.contentWidth/2-15;rankClose.y=rankTop.y
  		rankClose.id="close"

  		rankClose_bg = display.newRect(rankGroup,0,0,30,30)
  		rankClose_bg.x=rankTop.x+rankTop.contentWidth/2-15;rankClose_bg.y=rankTop.y
  		rankClose_bg.id="close"
  		rankClose_bg.alpha=0.01


  		rankTop:addEventListener("touch",rankToptouch)
  		rankText:addEventListener("touch",rankToptouch)
  		rankClose_bg:addEventListener("touch",rankToptouch)

  		

  		rankList = widget.newTableView
  		{
  			left = 0,
  			top = -50,
  			height = 290,
  			width = 300,
  			onRowRender = onRowRender,
  			onRowTouch = onRowTouch,
  		--hideBackground = true,
  		noLines=true,
  		hideScrollBar=true,
  		isBounceEnabled=false,

  	}

  	rankList.x=MKRank_bg.x+MKRank_bg.contentWidth/2
  	rankList.y=rankTop.y+rankTop.height/2
  	rankList.height = rankTop_bg.contentHeight-2
  	rankList.width = MKRank_bg.contentWidth
  	rankList.anchorY=0
  	rankGroup.isVisible=false

  	rankGroup:insert(rankList)
  	
  --	scrollView:insert(rankGroup)


---------------

for i = 1, #List_array do
			    -- Insert a row into the tableView
			    rankList:insertRow{ rowHeight = 35,
			    rowColor = { default={ 1,1,1}, over={ 0, 0, 0, 0.1 } }

			}
		end
	end


	Webservice.GET_LIST_OF_RANKS(GetListArray)



elseif phase == "did" then

	composer.removeHidden()

	openPage="requestAccess Page"

	ga.enterScene("Request Access")


	MKRank_bg:addEventListener( "touch", rankTouch )
	MKRank:addEventListener( "touch", rankTouch )

	FirstName:addEventListener( "userInput", textfield )
	Name:addEventListener( "userInput", textfield )
	Email:addEventListener( "userInput", textfield )
	Phone:addEventListener( "userInput", textfield )
	UnitNumber:addEventListener( "userInput", textfield )
	Comment:addEventListener( "userInput", textfield )
	DirectorName:addEventListener( "userInput", textfield )
	DirectorEmail:addEventListener( "userInput", textfield )
	
	Background:addEventListener("touch",touchBg)

	backBtn_bg:addEventListener("touch",backAction)
	backBtn:addEventListener("touch",backAction)

	Runtime:addEventListener( "key", onKeyEvent )

	

end	

MainGroup:insert(sceneGroup)

end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		for j=MainGroup.numChildren, 1, -1 do 
			display.remove(MainGroup[MainGroup.numChildren])
			MainGroup[MainGroup.numChildren] = nil
		end

		MKRank_bg:removeEventListener( "touch", rankTouch )
		MKRank:removeEventListener( "touch", rankTouch ) 

		Runtime:removeEventListener( "key", onKeyEvent )

		if rankTop then rankTop:removeEventListener("touch",rankToptouch) end
		if rankText then rankText:removeEventListener("touch",rankToptouch) end 
		if rankClose_bg then rankClose_bg:removeEventListener("touch",rankToptouch) end


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