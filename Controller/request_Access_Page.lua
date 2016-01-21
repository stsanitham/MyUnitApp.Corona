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




--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

--Display Object
local Background,BgText,tabBar,backBtn,page_title,MKRank,rankText_icon,sumbitBtn_lbl

--EditText Background
local FirstName_bg,Name_bg,Email_bg,Phone_bg,MKRank_bg,Comment_bg

--EditText
local FirstName,Name,Email,Phone,UnitNumber,Comment

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
			rankGroup.isVisible=falses

				FirstName.isVisible=true
				Name.isVisible=true
				Email.isVisible=true
				Phone.isVisible=true
				UnitNumber.isVisible=true
				Comment.isVisible=true

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
		input = native.newTextField(W/2, Email_bg.y+Email_bg.height+10, W-20, 28)
		
		return input
	end

local function RequestProcess()

	if  sumbitBtn.width == 80 then

			submit_spinner.isVisible=true
			sumbitBtn.width = sumbitBtn.width+20
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
			submit_spinner:start( )



	function get_requestAccess(response)

			Request_response = response

			submit_spinner.isVisible=false
			sumbitBtn.width = sumbitBtn.width-20
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
			submit_spinner:stop( )
			
								

		if Request_response == "REQUEST"  then

			alertFun(RequestAccess.REQUEST,0)

		elseif Request_response == "FIRSTREQUEST" then

			alertFun(RequestAccess.FIRSTREQUEST,1)

		elseif Request_response == "OPEN" then

			alertFun(RequestAccess.OPEN,1)
						
		elseif Request_response == "GRANT" then

			alertFun(RequestAccess.GRANT,1)

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

						Webservice.REQUEST_ACCESS(FirstName.text,Name.text,Email.text,Phone.text,Unitnumber_value,mkRank_id,Comment.text,get_requestAccess)
					else
						Webservice.REQUEST_ACCESS(FirstName.text,Name.text,Email.text,Phone.text,UnitNumber.text,mkRank_id,Comment.text,get_requestAccess)
					end

