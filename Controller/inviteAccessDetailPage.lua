----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local json = require("json")
local widget = require( "widget" )

local popupGroup = require( "Controller.popupGroup" )
local alertGroup = require( "Controller.alertGroup" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )



--------------- Initialization -------------------


local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,contactId

local RecentTab_Topvalue = 70

openPage="inviteAndaccessPage"

ContactIdValue = 0

local display_details = {}

page_flag1 = "inviteAndaccessPage"



--------------------------------------------------


-----------------Function-------------------------



	local function bgTouch( event )

	if event.phase == "began" then
	display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
	display.getCurrentStage():setFocus( nil )

	end

	return true
	end



	local function closeInviteDetails( event )

		print("^^^^^^^^^^^^^")

	if event.phase == "began" then
	display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then

	print("close button pressed")

	display.getCurrentStage():setFocus( nil )
	composer.hideOverlay( "slideRight", 300 )

	end

	return true

	end






	function get_removeorblockDetails( response)

		Request_response = response


	    function onCompletion(event)

	       if "clicked"==event.action then

	       	print("on complete action done [[[[[[[[[[[[[[[[[[[[980890890890]]]]]]]]]]]]]]]]]]]]]]]]]")

			 AlertGroup.isVisible = false


			 -- ContactIdValue = contactId

			 -- print("ContactIdVlaue after assigning"..ContactIdValue)


	         composer.hideOverlay()

	       end

         end



		 if id_value == "Remove Access" then

		    print("response after removing details ",Request_response)
	        local remove_successful= native.showAlert(CommonWords.Remove , CareerPath.RemovedText, { CommonWords.ok} , onCompletion)


		 elseif id_value == "Block Access" then

		    print("response after blocking details ",Request_response)
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




function onAccessButtonTouch( event )

    if event.phase == "began" then

   elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
        end


    elseif event.phase == "ended" then

        native.setKeyboardFocus(nil)

--------------------------------------remove method -----------------------------------------------------

			       if id_value == "Remove Access" then

			    	    AlertGroup.isVisible = true

			            reqaccess_id = invitedetail_value.MyUnitBuzzRequestAccessId
						reqaccess_from = invitedetail_value.GetRquestAccessFrom
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

			            reqaccess_id = invitedetail_value.MyUnitBuzzRequestAccessId
						reqaccess_from = invitedetail_value.GetRquestAccessFrom
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



local function Block()

	id_value = "Block Access"

       GetAlertPopup()

		AlertText.text = "Block"
		AlertContentText.text = CareerPath.BlockAccess
		print("block access occurred text value ",AlertContentText.text)

		accept_button_text.text = CareerPath.ToBlock
		reject_button_text.text = CareerPath.NotToBlock

	  accept_button:addEventListener("touch",onAccessButtonTouch)
	  reject_button:addEventListener("touch",onAccessButtonTouch)

end



local function RemoveProcess()

	id_value = "Remove Access"

	  GetAlertPopup()

	  accept_button:addEventListener("touch",onAccessButtonTouch)
	  reject_button:addEventListener("touch",onAccessButtonTouch)

end




local function GrandProcess()

    id_value = "Grant Access"
	     GetPopUp(invitedetail_value.MyUnitBuzzRequestAccessId,invitedetail_value.EmailAddress,invitedetail_value.PhoneNumber,invitedetail_value.PhoneNumber,invitedetail_value.MkRankLevel,invitedetail_value.UpdateTimeStamp,id_value,invitedetail_value,page_flag1)
       
end


local function DenyProcess()
	id_value = "Deny Access"

	 GetPopUp(invitedetail_value.MyUnitBuzzRequestAccessId,invitedetail_value.EmailAddress,invitedetail_value.PhoneNumber,invitedetail_value.PhoneNumber,invitedetail_value.MkRankLevel,invitedetail_value.UpdateTimeStamp,id_value,invitedetail_value,page_flag1)

end


local function ProvideAccess()
	id_value = "Provide Access"

	GetPopUp(invitedetail_value.MyUnitBuzzRequestAccessId,invitedetail_value.EmailAddress,invitedetail_value.PhoneNumber,invitedetail_value.PhoneNumber,invitedetail_value.MkRankLevel,invitedetail_value.UpdateTimeStamp,id_value,invitedetail_value,page_flag1)

end






