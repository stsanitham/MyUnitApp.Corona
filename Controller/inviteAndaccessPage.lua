----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local popupGroup = require( "Controller.popupGroup" )
local json = require('json')

local alertGroup = require( "Controller.alertGroup" )


local Utility = require( "Utils.Utility" )

local Details={}

local listValue = {}

local scrollView;

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,title

local menuBtn

openPage="inviteAndaccessPage"

local RecentTab_Topvalue = 72

local groupArray={}

local displayGroup={}

local networkArray = {}

local feedArray={}

page_flagval = "inviteAndaccessPage"



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

   elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            scrollView:takeFocus( event )
        end


    elseif event.phase == "ended" then

        native.setKeyboardFocus(nil)

--------------------------------------remove method -----------------------------------------------------

			       if id_value == "Remove Access" then


			    	    AlertGroup.isVisible = true

			            reqaccess_id = Details.MyUnitBuzzRequestAccessId
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

			            reqaccess_id = Details.MyUnitBuzzRequestAccessId
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

          GetPopUp(value.MyUnitBuzzRequestAccessId,value.EmailAddress,value.Mobile,value.HomePhoneNumber,value.WorkPhoneNumber,value.OtherPhoneNumber,id_value,value,page_flagval)
         
end

local function RemoveProcess(value)
	id_value = "Remove Access"

	  print("remove access pressed") 

	  --local remove_alert = native.showAlert("Remove", CareerPath.RemoveAccess, { CareerPath.ToRemove , CareerPath.NotToRemove} , onBlockClickComplete )

	  GetAlertPopup()

	  accept_button:addEventListener("touch",onAccessButtonTouch)
	  reject_button:addEventListener("touch",onAccessButtonTouch)

end



local function DenyProcess(value)
	id_value = "Deny Access"

	 GetPopUp(value.MyUnitBuzzRequestAccessId,Details.EmailAddress,Details.Mobile,Details.HomePhoneNumber,Details.WorkPhoneNumber,Details.OtherPhoneNumber,id_value,value,page_flagval)


end


local function ProvideAccess(value)
	id_value = "Provide Access"

	GetPopUp(value.MyUnitBuzzRequestAccessId,Details.EmailAddress,Details.Mobile,Details.HomePhoneNumber,Details.WorkPhoneNumber,Details.OtherPhoneNumber,id_value,value,page_flagval)


end


local function Block(value)

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

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            scrollView:takeFocus( event )
        end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
				for i=1,#groupArray do
				local group = groupArray[i]
						group[group.numChildren].isVisible = true
					
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

				elseif event.target.id == "listBg" then

						Details = event.target.value


					local Status_Name = event.target.name


						if Status_Name == "GRANT" or Status_Name == "DENY" or Status_Name == "OPEN" or Status_Name == "ADDREQUEST" then

							local options = 
							{
							isModal = true,
							effect = "slideLeft",
							time = 300,
							params = {
							inviteDetails =  Details,checkstatus = Status_Name
								}
							}

							composer.showOverlay( "Controller.inviteAccessDetailPage", options )


						end



				end


			print( event.target.id )
	end

return true
end


local function Createmenu( object )


local menuGroup = display.newGroup( )
	
	--print( "here" )
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

		 	Blockbtn_txt = display.newText( menuGroup,CommonWords.Block,0,0,native.systemFont,12 )
		 	Blockbtn_txt:setFillColor( 0.2 )
		 	Blockbtn_txt.x=Blockbtn.x-18;Blockbtn_txt.y=Blockbtn.y+Blockbtn.contentHeight/2

		 	Blockbtn:addEventListener( "touch", ActionTouch )

		elseif status == "DENY" then

			Grantbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Grantbtn.anchorY=0
		 	Grantbtn.y=menuBg.y+5;Grantbtn.x=menuBg.x
		 	Grantbtn:setFillColor( 0.4 )
		 	Grantbtn.alpha=0.01
		 	Grantbtn.id = "grant"
		 	Grantbtn.value = object.value

		 	Grantbtn_txt = display.newText( menuGroup,CommonWords.Grant,0,0,native.systemFont,12 )
		 	Grantbtn_txt:setFillColor( 0.2 )
		 	Grantbtn_txt.x=Grantbtn.x-18;Grantbtn_txt.y=Grantbtn.y+Grantbtn.contentHeight/2

		 	removebtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	removebtn.anchorY=0
		 	removebtn.y=Grantbtn.y+Grantbtn.contentHeight+5;removebtn.x=menuBg.x
		 	removebtn:setFillColor( 0.4 )
		 	removebtn.alpha=0.01
		 	removebtn.id="remove"
		 	removebtn.value = object.value

		 	removebtn_txt = display.newText( menuGroup,CommonWords.Remove,0,0,native.systemFont,12 )
		 	removebtn_txt:setFillColor( 0.2 )
		 	removebtn_txt.x=removebtn.x-10;removebtn_txt.y=removebtn.y+removebtn.contentHeight/2

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

		 	Grantbtn_txt = display.newText( menuGroup,CommonWords.Grant,0,0,native.systemFont,12 )
		 	Grantbtn_txt:setFillColor( 0.2 )
		 	Grantbtn_txt.x=Grantbtn.x-18;Grantbtn_txt.y=Grantbtn.y+Grantbtn.contentHeight/2

		 	denybtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	denybtn.anchorY=0
		 	denybtn.y=Grantbtn.y+Grantbtn.contentHeight+5;denybtn.x=menuBg.x
		 	denybtn:setFillColor( 0.4 )
		 	denybtn.alpha=0.01
		 	denybtn.id="deny"
		 	denybtn.value = object.value

		 	denybtn_txt = display.newText( menuGroup,CommonWords.Deny,0,0,native.systemFont,12 )
		 	denybtn_txt:setFillColor( 0.2 )
		 	denybtn_txt.x=denybtn.x-18;denybtn_txt.y=denybtn.y+denybtn.contentHeight/2

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

		 	Provideacess_txt = display.newText( menuGroup,CommonWords.ProvideAccess,0,0,native.systemFont,12 )
		 	Provideacess_txt:setFillColor( 0.2 )
		 	Provideacess_txt.x=Provideacessbtn.x;Provideacess_txt.y=Provideacessbtn.y+Provideacessbtn.contentHeight/2

		 	
		 	Provideacessbtn:addEventListener( "touch", ActionTouch )


		end
	return menuGroup

