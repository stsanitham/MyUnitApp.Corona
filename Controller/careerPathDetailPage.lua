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

local menuBtn,contactId

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

local ProfileImage,careerDetail_scrollview

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

			system.openURL( "tel:"..number)

			callFlag = system.openURL( "tel:"..number )

			 if callFlag == true  then 

				--fortumo.findService({callFlag}, onFindServiceComplete)

			 else

			 	native.showAlert( "Call", CareerPath.NoSim, { CommonWords.ok } )

			end
		end

		return true

	end


	local function closeDetails( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
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



	local function onKeyEventDetail( event )

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




	function get_removeorblockDetails( response)

		Request_response = response


	    function onCompletion(event)

	       if "clicked"==event.action then

	       	print("on complete action done [[[[[[[[[[[[[[[[[[[[980890890890]]]]]]]]]]]]]]]]]]]]]]]]]")

			 AlertGroup.isVisible = false

			 ContactIdValue = contactId

			 print("ContactIdVlaue after assigning"..ContactIdValue)

	         composer.hideOverlay()

	       end

         end



		 if id_value == "Remove Access" then

		    print("response after removing details ",Request_response)
	        local remove_successful= native.showAlert("Remove", "Contact removed from the list.", { CommonWords.ok} , onCompletion)


		 elseif id_value == "Block Access" then

		    print("response after blocking details ",Request_response)
			local block_successful = native.showAlert("Block", "This Contact’s Access blocked successfully.", { CommonWords.ok} , onCompletion)

		 end


         if id_value == "Deny Access" then

         	 if Request_response == "5" then

         	 	denyaccess = native.showAlert("Deny", "Access denied to this Contact.", { CommonWords.ok } , onCompletion)

         	 elseif Request_response == "GRANT" then

         	 	granted = native.showAlert("Already Granted", "Access is already granted", { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert("Already Removed", "Access is already removed", { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert("Add Request", "Provide Access to the contact", { CommonWords.ok} , onCompletion)

         	 end

         elseif id_value == "Grant Access" then

	 	    if Request_response == "5" then

	 	    	grantaccess = native.showAlert("Grant access", "Access granted successfully to this Contact.", { CommonWords.ok} , onCompletion)

	 	     elseif Request_response == "GRANT" then

         	 	granted = native.showAlert("Already Granted", "Access is already granted", { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert("Already Removed", "Access is already removed", { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert("Add Request", "Provide Access to the contact", { CommonWords.ok} , onCompletion)

         	 end

	 	elseif id_value == "Provide Access" then

	 	    if Request_response == "5" then

	 	    	accessprovided = native.showAlert("Provide access", " Access provided successfully to this Contact.", { CommonWords.ok } , onCompletion)

	 	     elseif Request_response == "GRANT" then

         	 	granted = native.showAlert("Already Granted", "Access is already granted", { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert("Already Removed", "Access is already removed", { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert("Add Request", "Provide Access to the contact", { CommonWords.ok} , onCompletion)

         	 end

         end

	end





function onAccessButtonTouch( event )

    if event.phase == "began" then

    elseif event.phase == "ended" then

        native.setKeyboardFocus(nil)

--------------------------------------remove method -----------------------------------------------------

			       if id_value == "Remove Access" then


			    	    AlertGroup.isVisible = true

			            reqaccess_id = Details.ContactId
						reqaccess_from = "Contacts"
					    accessStatus = "REMOVE"

						print("contactid details",reqaccess_id,reqaccess_from,accessStatus)

			        	if event.target.id == "accept" then

			        		AlertGroup.isVisible = false

		        		Webservice.RemoveOrBlockContactDetails(reqaccess_id,reqaccess_from,accessStatus,get_removeorblockDetails)

			        	elseif event.target.id == "reject" then

							 print("making it invisible")

							  AlertGroup.isVisible = false

			        	end

			        end

------------------------------------------block method-------------------------------------------------

			       if id_value == "Block Access" then

			    	    AlertGroup.isVisible = true

			            reqaccess_id = Details.ContactId
						reqaccess_from = "Contacts"
					    accessStatus = "BLOCK"

						print("contactid details",reqaccess_id,reqaccess_from,accessStatus)


			        	if event.target.id == "accept" then

			        		AlertGroup.isVisible = false

		        			Webservice.RemoveOrBlockContactDetails(reqaccess_id,reqaccess_from,accessStatus,get_removeorblockDetails)

			        	elseif event.target.id == "reject" then

							 print("making it invisible")

							  AlertGroup.isVisible = false

			        	end
			        end
          end

    end



	 local function OnPasswordGeneration(event)

	 	 if event.phase == "began" then

         elseif event.phase == "ended" then

         local function getGeneratedPassword( response )

         	print("GENERATED PASSWORD OUTPUT "..response)

         end

         Webservice.GeneratePassword(getGeneratedPassword)

         end

	 end




 local function onButtonTouch(event)

 	 local phase = event.phase

 	 id_value = event.target.id

    if ( phase == "began" ) then 

    if id_value == "Grant Access" then

              GetPopUp(Details.EmailAddress,Details.Mobile,Details.HomePhoneNumber,Details.WorkPhoneNumber,Details.OtherPhoneNumber,id_value)

          processbutton_text.text = "Grant Access"
          popupText.text = "Grant Access"


          if Details.FirstName ~= nil and Details.LastName ~= nil then
             NameDetailValue.text = Details.FirstName.." "..Details.LastName
             native.setKeyboardFocus( nil )
          elseif  Details.FirstName  ~= nil then
             NameDetailValue.text = Details.FirstName
             native.setKeyboardFocus( nil )
          elseif Details.LastName ~= nil  then
             NameDetailValue.text = Details.LastName
             native.setKeyboardFocus( nil )
		  else
		     NameDetailValue.text = nil
          end
          print("print the value of name ",NameDetailValue.text)



          if Details.EmailAddress ~= nil then
          EmailDetailValue.text = Details.EmailAddress
        --  native.setKeyboardFocus(PhoneDetailValue)
            emailnotifybox.isVisible = true
		    emailnotifytext.isVisible = true
          else
		  EmailDetailValue.text = nil
		   emailnotifybox.isVisible = false
		   emailnotifytext.isVisible = false
          end
           print("print the value of email ",EmailDetailValue.text)


        if Details.Mobile ~= nil or Details.Mobile ~= "" then
             PhoneDetailValue.text = Details.Mobile
          			textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true
          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "" then
             PhoneDetailValue.text = Details.HomePhoneNumber
          			textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "" then
             PhoneDetailValue.text = Details.WorkPhoneNumber
          			textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "" then
             PhoneDetailValue.text = Details.OtherPhoneNumber
                    textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          else
          	 PhoneDetailValue.text = nil
          	       textnotifybox.isVisible = false
			       textnotifytext.isVisible = false
          end

            print("print the value of phone ",PhoneDetailValue.text)



          if  (PhoneDetailValue.text == nil) then

          	   textnotifybox.isVisible = false
			   textnotifytext.isVisible = false
			   print("here12345")

			   MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			   MKRankDetail_title.y= MKRankDetail_bg.y+8
			   MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			   MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			   Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			   Requesteddate_title.y= Requesteddate_bg.y + 7
			   RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			   Requesteddate_bottom.y= RequesteddateValue.y+8.5
			   Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		  	print("val not null")

		  	  textnotifybox.isVisible = true
			  textnotifytext.isVisible = true

			  MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.height+5
			  MKRankDetail_title.y= MKRankDetail_bg.y+8
			  MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			  MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			  Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			  Requesteddate_title.y= Requesteddate_bg.y + 7
			  RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			  Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end




          if Details.CareerProgress ~= nil then
          MKRankDetailValue.text = Details.CareerProgress
          native.setKeyboardFocus( nil )
          else
		  MKRankDetailValue.text = ""
          end

          if Details.UpdateTimeStamp ~= nil then
          local time = Utils.makeTimeStamp(Details.UpdateTimeStamp)
          print("time stamp ",time)
          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%m %p",time))
          native.setKeyboardFocus( nil )
          else
          RequesteddateValue.text = ""
          end

	      print("values event ",EmailDetailValue.text)

	      EmailDetailValue:addEventListener("userInput",textField)
		  PhoneDetailValue:addEventListener("userInput",textField)
		  PasswordValue:addEventListener("userInput",textField)


	      processbutton:addEventListener("touch",onGrantButtonTouch)




	  elseif id_value == "Remove Access" then

	  print("remove access pressed") 

	  --local remove_alert = native.showAlert("Remove", CareerPath.RemoveAccess, { CareerPath.ToRemove , CareerPath.NotToRemove} , onBlockClickComplete )

	  GetAlertPopup()

	  accept_button:addEventListener("touch",onAccessButtonTouch)
	  reject_button:addEventListener("touch",onAccessButtonTouch)

	  



	  elseif id_value == "Provide Access" then

	  print("provide access pressed") 

	  GetPopUp(Details.EmailAddress,Details.Mobile,Details.HomePhoneNumber,Details.WorkPhoneNumber,Details.OtherPhoneNumber,id_value)

        processbutton_text.text = "Provide Access"
        popupText.text = "Provide Access"

                Requesteddate_bg.isVisible = false
			 	RequesteddateValue.isVisible = false
			 	Requesteddate_title.isVisible = false
			 	Requesteddate_bottom.isVisible = false
       
          if Details.FirstName ~= nil and Details.LastName ~= nil then
             NameDetailValue.text = Details.FirstName..""..Details.LastName
             native.setKeyboardFocus( nil )
          elseif  Details.FirstName  ~= nil then
             NameDetailValue.text = Details.FirstName
             native.setKeyboardFocus( nil )
          elseif Details.LastName ~= nil  then
            NameDetailValue.text = Details.LastName
             native.setKeyboardFocus( nil )
		  else
		    NameDetailValue.text = nil
          end
          print(NameDetailValue.text)


          if Details.EmailAddress ~= "" then

          	print("email not equal to error message")
          EmailDetailValue.text = Details.EmailAddress

          print("@#$@#$@#$@@@@@@@@@@@@@@@@@@@@@@@@@ ",EmailDetailValue.text)
          --native.setKeyboardFocus(PhoneDetailValue)
            emailnotifybox.isVisible = true
		    emailnotifytext.isVisible = true
          else
		   EmailDetailValue.text = nil
		   emailnotifybox.isVisible = false
		   emailnotifytext.isVisible = false
          end


          if EmailDetailValue.text == "" then

          	print("email null ********************************")

          	emailnotifybox.isVisible = false
          	emailnotifytext.isVisible = false

          	PhoneDetail_bg.y =  EmailDetail_bottom.y+EmailDetail_bottom.contentHeight+5
          	PhoneDetail_titlestar.y= PhoneDetail_bg.y
          	PhoneDetail_titletext.y= PhoneDetail_bg.y
          	PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
			PhoneDetail_bottom.y= PhoneDetailValue.y+10
			textnotifybox.y = PhoneDetail_bottom.y+15
			textnotifytext.y= PhoneDetail_bottom.y + 15
			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		   else

		   	emailnotifybox.isVisible = true
          	emailnotifytext.isVisible = true

		   	PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
		   	PhoneDetail_titlestar.y= PhoneDetail_bg.y
		   	PhoneDetail_titlestar.y= PhoneDetail_bg.y
		   	PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
			PhoneDetail_bottom.y= PhoneDetailValue.y+10
			textnotifybox.y = PhoneDetail_bottom.y+15
			textnotifytext.y= PhoneDetail_bottom.y + 15
			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

          end



          if Details.Mobile ~= nil  then
             PhoneDetailValue.text = Details.Mobile
          			textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true
          elseif Details.HomePhoneNumber ~= nil then
             PhoneDetailValue.text = Details.HomePhoneNumber
          			textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          elseif Details.WorkPhoneNumber ~= nil then
             PhoneDetailValue.text = Details.WorkPhoneNumber
          			textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          elseif Details.OtherPhoneNumber ~= nil then
             PhoneDetailValue.text = Details.OtherPhoneNumber
                    textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          else
          	 PhoneDetailValue.text = nil
          	 textnotifybox.isVisible = false
			   textnotifytext.isVisible = false
          end


          print(" PhoneDetailValue.text             ",  PhoneDetailValue.text)


          if  PhoneDetailValue.text == nil or PhoneDetailValue.text == "" then

          	   textnotifybox.isVisible = false
			   textnotifytext.isVisible = false
			   print("here12345")

			   MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			   MKRankDetail_title.y= MKRankDetail_bg.y+8
			   MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			   MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			  -- Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			 --  Requesteddate_title.y= Requesteddate_bg.y + 7
			 --  RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			  -- Requesteddate_bottom.y= RequesteddateValue.y+8.5
			    Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
				Password_titlestar.y= Password_bg.y+7
				Password_titletext.y= Password_bg.y+7
				PasswordValue.y =Password_titletext.y+Password_titletext.height+8
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		  	print("3475673456346586348586348568346587777777777777777777777777777")

		  	  textnotifybox.isVisible = true
			  textnotifytext.isVisible = true

			  MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			  MKRankDetail_title.y= MKRankDetail_bg.y+8
			  MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			  MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			  --Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			 -- Requesteddate_title.y= Requesteddate_bg.y + 7
			 -- RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			 -- Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
				Password_titlestar.y= Password_bg.y+7
				Password_titletext.y= Password_bg.y+7
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end


          if Details.CareerProgress ~= nil then
          MKRankDetailValue.text = Details.CareerProgress
          native.setKeyboardFocus( nil )
          else
		  MKRankDetailValue.text = ""
          end

          if Details.UpdateTimeStamp ~= nil then
          local time = Utils.makeTimeStamp(Details.UpdateTimeStamp)
          print("time stamp ",time)
          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%m %p",time))
          native.setKeyboardFocus( nil )
          else
          RequesteddateValue.text = ""
          end

	      print("values event PA", EmailDetailValue.text)
	      print("values event PA", PhoneDetailValue.text)

	      EmailDetailValue:addEventListener("userInput",textField)
		  PhoneDetailValue:addEventListener("userInput",textField)
		  PasswordValue:addEventListener("userInput",textField)

		  --GeneratePasstext:addEventListener("touch",OnPasswordGeneration)

	      processbutton:addEventListener("touch",onGrantButtonTouch)



	 
	  elseif id_value == "Deny Access" then

	  print("deny access pressed") 

	    GetPopUp(Details.EmailAddress,Details.Mobile,Details.HomePhoneNumber,Details.WorkPhoneNumber,Details.OtherPhoneNumber,id_value)

        processbutton_text.text = "Deny Access"
        popupText.text = "Deny Access"

        PasswordValue.isVisible = false
        Password_bg.isVisible = false
        Password_titlestar.isVisible = false
        Password_titletext.isVisible = false
        Password_bottom.isVisible = false
        PasswordHelptext.isVisible = false
        GeneratePasstext.isVisible = false

        deny_bg.isVisible = true
        deny_Value.isVisible = true

        Requesteddate_bottom.y= RequesteddateValue.y+8.5
        deny_bg.y = Requesteddate_bottom.y + Requesteddate_bottom.contentHeight +15
        deny_Value.y=deny_bg.y
        processbutton.y = deny_Value.y+deny_Value.contentHeight


       
          if Details.FirstName ~= nil and Details.LastName ~= nil then
             NameDetailValue.text = Details.FirstName..""..Details.LastName
             native.setKeyboardFocus( nil )
          elseif  Details.FirstName  ~= nil then
             NameDetailValue.text = Details.FirstName
             native.setKeyboardFocus( nil )
          elseif Details.LastName ~= nil  then
            NameDetailValue.text = Details.LastName
             native.setKeyboardFocus( nil )
		  else
		    NameDetailValue.text = nil
          end
          print(NameDetailValue.text)


          if Details.EmailAddress ~= nil then
          EmailDetailValue.text = Details.EmailAddress
        --  native.setKeyboardFocus(PhoneDetailValue)
            emailnotifybox.isVisible = true
		    emailnotifytext.isVisible = true
          else
		  EmailDetailValue.text = nil
		   emailnotifybox.isVisible = false
		   emailnotifytext.isVisible = false
          end


          if Details.Mobile ~= nil or Details.Mobile ~= "" then
             PhoneDetailValue.text = Details.Mobile
          			textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true
          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "" then
             PhoneDetailValue.text = Details.HomePhoneNumber
          			textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "" then
             PhoneDetailValue.text = Details.WorkPhoneNumber
          			textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "" then
             PhoneDetailValue.text = Details.OtherPhoneNumber
                    textnotifybox.isVisible = true
					textnotifytext.isVisible = true
          else
          	 PhoneDetailValue.text = nil
          	        textnotifybox.isVisible = false
					textnotifytext.isVisible = false
          end



          if  PhoneDetailValue.text == nil then

          	   textnotifybox.isVisible = false
			   textnotifytext.isVisible = false
			   print("here12345")

			   MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			   MKRankDetail_title.y= MKRankDetail_bg.y+8
			   MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			   MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			   Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			   Requesteddate_title.y= Requesteddate_bg.y + 7
			   RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			   Requesteddate_bottom.y= RequesteddateValue.y+8.5
			   Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		  	  textnotifybox.isVisible = true
			  textnotifytext.isVisible = true

			  MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			  MKRankDetail_title.y= MKRankDetail_bg.y+8
			  MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			  MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			  Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			  Requesteddate_title.y= Requesteddate_bg.y + 7
			  RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			  Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end




          if Details.CareerProgress ~= nil then
          MKRankDetailValue.text = Details.CareerProgress
          native.setKeyboardFocus( nil )
          else
		  MKRankDetailValue.text = ""
          end

          if Details.UpdateTimeStamp ~= nil then
          local time = Utils.makeTimeStamp(Details.UpdateTimeStamp)
          print("time stamp ",time)
          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%m %p",time))
          native.setKeyboardFocus( nil )
          else
          RequesteddateValue.text = ""
          end

	      print("values event ",EmailDetailValue.text)

	      EmailDetailValue:addEventListener("userInput",textField)
		  PhoneDetailValue:addEventListener("userInput",textField)
		  PasswordValue:addEventListener("userInput",textField)


	      processbutton:addEventListener("touch",onGrantButtonTouch)




	  elseif id_value == "Block Access" then

	  print("block access pressed") 

	 -- local block_alert = native.showAlert("Block", CareerPath.BlockAccess, { CareerPath.ToBlock , CareerPath.NotToBlock } , onBlockClickComplete)

       GetAlertPopup()

		AlertText.text = "Block"
		AlertContentText.text = CareerPath.BlockAccess
		print("block access occurred text value ",AlertContentText.text)

		accept_button_text.text = CareerPath.ToBlock
		reject_button_text.text = CareerPath.NotToBlock

	  accept_button:addEventListener("touch",onAccessButtonTouch)
	  reject_button:addEventListener("touch",onAccessButtonTouch)

    end

   
    elseif ( phase == "ended") then 

    end

 end





    function RequestGrantProcess( )


    	if processbutton_text.text == "Grant Access" then

    		print("service of grant access")


   	    PhoneNumber=PhoneDetailValue.text

   	    Email = EmailDetailValue.text


   	    MkRankId = Details.CareerProgressId
        MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId
        print("value for access id : ",MyUnitBuzzRequestAccessId)

   	    if MyUnitBuzzRequestAccessId == 0 then

            isaddedToContact = true  
            MyUnitBuzzRequestAccessId = Details.ContactId

        else
        	isaddedToContact = false

        end

   	    print("value for isaddedToContact : ",isaddedToContact)
     
   	    GetRquestAccessFrom = "Contacts"
   	    MailTemplate = "GRANT"
   	    Status = "GRANT"
   	    ContactId = Details.ContactId
   	    isSentMail = isSentMailValue
   	    print("value 1 ",isSentMailValue)
   	    isSendText= isSentMailValue
   	    print("value 2 ",isSendTextValue)
   	    password = PasswordValue.text

   	    idvalue = processbutton_text.text
   	    print(idvalue)

   	    	Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,password,get_removeorblockDetails)

     	end




   	    if processbutton_text.text == "Provide Access" then

   	    		print("service of Provide access")


   	    PhoneNumber=PhoneDetailValue.text

   	    Email = EmailDetailValue.text

   	    print("}}}}}}}}}}}}}",PhoneNumber)

   	    print("}}}}}}}}}}}}}",Email)


   	    MkRankId = Details.CareerProgressId
   	    GetRquestAccessFrom = "Contacts"

   	   MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId
        print("value for access id : ",MyUnitBuzzRequestAccessId)

   	    if MyUnitBuzzRequestAccessId == 0 then
   	    	
            isaddedToContact = true  
            MyUnitBuzzRequestAccessId = Details.ContactId

        else
        	isaddedToContact = false

        end

   	    print("value for isaddedToContact : ",isaddedToContact)
     

   	    MailTemplate = "ADDREQUEST"
   	    Status = "GRANT"
   	    ContactId = Details.ContactId
   	    isSentMail = isSentMailValue
   	    print("value 1 ",isSentMailValue)
   	    isSendText= isSentMailValue
   	    print("value 2 ",isSendTextValue)
   	    password = PasswordValue.text

   	    idvalue = processbutton_text.text
   	    print(idvalue)



   	    	Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,password,get_removeorblockDetails)
        end




        if processbutton_text.text == "Deny Access" then

        		print("service of deny access")

  
   	    PhoneNumber=PhoneDetailValue.text

   	    Email = EmailDetailValue.text

   	    print("}}}}}}}}}}}}}",PhoneNumber)

   	    print("}}}}}}}}}}}}}",Email)

   	    MkRankId = Details.CareerProgressId
   	    GetRquestAccessFrom = "Contacts"

   	    MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId
        print("value for access id : ",MyUnitBuzzRequestAccessId)

   	    if MyUnitBuzzRequestAccessId == 0 then
   	    	
            isaddedToContact = true  
            MyUnitBuzzRequestAccessId = Details.ContactId

        else
        	isaddedToContact = false

        end

   	    print("value for isaddedToContact : ",isaddedToContact)
     
   	    MailTemplate = "DENY"
   	    Status = "DENY"
   	    ContactId = Details.ContactId
   	    isSentMail = isSentMailValue
   	    print("value 1 ",isSentMailValue)
   	    isSendText= isSentMailValue
   	    print("value 2 ",isSendTextValue)
   	    reasonfordeny = deny_Value.text
   	    print("reason for deny%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",reasonfordeny)

   	    idvalue = processbutton_text.text
   	    print(idvalue)

   	    	Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,reasonfordeny,get_removeorblockDetails)

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

				print("ContactIdVlaue before assigning"..contactId)


				for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

				ContactId = row.ContactId

				print("ContactId :"..ContactId)

				end

	
			function get_avtiveTeammemberDetails( response)

				print("Career Detail Response ",json.encode(response))

				Details = response

				-- detailcontactid = Details.ContactId
				-- print("detailcontactid before assigning"..detailcontactid)

				titleBar = display.newRect(sceneGroup,W/2,tabBar.y+tabBar.contentHeight/2,W,30)
				titleBar.anchorY=0
				titleBar.isVisible=false

				titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
			

				if Details.ImagePath ~= nil then
					ProfileImage = display.newImage(sceneGroup,"career"..contactId..".png",system.TemporaryDirectory)

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




			    if(Details.FirstName ~= nil ) then

					Career_Username = display.newText(sceneGroup,Details.FirstName.." "..Details.LastName,0,0,native.systemFont,24)

				else
					Career_Username = display.newText(sceneGroup,Details.LastName,0,0,native.systemFont,24)
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


		if (tostring(ContactId) ~= tostring(contactId)) then

            if (IsOwner == true) then

				InviteAccess = display.newText("Invite/Access",0,0,0,0,native.systemFontBold,16)
				InviteAccess.anchorX = 0 ;InviteAccess.anchorY=0
				InviteAccess.x=leftPadding
				InviteAccess.isVisible = false
				InviteAccess:setFillColor(0,0,0)
				InviteAccess.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+8
				--Utils.CssforTextView(InviteAccess,sp_labelName)
				careerDetail_scrollview:insert( InviteAccess )


                    if(IsOwner == true and Details.Status == "DENY" or Details.Status == "BLOCK") then

                    print("Grant or Remove Access")

                    InviteAccess.isVisible = true

					grantaccess_button = display.newRect(sceneGroup,0,0,W,25)
					grantaccess_button.x=leftPadding + 75
					grantaccess_button.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+55
					grantaccess_button:setStrokeColor(0,0,0,0.5)
					grantaccess_button:setFillColor(0,0,0,0.2)
					grantaccess_button.strokeWidth = 1
					grantaccess_button.cornerRadius = 2
					grantaccess_button.width = W-190
					grantaccess_button.id="Grant Access"
					grantaccess_button:addEventListener("touch",onButtonTouch)
					careerDetail_scrollview:insert( grantaccess_button )

					grantaccess_button_text = display.newText(sceneGroup,"Grant",0,0,native.systemFont,16)
					grantaccess_button_text.x=grantaccess_button.x
					grantaccess_button_text.y=grantaccess_button.y
					grantaccess_button_text:setFillColor(0,0,0)
					careerDetail_scrollview:insert( grantaccess_button_text )


					removeaccess_button = display.newRect(sceneGroup,0,0,W,25)
					removeaccess_button.x=leftPadding + 223
					removeaccess_button.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+55
					removeaccess_button:setStrokeColor(0,0,0,0.5)
					removeaccess_button:setFillColor(0,0,0,0.2)
					removeaccess_button.strokeWidth = 1
					removeaccess_button.cornerRadius = 2
					removeaccess_button.width = W-190
					removeaccess_button.id="Remove Access"
					removeaccess_button:addEventListener("touch",onButtonTouch)
					careerDetail_scrollview:insert( removeaccess_button )

					removeaccess_button_text = display.newText(sceneGroup,"Remove",0,0,native.systemFont,16)
					removeaccess_button_text.x=removeaccess_button.x
					removeaccess_button_text.y=removeaccess_button.y
					removeaccess_button_text:setFillColor(0,0,0)
					careerDetail_scrollview:insert( removeaccess_button_text )



					elseif(IsOwner == true and Details.Status == "GRANT") then

					print("Block Access")

					 InviteAccess.isVisible = true

				    blockaccess_button = display.newRect(sceneGroup,0,0,W,25)
					blockaccess_button.x=leftPadding + 150
					blockaccess_button.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+55
					blockaccess_button:setStrokeColor(0,0,0,0.5)
					blockaccess_button:setFillColor(0,0,0,0.2)
					blockaccess_button.strokeWidth = 1
					blockaccess_button.cornerRadius = 2
					blockaccess_button.width = W-150
					blockaccess_button.id="Block Access"
					blockaccess_button:addEventListener("touch",onButtonTouch)
					careerDetail_scrollview:insert( blockaccess_button )

					blockaccess_button_text = display.newText(sceneGroup,"Block",0,0,native.systemFont,16)
					blockaccess_button_text.x=blockaccess_button.x
					blockaccess_button_text.y=blockaccess_button.y
					blockaccess_button_text:setFillColor(0,0,0)
					careerDetail_scrollview:insert( blockaccess_button_text )



					elseif(IsOwner == true and Details.Status == "ADDREQUEST" or Details.Status == "REMOVE") then

					print("Provide Access")

					InviteAccess.isVisible = true

				    provideaccess_button = display.newRect(sceneGroup,0,0,W,25)
					provideaccess_button.x=leftPadding + 150
					provideaccess_button.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+55
					provideaccess_button:setStrokeColor(0,0,0,0.5)
					provideaccess_button:setFillColor(0,0,0,0.2)
					provideaccess_button.strokeWidth = 1
					provideaccess_button.cornerRadius = 2
					provideaccess_button.width = W-150
					provideaccess_button.id="Provide Access"
					provideaccess_button:addEventListener("touch",onButtonTouch)
					careerDetail_scrollview:insert( provideaccess_button )

					provideaccess_button_text = display.newText(sceneGroup,"Provide Access",0,0,native.systemFont,16)
					provideaccess_button_text.x=provideaccess_button.x
					provideaccess_button_text.y=provideaccess_button.y
					provideaccess_button_text:setFillColor(0,0,0)
					careerDetail_scrollview:insert( provideaccess_button_text )



					elseif(IsOwner == true and Details.Status == "OPEN") then

                    print("Grant or Deny Access")

                     InviteAccess.isVisible = true

					grantaccess_button = display.newRect(sceneGroup,0,0,W,25)
					grantaccess_button.x=leftPadding + 75
					grantaccess_button.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+55
					grantaccess_button:setStrokeColor(0,0,0,0.5)
					grantaccess_button:setFillColor(0,0,0,0.3)
					grantaccess_button.strokeWidth = 1
					grantaccess_button.cornerRadius = 2
					grantaccess_button.width = W-190
					grantaccess_button.id="Grant Access"
					grantaccess_button:addEventListener("touch",onButtonTouch)
					careerDetail_scrollview:insert( grantaccess_button )

					grantaccess_button_text = display.newText(sceneGroup,"Grant",0,0,native.systemFont,16)
					grantaccess_button_text.x=grantaccess_button.x
					grantaccess_button_text.y=grantaccess_button.y
					grantaccess_button_text:setFillColor(0,0,0)
					careerDetail_scrollview:insert( grantaccess_button_text )

					denyaccess_button = display.newRect(sceneGroup,0,0,W,25)
					denyaccess_button.x=leftPadding + 223
					denyaccess_button.y = Details_Display[#Details_Display].y+Details_Display[#Details_Display].contentHeight+55
					denyaccess_button:setStrokeColor(0,0,0,0.5)
					denyaccess_button:setFillColor(0,0,0,0.3)
					denyaccess_button.strokeWidth = 1
					denyaccess_button.cornerRadius = 2
					denyaccess_button.width = W-190
					denyaccess_button.id="Deny Access"
					denyaccess_button:addEventListener("touch",onButtonTouch)
					careerDetail_scrollview:insert( denyaccess_button )

					denyaccess_button_text = display.newText(sceneGroup,"Deny",0,0,native.systemFont,16)
					denyaccess_button_text.x=denyaccess_button.x
					denyaccess_button_text.y=denyaccess_button.y
					denyaccess_button_text:setFillColor(0,0,0)
					careerDetail_scrollview:insert( denyaccess_button_text )

				    end

				end

			end

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

			    Runtime:addEventListener("key",onKeyEventDetail)
			
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

		MainGroup:insert(sceneGroup)

			Webservice.GET_ACTIVE_TEAMMEMBERDETAILS(contactId,get_avtiveTeammemberDetails)

	end

	

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		for j=popUpGroup.numChildren, 1, -1 do 
						display.remove(popUpGroup[popUpGroup.numChildren])
						popUpGroup[popUpGroup.numChildren] = nil
	 	end

	 	for j=AlertGroup.numChildren, 1, -1 do 
						display.remove(AlertGroup[AlertGroup.numChildren])
						AlertGroup[AlertGroup.numChildren] = nil
	 	end


		if myMap then myMap:removeSelf();myMap=nil;map_close:removeSelf();map_close=nil end

		elseif phase == "did" then

			event.parent:resumeGame(ContactIdValue)

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

			Runtime:removeEventListener("key",onKeyEventDetail)

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
