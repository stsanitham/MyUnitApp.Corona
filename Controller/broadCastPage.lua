----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local lfs = require ("lfs")
local mime = require("mime")
local style = require("res.value.style")
local Utility = require( "Utils.Utility" )
local newGroup = require( "Controller.newGroupAlert" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,tabButtons,chattabBar,NoEvent

openPage="MessagingPage"

local BackFlag = false

local networkArray = {}

local NameArray = {}

local groupList_scrollview

local careerListArray = {}

local RecentTab_Topvalue = 75

local header_value = ""

local Image

local byNameArray = {}

local groupListresponse_array = {}

local tabBarGroup = display.newGroup( )



local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"





	local function onTimer ( event )

		print( "event time completion" )

		BackFlag = false

	end


    local function addGroupAction(event)

	 	 if event.phase == "began" then
	 	 	print( "here" )
         elseif event.phase == "ended" then

         composer.removeHidden()

		    local options = {
						effect = "crossFade",
						time = 500,	
						params = { addGroupid = addGroupBtn.id, page_id = "broadcast"}
						}

	        composer.gotoScene( "Controller.consultantListPage", options )

         end

	    return true

    end




function makeTimeStamp( dateString )
   local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
   local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin = dateString:match(pattern)
   local timestamp = os.time(
      { year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false }
   )
   local offset = 0
   if ( tzoffset ) then
      if ( tzoffset == "+" or tzoffset == "-" ) then  -- We have a timezone
         offset = offsethour * 60 + offsetmin
         if ( tzoffset == "-" ) then
            offset = offset * -1
         end
         timestamp = timestamp + offset
      end
   end
   return timestamp
end




local function groupBackground_Touch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			groupList_scrollview:takeFocus( event )
		end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			 local options = {
								effect = "flipFadeOutIn",
								time = 200,	
								params = { tabbuttonValue2 =json.encode(tabButtons),contactDetails = event.target.value}
							 }

					    composer.gotoScene( "Controller.chatPage", options )

			
	end

	return true

end




	local function onKeyEvent( event )

	        local phase = event.phase
	        local keyName = event.keyName

	        if phase == "up" then

	        if keyName=="back" then

	        	if BackFlag == false then

	        		Utils.SnackBar(ChatPage.PressAgain)

	        		BackFlag = true

	        		timer.performWithDelay( 3000, onTimer )

	                return true

	            elseif BackFlag == true then

				 os.exit() 

	            end
	            
	        end

	    end

	        return false
	 end

local function CreateTabBarIcons( )

	if tab_Group_btn ~= nil then if tab_Group_btn.y then tab_Group_btn:removeSelf( );tab_Group_btn=nil end end
	if tab_Message_btn ~= nil then if tab_Message_btn.y then tab_Message_btn:removeSelf( );tab_Message_btn=nil end end
	if tab_Contact_btn ~= nil then if tab_Contact_btn.y then tab_Contact_btn:removeSelf( );tab_Contact_btn=nil end end


	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0



	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0



	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant.png", 35/1.4, 31/1.4 )
	tab_Contact_btn.x=tab_Contact.x
	tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
	tab_Contact_btn.anchorY=0


end


	local function TabbarTouch( event )

		if event.phase == "began" then 

		elseif event.phase == "ended" then
			
			if event.target.id == "message" then

				title.text = ChatPage.Chats
				print( "Messages" )

			    	CreateTabBarIcons()

			    	tab_Message_btn:removeSelf( );tab_Message_btn=nil

			    	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
					tab_Message_btn.x=tab_Message.x
					tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
					tab_Message_btn.anchorY=0
					tab_Message_btn:scale(0.1,0.1)

					tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Message_btn.x, tab_Message_btn.y+tab_Message_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Contact_txt:setFillColor(  0.3  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Message_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

					      local options = {
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.MessagingPage", options )
					end

					if overlay then overlay:removeSelf( );overlay=nil end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Message_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )


			elseif event.target.id == "group" then

				
			elseif event.target.id == "contact" then

			    	CreateTabBarIcons()

			    	tab_Contact_btn:removeSelf( );tab_Contact_btn=nil

			    	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant active.png", 35/1.4, 31/1.4 )
					tab_Contact_btn.x=tab_Contact.x
					tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
					tab_Contact_btn.anchorY=0
					tab_Contact_btn:scale(0.1,0.1)

					tab_Contact_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Contact_btn.x, tab_Contact_btn.y+tab_Contact_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  Utils.convertHexToRGB(color.tabBarColor)  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Contact_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Contact_btn.x

					      local options = {
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.consultantListPage", options )
					end

					if overlay then overlay:removeSelf( );overlay=nil end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Contact_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )

   				

			end

	    end

    return true 

	end

	------------------------------------------------------



local function GroupCreation_list( list )

	for j=#careerListArray, 1, -1 do 
		
		display.remove(careerListArray[#careerListArray])
		careerListArray[#careerListArray] = nil
	end

	for i=1,#list do
      print("here")

		careerListArray[#careerListArray+1] = display.newGroup()

		local tempGroup = careerListArray[#careerListArray]

		local tempHeight = 0

		local background = display.newRect(tempGroup,0,0,W,50)

		if(careerListArray[#careerListArray-1]) ~= nil then
			tempHeight = careerListArray[#careerListArray-1][1].y + careerListArray[#careerListArray-1][1].height+3
		end

		background.anchorY = 0
		background.x=W/2;background.y=tempHeight
		background.id=list[i].Contact_Id
		background.alpha=0.01
		background.value = list[i]
		print( "Listy : "..json.encode(list[i]) )

		local Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
		Image.x=30;Image.y=background.y+background.height/2

		local GroupName_txt = display.newText(tempGroup,list[i].MyUnitBuzzGroupName,0,0,native.systemFont,14)
		GroupName_txt.x=60;GroupName_txt.y=background.y+background.height/2-2
		GroupName_txt.anchorX=0
		Utils.CssforTextView(GroupName_txt,sp_labelName)
		GroupName_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

			local timecreated = list[i].CreateTimeStamp

			local time = makeTimeStamp(timecreated)
		   -- local timeValue = Utils.getTime(time,"%b %d, %Y %I:%M %p","")

			print( list[i].CreateTimeStamp,os.date("%b %d, %Y %I:%M %p",time) )											


		local GroupCreated_time = display.newText(tempGroup,os.date("%b %d, %Y %I:%M %p",time),0,0,native.systemFont,11)
		GroupCreated_time.x=background.x+background.contentWidth/2-123
		GroupCreated_time.y=background.y+background.height/2+15
		GroupCreated_time.anchorX=0
		Utils.CssforTextView(GroupCreated_time,sp_labelName)
		GroupCreated_time:setFillColor(0,0,0,0.6)


		-- local right_img = display.newImageRect(tempGroup,"res/assert/arrow_1.png",15/2,30/2)
		-- right_img.anchorX=0
		-- right_img.x=background.x+background.contentWidth/2-30;right_img.y=background.y+background.height/2


		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
	
		tempGroup.Contact_Id = list[i].Contact_Id

		groupList_scrollview:insert(tempGroup)



		background:addEventListener( "touch", groupBackground_Touch )


	end

		if IsOwner then
			
			addGroupBtn:toFront( )

		end
end




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

		title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=5;title.y = title_bg.y
		title:setFillColor(0)
		title.text = "Broadcast List"

		-- addGroupBtn = display.newImageRect( sceneGroup, "res/assert/addevent.png", 66/2,66/2.2 )
		-- addGroupBtn.x=W-40
		-- addGroupBtn.y=tabBar.y+tabBar.contentHeight-4
		-- addGroupBtn.anchorX = 0
		-- addGroupBtn.isVisible = true
		-- addGroupBtn.id="addGroup"


		subjectBar = display.newRect(sceneGroup,W/2,0,W,40)
		subjectBar.y=title_bg.y+15
		subjectBar.height = 40
		subjectBar.anchorY = 0
		subjectBar.isVisible = false
		subjectBar:setFillColor(0,0,0,0.1)

		GroupSubject =  native.newTextField( W/2+3, subjectBar.y + 20, W-60, 25)
		GroupSubject.id="groupSubject"
		GroupSubject.y = subjectBar.y +20
		GroupSubject.size=14
		GroupSubject.anchorX = 0
		GroupSubject.isVisible = false
		GroupSubject.x = 10
		GroupSubject:setReturnKey( "done" )
		GroupSubject.hasBackground = false	
		GroupSubject.placeholder = ChatPage.groupSubject
		sceneGroup:insert(GroupSubject)

		create_groupicon =  display.newImageRect(sceneGroup,"res/assert/tick.png",25,22)
		create_groupicon.anchorX=0
		create_groupicon.isVisible = false
		create_groupicon.x=GroupSubject.x+GroupSubject.contentWidth+15
		create_groupicon.y=subjectBar.y +20

		NoEvent = display.newText( sceneGroup, "No Broadcast List Found" , 0,0,0,0,native.systemFontBold,16)
		NoEvent.x=W/2;NoEvent.y=H/2
		NoEvent.isVisible=false
		NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )


	--Webservice.GetMyUnitBuzzRequestAccesses("GRANT",get_Activeteammember)


	MainGroup:insert(sceneGroup)

	end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

					groupList_scrollview = widget.newScrollView
				{
					top = RecentTab_Topvalue-5,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue-50+5,
					hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
					listener = grouplist_scrollListener,
				}

            sceneGroup:insert(groupList_scrollview)

            
		if IsOwner == true then

		addGroupBtn = display.newImageRect( sceneGroup, "res/assert/addevent.png", 66/1.5,66/1.7 )
		addGroupBtn.x=W/2+W/3+15;addGroupBtn.y=H-80;addGroupBtn.id="addGroup"
		addGroupBtn.isVisible = true
		addGroupBtn:addEventListener("touch",addGroupAction)
	    end


			 function getGroupListresponse(response )

				grouplist_response = response

						if grouplist_response ~= nil and #grouplist_response ~= 0 then
								
								NoEvent.text = ""

								GroupCreation_list(grouplist_response)

						else

								NoEvent.isVisible=true

						end
				end

			Webservice.GetChatMessageGroupList("BROADCAST",getGroupListresponse)

			--Tabbar---



tabBg = display.newRect( tabBarGroup, W/2, H-40, W, 40 )
tabBg.anchorY=0
tabBg.strokeWidth = 1
tabBg:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor),0.7 )

tab_Group = display.newRect(tabBarGroup,0,0,70,40)
tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
tab_Group.anchorY=0
tab_Group.alpha=0.01
tab_Group.id="group"
tab_Group:setFillColor( 0.2 )

tab_Message = display.newRect(tabBarGroup,0,0,70,40)
tab_Message.x=W/2;tab_Message.y=tabBg.y
tab_Message.anchorY=0
tab_Message.alpha=0.01
tab_Message.id="message"
tab_Message:setFillColor( 0.2 )

tab_Contact = display.newRect(tabBarGroup,0,0,70,40)
tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
tab_Contact.anchorY=0
tab_Contact.alpha=0.01
tab_Contact.id="contact"
tab_Contact:setFillColor( 0.2 )

tab_Group:addEventListener( "touch", TabbarTouch )
tab_Message:addEventListener( "touch", TabbarTouch )
tab_Contact:addEventListener( "touch", TabbarTouch )

CreateTabBarIcons()

	if tab_Group_btn then tab_Group_btn:removeSelf( );tab_Group_btn=nil end

	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group active.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0


tab_Group_txt = display.newText( tabBarGroup, "Broadcast List" ,0,0,native.systemFont,11 )
tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
tab_Group_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

if overlay then overlay:removeSelf( );overlay=nil end
overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
overlay.y=tabBg.y+6;overlay.x=tab_Group_btn.x

tab_Message_txt = display.newText( tabBarGroup, ChatPage.Chats ,0,0,native.systemFont,11 )
tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
tab_Message_txt:setFillColor( 0.3 )

tab_Contact_txt = display.newText( tabBarGroup, ChatPage.Consultant_List ,0,0,native.systemFont,11 )
tab_Contact_txt.x=tab_Contact_btn.x;tab_Contact_txt.y=tab_Contact_btn.y+tab_Contact_btn.contentHeight+5
tab_Contact_txt:setFillColor( 0.3 )

sceneGroup:insert( tabBarGroup )


		elseif phase == "did" then

		         	composer.removeHidden()

			


			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)


			

	   		Runtime:addEventListener( "key", onKeyEvent )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end



	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

		    composer.removeHidden()

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)
			Runtime:removeEventListener( "key", onKeyEvent )
			if IsOwner then
				addGroupBtn:removeEventListener("touch",addGroupAction)
			end

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



	--Webservice.AddTeamMemberToChatGroup(groupid,userid,postExecution)