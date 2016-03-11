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
local mkRank_id=0
local current_textField,defalut
local rankGroup = display.newGroup()
local RequestFromStatus = ""
local unitnumberflag = false


--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

--Display Object
local Background,BgText,tabBar,backBtn,page_title,MKRank,rankText_icon,sumbitBtn_lbl

--EditText Background
local FirstName_bg,Name_bg,Email_bg,Phone_bg,MKRank_bg,Comment_bg,DirectorName_bg,DirectorEmail_bg

--EditText
local FirstName,Name,Email,Phone,UnitNumber,Comment,DirectorName,DirectorEmail

--Spinner
local submit_spinner

--Button
local sumbitBtn,scrollView

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

			elseif event.phase == "ended" then

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
				   if event.action == "clicked" then
				        local i = event.index
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
				   end
			end

		local alert = native.showAlert( RequestAccess.PageTitle , value, { CommonWords.ok }, onComplete )

	end	



	local function createField()

		
		native.setKeyboardFocus(nil)
		input = native.newTextField(W/2+3, Email_bg.y+Email_bg.height+7, W-20, 25)
		
		return input
	end



local function RequestProcess()

	print( "here !!!!!" )

	if  submit_spinner.isVisible == false then

			submit_spinner.isVisible=true
			sumbitBtn.width = sumbitBtn.contentWidth+20
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15

			sumbitBtn.width = sumbitBtn_lbl.contentWidth+40
			sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
			sumbitBtn_lbl.x = sumbitBtn.x+5
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15

			submit_spinner:start( )


	function get_requestAccess(response)

			Request_response = response

			print("response after unit number validation ",Request_response)

			submit_spinner.isVisible=false
			sumbitBtn.width = sumbitBtn_lbl.width+20
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
			sumbitBtn.width = sumbitBtn_lbl.contentWidth+15
sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
sumbitBtn_lbl.x = sumbitBtn.x+5

			submit_spinner:stop( )

							UnitNumber.text = ""
							DirectorName.text = ""
							DirectorEmail.text = ""
							FirstName.text = ""
							Name.text = ""
							Email.text = ""
							Phone.text = ""
							MKRank.text = "-Select MK Rank-"
							MKRank.value = "-Select MK Rank-"
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

				SetError("* "..RequestAccess.NOUNITNUMBER,UnitNumber)

			elseif Request_response == "BLOCK"  then

				alertFun(RequestAccess.BLOCK,0)

			elseif Request_response == "DENY" then

				alertFun(RequestAccess.DENY,0)

			elseif Request_response == "FAIL" then

				alertFun(RequestAccess.FAIL,0)
			end

			end
					
				if AppName == "DirectorApp" then

						Webservice.REQUEST_ACCESS(RequestFromStatus,"","",FirstName.text,Name.text,Email.text,Phone.text,Unitnumber_value,mkRank_id,Comment.text,get_requestAccess)
				else
						Webservice.REQUEST_ACCESS(RequestFromStatus,DirectorName.text,DirectorEmail.text,FirstName.text,Name.text,Email.text,Phone.text,UnitNumber.text,mkRank_id,Comment.text,get_requestAccess)
						
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

			print("************************Request_response unitnumber initial*************************** ",Request_response)

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

							if "*" == event.target.text:sub(1,1) then
								event.target.text=""
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

			
								
        			

        				if event.target.id ~= "Comments" then
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

							if event.target.text:len() > 15 then

								event.target.text = event.target.text:sub(1,15)


							end

							if event.target.text:len() > event.startPosition then

								event.target.text = event.target.text:sub(1,event.startPosition )

							end


							local maskingValue =Utils.PhoneMasking(tostring(event.target.text))

											

									native.setKeyboardFocus(nil)

									event.target.text=maskingValue

									event.target = Phone

									native.setKeyboardFocus(Phone)
									

						
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

		if Name.text == "" or Name.text == Name.id then
		validation=false
		SetError("* "..RequestAccess.Name_error,Name)
		end


		if unitnumberflag == true then

		if DirectorName.text == "" or DirectorName.text == DirectorName.id then
		validation=false
		SetError("* "..RequestAccess.DirectorName_error,DirectorName)
		end

		if DirectorEmail.text == "" or DirectorEmail.text == DirectorEmail.id then
		validation=false
		SetError("* "..RequestAccess.DirectorEmail_error,DirectorEmail)
		else

			if not Utils.emailValidation(DirectorEmail.text) then
			validation=false
			SetError("* "..RequestAccess.DirectorEmailValidation_error,DirectorEmail)

			end
		end

		end


		if Email.text == "" or Email.text == Email.id then
			validation=false
		SetError("* "..RequestAccess.Email_error,Email)
		else

		if not Utils.emailValidation(Email.text) then
		validation=false
		SetError("* "..RequestAccess.EmailValidation_error,Email)

		end

		end

			if Phone.text == "" or Phone.text == Phone.id or Phone.text:len() < 15  then
				validation=false
				SetError("* "..RequestAccess.Phone_error,Phone)
			end

			if AppName ~= "DirectorApp" then
				if UnitNumber.text == "" or UnitNumber.text == nil then
					validation=false
					SetError("* "..RequestAccess.UnitNumber_error,UnitNumber)
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

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.height/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	
	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=5;BgText.y=20
	BgText.anchorX=0

	backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
	backBtn_bg.x=25;backBtn_bg.y=BgText.y+BgText.contentHeight/2+26
	backBtn_bg.alpha=0.01

	backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
	backBtn.x=20;backBtn.y=BgText.y+BgText.contentHeight/2+20
	backBtn.xScale=-1
	backBtn.anchorY=0

	page_title = display.newText(sceneGroup,RequestAccess.PageTitle,0,0,native.systemFont,18)
	page_title.x=backBtn.x+18;page_title.y=backBtn.y+8
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))
	


	if AppName ~= "DirectorApp" then
			UnitNumber_bg = display.newRect( W/2, page_title.y+35, W-20, 25)
			sceneGroup:insert(UnitNumber_bg)
			UnitNumber_bg.alpha=0.01

			UnitNumber = native.newTextField(W/2+3, page_title.y+35, W-20, 25 )
			UnitNumber.id = "Unit Number / Director name"
			UnitNumber.value=""
			UnitNumber.size=14	
			UnitNumber:setReturnKey( "next" )
			UnitNumber.hasBackground = false
			UnitNumber.placeholder=LoginPage.Unitnumber_placeholder
			sceneGroup:insert(UnitNumber)

		UnitNumber_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		UnitNumber_bottom.x=W/2
		UnitNumber_bottom.y= page_title.y+45

    end





