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
require("res.value.string")
local List_array = {}
local mkRank_id=0
local current_textField,defalut
local FirstnameGroup = display.newGroup()
local nameGroup = display.newGroup()
local emailGroup = display.newGroup()
local phoneGroup = display.newGroup()
local unitnumberGroup = display.newGroup()
local commentGroup = display.newGroup()
local rankGroup = display.newGroup()

--malarkodi.sellamuthu@w3magix.com

--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

local Background,BgText


local list_response_total = {}
local list_response = {}

--Button
local sumbitBtn,scrollView

--TexView
local PageTitle;

--rank
local rankList,rankTop,rankClose,rankText

--Edittext
local PageTitle,Name_bg,Name,Email_bg,Email,Phone_bg,Phone,UnitNumber_bg,UnitNumber,MKRank_bg,MKRank,Comment_bg,Comment

openPage="request_Access_Page"

local listFlag= false

local unitnumer_list


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

local function onRowRender_unitnumber_request( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rect = display.newRect(row,0,0,row.width,rowHeight)
    rect.anchorX = 0
    rect.x = 0
    rect.y=rowHeight * 0.5
    rect:setFillColor(0,0,0,0.1)
    rect.strokeWidth = 1
    rect:setStrokeColor( 0, 0, 0,0.3 ) 
    local rowTitle


    if (list_response[row.index]) ~= nil then
    	rowTitle = display.newText( row, list_response[row.index].DirectorName, 0, 0, nil, 14 )
    else
    	rowTitle = display.newText( row, "", 0, 0, nil, 14 )

    end
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 10
    rowTitle.y = rowHeight * 0.5

    row.name = rowTitle.text
    if list_response[row.index].UnitNumber then
    	row.id = list_response[row.index].UnitNumber
    end
end


local function onRowTouch_unitnumber_request( event )

	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then


		elseif ( "release" == phase ) then

			native.setKeyboardFocus(nil)

			unitnumer_list.alpha=0

			Comment.isVisible=true

			UnitNumber.text = row.name
			UnitNumber.value = row.id

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

	local function scroll(scroll_value)

		--[[scrollView:scrollToPosition
		{

		y = scroll_value,
		time = 400,
	}]]

end

local function RequestProcess()

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
			
		local function alertFun(value)


					local function onComplete( event )
						   if event.action == "clicked" then
						        local i = event.index
						        if i == 1 then   
						        	local options = {
										effect = "slideRight",
										time = 600,
										params = { responseValue=list_response_total}
										}
									composer.gotoScene( "Controller.singInPage", options )
						        end
						    end
						end


			local alert = native.showAlert( "Request Access", value, { "OK" }, onComplete )

			end	

									

		if Request_response == "REQUEST"  then

			alertFun("Request already sent")

		elseif Request_response == "FIRSTREQUEST" then

			alertFun("Your Request Access has been sent successfully")

		elseif Request_response == "OPEN" then

			alertFun("Request Access sent")
						
		elseif Request_response == "GRANT" then

			alertFun("Access already granted")

		elseif Request_response == "NOUNITNUMBER" then

			SetError("* Enter the Valid UnitNumber",UnitNumber)

		elseif Request_response == "BLOCK"  then

			alertFun("Access denied already")


		elseif Request_response == "DENY" then

			alertFun("Access denied already")

		elseif Request_response == "FAIL" then

			alertFun("Enter Valid credentials")
		end

	end
					if FirstName.text == FirstName.id then
						FirstName.text=""
					end
					if AppName == "DirectorApp" then

						Webservice.REQUEST_ACCESS(FirstName.text,Name.text,Email.text,Phone.text,Unitnumber_value,mkRank_id,Comment.text,get_requestAccess)
					else
						Webservice.REQUEST_ACCESS(FirstName.text,Name.text,Email.text,Phone.text,UnitNumber.value,mkRank_id,Comment.text,get_requestAccess)
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


					elseif ( event.phase == "ended" or event.phase == "submitted" ) then

					       			

        			elseif ( event.phase == "editing" ) then


	       				if(current_textField.id == "Comments") then
        					if event.text:len() > 160 then

								event.target.text = event.text:sub(1,160)

							end

						elseif(current_textField.id =="Phone") then

							local tempvalue = event.target.text:sub(1,1)

							if (event.text:len() == 3) then

								if (tempvalue ~= "(") then


									event.target.text = "("..event.text..") "

								else

									event.target.text = event.text:sub(2,event.target.text:len())


								end
							elseif event.text:len() == 5 and (tempvalue == "(") then

								if event.text:sub(5,5) ~= ")" then

									event.target.text = event.text:sub(1,4)..") "..event.text:sub(5,5)
				
								end


							elseif event.text:len() == 9 and not string.find(event.text,"-") then

								event.target.text = event.target.text.."- "

							elseif event.text:len() == 10 then

								if string.find(event.text,"-") then

									event.target.text = event.text:sub(1,9)
								else

									event.target.text = event.text:sub(1,9).."- "..event.text:sub(10,10)
								end

							end

							if event.text:len() > 15 then

								event.target.text = event.text:sub(1,15)

							end

							--(123) 654- 8901
        				end

        			if(current_textField.id == "Unit Number / Director name") then

        				unitnumer_list.alpha=1

        					if event.text:len() > 50 then

							event.target.text = event.text:sub(1,50)

						end


						unitnumer_list.alpha=1

						---UserName.isVisible=false

						current_textField.value=0

						unitnumer_list:deleteAllRows()

						--list_response = list_response_total

						if #list_response ~= nil then
							for i = #list_response,1,-1 do
								table.remove(list_response,i)
							end
						end

						for i = #list_response_total,1,-1 do
							local temp = event.text

							local tempvalue = temp:sub(temp:len(),temp:len())

							if(tempvalue == "(") then
								event.text = event.text:sub( 1, event.text:len()-1)
							end

							if string.find( list_response_total[i].DirectorName:upper(), event.text:upper() ) then
								list_response[#list_response+1] = list_response_total[i]
							end
							
						end



					if list_response ~= nil then

						print( #list_response )

						if #list_response == 0 then

							Comment.isVisible=true

							unitnumer_list.alpha=0


						else

							Comment.isVisible=false
						end

						for i = 1, #list_response do
						  	-- Insert a row into the tableView
						  	unitnumer_list:insertRow{}

						end
					else
						Comment.isVisible=true

					end

 				local dotFlag = string.find(event.text,"%.")

						if event.text == "" or dotFlag then
							
							unitnumer_list.alpha=0
							Comment.isVisible=true

						end



						end

					end
				end


			




	local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth



    local rowTitle = display.newText(row, List_array[row.index][1], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
    rowTitle.anchorX = 0
    rowTitle.x = 5
    rowTitle.y = rowHeight * 0.5


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

			if FirstName.text == "" or FirstName.text == FirstName.id  then
				--validation=false
				--SetError("* Enter the First Name",FirstName)

				--FirstName.text = " "
			end

			if Name.text == "" or Name.text == Name.id  then
				validation=false
				SetError("* Enter the Last Name",Name)
			end
			if Email.text == "" or Email.text == Email.id then
				validation=false
				SetError("* Enter the Email",Email)
			else

				if not Utils.emailValidation(Email.text) then
					validation=false
					SetError("* Enter the valid email",Email)

				end

			end
			if Phone.text == "" or Phone.text == Phone.id then
				validation=false
				SetError("* Enter the Phone Number",Phone)
			end
			if AppName ~= "DirectorApp" then
				if UnitNumber.value == "" or UnitNumber.value == UnitNumber.id then
					validation=false
					SetError("* Enter the Unit Number",UnitNumber)
				end
			end
			if MKRank.text == "" then
				validation=false
				SetError("* Select MKRank",MKRank)
			end
			if Comment.text == "" or Comment.text == Comment.id then
				--validation=false
				--SetError("* Enter the Comment",Comment)
				--Comment.text = " "
			end

			if(validation == true) then

				print("request validation complete")
				
				RequestProcess()

			end

	end
return true

end


local function rankTouch( event )
	if event.phase == "began" then

		print("1234")
		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "moved" then
			local dx = math.abs( event.x - event.xStart )
			local dy = math.abs( event.y - event.yStart )
        -- if finger drags button more than 5 pixels, pass focus to scrollView
        if dx > 5 or dy > 5 then
        	print("enter")
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

	page_title = display.newText(sceneGroup,"Request Access",0,0,native.systemFont,18)
	page_title.x=backBtn.x+18;page_title.y=backBtn.y+8
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))
	



		FirstName_bg = display.newRect(W/2, page_title.y+35, W-20, 28)
		FirstnameGroup:insert(FirstName_bg)

		FirstName = native.newTextField(W/2, page_title.y+35, W-20, 28)
		FirstName.id="First Name"
		FirstName.size=14	
		FirstName.placeholder="First Name"
		FirstnameGroup:insert(FirstName)

		sceneGroup:insert(FirstnameGroup)

		Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+10, W-20, 28)
		nameGroup:insert(Name_bg)

		Name = native.newTextField( W/2, FirstName_bg.y+FirstName_bg.height+10, W-20, 28)
		Name.id="Last Name"
		Name.size=14	
		Name.placeholder="Last Name"
		nameGroup:insert(Name)
		sceneGroup:insert(nameGroup)


		Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+10, W-20, 28 )
		emailGroup:insert(Email_bg)

		Email = native.newTextField(W/2, Name_bg.y+Name_bg.height+10, W-20, 28 )
		Email.id="Email"
		Email.size=14	
		Email.placeholder="Email Address"
		emailGroup:insert(Email)
		sceneGroup:insert(emailGroup)


		Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.height+10, W-20, 28)
		phoneGroup:insert(Phone_bg)


		Phone = native.newTextField(W/2, Email_bg.y+Email_bg.height+10, W-20, 28)
		Phone.id="Phone"
		Phone.size=14	
		Phone.placeholder="Phone"
		Phone.inputType = "number"
		phoneGroup:insert(Phone)


		sceneGroup:insert(phoneGroup)



		if AppName ~= "DirectorApp" then
			UnitNumber_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+10, W-20, 28)
			unitnumberGroup:insert(UnitNumber_bg)

			UnitNumber = native.newTextField(W/2, Phone_bg.y+Phone_bg.height+10, W-20, 28 )
			UnitNumber.id = "Unit Number / Director name"
			UnitNumber.value=""
			UnitNumber.size=14	
			UnitNumber.placeholder="Unit Number / Director Name"
			unitnumberGroup:insert(UnitNumber)

			sceneGroup:insert(unitnumberGroup)

			MKRank_bg = display.newRect(W/2, UnitNumber_bg.y+UnitNumber_bg.height+10, W-20, 28)

		else
			MKRank_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+10, W-20, 28)

		end

		MKRank_bg.id="MKrank"
		sceneGroup:insert(MKRank_bg)



		MKRank = display.newText("",MKRank_bg.x+10,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.height,native.systemFont,14 )
		MKRank.text = "-Select MK Rank-"
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
	commentGroup:insert(Comment_bg)


	Comment = native.newTextField( W/2, Comment_bg.y, W-20, 100 )
	Comment.id = "Comments"
	Comment.size=14	
	Comment.placeholder="Enter your comment here"
	commentGroup:insert(Comment)

	sceneGroup:insert(commentGroup)




