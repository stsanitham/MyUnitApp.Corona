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

openPage="groupPage"

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

         elseif event.phase == "ended" then

         composer.removeHidden()

		    local options = {
						effect = "crossFade",
						time = 500,	
						params = { addGroupid = addGroupBtn.id }
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

			
	end

	return true

end




	local function onKeyEvent( event )

	        local phase = event.phase
	        local keyName = event.keyName

	        if phase == "up" then

	        if keyName=="back" then

	        	if BackFlag == false then

	        		Utils.SnackBar("Press again to exit")

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



		local function handleTabBarEvent( event )

			if event.phase == "press" then 

					tabbutton_id = event.target._id 

			    if tabbutton_id == "group" then

					title.text = "Group"

				elseif tabbutton_id == "broadcast_list" then

	 				print("tabButtons details : "..json.encode(tabButtons))

						chattabBar:setSelected( 1 ) 
						composer.removeHidden()
	   				    local options = {
										effect = "crossFade",
										time = 300,	
										params = { tabbuttonValue2 =json.encode(tabButtons)}
										}

					    composer.gotoScene( "Controller.MessagingPage", options )

				-- elseif tabbutton_id == "chat" then

				-- 	    print("tabButtons details : "..json.encode(tabButtons))

				-- 		chattabBar:setSelected( 2 ) 
				-- 		composer.removeHidden()
	   -- 				    local options = {
				-- 						effect = "crossFade",
				-- 						time = 300,	
				-- 						params = { tabbuttonValue2 =json.encode(tabButtons)}
				-- 						}

				-- 	    composer.gotoScene( "Controller.chatPage", options )

				elseif tabbutton_id == "consultant_list" then

				    	chattabBar:setSelected( 4 ) 
				    	composer.removeHidden()
	   				    local options = {
										effect = "crossFade",
										time = 300,	 
										params = { tabbuttonValue4 =json.encode(tabButtons)}
										}

					    composer.gotoScene( "Controller.consultantListPage", options )

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

		addGroupBtn:toFront( )

		background:addEventListener( "touch", groupBackground_Touch )


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
		title.text = "Group"

		-- addGroupBtn = display.newImageRect( sceneGroup, "res/assert/addevent.png", 66/2,66/2.2 )
		-- addGroupBtn.x=W-40
		-- addGroupBtn.y=tabBar.y+tabBar.contentHeight-4
		-- addGroupBtn.anchorX = 0
		-- addGroupBtn.isVisible = true
		-- addGroupBtn.id="addGroup"

		addGroupBtn = display.newImageRect( sceneGroup, "res/assert/addevent.png", 66/1.5,66/1.7 )
		addGroupBtn.x=W/2+W/3+15;addGroupBtn.y=H-80;addGroupBtn.id="addGroup"
		addGroupBtn.isVisible = true

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
		GroupSubject.placeholder = "Type group subject here..."
		sceneGroup:insert(GroupSubject)

		create_groupicon =  display.newImageRect(sceneGroup,"res/assert/tick.png",25,22)
		create_groupicon.anchorX=0
		create_groupicon.isVisible = false
		create_groupicon.x=GroupSubject.x+GroupSubject.contentWidth+15
		create_groupicon.y=subjectBar.y +20

		NoEvent = display.newText( sceneGroup,"No Group Found" , 0,0,0,0,native.systemFontBold,16)
		NoEvent.x=W/2;NoEvent.y=H/2
		NoEvent.isVisible=false
		NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )


		tabButtons = {
		{
		label = "Group",
		defaultFile = "res/assert/phone.png",
		overFile = "res/assert/phone.png",
		size = 11.5,
		labelYOffset = 2,
		id = "group",
		labelColor = { 
		default = { 0,0,0}, 
		over = { 0,0,0 }
		},
		width = 20,
		height = 20,
		onPress = handleTabBarEvent,
		},


		{
		label = "Chats",
		defaultFile = "res/assert/user.png",
		overFile = "res/assert/user.png",
		size = 11.5,
		labelYOffset = 2,
		id = "broadcast_list",
		labelColor = { 
		default = { 0,0,0}, 
		over = {0,0
		,0}
		        },
		        width = 20,
		        height = 20,
		        onPress = handleTabBarEvent,
		        selected = true,
		    },


		    {
		        label = "Consultant List",
		        defaultFile = "res/assert/map.png",
		        overFile = "res/assert/map.png",
		        size = 11.5,
		        labelYOffset = 2,
		        id = "consultant_list",
		        labelColor = { 
		            default = { 0,0,0}, 
		            over = { 0,0,0 }
		        },
		        width = 16,
		        height = 20,
		        onPress = handleTabBarEvent,
		    }
		}

				    chattabBar = widget.newTabBar{
				    top =  display.contentHeight - 55,
				    left = 0,
				    width = display.contentWidth, 
				    backgroundFile = tabBarBackground,
				    tabSelectedLeftFile = tabBarLeft,   
				    tabSelectedRightFile = tabBarRight,    
				    tabSelectedMiddleFile = tabBarMiddle,   
				    tabSelectedFrameWidth = 20,                                         
				    tabSelectedFrameHeight = 50, 
				    backgroundFrame = 1,
				    tabSelectedLeftFrame = 2,
				    tabSelectedMiddleFrame = 3,
				    tabSelectedRightFrame = 4,                                       
				    buttons = tabButtons,
				    height = 50,
				}

				sceneGroup:insert(chattabBar)


	            local rect = display.newRect(0,0,display.contentWidth,1.3)
				rect.x = 0;
				rect.anchorX=0
				rect.y = display.contentHeight - 50;
				rect:setFillColor(0)
				sceneGroup:insert( rect )


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



			 function getGroupListresponse(response )

				grouplist_response = response

							for i=1,#groupListresponse_array do
							groupListresponse_array[i]=nil
							byNameArray[i]=nil
							end

							groupListresponse_array=grouplist_response

							if grouplist_response ~= nil and #grouplist_response ~= 0 then
									
							--NameArray

							print("size = "..#groupListresponse_array)

								for i=1,#groupListresponse_array do

									grouplist_Name = groupListresponse_array[i].MyUnitBuzzGroupName
									grouplist_createdtime = groupListresponse_array[i].CreateTimeStamp
									
									local temp = {}

									if grouplist_Name:sub(1,1) == " " then
										grouplist_Name = grouplist_Name:sub( 2,grouplist_Name:len())
									end

									temp.MyUnitBuzzGroupName = grouplist_Name

									temp.CreateTimeStamp = grouplist_createdtime

									byNameArray[#byNameArray+1] = temp


								end

									GroupCreation_list(byNameArray)

							else

							NoEvent.isVisible=true

							end
				end

			Webservice.GetChatMessageGroupList(getGroupListresponse)


		elseif phase == "did" then

		         	composer.removeHidden()

			


			menuBtn:addEventListener("touch",menuTouch)
			BgText:addEventListener("touch",menuTouch)

			addGroupBtn:addEventListener("touch",addGroupAction)

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

			addGroupBtn:removeEventListener("touch",addGroupAction)

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