-------------------------------------- first name -------------------------------------------

		FirstName_bg = display.newRect(W/2, UnitNumber_bg.y+UnitNumber_bg.height+7, W-20, 25)
		FirstName_bg.y = UnitNumber_bg.y+UnitNumber_bg.height+7
		FirstName_bg.alpha = 0.01
		sceneGroup:insert(FirstName_bg)

		FirstName_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		FirstName_bottom.x=W/2
		FirstName_bottom.y= UnitNumber_bg.y+UnitNumber_bg.height+16

		FirstName = native.newTextField(W/2+3, UnitNumber_bg.y+UnitNumber_bg.height+7, W-20, 25)
		FirstName.id="First Name"
		FirstName.size=14	
		FirstName.y = UnitNumber_bg.y+UnitNumber_bg.height+7
		FirstName.hasBackground = false
		FirstName:setReturnKey( "next" )
		FirstName.placeholder=RequestAccess.FirstName_placeholder
		sceneGroup:insert(FirstName)

-------------------------------------Last name ----------------------------------------------

		Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
		Name_bg.y = FirstName_bg.y+FirstName_bg.height+7
		Name_bg.alpha = 0.01
		sceneGroup:insert(Name_bg)

		Name_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Name_bottom.x=W/2
		Name_bottom.y= FirstName_bg.y+FirstName_bg.height+16

		Name = native.newTextField( W/2+3, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
		Name.id="Last Name"
		Name.y = FirstName_bg.y+FirstName_bg.height+7
		Name.size=14
		Name:setReturnKey( "next" )
		Name.hasBackground = false	
		Name.placeholder = RequestAccess.LastName_placeholder
		sceneGroup:insert(Name)


----------------------------------Email address---------------------------------
		Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+7, W-20, 25 )
		Email_bg.alpha = 0.01
		sceneGroup:insert(Email_bg)

		Email_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Email_bottom.x=W/2
		Email_bottom.y= Name_bg.y+Name_bg.height+16

		Email = native.newTextField(W/2+3, Name_bg.y+Name_bg.height+7, W-20, 25 )
		Email.id="Email"
		Email.size=14	
		Email:setReturnKey( "next" )
		Email.hasBackground = false
		Email.placeholder=RequestAccess.EmailAddress_placeholder
		sceneGroup:insert(Email)


-----------------------------------phone------------------------------------------
		Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.height+7, W-20, 25)
		Phone_bg.alpha = 0.01
		sceneGroup:insert(Phone_bg)

		Phone_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Phone_bottom.x=W/2
		Phone_bottom.y= Email_bg.y+Email_bg.height+16


		Phone = native.newTextField(W/2+3, Email_bg.y+Email_bg.height+7, W-20, 25)
		Phone.id="Phone"
		Phone.size=14	
		Phone:setReturnKey( "next" )
		Phone.hasBackground = false
		Phone.placeholder=RequestAccess.Phone_placeholder
		Phone.inputType = "number"
		sceneGroup:insert(Phone)