sumbitBtn = display.newRect( 0,0,0,0 )
sumbitBtn.x=W/2;sumbitBtn.y = Comment_bg.y+Comment_bg.height/2+25
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

			unitnumer_list = widget.newTableView
			{
			left = 0,
			top = 0,
			height = 130,
			width = 300,
			noLines = true,
			onRowRender = onRowRender_unitnumber_request,
			onRowTouch = onRowTouch_unitnumber_request,
			--backgroundColor = { 0.8, 0.8, 0.8 },
			--hideBackground=true,
			listener = scrollListener
		}

		unitnumer_list.x=UnitNumber_bg.x
		unitnumer_list.y=UnitNumber_bg.y+UnitNumber_bg.height/2
		unitnumer_list.anchorY=0

		unitnumer_list.alpha=0

		if event.params.responseValue then

			list_response_total = event.params.responseValue

		end

		
		sceneGroup:insert(unitnumer_list)

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
  		rankTop = display.newRect(rankGroup,W/2,H/2-160,300,30)
  		rankTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

  		rankText = display.newText(rankGroup,"-Select MK Rank-",0,0,native.systemFont,16)
  		rankText.x=rankTop.x;rankText.y=rankTop.y


  		rankClose = display.newImageRect(rankGroup,"res/assert/cancel.png",19,19)
  		rankClose.x=rankTop.x+rankTop.contentWidth/2-15;rankClose.y=rankTop.y
  		rankClose.id="close"

  		rankTop:addEventListener("touch",rankToptouch)
  		rankText:addEventListener("touch",rankToptouch)
  		rankClose:addEventListener("touch",rankToptouch)

  		

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
			    rankList:insertRow{ rowHeight = 30,
			    rowColor = { default={ 1,1,1}, over={ 0, 0, 0, 0.1 } }

			}
		end
end


	Webservice.GET_LIST_OF_RANKS(GetListArray)

		

		backBtn:addEventListener("touch",backAction)
		page_title:addEventListener("touch",backAction)

end	

MainGroup:insert(sceneGroup)

end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then



--MUB_Android_Dev_V1.0.0_11042015_b1.apk

elseif phase == "did" then

	MKRank_bg:removeEventListener( "touch", rankTouch )
	MKRank:removeEventListener( "touch", rankTouch )
	rankTop:removeEventListener("touch",rankToptouch)
	rankText:removeEventListener("touch",rankToptouch)
	rankClose:removeEventListener("touch",rankToptouch)


	composer.removeHidden()



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