end

local function ListmenuTouch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            scrollView:takeFocus( event )
        end


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



local function CreateList(list,scrollView)

	local feedArray = list



	for i=1,#feedArray do

			groupArray[#groupArray+1] = display.newGroup()

			local Display_Group = {}

			local tempGroup = groupArray[#groupArray]
			local bgheight = 105

            local Image 

		
			local background = display.newRect(tempGroup,0,0,W,45)
			local Initial_Height = 3

			if(groupArray[#groupArray-1]) ~= nil then
				Initial_Height = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].height-2
			end

			background.anchorY = 0
			background.anchorX = 0
			background.x=5;background.y=Initial_Height
			background.alpha=0.01
			background.value = feedArray[i]
			background.id="listBg"
			background.name = status
			background:addEventListener( "touch", ActionTouch )



			local line = display.newRect(tempGroup,W/2,background.y,W,1)
			line.y=background.y+background.contentHeight-line.contentHeight+15
			line:setFillColor(Utility.convertHexToRGB(color.LtyGray))



			if feedArray[i].ImagePath ~= nil then

			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2+5
			Image.isVisible = true

			networkArray[#networkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..feedArray[i].ImagePath,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else

						if Image then

						Image = display.newImage(tempGroup,img_event.response.filename,system.TemporaryDirectory)
						Image.width=35;Image.height=35
						Image.x=30;Image.y=background.y+background.height/2-7
    				--event.row:insert(img_event.target)

    			    else

						Image:removeSelf();Image=nil

					 end
    			end

    			end, "inviteaccess"..feedArray[i].MyUnitBuzzRequestAccessId..".png", system.TemporaryDirectory)
		else

			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2+5

		end





          --  local nameLabel = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)

		    	Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
				Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
				Display_Group[#Display_Group].x=Image.x+Image.contentWidth/2 +10;Display_Group[#Display_Group].y=background.y-1
				Display_Group[#Display_Group]:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


			if feedArray[i].FirstName ~= nil then

				Display_Group[#Display_Group].text = feedArray[i].FirstName.." "..feedArray[i].LastName

			else

				Display_Group[#Display_Group].text = feedArray[i].LastName
			
			end



			if feedArray[i].EmailAddress ~= nil then

				Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
				Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
				Display_Group[#Display_Group].x=Image.x+Image.contentWidth/2 +10;Display_Group[#Display_Group].y=Display_Group[#Display_Group-1].y+Display_Group[#Display_Group-1].contentHeight+5
				Display_Group[#Display_Group]:setFillColor( 0.3 )
				Display_Group[#Display_Group].text = feedArray[i].EmailAddress


			if feedArray[i].EmailAddress:len() > 33 then

				Display_Group[#Display_Group].text = Display_Group[#Display_Group].text:sub(1,33)..".."

			end
        

			end




			if feedArray[i].PhoneNumber ~= nil and feedArray[i].PhoneNumber ~= "" then

				Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
				Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
				Display_Group[#Display_Group].x=Image.x+Image.contentWidth/2 +10;Display_Group[#Display_Group].y=Display_Group[#Display_Group-1].y+Display_Group[#Display_Group-1].contentHeight+5
				Display_Group[#Display_Group]:setFillColor( 0.3 )
				Display_Group[#Display_Group].text = feedArray[i].PhoneNumber

			end



			background.height = 0

			for i=1,#Display_Group do

				background.height = background.height + Display_Group[i].contentHeight+10

			end

		--	background.height = background.height + 20

			--background.height = background.height-((background.height/5)*(5-#Display_Group))+5


	

			 --  group =  Createmenu(background)

   				--tempGroup:insert( group )

   				--group.isVisible=false

			scrollView:insert(tempGroup)

			print( "@@@@@@@@@" )


	end

end

local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

			elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            scrollView:takeFocus( event )
        end

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

	title = display.newText(sceneGroup,"Contacts with Access",0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	NoEvent = display.newText( sceneGroup, EventCalender.NoEvent , 0,0,0,0,native.systemFontBold,14)
	NoEvent.x=W/2;NoEvent.y=H/2
	NoEvent.isVisible=false
	NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )



	MainGroup:insert(sceneGroup)
end

function get_GetMyUnitBuzzRequestAccesses(response)


		scrollView:scrollToPosition
		{
		    y = 0,
		    time = 200,
		}


		for j=#groupArray, 1, -1 do 
			display.remove(groupArray[#groupArray])
			groupArray[#groupArray] = nil
		end


	if response ~= nil then
		if #response > 0 then
		

				NoEvent.isVisible=false


			local listValue = {}

				for i=1,#response do

					listValue[#listValue+1] = response[i]	

				end



			-- for i=1,#response do

			-- 	if response[i].IsOwner == true then


			-- 	else

			--	listValue[#listValue+1] = response[i]	

			--	end

			--end

				print( "here !!!!!!!"..#listValue )	
			CreateList(listValue,scrollView)

		else

				NoEvent.isVisible=true

				if status == "DENY" then

					NoEvent.text="No list of Denied Access found"

				elseif status == "OPEN" then

					NoEvent.text="No Pending Requests found"

				elseif status == "ADDREQUEST" then

					NoEvent.text="No list of Team Members without Access found"

				end


		end

	end

end

function reloadInvitAccess(reloadstatus)

	composer.hideOverlay( )

	status = reloadstatus

	if reloadstatus == "GRANT" then title.text = "Contacts with Access" end
	if reloadstatus == "DENY" then title.text = "Denied Access" end
	if reloadstatus == "OPEN" then title.text = "Pending Requests" end
	if reloadstatus == "ADDREQUEST" then title.text = "Team Member without Access" end

	Webservice.GetMyUnitBuzzRequestAccesses(reloadstatus,get_GetMyUnitBuzzRequestAccesses)

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
					isBounceEnabled=false,
					horizontalScrollDisabled = true,
			   		--scrollWidth = W,
					bottomPadding = 60,
		   			--listener = Facebook_scrollListener,
		}



sceneGroup:insert(scrollView)

		
		status = event.params.status
	

		Webservice.GetMyUnitBuzzRequestAccesses(event.params.status,get_GetMyUnitBuzzRequestAccesses)

		menuBtn:addEventListener("touch",menuTouch)
		
	end	
	
MainGroup:insert(sceneGroup)

end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			composer.removeHidden()


			elseif phase == "did" then


					for i=1,#networkArray do

						network.cancel(networkArray[i])
					end


					for j=1,#groupArray do 
						if groupArray[j] then groupArray[j]:removeSelf();groupArray[j] = nil	end
					end


			end	

		end


		function scene:destroy( event )
			local sceneGroup = self.view



		end


		scene:addEventListener( "create", scene )
		scene:addEventListener( "show", scene )
		scene:addEventListener( "hide", scene )
		scene:addEventListener( "destroy", scene )

		function scene:resumeGame()

			composer.removeHidden(true)


		reloadInvitAccess(status)

	end



		function get_removeorblockDetails( response)

		Request_response = response


	    function onCompletion(event)

	       if "clicked"==event.action then

			 AlertGroup.isVisible = false

			 print( "@@@@@@@@@" )
			 ContactIdValue = Details.MyUnitBuzzRequestAccessId

			if popUpGroup.numChildren ~= nil then
			 for j=popUpGroup.numChildren, 1, -1 do 
								display.remove(popUpGroup[popUpGroup.numChildren])
								popUpGroup[popUpGroup.numChildren] = nil
			 end
			end

			Webservice.GetMyUnitBuzzRequestAccesses(status,get_GetMyUnitBuzzRequestAccesses)

	       end

         end



         if Request_response == "SUCCESS" then

			 if id_value == "Remove Access" then

			    print("response after removing details ",Request_response)
		        local remove_successful= native.showAlert(CommonWords.Remove, "Contact removed from the list.", { CommonWords.ok} , onCompletion)


			 elseif id_value == "Block Access" then

			    print("!!!!! response after blocking details ",Request_response)
				local block_successful = native.showAlert(CommonWords.Block, "This Contact’s Access blocked successfully.", { CommonWords.ok} , onCompletion)

			 end
		--else
			--local block_successful = native.showAlert("Block", "Blocking of this Contact’s Access failed.", { CommonWords.ok} )
		end



         if id_value == "Deny Access" then

         	 if Request_response == "SUCCESS" then

         	 	denyaccess = native.showAlert(CommonWords.Deny,  CareerPath.DeniedText, { CommonWords.ok } , onCompletion)

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

		 	    addrequest = native.showAlert(CareerPath.AddRequest, CareerPath.AddRequestText,{ CommonWords.ok} , onCompletion)

		 	 elseif Request_response == "BLOCK" then

		 	    addrequest = native.showAlert(CareerPath.AlreadyBlocked, CareerPath.AlreadyBlockedText, { CommonWords.ok} , onCompletion)

         	 end

         end

	end



		return scene

 
