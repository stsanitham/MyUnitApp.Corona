----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local popupGroup = require( "Controller.popupGroup" )

local alertGroup = require( "Controller.alertGroup" )


local Utility = require( "Utils.Utility" )

local Details={}

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,title

local menuBtn

openPage="inviteAndaccessPage"

local RecentTab_Topvalue = 110

local groupArray={}

local feedArray={}

local status = "GRANT"

local StatusArray = {"GRANT","DENY","OPEN","ADDREQUEST"}


local inviteArray={"Contacts with Access","Denied Access","Pending Requests","Team Members without Access"}
--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

	end

return true

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


local function GrandProcess(value)

	id_value = "Grant Access"
 GetPopUp(value.EmailAddress,value.PhoneNumber,value.PhoneNumber,value.PhoneNumber,value.PhoneNumber,"Grant Access")

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




          if Details.MkRankLevel ~= nil then
          MKRankDetailValue.text = Details.MkRankLevel
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

end

local function RemoveProcess()
	id_value = "Remove Access"

	  print("remove access pressed") 

	  --local remove_alert = native.showAlert("Remove", CareerPath.RemoveAccess, { CareerPath.ToRemove , CareerPath.NotToRemove} , onBlockClickComplete )

	  GetAlertPopup()

	  accept_button:addEventListener("touch",onAccessButtonTouch)
	  reject_button:addEventListener("touch",onAccessButtonTouch)

	  


end
local function DenyProcess()
	id_value = "Deny Access"

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




          if Details.MkRankLevel ~= nil then
          MKRankDetailValue.text = Details.MkRankLevel
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


end
local function ProvideAccess()
	id_value = "Provide Access"

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


          if Details.EmailAddress ~= nil then
          EmailDetailValue.text = Details.EmailAddress
          --native.setKeyboardFocus(PhoneDetailValue)
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
          end


          if  PhoneDetailValue.text == nil then

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


          if Details.MkRankLevel ~= nil then
          MKRankDetailValue.text = Details.MkRankLevel
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



end
local function Block()
	id_value = "Block Access"

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




