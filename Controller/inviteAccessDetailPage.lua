----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local RecentTab_Topvalue = 105

openPage="inviteAndaccessPage"

local display_details = {}



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



	local function closeDetails( event )

	if event.phase == "began" then
	display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
	display.getCurrentStage():setFocus( nil )
	composer.hideOverlay( "slideRight", 300 )

	end

	return true

	end




	local function onKeyInviteDetail( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" or keyName=="a" then

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


		elseif phase == "did" then

			local leftAlign = 10

				titleBar_icon:addEventListener("touch",closeDetails)
				titleBar_text:addEventListener("touch",closeDetails)

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


        if (invitedetail_value.FirstName ~= nil and invitedetail_value.FirstName ~= "") or (invitedetail_value.LastName ~= nil and invitedetail_value.LastName ~= "")  then

		       titleBar_text.text = invitedetail_value.FirstName.." "..invitedetail_value.LastName 

		       print("TITLE NAME 111 -----------------------------------" , titleBar_text)

		elseif invitedetail_value.LastName ~= nil and invitedetail_value.LastName ~= ""  then

		       titleBar_text.text = invitedetail_value.FirstName.." "..invitedetail_value.LastName

		       print("TITLE NAME 222-----------------------------------" , titleBar_text)


		end

			  --  if titleBar_text.text:len() > 30 then

					-- titleBar_text.text = titleBar_text.text:sub(1,30).."..."

			  --  end

----------------------------Email Address---------------------------------------------------------

	    if invitedetail_value.EmailAddress ~= nil and invitedetail_value.EmailAddress ~= "" then

		display_details[#display_details+1] = display.newText("Email",0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=RecentTab_Topvalue+10
		display_details[#display_details].anchorX=0
		sceneGroup:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(invitedetail_value.EmailAddress,0,0,190,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-38;display_details[#display_details].y=display_details[#display_details-1].y-5
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="email_address"
		sceneGroup:insert( display_details[#display_details] )

		end

---------------------------------------------------------------------------------------------------		



----------------------------Phone Number---------------------------------------------------------

	    if invitedetail_value.PhoneNumber ~= nil and invitedetail_value.PhoneNumber ~= "" then

		display_details[#display_details+1] = display.newText("Phone",0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
		display_details[#display_details].anchorX=0
		sceneGroup:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(invitedetail_value.PhoneNumber,0,0,180,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-38;display_details[#display_details].y=display_details[#display_details-1].y-5
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="phone_number"
		sceneGroup:insert( display_details[#display_details] )

		end

-------------------------------------------------------------------------------------------------		




----------------------------MK Rank---------------------------------------------------------

	    if invitedetail_value.MkRankLevel ~= nil and invitedetail_value.MkRankLevel ~= "" then

		display_details[#display_details+1] = display.newText("MK Rank",0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
		display_details[#display_details].anchorX=0
		sceneGroup:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(invitedetail_value.MkRankLevel,0,0,180,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-38;display_details[#display_details].y=display_details[#display_details-1].y-5
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="mk_rank"
		sceneGroup:insert( display_details[#display_details] )

		end

-------------------------------------------------------------------------------------------------	




----------------------------Activity On---------------------------------------------------------

	    if invitedetail_value.UpdateTimeStamp ~= nil and invitedetail_value.UpdateTimeStamp ~= "" then

	       local time = Utils.makeTimeStamp(invitedetail_value.UpdateTimeStamp)

		   local activity_time = tostring(os.date("%m/%d/%Y %I:%m %p",time))

		display_details[#display_details+1] = display.newText("Activity On",0,0,sp_labelName.Font_Weight,sp_labelName.Font_Size_ios)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(sp_labelName.Text_Color))
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+20
		display_details[#display_details].anchorX=0
		sceneGroup:insert( display_details[#display_details] )


		display_details[#display_details+1] = display.newText(activity_time,0,0,180,0,native.systemFont,14)
		display_details[#display_details]:setFillColor(Utils.convertHexToRGB(color.Black))
		display_details[#display_details].x=W/2-38;display_details[#display_details].y=display_details[#display_details-1].y-5
		display_details[#display_details].anchorX=0
		display_details[#display_details].anchorY=0
		display_details[#display_details].id="mk_rank"
		sceneGroup:insert( display_details[#display_details] )

		end

-------------------------------------------------------------------------------------------------	


		display_details[#display_details+1] = display.newText("Invite/Access",0,0,0,0,native.systemFontBold,15)
		display_details[#display_details]:setFillColor(0,0,0)
		display_details[#display_details].x=leftAlign
		display_details[#display_details].y=display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+25
		display_details[#display_details].anchorX=0
		sceneGroup:insert( display_details[#display_details] )


----------------------------Activity On---------------------------------------------------------

	    if invite_status == "DENY" then


		            grantaccess_button = display.newRect(sceneGroup,0,0,W,25)
					grantaccess_button.x=leftAlign + 75
					grantaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					grantaccess_button:setStrokeColor(0,0,0,0.5)
					grantaccess_button:setFillColor(0,0,0,0.2)
					grantaccess_button.strokeWidth = 1
					grantaccess_button.cornerRadius = 2
					grantaccess_button.width = W-190
					grantaccess_button.id="Grant Access"
					--grantaccess_button:addEventListener("touch",onButtonTouch)
					sceneGroup:insert( grantaccess_button )

					grantaccess_button_text = display.newText(sceneGroup,"Grant",0,0,native.systemFont,16)
					grantaccess_button_text.x=grantaccess_button.x
					grantaccess_button_text.y=grantaccess_button.y
					grantaccess_button_text:setFillColor(0,0,0)
					sceneGroup:insert( grantaccess_button_text )


					removeaccess_button = display.newRect(sceneGroup,0,0,W,25)
					removeaccess_button.x=leftAlign + 223
					removeaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					removeaccess_button:setStrokeColor(0,0,0,0.5)
					removeaccess_button:setFillColor(0,0,0,0.2)
					removeaccess_button.strokeWidth = 1
					removeaccess_button.cornerRadius = 2
					removeaccess_button.width = W-190
					removeaccess_button.id="Remove Access"
					--removeaccess_button:addEventListener("touch",onButtonTouch)
					sceneGroup:insert( removeaccess_button )

					removeaccess_button_text = display.newText(sceneGroup,"Remove",0,0,native.systemFont,16)
					removeaccess_button_text.x=removeaccess_button.x
					removeaccess_button_text.y=removeaccess_button.y
					removeaccess_button_text:setFillColor(0,0,0)
					sceneGroup:insert( removeaccess_button_text )


	    elseif invite_status == "GRANT" then

	    	  		blockaccess_button = display.newRect(sceneGroup,0,0,W,25)
					blockaccess_button.x=leftAlign + 150
					blockaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					blockaccess_button:setStrokeColor(0,0,0,0.5)
					blockaccess_button:setFillColor(0,0,0,0.2)
					blockaccess_button.strokeWidth = 1
					blockaccess_button.cornerRadius = 2
					blockaccess_button.width = W-150
					blockaccess_button.id="Block Access"
					--blockaccess_button:addEventListener("touch",onButtonTouch)
					sceneGroup:insert( blockaccess_button )

					blockaccess_button_text = display.newText(sceneGroup,"Block",0,0,native.systemFont,16)
					blockaccess_button_text.x=blockaccess_button.x
					blockaccess_button_text.y=blockaccess_button.y
					blockaccess_button_text:setFillColor(0,0,0)
					sceneGroup:insert( blockaccess_button_text )


		elseif invite_status == "ADDREQUEST" then

			 	    provideaccess_button = display.newRect(sceneGroup,0,0,W,25)
					provideaccess_button.x=leftAlign + 150
					provideaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					provideaccess_button:setStrokeColor(0,0,0,0.5)
					provideaccess_button:setFillColor(0,0,0,0.2)
					provideaccess_button.strokeWidth = 1
					provideaccess_button.cornerRadius = 2
					provideaccess_button.width = W-150
					provideaccess_button.id="Provide Access"
					--provideaccess_button:addEventListener("touch",onButtonTouch)
					sceneGroup:insert( provideaccess_button )

					provideaccess_button_text = display.newText(sceneGroup,"Provide Access",0,0,native.systemFont,16)
					provideaccess_button_text.x=provideaccess_button.x
					provideaccess_button_text.y=provideaccess_button.y
					provideaccess_button_text:setFillColor(0,0,0)
					sceneGroup:insert( provideaccess_button_text )


        elseif invite_status == "OPEN" then

        			grantaccess_button = display.newRect(sceneGroup,0,0,W,25)
					grantaccess_button.x=leftAlign + 75
					grantaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					grantaccess_button:setStrokeColor(0,0,0,0.5)
					grantaccess_button:setFillColor(0,0,0,0.3)
					grantaccess_button.strokeWidth = 1
					grantaccess_button.cornerRadius = 2
					grantaccess_button.width = W-190
					grantaccess_button.id="Grant Access"
					--grantaccess_button:addEventListener("touch",onButtonTouch)
					sceneGroup:insert( grantaccess_button )

					grantaccess_button_text = display.newText(sceneGroup,"Grant",0,0,native.systemFont,16)
					grantaccess_button_text.x=grantaccess_button.x
					grantaccess_button_text.y=grantaccess_button.y
					grantaccess_button_text:setFillColor(0,0,0)
					sceneGroup:insert( grantaccess_button_text )

					denyaccess_button = display.newRect(sceneGroup,0,0,W,25)
					denyaccess_button.x=leftAlign + 223
					denyaccess_button.y = display_details[#display_details-1].y+display_details[#display_details-1].contentHeight+60
					denyaccess_button:setStrokeColor(0,0,0,0.5)
					denyaccess_button:setFillColor(0,0,0,0.3)
					denyaccess_button.strokeWidth = 1
					denyaccess_button.cornerRadius = 2
					denyaccess_button.width = W-190
					denyaccess_button.id="Deny Access"
					--denyaccess_button:addEventListener("touch",onButtonTouch)
					sceneGroup:insert( denyaccess_button )

					denyaccess_button_text = display.newText(sceneGroup,"Deny",0,0,native.systemFont,16)
					denyaccess_button_text.x=denyaccess_button.x
					denyaccess_button_text.y=denyaccess_button.y
					denyaccess_button_text:setFillColor(0,0,0)
					sceneGroup:insert( denyaccess_button_text )

		end

-------------------------------------------------------------------------------------------------	





			
		end	
		
	MainGroup:insert(sceneGroup)

	end



	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			elseif phase == "did" then

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