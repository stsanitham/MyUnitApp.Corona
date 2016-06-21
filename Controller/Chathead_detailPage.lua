----------------------------------------------------------------------------------
--
-- careerPathDetailPage.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local json = require("json")
local popupGroup = require( "Controller.popupGroup" )
local alertGroup = require( "Controller.alertGroup" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,pageTitle,changeList_order_icon

local menuBtn,contactId,Message_Type,PageValueType

local Details = {}

local Details_Display = {}

openPage="careerPathPage"

local Career_Username , id_value , popupevnt_value

local leftPadding = 10

local myMap,map_close

local Image,below_tab,below_mail,below_call,below_map

local mapGroup = display.newGroup()

local phoneNum = ""

local RecentTab_Topvalue

ContactIdValue = 0

local contactCount = {}

local ProfileImage,careerDetail_scrollview

pagevalue = "careerPathPage"

local groupMemberListArray = {}

local status ="normal"
--------------------------------------------------


-----------------Function-------------------------



makeTimeStamp_career = function ( dateString )

	local pattern = "(%d+)%/(%d+)%/(%d+)T(%d+):(%d+):(%d+)"

	local month, day, year , hour, minute, seconds, tzoffset, offsethour, offsetmin =
	dateString:match(pattern)

	
	local timestamp = os.time( {year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false} )

	return timestamp;
end


local function bgTouch( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		print('bg touch')
	end

	return true

end

local function addMemberAction( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

					 --    local options = {
						-- effect = "crossFade",
						-- time = 500,	
						-- }

	     --    composer.showOverlay( "Controller.consultantListPage", options )
	     	status="editArray"
	     	composer.hideOverlay( "slideRight", 100 )
		
	end

	return true

end



local function emailTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		local careerMail =
			{
			  to = event.target.value,
			}
 
		native.showPopup( "mail", careerMail )

	end

	return true

end



local function observableScroll( event )

    local phase = event.phase
    if ( phase == "began" ) then 
    elseif ( phase == "moved" ) then 

    	if event.direction ~= nil then

    	-- print("Direction : "..event.direction)

    	 	if event.direction == "up" then

    	 		if TrasitionBar.yScale >= 0.2 then


    	 			event.target:scrollTo( "top" , { time=0})

    	 			--display.getCurrentStage():setFocus(nil)

    	 			--ProfileImage.yScale=ProfileImage.yScale-0.05

    	 			TrasitionBar.yScale=TrasitionBar.yScale-0.05

    	 			TrasitionBar.alpha=TrasitionBar.alpha+0.08


    	 			careerDetail_scrollview.y=TrasitionBar.y+TrasitionBar.contentHeight

	   	 			if Career_Username.y >= tabBar.y+30 then

    	 				Career_Username.y=Career_Username.y-8.8


    	 				Career_Username.xScale = Career_Username.xScale - 0.018
    	 				Career_Username.yScale = Career_Username.yScale - 0.018
    	 				Career_Username.x=Career_Username.x+0.8

    	 			end

  	 			

    	 		else


    	 		end

    	 	elseif event.direction == "down" then

    	 			if TrasitionBar.yScale <= 1 then


    	 			event.target:scrollTo( "top" , { time=0})

    	 			--display.getCurrentStage():setFocus(nil)

    	 			--ProfileImage.yScale=ProfileImage.yScale+0.05
    	 			if Career_Username.y <= ProfileImage.y+ProfileImage.contentHeight-Career_Username.contentHeight/2-25 then

    	 				Career_Username.y=Career_Username.y+8.8

    	 				Career_Username.xScale = Career_Username.xScale + 0.018
    	 				Career_Username.yScale = Career_Username.yScale + 0.018
    	 				Career_Username.x=Career_Username.x-0.8

    	 			end


    	 			careerDetail_scrollview.y=TrasitionBar.y+TrasitionBar.contentHeight

    	 			TrasitionBar.yScale=TrasitionBar.yScale+0.05

    	 			TrasitionBar.alpha=TrasitionBar.alpha-0.08

    	 			local temp = RecentTab_Topvalue - careerDetail_scrollview.y

 	 			

    	 		else


    	 		end

    	 	end


    	end


  

    elseif ( phase == "ended" ) then 
    end

   
  	 -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then 
        elseif ( event.direction == "down" ) then 
        elseif ( event.direction == "left" ) then 
        elseif ( event.direction == "right" ) then 
        end
    end
    return true
end



-- function onFindServiceComplete(response)
--     -- Indicates the carrier support. 0 - unknown (network error/timeout), 1 - available, 2 - unavailable
--     local q1 = response.serviceStatus

--     print("response.serviceStatus"..q1)

--     -- Service ID
--     local q2 =response.serviceId

--     print("response.serviceId"..q2)

--     if response.serviceStatus == fortumo.SERVICE_STATUS_AVAILABLE then
--         -- more code...
--     end
-- end




	local function phoneCallFunction( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			--work
			
			local callFlag

			local number = string.gsub(event.target.id, "%s+", "")

				number = string.gsub(number,"%(" , "")
				number = string.gsub(number,"%)" , "")
				number = string.gsub(number,"%-" , "")


			print( "Call : "..number )

			--system.openURL( "tel:"..number)

			callFlag = system.openURL( "tel:"..number )

			 if callFlag == true  then 

				--fortumo.findService({callFlag}, onFindServiceComplete)

			 else

			 	if isIos then 

			 		native.showAlert( CareerPath.Call, CareerPath.NoSim, { CommonWords.ok } )

			 	end

			end
		end

		return true

	end


	local function closeDetails( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then

			print( "closeDetails" )
			display.getCurrentStage():setFocus( nil )

			composer.hideOverlay( "slideRight", 300 )



		end

		return true

	end

	local function MapShowing( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			print("MapShowing")

			if event.target.id == "close" then
				mapGroup.isVisible=false
				if myMap then myMap.isVisible=false end
			else
				mapGroup.isVisible=true
				if myMap then myMap.isVisible=true end
			end
		end

		return true

	end







	function get_removeorblockDetails( response)

		Request_response = response


	    function onCompletion(event)

	       if "clicked"==event.action then


			 AlertGroup.isVisible = false

			 ContactIdValue = contactId

	         composer.hideOverlay()

	       end

         end



		 if id_value == "Remove Access" then

	        local remove_successful= native.showAlert(CommonWords.Remove , CareerPath.RemovedText, { CommonWords.ok} , onCompletion)


		 elseif id_value == "Block Access" then

			local block_successful = native.showAlert(CommonWords.Block , CareerPath.BlockedText, { CommonWords.ok} , onCompletion)

		 end


         if id_value == "Deny Access" then

         	 if Request_response == "SUCCESS" then

         	 	denyaccess = native.showAlert(CommonWords.Deny, CareerPath.DeniedText, { CommonWords.ok } , onCompletion)

         	 elseif Request_response == "GRANT" then

         	 	granted = native.showAlert(CareerPath.AlreadyGranted, CareerPath.AlreadyGrantedText, { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert(CareerPath.AlreadyRemoved, CareerPath.AlreadyRemovedText, { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert(CareerPath.AddRequest, CareerPath.AddRequestText, { CommonWords.ok} , onCompletion)

		 	     elseif Request_response == "BLOCK" then

		 	    addrequest = native.showAlert(CareerPath.AlreadyBlocked, CareerPath.AlreadyBlockedText, { CommonWords.ok} , onCompletion)

         	 end

         elseif id_value == "Grant Access" then

	 	    if Request_response == "SUCCESS" then

	 	    	grantaccess = native.showAlert(CommonWords.GrantAccessText, CareerPath.GrantSuccessText, { CommonWords.ok} , onCompletion)

	 	     elseif Request_response == "GRANT" then

         	 	granted = native.showAlert(CareerPath.AlreadyGranted, CareerPath.AlreadyGrantedText, { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert(CareerPath.AlreadyRemoved, CareerPath.AlreadyRemovedText, { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert(CareerPath.AddRequest, CareerPath.AddRequestText, { CommonWords.ok} , onCompletion)

		 	 elseif Request_response == "BLOCK" then

		 	    addrequest = native.showAlert(CareerPath.AlreadyBlocked, CareerPath.AlreadyBlockedText, { CommonWords.ok} , onCompletion)

         	 end

	 	elseif id_value == "Provide Access" then

	 	    if Request_response == "SUCCESS" then

	 	    	accessprovided = native.showAlert(CommonWords.ProvideAccessText, CareerPath.ProvideAccessSuccessText , { CommonWords.ok } , onCompletion)

	 	     elseif Request_response == "GRANT" then

         	 	granted = native.showAlert(CareerPath.AlreadyGranted, CareerPath.AlreadyGrantedText, { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert(CareerPath.AlreadyRemoved, CareerPath.AlreadyRemovedText, { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert(CareerPath.AddRequest, CareerPath.AddRequestText, { CommonWords.ok} , onCompletion)

		 	     elseif Request_response == "BLOCK" then

		 	    addrequest = native.showAlert(CareerPath.AlreadyBlocked, CareerPath.AlreadyBlockedText, { CommonWords.ok} , onCompletion)

         	 end

         end

	end



	local function onKeycareerDetail( event )

	        local phase = event.phase
	        local keyName = event.keyName

	        if phase == "up" then

	        if keyName=="back" then

	        	composer.hideOverlay( "slideRight", 300 )

	        	 return true
	            
	        end

	    end

	        return false
	 end




local function CreateGroupMemberList( list )


	for j=#groupMemberListArray, 1, -1 do 
		
		display.remove(groupMemberListArray[#groupMemberListArray])
		groupMemberListArray[#groupMemberListArray] = nil
	end

	local ContactList = list.Contact

	for i=1,#ContactList do
      


		groupMemberListArray[#groupMemberListArray+1] = display.newGroup()

		local tempGroup = groupMemberListArray[#groupMemberListArray]

		local Image 

		local tempHeight = 0

		local background = display.newRect(tempGroup,0,0,W,50)

		if(groupMemberListArray[#groupMemberListArray-1]) ~= nil then
			tempHeight = groupMemberListArray[#groupMemberListArray-1][1].y + groupMemberListArray[#groupMemberListArray-1][1].height+3
		end

		background.anchorY = 0
		background.x=W/2;background.y=tempHeight
		background.alpha=0.01
		background.value = ContactList[i]

		contactCount[#contactCount+1] = ContactList[i].Contact_Id

		  local filePath = system.pathForFile( ContactList[i].Contact_Id..".png",system.TemporaryDirectory )
		  local fhd = io.open( filePath )

		  local Image

		 if fhd then

			Image = display.newImageRect(tempGroup,ContactList[i].Contact_Id..".png",system.TemporaryDirectory,45,38)

			io.close( fhd )

		else

			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

		end

					Image.x=30;Image.y=background.y+background.height/2

						local mask = graphics.newMask( "res/assert/masknew.png" )

									Image:setMask( mask )

		local name

		if ContactList[i].First_Name ~= nil then 
			name = ContactList[i].First_Name.." "..ContactList[i].Last_Name
		else

			name = ContactList[i].Last_Name


		end

		local Name_txt = display.newText(tempGroup,name,0,0,native.systemFont,14)
		Name_txt.x=60;Name_txt.y=background.y+background.height/2-10
		Name_txt.anchorX=0
		Utils.CssforTextView(Name_txt,sp_labelName)
		Name_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		local Position_txt = display.newText(tempGroup,ContactList[i].Email_Address,0,0,native.systemFont,14)
		Position_txt.x=60;Position_txt.y=background.y+background.height/2+10
		Position_txt.anchorX=0
		Utils.CssforTextView(Position_txt,sp_fieldValue)

		if Position_txt.text:len() > 26 then		
			Position_txt.text = string.sub(Position_txt.text,1,26).."..."
		end


		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


		--tempGroup.Contact_Id = list[i].Contact_Id

		careerDetail_scrollview:insert(tempGroup)

		--background:addEventListener( "touch", consultantTounch )


	end

end

------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	
	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0


	MainGroup:insert(sceneGroup)

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		elseif phase == "did" then


				contactId = event.params.contactId
				Message_Type = event.params.MessageType
				GroupType_Value = event.params.GroupTypeValue


				print("TypeValue : "..Message_Type)

				for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

					ContactId = row.ContactId

				end

				titleBar = display.newRect(sceneGroup,W/2,tabBar.y+tabBar.contentHeight/2,W,30)
				titleBar.anchorY=0
				titleBar.isVisible=false

				titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

			local function get_MessageGroupTeamMemberList( response )

				Details = response

				json.encode( Details )

	
				local path = system.pathForFile( "career"..contactId..".png",system.TemporaryDirectory)
				local fhd = io.open( path )


				-- Determine if file exists
				if fhd then
				   ProfileImage = display.newImage("career"..contactId..".png",system.TemporaryDirectory)
				   fhd:close()
				else
				    ProfileImage = display.newImage("res/assert/detail_defalut.jpg")
				end


				sceneGroup:insert( ProfileImage )
				ProfileImage.width = W;ProfileImage.height = 180
				ProfileImage.x=W/2;ProfileImage.y=titleBar.y
				ProfileImage.anchorY=0

				TrasitionBar = display.newRect(sceneGroup,ProfileImage.x,ProfileImage.y,ProfileImage.width,ProfileImage.height)
				TrasitionBar.anchorY=0
				TrasitionBar.alpha=0
				TrasitionBar:setFillColor(Utils.convertHexToRGB("#B6B6B6"))

				titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
				titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+15
				titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
				titleBar_icon.anchorY=0

				titleBar_icon_bg = display.newRect(sceneGroup,0,0,25,28)
				titleBar_icon_bg.x=titleBar.x-titleBar.contentWidth/2+20
				titleBar_icon_bg.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon_bg.contentWidth+10
				titleBar_icon_bg.anchorY=0
				titleBar_icon_bg.alpha=0.01

				titleBar_icon_bg:addEventListener("touch",closeDetails)


				Career_Username = display.newText(sceneGroup,Details.MyUnitBuzzGroupName,0,0,native.systemFont,24)
				Career_Username.x=leftPadding
				Career_Username.y=ProfileImage.y+ProfileImage.contentHeight-Career_Username.contentHeight/2-20
				Career_Username.anchorX=0;Career_Username.anchorY=0
				Career_Username.name = "userName"
				Career_Username.fontSize=24
				Career_Username:addEventListener("touch",closeDetails)


				if Message_Type == "GROUP" or Message_Type == "BROADCAST" then
					local addRecipient = display.newImageRect( sceneGroup, "res/assert/addmember.png", 18, 15 )
					addRecipient.anchorY=0
					addRecipient.x=W-30;addRecipient.y = titleBar_icon_bg.y+5
					addRecipient:addEventListener( "touch", addMemberAction )
				end

				RecentTab_Topvalue = ProfileImage.y+ProfileImage.contentHeight

				careerDetail_scrollview = widget.newScrollView
					{
					top = 0,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue+ProfileImage.contentHeight-35,
					--hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
					listener = observableScroll
				}

				--spinner_show()
				careerDetail_scrollview.y=RecentTab_Topvalue
				careerDetail_scrollview.x=W/2
				careerDetail_scrollview.anchorY=0
				sceneGroup:insert(careerDetail_scrollview)

				CreateGroupMemberList(response)


			end

	
			local function get_avtiveTeammemberDetails( response)

				print("Career Detail Response ",json.encode(response))

				--local nativeee = native.showAlert("MUB",json.encode(response),{"OK"})

				Details = response

				-- detailcontactid = Details.ContactId
				-- print("detailcontactid before assigning"..detailcontactid)

				
			

				if Details.ImagePath ~= nil then
					ProfileImage = display.newImage(sceneGroup,contactId..".png",system.TemporaryDirectory)

				end

				if not ProfileImage then
					ProfileImage = display.newImageRect(sceneGroup,"res/assert/detail_defalut.jpg",80,80)
				end

				ProfileImage.width = W;ProfileImage.height = 180
				ProfileImage.x=W/2;ProfileImage.y=titleBar.y
				ProfileImage.anchorY=0

				TrasitionBar = display.newRect(sceneGroup,ProfileImage.x,ProfileImage.y,ProfileImage.width,ProfileImage.height)
				TrasitionBar.anchorY=0
				TrasitionBar.alpha=0
				TrasitionBar:setFillColor(Utils.convertHexToRGB("#B6B6B6"))

				titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
				titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+15
				titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
				titleBar_icon.anchorY=0

				titleBar_icon_bg = display.newRect(sceneGroup,0,0,25,28)
				titleBar_icon_bg.x=titleBar.x-titleBar.contentWidth/2+20
				titleBar_icon_bg.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon_bg.contentWidth+10
				titleBar_icon_bg.anchorY=0
				titleBar_icon_bg.alpha=0.01

				titleBar_icon_bg:addEventListener("touch",closeDetails)




			    if Details.FirstName ~= nil and Details.LastName ~= nil then

					Career_Username = display.newText(sceneGroup,Details.FirstName.." "..Details.LastName,0,0,native.systemFont,24)

				elseif Details.FirstName == nil  and Details.LastName ~= nil  then

					Career_Username = display.newText(sceneGroup,Details.LastName,0,0,native.systemFont,24)

				elseif Details.FirstName ~= nil  and Details.LastName == nil  then

					Career_Username = display.newText(sceneGroup,Details.FirstName,0,0,native.systemFont,24)

				end
				
				Career_Username.x=leftPadding
				Career_Username.y=ProfileImage.y+ProfileImage.contentHeight-Career_Username.contentHeight/2-20
				Career_Username.anchorX=0;Career_Username.anchorY=0
				Career_Username.name = "userName"
				Career_Username.fontSize=24
				Career_Username:addEventListener("touch",closeDetails)



				RecentTab_Topvalue = ProfileImage.y+ProfileImage.contentHeight

					careerDetail_scrollview = widget.newScrollView
					{
					top = 0,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue+ProfileImage.contentHeight,
					--hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
					listener = observableScroll
				}

				--spinner_show()
				careerDetail_scrollview.y=RecentTab_Topvalue
				careerDetail_scrollview.x=W/2
				careerDetail_scrollview.anchorY=0
				sceneGroup:insert(careerDetail_scrollview)


				Details_Display[#Details_Display+1] = display.newText("",0,0,native.systemFont,18)
				Details_Display[#Details_Display].x=leftPadding
				Details_Display[#Details_Display].y = -10
				Details_Display[#Details_Display]:setFillColor( 0 )
				careerDetail_scrollview:insert( Details_Display[#Details_Display] )

				if(Details.DateOfBirth ~= nil) then

					local birthday_icon = display.newImageRect("res/assert/birthday.png",22,24)
					birthday_icon.anchorX = 0 ;birthday_icon.anchorY=0
					birthday_icon.x=leftPadding
					birthday_icon.y=20
					careerDetail_scrollview:insert( birthday_icon )

					--local timeGMT = makeTimeStamp_career(Details.DateOfBirth.."T00:00:00")

					Details_Display[#Details_Display+1] = display.newText(Details.DateOfBirth,0,0,native.systemFont,18)
--					Details_Display[#Details_Display+1] = display.newText(os.date( "%B %d, %Y" , timeGMT ),0,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=birthday_icon.x+birthday_icon.contentWidth+5
					Details_Display[#Details_Display].y = birthday_icon.y
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					Details_Display[#Details_Display].name = "birthDay"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.AnniversariesDate ~= nil) then

					local anniversari_icon = display.newImageRect("res/assert/anniversary.png",22,18)
					anniversari_icon.anchorX = 0 ;anniversari_icon.anchorY=0
					anniversari_icon.x=leftPadding
					anniversari_icon.y=Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+15
					careerDetail_scrollview:insert( anniversari_icon )

					--local timeGMT = makeTimeStamp_career(Details.AnniversariesDate.."T00:00:00")

					--Details_Display[#Details_Display+1] = display.newText(os.date( "%B %d, %Y" , timeGMT ),0,0,native.systemFont,18)
					Details_Display[#Details_Display+1] = display.newText(Details.AnniversariesDate,0,0,native.systemFont,18)
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=anniversari_icon.x+anniversari_icon.contentWidth+5
					Details_Display[#Details_Display].y = anniversari_icon.y
					Details_Display[#Details_Display].name = "Anniversarie"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end


				--Email ---


				if(Details.EmailAddress ~= nil) then

					local EmailAddress = display.newText(LoginPage.UserName_placeholder,0,0,150,0,native.systemFont,16)
					EmailAddress.anchorX = 0 ;EmailAddress.anchorY=0
					EmailAddress.x=leftPadding
					EmailAddress.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					Utils.CssforTextView(EmailAddress,sp_labelName)
					careerDetail_scrollview:insert( EmailAddress )

					Details_Display[#Details_Display+1] = display.newText(Details.EmailAddress,0,0,native.systemFont,14)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=leftPadding
					Details_Display[#Details_Display].y = EmailAddress.y+20
					Details_Display[#Details_Display].name = "EmailAddress"
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end



			
				-----------Details_Display---------

				if(Details.RecruitedDate ~= nil) then

					local RecruitedDate = display.newText(CareerPath.When,0,0,150,0,native.systemFont,16)
					RecruitedDate.anchorX = 0 ;RecruitedDate.anchorY=0
					RecruitedDate.x=leftPadding
					RecruitedDate.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					Utils.CssforTextView(RecruitedDate,sp_labelName)
					careerDetail_scrollview:insert( RecruitedDate )



					local timeGMT = Utils.makeTimeStamp(Details.RecruitedDate)

					local month = Utils.GetMonth(os.date( "%b" , timeGMT ))

					local value
					
					if CommonWords.language == "Canada English" then

						value = os.date( " %d " , timeGMT )..month..os.date( ", %Y" , timeGMT  )

					else

						value = month..os.date( " %d, %Y" , timeGMT)

					end

					Details_Display[#Details_Display+1] = display.newText(value,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruitedDate.y 
					Details_Display[#Details_Display].name = "RecruitedDate"
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.ConsultantNumber ~= nil) then

					local ConsultantNumber = display.newText(CareerPath.Consultant_No,0,0,150,0,native.systemFont,16)
					ConsultantNumber.anchorX = 0 ;ConsultantNumber.anchorY=0
					ConsultantNumber.x=leftPadding
					ConsultantNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					Utils.CssforTextView(ConsultantNumber,sp_labelName)
					careerDetail_scrollview:insert( ConsultantNumber )

					Details_Display[#Details_Display+1] = display.newText(Details.ConsultantNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = ConsultantNumber.y
					Details_Display[#Details_Display].name = "ConsultantNumber"
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.UnitNumber ~= nil) then

					
					local UnitNumber = display.newText(CareerPath.Unit_No,0,0,150,0,native.systemFont,16)
					UnitNumber.anchorX = 0 ;UnitNumber.anchorY=0
					Utils.CssforTextView(UnitNumber,sp_labelName)
					UnitNumber.x=leftPadding
					UnitNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					careerDetail_scrollview:insert( UnitNumber )

					Details_Display[#Details_Display+1] = display.newText(Details.UnitNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = UnitNumber.y
					Details_Display[#Details_Display].name = "UnitNumber"
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.RecruiterNumber ~= nil) then

					local RecruiterNumber = display.newText(CareerPath.Recruiter_No,0,0,150,0,native.systemFont,16)
					RecruiterNumber.anchorX = 0 ;RecruiterNumber.anchorY=0
					RecruiterNumber.x=leftPadding
					RecruiterNumber.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					Utils.CssforTextView(RecruiterNumber,sp_labelName)
					careerDetail_scrollview:insert( RecruiterNumber )


					Details_Display[#Details_Display+1] = display.newText(Details.RecruiterNumber,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruiterNumber.y
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					Details_Display[#Details_Display].name = "RecruiterNumber"
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				if(Details.RecruiterName ~= nil) then

					local RecruiterName = display.newText(CareerPath.Recruiter_Name,0,0,150,0,native.systemFont,16)
					RecruiterName.anchorX = 0 ;RecruiterName.anchorY=0
					RecruiterName.x=leftPadding
					RecruiterName.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					Utils.CssforTextView(RecruiterName,sp_labelName)
					careerDetail_scrollview:insert( RecruiterName )

					Details_Display[#Details_Display+1] = display.newText(Details.RecruiterName,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = RecruiterName.y
					Details_Display[#Details_Display].name = "RecruiterName"
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end


				if(Details.CareerProgress ~= nil) then

					local CareerProgress = display.newText(CareerPath.Career_Progress,0,0,150,0,native.systemFont,16)
					CareerProgress.anchorX = 0 ;CareerProgress.anchorY=0
					CareerProgress.x=leftPadding
					CareerProgress.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+10
					Utils.CssforTextView(CareerProgress,sp_labelName)
					careerDetail_scrollview:insert( CareerProgress )


					Details_Display[#Details_Display+1] = display.newText(Details.CareerProgress,0,0,160,0,native.systemFont,18)
					Details_Display[#Details_Display].anchorX = 0 ;Details_Display[#Details_Display].anchorY=0
					Details_Display[#Details_Display].x=W/2
					Details_Display[#Details_Display].y = CareerProgress.y 
					Details_Display[#Details_Display].name = "CareerProgress"
					Utils.CssforTextView(Details_Display[#Details_Display],sp_fieldValue)
					careerDetail_scrollview:insert( Details_Display[#Details_Display] )
				end

				Details_Display[#Details_Display+1] = display.newRect( W/2, Details_Display[#Details_Display].y+30, W, 5)
				Details_Display[#Details_Display].isVisible=false
				careerDetail_scrollview:insert( Details_Display[#Details_Display] )


				print("ContactId and event id ",ContactId.."\n"..contactId)


		

				Details_Display[#Details_Display+1] = display.newRect( W/2, Details_Display[#Details_Display].y+30, W, 5)
				Details_Display[#Details_Display].isVisible=false
				careerDetail_scrollview:insert( Details_Display[#Details_Display] )


---------------------------------------------------End of Access Buttons----------------------------------------------------------------------				

				local totalLenth_count = 0

				local MapDisplayArray = {}

				maptap = display.newRect(sceneGroup,W/2,H-30,W,30)
				maptap.anchorY=0
				maptap:setFillColor( Utils.convertHexToRGB(color.LtyGray) )

				if Details.EmailAddress ~= nil then

				MapDisplayArray[#MapDisplayArray+1] = display.newImageRect(sceneGroup,"res/assert/mail.png",33/2,25/2)
				MapDisplayArray[#MapDisplayArray].x=W/4
				MapDisplayArray[#MapDisplayArray].id="email"
				MapDisplayArray[#MapDisplayArray].value = Details.EmailAddress
				MapDisplayArray[#MapDisplayArray].y=maptap.y+maptap.contentHeight/2
				MapDisplayArray[#MapDisplayArray]:addEventListener( "touch", emailTouch )

				end

				
				if Details.HomePhoneNumber ~= nil then
					phoneNum = Details.HomePhoneNumber 
				end
				if Details.WorkPhoneNumber ~= nil then
					phoneNum = Details.WorkPhoneNumber 
				end
				if Details.OtherPhoneNumber ~= nil then
					phoneNum = Details.OtherPhoneNumber 
				end

				if phoneNum ~= "" then
					MapDisplayArray[#MapDisplayArray+1] = display.newImageRect(sceneGroup,"res/assert/phone.png",32/2,32/2)

					if MapDisplayArray[#MapDisplayArray-1] ~= nil then
						MapDisplayArray[#MapDisplayArray].x=W/2
					else
						MapDisplayArray[#MapDisplayArray].x=W/4
					end
					MapDisplayArray[#MapDisplayArray].y=maptap.y+maptap.contentHeight/2
					MapDisplayArray[#MapDisplayArray].id=phoneNum
					MapDisplayArray[#MapDisplayArray]:addEventListener("touch",phoneCallFunction)
				end	

				if Details.ContactsAddress ~= nil then

					MapDisplayArray[#MapDisplayArray+1] = display.newImageRect(sceneGroup,"res/assert/map.png",20/2,32/2)

					if MapDisplayArray[#MapDisplayArray-1] ~= nil then

						MapDisplayArray[#MapDisplayArray].x=W/2+(W/2)/2

					else

						MapDisplayArray[#MapDisplayArray].x=W/2

					end



					MapDisplayArray[#MapDisplayArray].x=maptap.x+90
					MapDisplayArray[#MapDisplayArray].y=maptap.y+maptap.contentHeight/2
					MapDisplayArray[#MapDisplayArray].id = "map"
					MapDisplayArray[#MapDisplayArray]:addEventListener("touch",MapShowing)


					myMap_rect = display.newRect(mapGroup,20, 20, 280, 360)
					myMap_rect.x = display.contentCenterX
					myMap_rect.y = display.contentCenterY-myMap_rect.contentHeight/2
					myMap_rect.strokeWidth = 1
					myMap_rect:setStrokeColor( 0.5 )
					myMap_rect.anchorY=0
					

					map_title = display.newText(mapGroup,CareerPath.Location,0,0,native.systemFont,16)
					map_title.x=myMap_rect.x-myMap_rect.contentWidth/2+10
					map_title.y=myMap_rect.y+15
					map_title.anchorX=0
					Utils.CssforTextView(map_title,sp_labelName)

				local location =""

				if Details.ContactsAddress.Address1 ~= nil and Details.ContactsAddress.Address1 ~= "" then

					if location:len() > 0  then

						location = location..","

					end

					location = location..Details.ContactsAddress.Address1

				end
				if Details.ContactsAddress.Address2 ~= nil and Details.ContactsAddress.Address2 ~= "" then

					if location:len() > 0  then

						location = location..","

					end

					location = location..Details.ContactsAddress.Address2
					
				end

				if location:len() > 0  then

						location = location.."\n"

				end

				if Details.ContactsAddress.City ~= nil and Details.ContactsAddress.City ~= "" then
				
					location = location..Details.ContactsAddress.City..","
					
				end
				if Details.ContactsAddress.State ~= nil and Details.ContactsAddress.State ~= "" then
				
					location = location..Details.ContactsAddress.State..","
					
				end
				
				if Details.ContactsAddress.Zip ~= nil and Details.ContactsAddress.Zip ~= "" then
				
					location = location..Details.ContactsAddress.Zip	
					
				end

				if location:sub( location:len() ,location:len()) == "," then
					location = location:sub( 1 ,location:len()-1)
				end

				map_location= display.newText(mapGroup,location,0,0,320,0,native.systemFont,14)
				map_location.x=myMap_rect.x-myMap_rect.contentWidth/2+10
				map_location.y=myMap_rect.y+25
				map_location.anchorY=0
				map_location.anchorX=0
				Utils.CssforTextView(map_location,sp_fieldValue)


				map_close = display.newImageRect(mapGroup,"res/assert/cancel.png",20,20)
				map_close.x=myMap_rect.x+myMap_rect.contentWidth/2-15
				map_close.y=myMap_rect.y+15
				map_close.id="close"

				map_close_bg = display.newImageRect(mapGroup,"res/assert/cancel.png",35,35)
				map_close_bg.x=myMap_rect.x+myMap_rect.contentWidth/2-15
				map_close_bg.y=myMap_rect.y+15
				map_close_bg.id="close"
				map_close_bg.alpha=0.01

				map_close_bg:addEventListener("touch",MapShowing)

			
			    	if not isSimulator then

						myMap = native.newMapView( display.contentCenterX, display.contentCenterY+50, 280, 270 )
						mapGroup:insert(myMap)
						myMap.isVisible=false
						myMap.anchorY=0
						myMap.y=map_location.y+map_location.contentHeight+15

						local function locationHandler( event )

							if ( event.isError ) then
								print( "Map Error: " .. event.errorMessage )
							else
								print( "The specified string is at: " .. event.latitude .. "," .. event.longitude )
								if myMap then myMap:setCenter( event.latitude, event.longitude ) 

								local options = 
								{ 
								title = CareerPath.Location, 
								subtitle = location, 
								imageFile =  "res/assert/map.png",
							}
							local result, errorMessage = myMap:addMarker( event.latitude, event.longitude , options )

							end
						end

					end

					myMap:requestLocation( location, locationHandler )
				end

		
			    end

				if #MapDisplayArray == 1 then

					MapDisplayArray[#MapDisplayArray].x=W/2

				end

				sceneGroup:insert(mapGroup)
				mapGroup.isVisible=false

			Background:addEventListener("touch",bgTouch)
			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)

		    end	


			ga.enterScene("Unit Career Path")

		    Runtime:addEventListener("key",onKeycareerDetail)

			MainGroup:insert(sceneGroup)


			if Message_Type == "GROUP" or Message_Type == "BROADCAST" then

				Webservice.GetMessageGroupTeamMemberList(contactId,Message_Type,get_MessageGroupTeamMemberList)
				
			else

				Webservice.GetContactInformation(contactId,get_avtiveTeammemberDetails)

			end

	end

	

end





function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		if popUpGroup.numChildren ~= nil then
			for j=popUpGroup.numChildren, 1, -1 do 
							display.remove(popUpGroup[popUpGroup.numChildren])
							popUpGroup[popUpGroup.numChildren] = nil
		 	end
		 end
		 if AlertGroup.numChildren ~= nil then
		 	for j=AlertGroup.numChildren, 1, -1 do 
							display.remove(AlertGroup[AlertGroup.numChildren])
							AlertGroup[AlertGroup.numChildren] = nil
		 	end
		 end

		 	if ProfileImage ~= nil then ProfileImage:removeSelf();ProfileImage=nil end

		if myMap then myMap:removeSelf();myMap=nil;map_close:removeSelf();map_close=nil end

		elseif phase == "did" then

			local params = { addGroupid = "editMember" , page_id = Message_Type:lower(),contacts = contactCount,name = Career_Username.text,contactId = contactId}


			print( "Status  :"..status )
			if status == "editArray" then

				print( "Json :"..json.encode(params) )
				event.parent:resumeGame(json.encode(params),status)
			else
					event.parent:resumeGameNormal(status)
			end


			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

			Runtime:removeEventListener("key",onKeycareerDetail)

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