local function ActionTouch( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
				for i=1,#groupArray do
				local group = groupArray[i]
						group[group.numChildren].isVisible = false
					
				end

				if event.target.id == "block" then

					Details = event.target.value

					Block(event.target.value)

				elseif event.target.id == "grant" then

					Details = event.target.value

					GrandProcess(event.target.value)

				elseif event.target.id == "remove" then

						Details = event.target.value

					RemoveProcess(event.target.value)


				elseif event.target.id == "deny" then

						Details = event.target.value

					DenyProcess(event.target.value)


				elseif event.target.id == "provideaccess" then

						Details = event.target.value

					ProvideAccess(event.target.value)

				
				end


			print( event.target.id )
	end

return true
end


local function Createmenu( object )

local menuGroup = display.newGroup( )
	
	print( "here" )
	local menuBg = display.newRect(menuGroup,0,0,75,60)
		 menuBg:setFillColor( 1 )
		 menuBg.strokeWidth = 1
		 menuBg.anchorY=0
		 menuBg.value = object.value
		 menuBg:setStrokeColor( Utils.convertHexToRGB("#d2d3d4") )
		 menuBg.y=object.y+5
		  menuBg.x=object.x-menuBg.contentWidth/2+4

		  

		 if status == "DENY" or status == "OPEN" then

		 	menuBg.height = 75
		 else
		 	menuBg.height = 35
		 end

		 if status == "ADDREQUEST" then

		 	menuBg.width = 90

		 else

		 	menuBg.width = 75

		 end

		 if status == "GRANT" then

		 	Blockbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Blockbtn.anchorY=0
		 	Blockbtn.y=menuBg.y+5;Blockbtn.x=menuBg.x
		 	Blockbtn:setFillColor( 0.4 )
		 	Blockbtn.alpha=0.01
		 	Blockbtn.id="block"
		 	Blockbtn.value = object.value

		 	Blockbtn_txt = display.newText( menuGroup, "Block",0,0,native.systemFont,12 )
		 	Blockbtn_txt:setFillColor( 0.2 )
		 	Blockbtn_txt.x=Blockbtn.x;Blockbtn_txt.y=Blockbtn.y+Blockbtn.contentHeight/2

		 	Blockbtn:addEventListener( "touch", ActionTouch )

		elseif status == "DENY" then

			Grantbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Grantbtn.anchorY=0
		 	Grantbtn.y=menuBg.y+5;Grantbtn.x=menuBg.x
		 	Grantbtn:setFillColor( 0.4 )
		 	Grantbtn.alpha=0.01
		 	Grantbtn.id = "grant"
		 	Grantbtn.value = object.value

		 	Grantbtn_txt = display.newText( menuGroup, "Grant",0,0,native.systemFont,12 )
		 	Grantbtn_txt:setFillColor( 0.2 )
		 	Grantbtn_txt.x=Grantbtn.x;Grantbtn_txt.y=Grantbtn.y+Grantbtn.contentHeight/2

		 	removebtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	removebtn.anchorY=0
		 	removebtn.y=Grantbtn.y+Grantbtn.contentHeight+5;removebtn.x=menuBg.x
		 	removebtn:setFillColor( 0.4 )
		 	removebtn.alpha=0.01
		 	removebtn.id="remove"
		 	removebtn.value = object.value

		 	removebtn_txt = display.newText( menuGroup, "Remove",0,0,native.systemFont,12 )
		 	removebtn_txt:setFillColor( 0.2 )
		 	removebtn_txt.x=removebtn.x;removebtn_txt.y=removebtn.y+removebtn.contentHeight/2

		 	Grantbtn:addEventListener( "touch", ActionTouch )
		 	removebtn:addEventListener( "touch", ActionTouch )

		elseif status == "OPEN" then

			Grantbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Grantbtn.anchorY=0
		 	Grantbtn.y=menuBg.y+5;Grantbtn.x=menuBg.x
		 	Grantbtn:setFillColor( 0.4 )
		 	Grantbtn.alpha=0.01
		 	Grantbtn.id="grant"
		 	Grantbtn.value = object.value

		 	Grantbtn_txt = display.newText( menuGroup, "Grant",0,0,native.systemFont,12 )
		 	Grantbtn_txt:setFillColor( 0.2 )
		 	Grantbtn_txt.x=Grantbtn.x;Grantbtn_txt.y=Grantbtn.y+Grantbtn.contentHeight/2

		 	denybtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	denybtn.anchorY=0
		 	denybtn.y=Grantbtn.y+Grantbtn.contentHeight+5;denybtn.x=menuBg.x
		 	denybtn:setFillColor( 0.4 )
		 	denybtn.alpha=0.01
		 	denybtn.id="deny"
		 	denybtn.value = object.value

		 	denybtn_txt = display.newText( menuGroup, "Deny",0,0,native.systemFont,12 )
		 	denybtn_txt:setFillColor( 0.2 )
		 	denybtn_txt.x=denybtn.x;denybtn_txt.y=denybtn.y+denybtn.contentHeight/2

		 	Grantbtn:addEventListener( "touch", ActionTouch )
		 	denybtn:addEventListener( "touch", ActionTouch )

		 elseif status == "ADDREQUEST" then
			Provideacessbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Provideacessbtn.anchorY=0
		 	Provideacessbtn.y=menuBg.y+5;Provideacessbtn.x=menuBg.x
		 	Provideacessbtn:setFillColor( 0.4 )
		 	Provideacessbtn.alpha=0.01
		 	Provideacessbtn.id="provideaccess"
		 	Provideacessbtn.value = object.value

		 	Provideacess_txt = display.newText( menuGroup, "Provide Access",0,0,native.systemFont,12 )
		 	Provideacess_txt:setFillColor( 0.2 )
		 	Provideacess_txt.x=Provideacessbtn.x;Provideacess_txt.y=Provideacessbtn.y+Provideacessbtn.contentHeight/2

		 	
		 	Provideacessbtn:addEventListener( "touch", ActionTouch )


		end
	return menuGroup

end

local function ListmenuTouch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			--Createmenu(event.target)

		

			local group = groupArray[event.target.id]

			if group[group.numChildren].isVisible == true then

				group[group.numChildren].isVisible = false

			else

				for i=1,#groupArray do
				local group = groupArray[i]
						group[group.numChildren].isVisible = false
					
				end

				group[group.numChildren].isVisible = true
			end

	end

return true

end


local function onRowRender( event )

print( "#########" )
 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( row, inviteArray[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 25
    rowTitle.y = rowHeight * 0.5

    row.name = inviteArray[row.index]




end

local function onRowTouch( event )

 -- Get reference to the row group
 local phase = event.phase
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    	if "press" == phase then
                print( "Pressed row: " .. row.index )

        elseif "release" == phase then
		    inviteList.isVisible=false
		    List_bg.isVisible=false

		    if row.name == titleValue.text then

		    else
		    	status = StatusArray[row.index]
		    	titleValue.text = row.name
		    	Webservice.GetMyUnitBuzzRequestAccesses(StatusArray[row.index],get_GetMyUnitBuzzRequestAccesses)

		    end

		end

	


end

local function CreateList(list,scrollView)

	local feedArray = list

	for j=#groupArray, 1, -1 do 
		display.remove(groupArray[#groupArray])
		groupArray[#groupArray] = nil
	end

	for i=1,#feedArray do


			groupArray[#groupArray+1] = display.newGroup()

			local tempGroup = groupArray[#groupArray]
			local bgheight = 100
			
		
			local background = display.newRect(tempGroup,0,0,W-10,bgheight)
			local Initial_Height = 1

			if(groupArray[#groupArray-1]) ~= nil then
				Initial_Height = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].height+2.5
			end

			background.anchorY = 0
			background.anchorX = 0
			background.x=5;background.y=Initial_Height
			background.strokeWidth = 1
			background:setStrokeColor( Utils.convertHexToRGB("#d2d3d4") )
			background:setFillColor(1)
			background.value = feedArray[i]
			background.id="listBg"
			background:addEventListener( "touch", ActionTouch )


			local list_bg = display.newRect( tempGroup, 0, 0, 35, 35 )
			list_bg:setFillColor( 0.3 )
			local list = display.newImageRect( tempGroup, "res/assert/list.png",8/2,34/2)
		    list.x = background.x+background.contentWidth-10
		    list.y=background.y+5
		    list.anchorY=0
		    list_bg.x=list.x-5
		    list_bg.y=list.y+5
		    list_bg.alpha=0.01
		    list_bg.value = feedArray[i]
		    list_bg.id=i
		    list_bg:addEventListener( "touch", ListmenuTouch )


			local Name = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			Name.anchorX=0;Name.anchorY=0
			Name.x=background.x+5;Name.y=background.y+5
			Name:setFillColor( 0.3 )

			if feedArray[i].FirstName ~= nil then

				Name.text = "Name : "..feedArray[i].LastName..", "..feedArray[i].FirstName

			else

				Name.text = "Name : "..feedArray[i].LastName

			end

			local Email = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			Email.anchorX=0;Email.anchorY=0
			Email.x=background.x+5;Email.y=Name.y+Name.contentHeight+5
			Email:setFillColor( 0.3 )

			if feedArray[i].EmailAddress ~= nil then

				Email.text = "EmailAddress : "..feedArray[i].EmailAddress

			end

			local Phone = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			Phone.anchorX=0;Phone.anchorY=0
			Phone.x=background.x+5;Phone.y=Email.y+Email.contentHeight+5
			Phone:setFillColor( 0.3 )

			if feedArray[i].PhoneNumber ~= nil then

				Phone.text = "Phone : "..feedArray[i].PhoneNumber

			end

			local MKRank = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			MKRank.anchorX=0;MKRank.anchorY=0
			MKRank.x=background.x+5;MKRank.y=Phone.y+Phone.contentHeight+5
			MKRank:setFillColor( 0.3 )

			if feedArray[i].MkRankLevel ~= nil then

				MKRank.text = "MKRank : "..feedArray[i].MkRankLevel
			else

				MKRank.text = "MKRank : "
			end

			local ActiveOn = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			ActiveOn.anchorX=0;ActiveOn.anchorY=0
			ActiveOn.x=background.x+5;ActiveOn.y=MKRank.y+MKRank.contentHeight+5
			ActiveOn:setFillColor( 0.3 )

			if feedArray[i].MkRankLevel ~= nil then

				local time = Utils.makeTimeStamp(feedArray[i].UpdateTimeStamp)

				
				ActiveOn.text = "Activity On : "..tostring(os.date("%m/%d/%Y %I:%m %p",time))

			end

			   group =  Createmenu(list_bg)

   				tempGroup:insert( group )

   				group.isVisible=false

			scrollView:insert(tempGroup)


	end

end

local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			if inviteList.isVisible == false then

				List_bg:toFront( )
				inviteList:toFront( )
				inviteList.isVisible = true
				List_bg.isVisible = true
			else
				inviteList.isVisible = false
				List_bg.isVisible = false
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
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,"Invite/Access",0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


		titleDropdown = display.newRect( W/2, 80, W-10, 28)
		titleDropdown.id="title"
		titleDropdown.anchorY=0
		titleDropdown.alpha=0.01
		sceneGroup:insert(titleDropdown)
		titleDropdown:addEventListener( "touch", TouchAction )

		titleValue = display.newText(sceneGroup,"Contacts with Access",titleDropdown.x-titleDropdown.contentWidth/2+15,titleDropdown.y,native.systemFont,14 )
		titleValue.alpha=0.7
		titleValue.anchorX=0
		titleValue:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		titleValue.x=15
		titleValue.y=titleDropdown.y+titleDropdown.contentHeight/2

	  	SelectEvent_icon = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	SelectEvent_icon.x=titleDropdown.x+titleDropdown.contentWidth/2-15
	  	SelectEvent_icon.y=titleValue.y

		BottomImage = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		BottomImage.x=W/2;BottomImage.y=titleValue.y+titleValue.contentHeight-5


	MainGroup:insert(sceneGroup)
end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		composer.removeHidden()

	elseif phase == "did" then


		scrollView = widget.newScrollView
					{
					top = RecentTab_Topvalue,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue,
					hideBackground = true,
					isBounceEnabled=true,
					horizontalScrollDisabled = true,
			   		scrollWidth = W,
					bottomPadding = 60,
		   			listener = Facebook_scrollListener,
		}


	
		

		inviteList = widget.newTableView(
		    {
		        left = 5,
		        top = 0,
		        height = 160,
		        width = 300,
		        onRowRender = onRowRender,
		        onRowTouch = onRowTouch,
		        hideBackground = false,
		        isBounceEnabled = false,
		        noLines = true,

		       -- listener = scrollListener
		    }
		)

	  	inviteList.anchorY=0
	  	inviteList.y=titleDropdown.y+titleDropdown.contentHeight
	  	sceneGroup:insert( inviteList )
	  	inviteList.isVisible = false

	  	List_bg = display.newRect(200, 200, 104, 304 )
		List_bg:setFillColor( 0 )
		sceneGroup:insert( List_bg )
	  	List_bg.anchorY = 0
	  	List_bg.isVisible = false
	  	List_bg.x=inviteList.x
	  	List_bg.y=inviteList.y
	  	List_bg.width = inviteList.width+2
	  	List_bg.height = inviteList.height+1


			for i = 1, #inviteArray do
		    -- Insert a row into the tableView
		    inviteList:insertRow{ rowHeight = 40,rowColor = 
		    {
		    default = { 1, 1, 1, 0 },
		    over={ 1, 0.5, 0, 0 },

		    }}
		end

	  	

sceneGroup:insert(scrollView)


		function get_GetMyUnitBuzzRequestAccesses(response)

			CreateList(response,scrollView)

		end

		Webservice.GetMyUnitBuzzRequestAccesses("GRANT",get_GetMyUnitBuzzRequestAccesses)

		menuBtn:addEventListener("touch",menuTouch)
		
	end	
	
MainGroup:insert(sceneGroup)

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

		function get_removeorblockDetails( response)

		Request_response = response


	    function onCompletion(event)

	       if "clicked"==event.action then

			 AlertGroup.isVisible = false

			 ContactIdValue = Details.ContactId

			 print("ContactIdVlaue after assigning"..ContactIdValue)

	         composer.hideOverlay()

	       end

         end

         if Request_response == true then

			 if id_value == "Remove Access" then

			    print("response after removing details ",Request_response)
		        local remove_successful= native.showAlert("Remove", "Contact removed", { CommonWords.ok} , onCompletion)


			 elseif id_value == "Block Access" then

			    print("response after blocking details ",Request_response)
				local block_successful = native.showAlert("Block", "Contact blocked successfully.", { CommonWords.ok} , onCompletion)

			 end
		else
			local block_successful = native.showAlert("Block", "Contact blocked unsuccessfully.", { CommonWords.ok} )
		end


         if id_value == "Deny Access" then

         	 if Request_response == "5" then

         	 	denyaccess = native.showAlert("Deny", "Access Denied", { CommonWords.ok } , onCompletion)

         	 elseif Request_response == "GRANT" then

         	 	granted = native.showAlert("Already Granted", "Access is already granted", { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert("Already Removed", "Access is already removed", { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert("Add Request", "Provide Access to the contact", { CommonWords.ok} , onCompletion)

         	 end

         elseif id_value == "Grant Access" then

	 	    if Request_response == "5" then

	 	    	grantaccess = native.showAlert(" Grant access", " Access granted successfully", { CommonWords.ok} , onCompletion)

	 	     elseif Request_response == "GRANT" then

         	 	granted = native.showAlert("Already Granted", "Access is already granted", { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert("Already Removed", "Access is already removed", { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert("Add Request", "Provide Access to the contact", { CommonWords.ok} , onCompletion)

         	 end

	 	elseif id_value == "Provide Access" then

	 	    if Request_response == "5" then

	 	    	accessprovided = native.showAlert("Provide access", " Access provided successfully", { CommonWords.ok } , onCompletion)

	 	     elseif Request_response == "GRANT" then

         	 	granted = native.showAlert("Already Granted", "Access is already granted", { CommonWords.ok} , onCompletion)

         	 elseif Request_response == "REMOVE" then

		 	    Removed = native.showAlert("Already Removed", "Access is already removed", { CommonWords.ok} , onCompletion)
		
		     elseif Request_response == "ADDREQUEST" then

		 	    addrequest = native.showAlert("Add Request", "Provide Access to the contact", { CommonWords.ok} , onCompletion)

         	 end

         end

	end


		function RequestGrantProcess( )


    	if processbutton_text.text == "Grant Access" then

	    		print("service of grant access")


	   	    PhoneNumber=PhoneDetailValue.text

	   	    Email = EmailDetailValue.text


	   	    MkRankId = Details.MkRankId
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


   	    MkRankId = Details.MkRankId
   	    GetRquestAccessFrom = "Contacts"

   	   MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId
        print("value for access id : ",MyUnitBuzzRequestAccessId)

   	    if MyUnitBuzzRequestAccessId == 0 then
   	    	
            isaddedToContact = true  
            MyUnitBuzzRequestAccessId = Details.ContactId

            --work

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

   	    MkRankId = Details.MkRankId
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
   	    print("reason for deny%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",MkRankId)

   	    idvalue = processbutton_text.text
   	    print(idvalue)

   	    	Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,reasonfordeny,get_removeorblockDetails)

        end

end


		return scene

 
