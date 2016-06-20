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
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local tabBarGroup = display.newGroup( )

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,tabButtons,chattabBar,pagervalue

openPage="MessagingPage"

local BackFlag = false

local totalcareerlist

local newtworkArray = {}

local checkedstate = 0

local NameArray = {}

local consultantList_scrollview

local careerListArray = {}

local consultantList_array = {}

local RecentTab_Topvalue = 75

local header_value = ""

local Image

local editContacts = {}

local editId

local selected_Contact={}

local groupteammemberid = {}

local byNameArray = {}

local Listresponse_array = {}

local ContactId

consultantList_array[#consultantList_array+1] = display.newGroup()


local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"


--------------------------------------------------
	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		ContactId = row.ContactId
	end

-----------------Function-------------------------

local function consultantTounch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )


	elseif ( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )

		if ( dy > 10 ) then
			display.getCurrentStage():setFocus( nil )
			consultantList_scrollview:takeFocus( event )
		end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )


				if pageid_value == "group" then

					pagervalue = "group"

				else
					pagervalue = "broadcast"

			    end



				if addGroupid_value == "addGroup" then

					--selectcontact_checkbox.isOn = true

				elseif addGroupid_value == "editMember" then

			    else

 				    local options = {
						    effect = "flipFadeOutIn",
							time = 200,	
							params = { tabbuttonValue2 =json.encode(tabButtons),contactDetails = event.target.value}
							}


				    composer.gotoScene( "Controller.chatPage", options )

			    end
	      end

	return true

end




local function bgTouch( event )

	if event.phase == "began" then
		--display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		--display.getCurrentStage():setFocus( nil )

		print('bg touch')
	end

	return true

end




local function backactionTouch(event)

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )


		  if addGroupid_value ~= "editMember" then

		  		if pageid_value == "group" then

		    local options = {
				effect = "slideRight",
				time = 300,	
				}

		    composer.gotoScene( "Controller.groupPage", options )

     	elseif pageid_value == "broadcast" then

		    local options = {
				effect = "slideRight",
				time = 300,	
				}

		     composer.gotoScene( "Controller.broadCastPage", options )

	    end

	else

		composer.hideOverlay( )
	end

		native.setKeyboardFocus(nil)

	end

end