local function onButtonTouchAction( event )

	if event.phase == "began" then
			
			display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
    
	elseif event.phase == "ended" then
			
			display.getCurrentStage():setFocus( nil )

			id_value =  event.target.id

				if id_value == "Block Access" then

					Block()

				elseif id_value == "Grant Access" then

					GrandProcess()

				elseif id_value == "Remove Access" then

					RemoveProcess()


				elseif id_value == "Deny Access" then

					DenyProcess()


				elseif id_value == "Provide Access" then

					ProvideAccess()

				end


			print("%%%%%%%%%%%%%%%%%%%%%%%%%%%", event.target.id )
	end

return true

end





	local function onKeyInviteDetail( event )

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

		menuTouch_s = display.newRect( sceneGroup, 0, BgText.y, 135, 40 )
		menuTouch_s.anchorX=0
		menuTouch_s.alpha=0.01

		title_bg = display.newRect(sceneGroup,0,0,W,30)
		title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
		title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

		title = display.newText(sceneGroup,"",0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=5;title.y = title_bg.y
		title:setFillColor(0)

		titleBar = display.newRect(sceneGroup,W/2,title_bg.y+title_bg.contentHeight/2,W,30)
		titleBar.anchorY=0
		titleBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		titleBar_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
		titleBar_icon.x=titleBar.x-titleBar.contentWidth/2+10
		titleBar_icon.y=titleBar.y+titleBar.contentHeight/2-titleBar_icon.contentWidth
		titleBar_icon.anchorY=0

		titleBar_text = display.newText(sceneGroup," ",0,0,native.systemFont,0)
		titleBar_text.x=titleBar_icon.x+titleBar_icon.contentWidth+5
		titleBar_text.y=titleBar.y+titleBar.contentHeight/2-titleBar_text.contentHeight/2
		titleBar_text.anchorX=0;titleBar_text.anchorY=0
		Utils.CssforTextView(titleBar_text,sp_subHeader)

	MainGroup:insert(sceneGroup)

	end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

			 --    contactId = invitedetail_value.MyUnitBuzzRequestAccessId

				-- print("ContactIdVlaue before assigning"..contactId)


				-- for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

				-- ContactId = row.ContactId

				-- print("ContactId :"..ContactId)

				-- end

	  


		elseif phase == "did" then

			local leftAlign = 10

				titleBar_icon:addEventListener("touch",closeInviteDetails)
				titleBar_text:addEventListener("touch",closeInviteDetails)

				Background:addEventListener("touch",bgTouch)

				menuBtn:addEventListener("touch",menuTouch)
				menuTouch_s:addEventListener("touch",menuTouch)
				BgText:addEventListener("touch",menuTouch)

				Runtime:addEventListener("key",onKeyInviteDetail)


			if event.params then

		     invitedetail_value = event.params.inviteDetails

		     invite_status = event.params.checkstatus

			 print("############################ Invite / Access Details...................." , json.encode(invitedetail_value) )

			 print("############################ Invite / Access Status...................." , invite_status)

			     menuBtn:addEventListener("touch",menuTouch)

		    end


			if invite_status == "GRANT" then title.text = "Contacts with Access" end
			if invite_status == "DENY" then title.text = "Denied Access" end
			if invite_status == "OPEN" then title.text = "Pending Requests" end
			if invite_status == "ADDREQUEST" then title.text = "Team Member without Access" end


		if (invitedetail_value.FirstName ~= nil and invitedetail_value.FirstName ~= "") and (invitedetail_value.LastName ~= nil and invitedetail_value.LastName ~= "") then

        	  titleBar_text.text = invitedetail_value.FirstName.." "..invitedetail_value.LastName

        elseif  (invitedetail_value.FirstName ~= nil and invitedetail_value.FirstName ~= "") or (invitedetail_value.LastName == nil and invitedetail_value.LastName == "") then

        	 titleBar_text.text = invitedetail_value.FirstName

        elseif  (invitedetail_value.FirstName == nil and invitedetail_value.FirstName == "") or (invitedetail_value.LastName ~= nil and invitedetail_value.LastName ~= "") then

        	 titleBar_text.text = invitedetail_value.LastName

		end


		scroll_View = widget.newScrollView
		{
		top = 100,
		left = 0,
		width = W,
		height = H-100,
		hideBackground = false,
		isBounceEnabled=false,
		horizontalScrollingDisabled = true,
		verticalScrollingDisabled = false,
		hideScrollBar=true,
		bottomPadding = 50,

		-- listener = scrollListener
		}
		--scroll_View.anchorY=0
		--scroll_View.y=titleBar.y+30
		--scrollView.anchorX=0

		sceneGroup:insert(scroll_View)


----------------------------Email Address---------------------------------------------------------

	    if invitedetail_value.EmailAddress ~= nil and invitedetail_value.EmailAddress ~= "" then

		display_details[#display_details+1] = display.newText(InviteAccessDetail.Email,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=15
		display_details[#display_details].anchorX=0
		scroll_View:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(invitedetail_value.EmailAddress,0,0,W-20,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-145;display_details[#display_details].y=display_details[#display_details-1].y+15
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="email_address"
		scroll_View:insert( display_details[#display_details] )

		-- display_details[#display_details+1] = display.newImageRect("res/assert/line-large.png",W-20,5)
		-- display_details[#display_details].x=W/2
		-- display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+4
		-- sceneGroup:insert(display_details[#display_details])

		display_details[#display_details+1] = display.newRect(0,0,W,0.8)
		display_details[#display_details].x = W/2-160;
		display_details[#display_details].anchorX=0
		display_details[#display_details].y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+10
		display_details[#display_details]:setFillColor(0,0,0,0.1)
		scroll_View:insert( display_details[#display_details] )

		end

---------------------------------------------------------------------------------------------------		



----------------------------Phone Number---------------------------------------------------------

	    if invitedetail_value.PhoneNumber ~= nil and invitedetail_value.PhoneNumber ~= "" then

		display_details[#display_details+1] = display.newText(InviteAccessDetail.Phone,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+15
		display_details[#display_details].anchorX=0
		scroll_View:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(invitedetail_value.PhoneNumber,0,0,W-20,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-145;display_details[#display_details].y=display_details[#display_details-1].y+15
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="phone_number"
		scroll_View:insert( display_details[#display_details] )

		-- display_details[#display_details+1] = display.newImageRect("res/assert/line-large.png",W-20,5)
		-- display_details[#display_details].x=W/2
		-- display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+4
		-- sceneGroup:insert(display_details[#display_details])

		display_details[#display_details+1] = display.newRect(0,0,W,0.8)
		display_details[#display_details].x = W/2-160;
		display_details[#display_details].anchorX=0
		display_details[#display_details].y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+10
		display_details[#display_details]:setFillColor(0,0,0,0.1)
		scroll_View:insert( display_details[#display_details] )

		end

-------------------------------------------------------------------------------------------------		




----------------------------MK Rank---------------------------------------------------------

	    if invitedetail_value.MkRankLevel ~= nil and invitedetail_value.MkRankLevel ~= "" then

		display_details[#display_details+1] = display.newText(InviteAccessDetail.MKRank,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+15
		display_details[#display_details].anchorX=0
		scroll_View:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(invitedetail_value.MkRankLevel,0,0,W-20,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-145;display_details[#display_details].y=display_details[#display_details-1].y+15
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="mk_rank"
		scroll_View:insert( display_details[#display_details] )

		-- display_details[#display_details+1] = display.newImageRect("res/assert/line-large.png",W-20,5)
		-- display_details[#display_details].x=W/2
		-- display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+4
		-- sceneGroup:insert(display_details[#display_details])

		display_details[#display_details+1] = display.newRect(0,0,W,0.8)
		display_details[#display_details].x = W/2-160;
		display_details[#display_details].anchorX=0
		display_details[#display_details].y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+10
		display_details[#display_details]:setFillColor(0,0,0,0.1)
		scroll_View:insert( display_details[#display_details] )

		end

-------------------------------------------------------------------------------------------------	




----------------------------Activity On----------------------------------------------------------

	  if invitedetail_value.UpdateTimeStamp ~= nil and invitedetail_value.UpdateTimeStamp ~= "" then

	       local time = Utils.makeTimeStamp(invitedetail_value.UpdateTimeStamp)

		   local activity_time = tostring(os.date("%m/%d/%Y %I:%m %p",time))

		display_details[#display_details+1] = display.newText(InviteAccessDetail.ActivityOn,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+15
		display_details[#display_details].anchorX=0
		scroll_View:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(activity_time,0,0,W-20,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-145;display_details[#display_details].y=display_details[#display_details-1].y+15
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="mk_rank"
		scroll_View:insert( display_details[#display_details] )

		-- display_details[#display_details+1] = display.newImageRect("res/assert/line-large.png",W-20,5)
		-- display_details[#display_details].x=W/2
		-- display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+4
		-- sceneGroup:insert(display_details[#display_details])

		display_details[#display_details+1] = display.newRect(0,0,W,0.8)
		display_details[#display_details].x = W/2-160;
		display_details[#display_details].anchorX=0
		display_details[#display_details].y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+10
		display_details[#display_details]:setFillColor(0,0,0,0.1)
		scroll_View:insert( display_details[#display_details] )


		end


		


	    if invitedetail_value.Comments ~= nil and invitedetail_value.Comments ~= "" then

		display_details[#display_details+1] = display.newText(InviteAccessDetail.Comments,0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+15
		display_details[#display_details].anchorX=0
		scroll_View:insert( display_details[#display_details] )

  

		display_details[#display_details+1] = display.newText(invitedetail_value.Comments,0,0,W-20,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-145;display_details[#display_details].y=display_details[#display_details-1].y+15
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="comments"
		scroll_View:insert( display_details[#display_details] )

		-- display_details[#display_details+1] = display.newRect( 0, 0, W-20, 30 )
		-- display_details[#display_details].x=W/2
		-- display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+4
		-- sceneGroup:insert(display_details[#display_details])


		display_details[#display_details+1] = display.newRect(0,0,W,0.8)
		display_details[#display_details].x = W/2-160;
		display_details[#display_details].anchorX=0
		display_details[#display_details].y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+10
		display_details[#display_details]:setFillColor(0,0,0,0.1)
		scroll_View:insert( display_details[#display_details] )


  end

	

-------------------------------------------------------------------------------------------------	

  if invitedetail_value.IsOwner == false then
		display_details[#display_details+1] = display.newText(CommonWords.InviteAccessText,0,0,0,0,native.systemFontBold,15)
		display_details[#display_details]:setFillColor(0,0,0)
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+25
		display_details[#display_details].anchorX=0
		scroll_View:insert( display_details[#display_details] )

  end


----------------------------Activity On---------------------------------------------------------

	    if invite_status == "DENY" then


		            grantaccess_button = display.newRect(scroll_View,0,0,W,25)
					grantaccess_button.x=leftAlign + 75
					grantaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					grantaccess_button:setStrokeColor(0,0,0,0.5)
					grantaccess_button:setFillColor(0,0,0,0.2)
					grantaccess_button.strokeWidth = 1
					grantaccess_button.cornerRadius = 2
					grantaccess_button.width = W-190
					grantaccess_button.id="Grant Access"
					grantaccess_button:addEventListener("touch",onButtonTouchAction)
					scroll_View:insert( grantaccess_button )

					grantaccess_button_text = display.newText(scroll_View,CommonWords.Grant,0,0,native.systemFont,16)
					grantaccess_button_text.x=grantaccess_button.x
					grantaccess_button_text.y=grantaccess_button.y
					grantaccess_button_text:setFillColor(0,0,0)
					scroll_View:insert( grantaccess_button_text )


					removeaccess_button = display.newRect(scroll_View,0,0,W,25)
					removeaccess_button.x=leftAlign + 223
					removeaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					removeaccess_button:setStrokeColor(0,0,0,0.5)
					removeaccess_button:setFillColor(0,0,0,0.2)
					removeaccess_button.strokeWidth = 1
					removeaccess_button.cornerRadius = 2
					removeaccess_button.width = W-190
					removeaccess_button.id="Remove Access"
					removeaccess_button:addEventListener("touch",onButtonTouchAction)
					scroll_View:insert( removeaccess_button )

					removeaccess_button_text = display.newText(scroll_View,CommonWords.Remove,0,0,native.systemFont,16)
					removeaccess_button_text.x=removeaccess_button.x
					removeaccess_button_text.y=removeaccess_button.y
					removeaccess_button_text:setFillColor(0,0,0)
					scroll_View:insert( removeaccess_button_text )


	    elseif invite_status == "GRANT" then


	    	  		blockaccess_button = display.newRect(scroll_View,0,0,W,25)
					blockaccess_button.x=leftAlign + 150
					blockaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					blockaccess_button:setStrokeColor(0,0,0,0.5)
					blockaccess_button:setFillColor(0,0,0,0.2)
					blockaccess_button.strokeWidth = 1
					blockaccess_button.cornerRadius = 2
					blockaccess_button.width = W-150
					blockaccess_button.id="Block Access"
					blockaccess_button:addEventListener("touch",onButtonTouchAction)
					scroll_View:insert( blockaccess_button )

					blockaccess_button_text = display.newText(scroll_View,CommonWords.Block,0,0,native.systemFont,16)
					blockaccess_button_text.x=blockaccess_button.x
					blockaccess_button_text.y=blockaccess_button.y
					blockaccess_button_text:setFillColor(0,0,0)
					scroll_View:insert( blockaccess_button_text )

          if invitedetail_value.IsOwner == true then

            blockaccess_button.isVisible=false
            blockaccess_button_text.isVisible=false

          end


		elseif invite_status == "ADDREQUEST" then

			 	    provideaccess_button = display.newRect(scroll_View,0,0,W,25)
					provideaccess_button.x=leftAlign + 150
					provideaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					provideaccess_button:setStrokeColor(0,0,0,0.5)
					provideaccess_button:setFillColor(0,0,0,0.2)
					provideaccess_button.strokeWidth = 1
					provideaccess_button.cornerRadius = 2
					provideaccess_button.width = W-150
					provideaccess_button.id="Provide Access"
					provideaccess_button:addEventListener("touch",onButtonTouchAction)
					scroll_View:insert( provideaccess_button )

					provideaccess_button_text = display.newText(scroll_View,CommonWords.ProvideAccess,0,0,native.systemFont,16)
					provideaccess_button_text.x=provideaccess_button.x
					provideaccess_button_text.y=provideaccess_button.y
					provideaccess_button_text:setFillColor(0,0,0)
					scroll_View:insert( provideaccess_button_text )


        elseif invite_status == "OPEN" then

        			grantaccess_button = display.newRect(scroll_View,0,0,W,25)
					grantaccess_button.x=leftAlign + 75
					grantaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					grantaccess_button:setStrokeColor(0,0,0,0.5)
					grantaccess_button:setFillColor(0,0,0,0.3)
					grantaccess_button.strokeWidth = 1
					grantaccess_button.cornerRadius = 2
					grantaccess_button.width = W-190
					grantaccess_button.id="Grant Access"
					grantaccess_button:addEventListener("touch",onButtonTouchAction)
					scroll_View:insert( grantaccess_button )

					grantaccess_button_text = display.newText(scroll_View,CommonWords.Grant,0,0,native.systemFont,16)
					grantaccess_button_text.x=grantaccess_button.x
					grantaccess_button_text.y=grantaccess_button.y
					grantaccess_button_text:setFillColor(0,0,0)
					scroll_View:insert( grantaccess_button_text )

					denyaccess_button = display.newRect(scroll_View,0,0,W,25)
					denyaccess_button.x=leftAlign + 223
					denyaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					denyaccess_button:setStrokeColor(0,0,0,0.5)
					denyaccess_button:setFillColor(0,0,0,0.3)
					denyaccess_button.strokeWidth = 1
					denyaccess_button.cornerRadius = 2
					denyaccess_button.width = W-190
					denyaccess_button.id="Deny Access"
					denyaccess_button:addEventListener("touch",onButtonTouchAction)
					scroll_View:insert( denyaccess_button )

					denyaccess_button_text = display.newText(scroll_View,CommonWords.Deny,0,0,native.systemFont,16)
					denyaccess_button_text.x=denyaccess_button.x
					denyaccess_button_text.y=denyaccess_button.y
					denyaccess_button_text:setFillColor(0,0,0)
					scroll_View:insert( denyaccess_button_text )

		end

-------------------------------------------------------------------------------------------------	


		end	
		
	MainGroup:insert(sceneGroup)

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


			elseif phase == "did" then

			 event.parent:resumeGame()

				menuBtn:removeEventListener("touch",menuTouch)
				BgText:removeEventListener("touch",menuTouch)
				menuTouch_s:removeEventListener("touch",menuTouch)

				Runtime:removeEventListener( "key", onKeyInviteDetail )

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