-----------------------------------MK rank----------------------------------------

		if AppName ~= "DirectorApp" then

			MKRank_bg = display.newRect(W/2, Phone_bg.y+Phone_bg.height+7, W-20, 25)
			MKRank_bg:setStrokeColor( 0, 0, 0 , 0.3 )
            MKRank_bg.strokeWidth = 1

		else
			MKRank_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+7, W-20, 25)
			MKRank_bg:setStrokeColor( 0, 0, 0 , 0.3 )
            MKRank_bg.strokeWidth = 1

		end

		MKRank_bg:setFillColor( 0,0,0,0 )

		MKRank_bg.id="MKrank"
		sceneGroup:insert(MKRank_bg)



		MKRank = display.newText("",MKRank_bg.x+10,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.height,native.systemFont,14 )
		MKRank.text = RequestAccess.MKRank_placeholder
		MKRank.value = "-Select MK Rank-"
		MKRank.id="MKrank"
		MKRank.alpha=0.9
		MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		MKRank.y=MKRank_bg.y+5
	    --MKRank.size=20
	    sceneGroup:insert(MKRank)

	  		rankText_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
	  		rankText_icon.x=MKRank_bg.x+MKRank_bg.contentWidth/2-15
	  		rankText_icon.y=MKRank_bg.y



----------------------comments --------------------------------------
	Comment_bg = display.newRect( W/2, 0, W-20, 70)
	Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
	Comment_bg:setFillColor( 0,0,0,0 )
	Comment_bg:setStrokeColor( 0, 0, 0 , 0.3 )
    Comment_bg.strokeWidth = 1
	sceneGroup:insert(Comment_bg)

	Comment = native.newTextBox(W/2+3, Comment_bg.y, W-20, 70 )
	Comment.placeholder=RequestAccess.Comment_placeholder
	Comment.isEditable = true
	Comment.size=14	
	Comment.id = "Comments"
	Comment.hasBackground = false
	Comment:setReturnKey( "next" )
	
	
	sceneGroup:insert(Comment)


-------------------------Director name----------------------------------
    	DirectorName_bg = display.newRect(W/2, Comment_bg.y+Comment_bg.height+7, W-20, 25)
    	DirectorName_bg.isVisible = true
    	DirectorName_bg.alpha = 0.01
    	DirectorName_bg.y = Comment_bg.y+Comment_bg.height-14
		sceneGroup:insert(DirectorName_bg)

		DirectorName_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		DirectorName_bottom.x=W/2
		DirectorName_bottom.y= Comment_bg.y+Comment_bg.height - 5

		DirectorName = native.newTextField(W/2+3, Comment_bg.y+Comment_bg.height+7, W-20, 25)
		DirectorName.id="Director Name"
		DirectorName.size=14	
		DirectorName.y = Comment_bg.y+Comment_bg.height-14
		DirectorName.hasBackground = false
		DirectorName:setReturnKey( "next" )
		DirectorName.isVisible = true
		DirectorName.placeholder=RequestAccess.DirectorName_placeholder
		sceneGroup:insert(DirectorName)


--------------------------Director email-------------------------------
		DirectorEmail_bg = display.newRect(W/2, DirectorName_bg.y+DirectorName_bg.height+7, W-20, 25)
		DirectorEmail_bg.isVisible = true
		DirectorEmail_bg.alpha = 0.01
		DirectorEmail_bg.y = DirectorName_bg.y+DirectorName_bg.height+7
		sceneGroup:insert(DirectorEmail_bg)

		DirectorEmail_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		DirectorEmail_bottom.x=W/2
		DirectorEmail_bottom.y= DirectorName_bg.y+DirectorName_bg.height+16

		DirectorEmail = native.newTextField(W/2+3, DirectorName_bg.y+DirectorName_bg.height+7, W-20, 25)
		DirectorEmail.id="Director Email"
		DirectorEmail.size=14	
		DirectorEmail.y = DirectorName_bg.y+DirectorName_bg.height+7
		DirectorEmail.hasBackground = false
		DirectorEmail.isVisible = true
		DirectorEmail:setReturnKey( "next" )
		DirectorEmail.placeholder=RequestAccess.DirectorEmail_placeholder
		sceneGroup:insert(DirectorEmail)


---------------------submit button------------------------------------
	sumbitBtn = display.newRect( 0,0,0,0 )
	sumbitBtn.x=W/2;sumbitBtn.y = DirectorEmail_bg.y+DirectorEmail_bg.height/2+30
	sumbitBtn.width=80
	sumbitBtn.height=30
	sumbitBtn.anchorX=0
	sumbitBtn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
	sceneGroup:insert(sumbitBtn)
	sumbitBtn.id="Submit"


sumbitBtn_lbl = display.newText( sceneGroup,CommonWords.submit,0,0,native.systemFont,16 )
sumbitBtn_lbl.y=sumbitBtn.y
sumbitBtn_lbl.anchorX=0

sumbitBtn.width = sumbitBtn_lbl.contentWidth+15
sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
sumbitBtn_lbl.x = sumbitBtn.x+5



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

  		rankTop_bg = display.newRect( rankGroup, MKRank_bg.x, H/2-10, MKRank_bg.contentWidth+1, 311 )
  		rankTop_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

  		rankTop = display.newRect(rankGroup,W/2,H/2-160,300,30)
  		rankTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

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

  	rankList.x=MKRank_bg.x
  	rankList.y=rankTop.y+rankTop.height/2
  	rankList.height = 290
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
		page_title:addEventListener("touch",backAction)

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