local function onTimer ( event )

	BackFlag = false

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
	if tab_broadcast_btn ~= nil then if tab_broadcast_btn.y then tab_broadcast_btn:removeSelf( );tab_broadcast_btn=nil end end


	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0



	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0

    if IsOwner == true then

		tab_broadcast_btn = display.newImageRect( tabBarGroup, "res/assert/resource.png", 35/1.4, 31/1.4 )
		tab_broadcast_btn.x=tab_Boradcast.x
		tab_broadcast_btn.y=tab_Boradcast.y+tab_broadcast_btn.contentHeight/2-8
		tab_broadcast_btn.anchorY=0
		tab_broadcast_btn:setFillColor( 0 )

    end


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
			elseif event.target.id == "broadcast" then


				CreateTabBarIcons()


					tab_broadcast_btn:removeSelf( );tab_broadcast_btn=nil

					tab_broadcast_btn = display.newImageRect( tabBarGroup, "res/assert/resource.png", 35/1.4, 31/1.4 )
					tab_broadcast_btn.x=tab_Boradcast.x
					tab_broadcast_btn.y=tab_Boradcast.y+tab_broadcast_btn.contentHeight/2-8
					tab_broadcast_btn.anchorY=0
					tab_broadcast_btn:scale(0.1,0.1)
					tab_broadcast_btn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Broadcast_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  0.3  )
					tab_Group_txt:setFillColor(  0.3  )

					local circle = display.newCircle( tabBarGroup, tab_broadcast_btn.x, tab_broadcast_btn.y+tab_broadcast_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_broadcast_btn:scale(0.8,0.8)

					    overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_broadcast_btn.x

					        local options = {
									time = 300,	  
									params = { tabbuttonValue3 =event.target.id}
									}

				   composer.gotoScene( "Controller.broadCastPage", options )
					end

					if overlay then overlay:removeSelf( );overlay=nil end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_broadcast_btn, { time=220, delay=100, xScale=1.3,yScale=1.3 , onComplete=listener1} )

   				


			elseif event.target.id == "group" then

				CreateTabBarIcons()


					tab_Group_btn:removeSelf( );tab_Group_btn=nil

					tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group active.png", 35/1.4, 31/1.4 )
					tab_Group_btn.x=tab_Group.x
					tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
					tab_Group_btn.anchorY=0
					tab_Group_btn:scale(0.1,0.1)

					tab_Group_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  0.3  )

					local circle = display.newCircle( tabBarGroup, tab_Group_btn.x, tab_Group_btn.y+tab_Group_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Group_btn:scale(0.8,0.8)

					    overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Group_btn.x

					        local options = {
									time = 300,	  
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.groupPage", options )
					end

					if overlay then overlay:removeSelf( );overlay=nil end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Group_btn, { time=220, delay=100, xScale=1.3,yScale=1.3 , onComplete=listener1} )

   				



			elseif event.target.id == "contact" then


			end

	    end

    return true 

end




	local function onSwitchPress( event )

		local switch = event.target

		    if tostring(switch.isOn) == "true" then

				local contactid = switch.value

				checkedstate = checkedstate + 1


			elseif tostring(switch.isOn) == "false" then

			 	checkedstate = checkedstate - 1

		    end


				  --  if addGroupid_value == "addGroup" and pageid_value == "broadcast"  then

					    if checkedstate > 0 then

					   		 count_details.isVisible = true

					  		  count_details.text = checkedstate.." selected"


				      		-- totalcareerlist = switch.totalvalue - 1

				        --     print("test @@@@@@@@@@@@@@@@@@@@@@@ : "..checkedstate.."/"..totalcareerlist)

				        --     count_details.x = W-55

				        --     count_details.text = checkedstate.."/"..totalcareerlist

					    else

				  		    count_details.isVisible = false

					    end

					--end

	end





	local function SetError( displaystring, object )

		object.text=displaystring
		object.size=10
		object:setTextColor(1,0,0)

	end





	local function onGroupCreationComplete( event )
		   if event.action == "clicked" then
		        local i = event.index
		        if i == 1 then  
		      --[[

        addGroupid_value
		editMember
		editId]]  		

		

		    if addGroupid_value ~= "editMember" then

								if grouptypevalue == "GROUP" then

			 				        local options = {
										effect = "slideRight",
										time = 300,	
										params = { pagevalue = grouptypevalue}
										}

					        		composer.gotoScene("Controller.groupPage",options)

					            elseif grouptypevalue == "BROADCAST" then


			 				        local options = {
										effect = "slideRight",
										time = 300,	
										params = { pagevalue = grouptypevalue}
										}

					            	composer.gotoScene("Controller.broadCastPage",options)

					        	end

					        else

					        	composer.hideOverlay()


					        end

		        end

		    end
    end



	local function onComplete( event )
		   if event.action == "clicked" then
		        local i = event.index
		        if i == 1 then  

		        end

		    end
    end


		    function getAddedMembersInGroup(response)

			    	if response == "Success" then

						    		if addGroupid_value ~= "editMember" then

									    		if grouptypevalue == "GROUP" then

								    				local alert = native.showAlert( ChatPage.GroupCreated ,ChatPage.GroupCreationSuccess, { CommonWords.ok }, onGroupCreationComplete )

									    	    else

									    	    	local alert = native.showAlert( ChatPage.BroadcastListCreated ,ChatPage.BroadcastListCreationSuccess, { CommonWords.ok }, onGroupCreationComplete )

									    	    end

									 elseif addGroupid_value == "editMember" then



									 			if grouptypevalue == "GROUP" then

								    				local alert = native.showAlert( "Group Updated" ,"Group updated successfully", { CommonWords.ok }, onGroupCreationComplete )

									    	    else

									    	    	local alert = native.showAlert( "Broadcast List Updated" ,"Broadcast List updated successfully", { CommonWords.ok }, onGroupCreationComplete )

									    	    end


									 end

			    	end

		    end





	 function getChatGroupCreation(response )

		groupcreation_response = response


		GroupSubject.text = ""

		groupSubjectname = ""

		groupid_value = groupcreation_response.MyUnitBuzzGroupId

		grouptypevalue = groupcreation_response.MyUnitBuzzGroupType

		local groupId = 0

		if addGroupid_value == "editMember" then

			groupId = editId

		else

			groupId = groupid_value
		end


			if grouptypevalue == "BROADCAST" then

				 Webservice.AddTeamMemberToChatGroup(grouptypevalue,groupId,selected_Contact,getAddedMembersInGroup)

			elseif grouptypevalue == "GROUP" then

				 Webservice.AddTeamMemberToChatGroup(grouptypevalue,groupId,selected_Contact,getAddedMembersInGroup)

		    end


	 end 







	function textField( event )

		if ( event.phase == "began" ) then

				event.target:setTextColor(color.black)

				current_textField = nil

				current_textField = event.target;	

				current_textField.size=14

				groupSubjectname = ""

				if "*" == event.target.text:sub(1,1) then
					event.target.text=""
					current_textField.text = ""
				end
				
		elseif ( event.phase == "submitted" ) then

			native.setKeyboardFocus(nil)

		elseif event.phase == "ended" then

			native.setKeyboardFocus(nil)

		elseif ( event.phase == "editing" ) then

				 if (current_textField.id == "groupSubject") then


				 	if event.target.text:len() > 25 then

						event.target.text = event.target.text:sub(1,25)

						native.setKeyboardFocus(nil)

					end

						groupSubjectname = event.target.text

						--print("group subject name ############################ : ",groupSubjectname)
				end
		 end
    end








	local function createGroup(event)

		if event.phase == "began" then
			
			native.setKeyboardFocus(nil)

		elseif event.phase == "ended" then

					print( "**************** here *****************" )

		      local validation = true

              native.setKeyboardFocus(nil)


                if pageid_value == "group" then

				     if GroupSubject.text == "" or GroupSubject.text == GroupSubject.placeholder or GroupSubject.text == ChatDetails.GroupSubjectError or GroupSubject.text == GroupSubject.id then
			            
			             validation=false

				     	 SetError(ChatDetails.GroupSubjectError,GroupSubject)

				     elseif GroupSubject.text ~= "" or GroupSubject.text  ~= GroupSubject.placeholder or GroupSubject.text  ~= ChatDetails.GroupSubjectError or GroupSubject.text  ~= GroupSubject.id then

				      	 GroupSubject.text = groupSubjectname

				     end

				end



                if pageid_value == "broadcast" then

				      if GroupSubject.text == "" or GroupSubject.text == GroupSubject.placeholder or GroupSubject.text == GroupSubject.id then

			             GroupSubject.text = ""

				      elseif GroupSubject.text ~= "" or GroupSubject.text  ~= GroupSubject.placeholder or GroupSubject.text  ~= ChatDetails.GroupSubjectError or GroupSubject.text  ~= GroupSubject.id then

				      	 GroupSubject.text = groupSubjectname

				      end

			    end

--------------------------------------------------------------------------------------
                 

			    if(validation == true) then

				      	GroupSubject.text = groupSubjectname

					      	for i=1,#selected_Contact do

					      		selected_Contact[i]=nil

					      	end

				      	 
					      	for i=1,#careerListArray do


					      		local tempGroup = careerListArray[i]

						      		for j=1,tempGroup.numChildren do

						      			if tempGroup[j].id == "email_Checkbox" then

							      			if tostring(tempGroup[j].isOn) == "true" then

							      				selected_Contact[#selected_Contact+1] = tempGroup[j].value

							      				--print(selected_Contact[#selected_Contact+1])

							      			end

							      		end

							      	end

					       	end




					      	 if pageid_value:lower() == "group" then

					      	 	 if #selected_Contact>0 then


						      	 	 	     if addGroupid_value ~= "editMember" then

						      	 	 	     		groupteammemberids = 0

						      	 	 	     else

						      	 	 	     		groupteammemberids = selected_Contact
						      	 	 	     end




					      	 	 	if addGroupid_value ~= "editMember" then

					      	 	     	Webservice.CreateMessageChatGroup(GroupSubject.text,"","true","GROUP",0,getChatGroupCreation)

					      	 	    else

					      	 	    	grouptypevalue = pageid_value:upper()

					      	 	    	Webservice.CreateMessageChatGroup(GroupSubject.text,"","true",grouptypevalue,editId,getChatGroupCreation)
					      	 	    	
				 						--Webservice.AddTeamMemberToChatGroup(pageid_value:upper(),editId,selected_Contact,getAddedMembersInGroup)


					      	 	    end
				                 
				                 else

				                      local alert = native.showAlert( ChatPage.addTeamMember, ChatPage.addLimit, { CommonWords.ok }, onComplete )

				                 end

			                 end




			                  if pageid_value:lower() == "broadcast" then

				                  	if #selected_Contact>0 then


						                  		 if addGroupid_value ~= "editMember" then

							      	 	 	     			groupteammemberids = 0

							      	 	 	     else

							      	 	 	     			groupteammemberids = selected_Contact
							      	 	 	     end



					                  		if GroupSubject.text == "" or GroupSubject.text == GroupSubject.placeholder or GroupSubject.text == GroupSubject.id then

						                  		 --GroupSubject.text = #selected_Contact.." recipients"
						                  		 if addGroupid_value ~= "editMember" then

								      	 	   		Webservice.CreateMessageChatGroup(#selected_Contact.." "..ChatPage.BroadcastRecipients,"","true","BROADCAST",0,getChatGroupCreation)

								      	 	   	 else

								      	 	    	grouptypevalue = pageid_value:upper()

								      	 	    	Webservice.CreateMessageChatGroup(#selected_Contact.." "..ChatPage.BroadcastRecipients,"","true",grouptypevalue,editId,getChatGroupCreation)


							 					--	Webservice.AddTeamMemberToChatGroup(pageid_value:upper(),editId,selected_Contact,getAddedMembersInGroup)

								      	 	    end


							      	 	    else


								      	 	      if addGroupid_value ~= "editMember" then

								      	 	   		Webservice.CreateMessageChatGroup(GroupSubject.text,"","true","BROADCAST",0,getChatGroupCreation)

								      	 	   	 else

								      	 	    	grouptypevalue = pageid_value:upper()

								      	 	    	Webservice.CreateMessageChatGroup(GroupSubject.text,"","true",grouptypevalue,editId,getChatGroupCreation)


							 					--	Webservice.AddTeamMemberToChatGroup(pageid_value:upper(),editId,selected_Contact,getAddedMembersInGroup)

								      	 	    end


							      	 	    end
				                 
					                else

					                       local alert = native.showAlert( ChatPage.addTeamMember , ChatPage.addBroadcastLimit , { CommonWords.ok }, onComplete )

					                end

				              end



			    end
---------------------------------------------------------------------------------------

		 end

	end

	


local function careePath_list( list )


	for j=#careerListArray, 1, -1 do 
		
		display.remove(careerListArray[#careerListArray])
		careerListArray[#careerListArray] = nil
	end

	for i=1,#list do
      

      if tostring(list[i].Contact_Id) ~= tostring(ContactId) then

		careerListArray[#careerListArray+1] = display.newGroup()

		local tempGroup = careerListArray[#careerListArray]

		local Image 

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

		if parentFlag == true then
			parentFlag=false


			parentTitle = display.newRect(tempGroup,0,0,W,25)
			if(careerListArray[#careerListArray-1]) ~= nil then
				--here
				tempHeight = careerListArray[#careerListArray-1][1].y + careerListArray[#careerListArray-1][1].height/2+10
			end


			parentTitle.anchorY = 0
			parentTitle.x=W/2;parentTitle.y=tempHeight+parentTitle.contentHeight/2
			parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))		

			if viewValue == "position" then
				parent_centerText = display.newText(tempGroup,header_value,0,0,native.systemFontBold,14)
			else
				parent_centerText = display.newText(tempGroup,header_value:upper(),0,0,native.systemFontBold,14)

			end

			parent_centerText.x=5
			parent_centerText.anchorX=0
			parent_centerText.y=parentTitle.y+parentTitle.contentHeight/2

			background.y=parentTitle.y+background.contentHeight/2

		end

		

		if list[i].Image_Path ~= nil then
			local Image
			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

			newtworkArray[#newtworkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..list[i].Image_Path,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else

                        if Image ~= nil then

							if Image.y ~= nil then Image:removeSelf() 

							--print(img_event.response.filename)

							Image = display.newImage(tempGroup,img_event.response.filename,system.TemporaryDirectory)
							Image.width=45;Image.height=38
							Image.x=30;Image.y=background.y+background.contentHeight/2
	    				    --event.row:insert(img_event.target)

    				        local mask = graphics.newMask( "res/assert/masknew.png" )

							Image:setMask( mask )

					     end

					     end

    			   
    			    end

    			end, list[i].Contact_Id..".png", system.TemporaryDirectory)
		else
			Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
			Image.x=30;Image.y=background.y+background.height/2

		end

		


		local Name_txt = display.newText(tempGroup,list[i].Name,0,0,native.systemFont,14)
		Name_txt.x=60;Name_txt.y=background.y+background.height/2-10
		Name_txt.anchorX=0
		Utils.CssforTextView(Name_txt,sp_labelName)
		Name_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

		local Position_txt = display.newText(tempGroup,list[i].CarrierProgress,0,0,native.systemFont,14)
		Position_txt.x=60;Position_txt.y=background.y+background.height/2+10
		Position_txt.anchorX=0
		Utils.CssforTextView(Position_txt,sp_fieldValue)

		if Position_txt.text:len() > 26 then		
			Position_txt.text = string.sub(Position_txt.text,1,26).."..."
		end


		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))

		if addGroupid_value =="addGroup" or addGroupid_value == "editMember" then

		contactidvalue =  list[i].Contact_Id




		local selectcontact_checkbox = widget.newSwitch(
		{
		left = 15,
		top = Position_txt.y-5,
		style = "checkbox",
		id = "email_Checkbox",
		initialSwitchState = false,
		onPress = onSwitchPress
		})
		selectcontact_checkbox.width= 20
		selectcontact_checkbox.height = 20
		selectcontact_checkbox.anchorX=0
		selectcontact_checkbox.totalvalue = #list
		selectcontact_checkbox.key="checkbox"
		selectcontact_checkbox.value = contactidvalue
		selectcontact_checkbox.x = background.x+background.contentWidth/2-33
		selectcontact_checkbox.y=background.y+background.height/2

		tempGroup:insert(selectcontact_checkbox)


		subjectBar.isVisible = true
		GroupSubject.isVisible = true
		create_groupicon.isVisible = true
		backbutton.isVisible = true
		if addGroupid_value == "editMember" then
			for j=1,#editContacts do

				if tonumber(contactidvalue) == tonumber(editContacts[j]) then
					selectcontact_checkbox:setState( { isOn=true, isAnimated=true, onComplete=onSwitchPress } )

				end

			end
		end


		else

	    end



		--tempGroup.Contact_Id = list[i].Contact_Id

		consultantList_scrollview:insert(tempGroup)

		background:addEventListener( "touch", consultantTounch )


	end

end

end






function get_Activeteammember(response)


	for i=1,#Listresponse_array do
		Listresponse_array[i]=nil
		byNameArray[i]=nil
	end

	Listresponse_array=response

	if response ~= nil and #response ~= 0 then
				
--NameArray


						for i=1,#Listresponse_array do

							local list_Name = Listresponse_array[i].Last_Name

							

								if Listresponse_array[i].First_Name then

									list_Name = Listresponse_array[i].First_Name.." "..Listresponse_array[i].Last_Name

								end

							

							local temp = {}

							if list_Name:sub(1,1) == " " then
								list_Name = list_Name:sub( 2,list_Name:len())
							end

							temp.Name = list_Name
							temp.CarrierProgress = Listresponse_array[i].Email_Address
							temp.Contact_Id = Listresponse_array[i].Contact_Id
							temp.Image_Path = Listresponse_array[i].Image_Path
							temp.Image_Name = Listresponse_array[i].Image_Name

							byNameArray[#byNameArray+1] = temp


						end

								careePath_list(byNameArray)

	else

		NoEvent.isVisible=true

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

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	title.text = ChatPage.Consultant_List

	count_details = display.newText(sceneGroup,"",0,0,native.systemFont,18)
	count_details.anchorX = 0
	count_details.isVisible = false
	count_details.x= W-105;count_details.y = title_bg.y
	count_details:setFillColor(0)


	subjectBar = display.newRect(sceneGroup,W/2,0,W,40)
	subjectBar.y=title_bg.y+15
	subjectBar.height = 40
	subjectBar.anchorY = 0
	subjectBar.isVisible = false
	subjectBar:setFillColor(0,0,0,0.1)

	backbutton = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
	backbutton.x=15
	backbutton:setFillColor(0,0,0)
	backbutton.isVisible = false
	backbutton.y=subjectBar.y +12
	backbutton.anchorY=0


	GroupSubject =  native.newTextField( W/2+3, subjectBar.y + 20, W-80, 25)
	GroupSubject.id="groupSubject"
	GroupSubject.y = subjectBar.y +20
	GroupSubject.size=14
	GroupSubject.anchorX = 0
	GroupSubject.isVisible = false
	GroupSubject.x = backbutton.x + backbutton.contentWidth +10
	GroupSubject:setReturnKey( "done" )
	GroupSubject.hasBackground = false	
	GroupSubject.placeholder = ChatPage.groupSubject
	sceneGroup:insert(GroupSubject)

	create_groupicon =  display.newImageRect(sceneGroup,"res/assert/tick.png",25,22)
	create_groupicon.anchorX=0
	create_groupicon.isVisible = false
	create_groupicon.x=GroupSubject.x+GroupSubject.contentWidth+15
	create_groupicon.y=subjectBar.y +20

	Webservice.GetActiveChatTeammembersList("GRANT",get_Activeteammember)


MainGroup:insert(sceneGroup)

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		if event.params then

			addGroupid_value = event.params.addGroupid

			pageid_value = event.params.page_id

			editContacts = event.params.contacts
		end


if addGroupid_value ~= "editMember" then

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
if IsOwner == true then
tab_Message.x=W/2-W/8
else
tab_Message.x = W/2
end
tab_Message.y=tabBg.y
tab_Message.anchorY=0
tab_Message.alpha=0.01
tab_Message.id="message"
tab_Message:setFillColor( 0.2 )

if IsOwner == true then
tab_Boradcast = display.newRect(tabBarGroup,0,0,70,40)
tab_Boradcast.x=W/2+W/10;tab_Boradcast.y=tabBg.y
tab_Boradcast.anchorY=0
tab_Boradcast.alpha=0.01
tab_Boradcast.id="broadcast"
tab_Boradcast:setFillColor( 0.2 )

tab_Boradcast:addEventListener( "touch", TabbarTouch )
end

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

	if tab_Contact_btn then tab_Contact_btn:removeSelf( );tab_Contact_btn=nil end

	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant active.png", 35/1.4, 31/1.4 )
	tab_Contact_btn.x=tab_Contact.x
	tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
	tab_Contact_btn.anchorY=0

	

tab_Group_txt = display.newText( tabBarGroup, ChatPage.Group ,0,0,native.systemFont,11 )
tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
tab_Group_txt:setFillColor( 0.3 )

if IsOwner == true then
tab_Broadcast_txt = display.newText( tabBarGroup,ChatPage.Broadcast,0,0,native.systemFont,11 )
tab_Broadcast_txt.x=tab_broadcast_btn.x;tab_Broadcast_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
tab_Broadcast_txt:setFillColor( 0.3 )
end


tab_Message_txt = display.newText( tabBarGroup,ChatPage.Chats ,0,0,native.systemFont,11 )
tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
tab_Message_txt:setFillColor( 0.3 )

tab_Contact_txt = display.newText( tabBarGroup, ChatPage.Consultant_List  ,0,0,native.systemFont,11 )
tab_Contact_txt.x=tab_Contact_btn.x;tab_Contact_txt.y=tab_Contact_btn.y+tab_Contact_btn.contentHeight+5
tab_Contact_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
if overlay then overlay:removeSelf( );overlay=nil end
overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
overlay.y=tabBg.y+6;overlay.x=tab_Contact_btn.x

sceneGroup:insert( tabBarGroup )

end


	    if addGroupid_value == "addGroup" and pageid_value == "group" then

		    	RecentTab_Topvalue = 115

				--GroupSubject.isVisible = false

	    elseif addGroupid_value == "addGroup" and pageid_value == "broadcast" then

		    	RecentTab_Topvalue = 115

		    	title.text = ChatPage.Broadcast

		    	GroupSubject.placeholder = ChatPage.broadcastSubject

		    	count_details.isVisible = true

	    	    --GroupSubject.isVisible = false

	    	    --Webservice.GetActiveChatTeammembersList("GRANT",get_Activeteammember)

	   	elseif addGroupid_value == "editMember" and (pageid_value:lower() == "group" or pageid_value:lower() == "broadcast") then

	   			RecentTab_Topvalue = 115

		    	title.text = "Edit Member"

		    	GroupSubject.placeholder = ChatPage.broadcastSubject

		    	count_details.isVisible = true

		    	GroupSubject.text =  event.params.name

		    	editId = event.params.contactId

		    	count_details.text = #editContacts.." Selected"



	    else

	    	RecentTab_Topvalue = 75

	    end



		consultantList_scrollview = widget.newScrollView
		{
			top = RecentTab_Topvalue-5,
			left = 0,
			width = W,
			height =H-RecentTab_Topvalue-45,
			hideBackground = true,
            backgroundColor = {0,0,0,0.6},
			isBounceEnabled=false,
			horizontalScrollingDisabled = true,
			verticalScrollingDisabled = false
		}

        sceneGroup:insert(consultantList_scrollview)
		



	elseif phase == "did" then

		Background:addEventListener( "touch", bgTouch )
		menuBtn:addEventListener("touch",menuTouch)
		BgText:addEventListener("touch",menuTouch)
		backbutton:addEventListener("touch",backactionTouch)
		GroupSubject:addEventListener("userInput",textField)
	   

		create_groupicon:addEventListener("touch",createGroup)

   		Runtime:addEventListener( "key", onKeyEvent )
		
	end	
	
MainGroup:insert(sceneGroup)

end


	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			network.cancel( newtworkArray[#newtworkArray] )

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)
			Runtime:removeEventListener( "key", onKeyEvent )
			backbutton:removeEventListener("touch",backactionTouch)

			GroupSubject:removeEventListener("userInput",textField)
		  
			create_groupicon:removeEventListener("touch",createGroup)


		
		elseif phase == "did" then

				if addGroupid_value == "editMember" then

					print("editId"..editId)

					 event.parent:resumeEditGame(editId)

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


		return scene