end
end


				function scrollTo( position )
					MainGroup.y = position
				end


				local function textfield( event )

					if ( event.phase == "began" ) then

					
							event.target:setTextColor(color.black)

							current_textField = nil

							current_textField = event.target;


							current_textField.size=14

							if "*" == event.target.text:sub(1,1) then
								event.target.text=""
							end

							if(current_textField.id == "Comments") then

							

									current_textField.text = ""

								
								scrollTo( -100 )

							end


					elseif ( event.phase == "submitted" ) then

							if current_textField then
					       			--native.setKeyboardFocus( nil )
					       			if(current_textField.id == "Comments") then

										scrollTo( 0 )

										native.setKeyboardFocus( nil )

									elseif(current_textField.id == "First Name") then

										native.setKeyboardFocus(Name)

									elseif(current_textField.id == "Last Name") then

										native.setKeyboardFocus(Email)

									elseif(current_textField.id == "Email") then

										native.setKeyboardFocus(Phone)

									elseif(current_textField.id == "Phone") then

										native.setKeyboardFocus(UnitNumber)

									elseif(current_textField.id == "Unit Number / Director name") then
																
										native.setKeyboardFocus( nil )

									end


								end

								scrollTo( 0 )

					elseif event.phase == "ended" then

						scrollTo( 0 )

						if(current_textField.id == "Comments") then

										scrollTo( 0 )
										
										native.setKeyboardFocus( nil )

						end

						--native.setKeyboardFocus( nil )

        			elseif ( event.phase == "editing" ) then
        				if current_textField.id ~= "Comments" then
        					if event.text:len() > 50 then

								event.target.text = event.target.text:sub(1,50)

							end

						end

	       				if(current_textField.id == "Comments") then
        					if event.text:len() > 160 then

								event.target.text = event.target.text:sub(1,160)

							end

							if (event.newCharacters=="\n") then
								native.setKeyboardFocus( nil )
							end

						elseif(current_textField.id =="Phone") then

							


							local tempvalue = event.target.text:sub(1,1)

							if (event.target.text:len() == 3) then

								if (tempvalue ~= "(") then


									--event.target.text = "("..event.target.text..") "

									local previousText=event.target.text

									event.target:removeSelf( );event.target.text=nil

									Phone = createField()
									Phone.id="Phone"
									Phone.size=14	
									Phone:setReturnKey( "next" )
									Phone.hasBackground = false
									Phone.placeholder=RequestAccess.Phone_placeholder
									Phone.inputType = "number"
									MainGroup:insert( Phone )

									Phone.text="("..previousText..") "


									Phone:addEventListener( "userInput", textfield )

									native.setKeyboardFocus(Phone)

									

								else

									event.target.text = event.target.text:sub(2,event.target.text:len())


								end
							elseif event.target.text:len() == 5 and (tempvalue == "(") then

								if event.target.text:sub(5,5) ~= ")" then

									event.target.text = event.text:sub(1,4)..") "..event.target.text:sub(5,5)
				
								end


							elseif event.target.text:len() == 9 and not string.find(event.target.text,"-") then


									local previousText=event.target.text

									event.target:removeSelf( );event.target.text=nil

									Phone = createField()
									Phone.id="Phone"
									Phone.size=14	
									Phone:setReturnKey( "next" )
									Phone.hasBackground = false
									Phone.placeholder=RequestAccess.Phone_placeholder
									Phone.inputType = "number"
									MainGroup:insert( Phone )

									Phone.text=previousText.."- "


									Phone:addEventListener( "userInput", textfield )

									native.setKeyboardFocus(Phone)



							elseif event.target.text:len() == 10 then

								if string.find(event.target.text,"-") then

									event.target.text = event.target.text:sub(1,9)
								else

									event.target.text = event.target.text:sub(1,9).."- "..event.target.text:sub(10,10)
								end

							end

							if event.target.text:len() > 15 then

								event.target.text = event.target.text:sub(1,15)

							end

						

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

			end

		end
	end



	local sumbitBtnRelease = function( event )

		if event.phase == "began" then



		elseif event.phase == "ended" then
			local validation = true

			native.setKeyboardFocus(nil)

			if Name.text == "" or Name.text == Name.id  then
				validation=false
				SetError("* "..RequestAccess.Name_error,Name)
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
        		end

        		elseif listFlag == true then

        			rankGroup.isVisible=false


        			listFlag=false

        		end

        	end
        end
        return true
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



	backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
	backBtn.x=20;backBtn.y=BgText.y+BgText.contentHeight/2+20
	backBtn.xScale=-1
	backBtn.anchorY=0

	page_title = display.newText(sceneGroup,RequestAccess.PageTitle,0,0,native.systemFont,18)
	page_title.x=backBtn.x+18;page_title.y=backBtn.y+8
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))
	



		FirstName_bg = display.newRect(W/2, page_title.y+35, W-20, 28)
		sceneGroup:insert(FirstName_bg)

		FirstName = native.newTextField(W/2, page_title.y+35, W-20, 28)
		FirstName.id="First Name"
		FirstName.size=14	
		FirstName.hasBackground = false
		FirstName:setReturnKey( "next" )
		FirstName.placeholder=RequestAccess.FirstName_placeholder
		sceneGroup:insert(FirstName)


		Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+10, W-20, 28)
		sceneGroup:insert(Name_bg)

		Name = native.newTextField( W/2, FirstName_bg.y+FirstName_bg.height+10, W-20, 28)
		Name.id="Last Name"
		Name.size=14
		Name:setReturnKey( "next" )
		Name.hasBackground = false	
		Name.placeholder = RequestAccess.LastName_placeholder
		sceneGroup:insert(Name)


		Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+10, W-20, 28 )
		sceneGroup:insert(Email_bg)

		Email = native.newTextField(W/2, Name_bg.y+Name_bg.height+10, W-20, 28 )
		Email.id="Email"
		Email.size=14	
		Email:setReturnKey( "next" )
		Email.hasBackground = false
		Email.placeholder=RequestAccess.EmailAddress_placeholder
		sceneGroup:insert(Email)


		Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.height+10, W-20, 28)
		sceneGroup:insert(Phone_bg)


		Phone = native.newTextField(W/2, Email_bg.y+Email_bg.height+10, W-20, 28)
		Phone.id="Phone"
		Phone.size=14	
		Phone:setReturnKey( "next" )
		Phone.hasBackground = false
		Phone.placeholder=RequestAccess.Phone_placeholder
		Phone.inputType = "number"
		sceneGroup:insert(Phone)


		if AppName ~= "DirectorApp" then
			UnitNumber_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+10, W-20, 28)
			sceneGroup:insert(UnitNumber_bg)

			UnitNumber = native.newTextField(W/2, Phone_bg.y+Phone_bg.height+10, W-20, 28 )
			UnitNumber.id = "Unit Number / Director name"
			UnitNumber.value=""
			UnitNumber.size=14	
			UnitNumber:setReturnKey( "go" )
			UnitNumber.hasBackground = false
			UnitNumber.placeholder=LoginPage.Unitnumber_placeholder
			sceneGroup:insert(UnitNumber)

			MKRank_bg = display.newRect(W/2, UnitNumber_bg.y+UnitNumber_bg.height+10, W-20, 28)

		else
			MKRank_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+10, W-20, 28)

		end

		MKRank_bg.id="MKrank"
		sceneGroup:insert(MKRank_bg)



		MKRank = display.newText("",MKRank_bg.x+10,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.height,native.systemFont,14 )
		MKRank.text = RequestAccess.MKRank_placeholder
		MKRank.value = "-Select MK Rank-"
		MKRank.id="MKrank"
		MKRank.alpha=0.7
		MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		MKRank.y=MKRank_bg.y+5
	--MKRank.size=20
	sceneGroup:insert(MKRank)

	  		rankText_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
	  		rankText_icon.x=MKRank_bg.x+MKRank_bg.contentWidth/2-15
	  		rankText_icon.y=MKRank_bg.y




	Comment_bg = display.newRect( W/2, 0, W-20, 100)
	Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2
	sceneGroup:insert(Comment_bg)


	Comment = native.newTextBox(W/2, Comment_bg.y, W-20, 100 )
	Comment.id = "Comments"
	Comment.size=14	
	Comment.hasBackground = false
	Comment:setReturnKey( "done" )
	Comment.isEditable = true
	Comment.placeholder=RequestAccess.Comment_placeholder
	sceneGroup:insert(Comment)



	sumbitBtn = display.newRect( 0,0,0,0 )
	sumbitBtn.x=W/2;sumbitBtn.y = Comment_bg.y+Comment_bg.height/2+35
	sumbitBtn.width=80
	sumbitBtn.height=35
	sumbitBtn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
	sceneGroup:insert(sumbitBtn)
	sumbitBtn.id="Submit"



sumbitBtn_lbl = display.newText( sceneGroup,CommonWords.submit,0,0,native.systemFont,16 )
sumbitBtn_lbl.x = sumbitBtn.x-sumbitBtn.contentWidth/2+15;sumbitBtn_lbl.y=sumbitBtn.y
sumbitBtn_lbl.anchorX=0

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


		elseif phase == "did" then

			composer.removeHidden()

			openPage="requestAccess Page"


		MKRank_bg:addEventListener( "touch", rankTouch )
		MKRank:addEventListener( "touch", rankTouch )

		FirstName:addEventListener( "userInput", textfield )
		Name:addEventListener( "userInput", textfield )
		Email:addEventListener( "userInput", textfield )
		Phone:addEventListener( "userInput", textfield )
		UnitNumber:addEventListener( "userInput", textfield )
		Comment:addEventListener( "userInput", textfield )
		
					Background:addEventListener("touch",touchBg)


		function GetListArray(response)


			for i=1,#response do

				List_array[i] = {}
				List_array[i][1] = response[i].MkRankLevel
				List_array[i][2] = response[i].MkRankId

			end
  		---Listview---

  		rankTop_bg = display.newRect( rankGroup, MKRank_bg.x, H/2-10, MKRank_bg.contentWidth+3, 331 )
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
  	rankList.height = 300
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

		

		backBtn:addEventListener("touch",backAction)
		page_title:addEventListener("touch",backAction)

		 local function RequestonKeyEvent( event )
		        local phase = event.phase
		        local keyName = event.keyName


		       if ( "back" == keyName ) then

		        		scrollTo( 0 )
		                native.setKeyboardFocus(nil)
		          
		        end
		        -- we handled the event, so return true.
		        -- for default behavior, return false.
		        return true
   		end

    -- Add the key callback
   Runtime:addEventListener( "key", RequestonKeyEvent );

		 

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