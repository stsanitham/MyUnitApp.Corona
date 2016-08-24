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

require( "Controller.genericAlert" )

local Utility = require( "Utils.Utility" )

local Details={}

local listValue = {}

local searchArray = {}

local searchArraytotal= {}

local ContactListResponse = {}

local testresponse ={}

local totArray = {}

local scrollView

local page_count = 0

local totalPageContent = 10

local searchGroup = display.newGroup( )

local TotalCount = 0



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,title

local menuBtn

openPage="inviteAndaccessPage"

--local RecentTab_Topvalue = 100

--local RecentTab_Topvalue = 72

local RecentTab_Topvalue = 100

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

	 AlertText.text = CommonWords.Block
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
        				inviteDetails =  Details,checkstatus = Status_Name,searchbg = searchflag,searchtext = search.text,searchbgval = searchtext_bg,searchview = search,
        			}
        		}

        		--if search then search:removeSelf(); search = nil end

        		native.setKeyboardFocus(nil)

        		composer.showOverlay( "Controller.inviteAccessDetailPage", options )



        			if searchflag == "false" then

	        			print("false")

	        			searchtext_bg.isVisible = false
	        			search.isVisible = false

	        		else

	        		   searchtext_bg.isVisible = false
	        		   search.isVisible=false

	        	    end



        	end



        end


        print( event.target.id )
    end

    return true
end






local function searchTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

    elseif event.phase == "ended" then

      		display.getCurrentStage():setFocus( nil )

			        if event.target.id == "searchbg" then

			        	print("RTERTERTERt")

				        	if searchtext_bg.isVisible == false and search.isVisible == false then

				        		print("&&&&&&&& true")

				        		native.setKeyboardFocus(search)

				        		searchtext_bg.isVisible = true

				        		search.isVisible = true

				        		scrollView.y = 130

				        		searchflag = "true"


				        			if page_count ~= 1 then

										scrollView:scrollToPosition
										{
											y = 0,
											time = 200,
										}

									end


					        else

					        	print("&&&&&&&& false")

					        	searchtext_bg.isVisible = false

					        	native.setKeyboardFocus(nil)

				        		search.isVisible = false

				        		scrollView.y = 100

				        		searchflag = "false"

				        	
				        			if page_count ~= 1 then

										scrollView:scrollToPosition
										{
											y = 0,
											time = 200,
										}

									end


					        end

			        end
     
    end


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






	local function CreateList(list)


		if page_count == 1 then

			for j=#groupArray, 1, -1 do 
				display.remove(groupArray[#groupArray])
				groupArray[#groupArray] = nil
			end

			scrollView:scrollToPosition
			{
				y = 0,
				time = 200,
			}

		end



        if page_count ~= 1 and scrollView.y ~=0 and search.text:len() > 1 then

				print("_________create not 111")

					for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
					end

				scrollView:scrollToPosition
				{
					y = 0,
					time = 200,
				}

	    end






        local feedArray = list


		for i=1,#feedArray do

				
			groupArray[#groupArray+1] = display.newGroup()

			local Display_Group = {}

			local tempGroup = groupArray[#groupArray]

			local bgheight = 65

			local Image 


			
			local background = display.newRect(tempGroup,0,0,W,55)

			local Initial_Height = 0

			if(groupArray[#groupArray-1]) ~= nil then
				Initial_Height = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].height-2
			end

			background.anchorY = 0
			background.anchorX = 0
			background.x=5;background.y=Initial_Height+15
			background.alpha=0.01
			background.value = feedArray[i]
			background.id="listBg"
			background.name = status
			background:addEventListener( "touch", ActionTouch )



		

		if feedArray[i].ImagePath ~= nil then

				--  Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
				-- --Image.anchorY=0
				-- Image.x=30;Image.y=background.y+background.contentHeight/2


				local filePath = system.pathForFile( feedArray[i].MyUnitBuzzRequestAccessId..".png", system.DocumentsDirectory )
								            -- Play back the recording
				local file = io.open( filePath)
								            
						if file then

								 io.close( file )

											  Image = display.newImageRect(tempGroup,feedArray[i].MyUnitBuzzRequestAccessId..".png", system.DocumentsDirectory,35,35)
								--Image.anchorY=0
								Image.x=30;Image.y=background.y+background.contentHeight/2 
							
							print( "here" )

						else

							print( "not here" )

								networkArray[#networkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..feedArray[i].ImagePath,
								"GET",
								
								function ( img_event)

									if ( img_event.isError ) then
										print ( "Network error - download failed" )
									else

									

										--	if Image ~= nil then Image:removeSelf();Image=nil end

											--img_event.response.filename

											local filePath = system.pathForFile( img_event.response.filename, system.DocumentsDirectory )
												            -- Play back the recording
												local file = io.open( filePath)
												            
												if file and img_event.response.filename ~= nil then

												 io.close( file )



												 Image = display.newImage(tempGroup,img_event.response.filename,system.DocumentsDirectory)


												else

													Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)

												end
											
											Image.width=35;Image.height=35
											--Image.anchorY=0
											Image.x=30;Image.y=background.y+background.contentHeight/2 
											
								    		--event.row:insert(img_event.target)

								    			
								    		end

								    		end, feedArray[i].MyUnitBuzzRequestAccessId..".png", system.DocumentsDirectory)

						end
		else

					 Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
					--Image.anchorY=0
					Image.x=30;Image.y=background.y+background.contentHeight/2
					

		end





          --  local nameLabel = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)

          Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
          Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
          Display_Group[#Display_Group].x=background.x+55;Display_Group[#Display_Group].y=background.y-2
          Display_Group[#Display_Group]:setFillColor(Utils.convertHexToRGB(color.primaryColor))



          if feedArray[i].FirstName ~= nil then

          	Display_Group[#Display_Group].text = feedArray[i].FirstName.." "..feedArray[i].LastName

          else

          	Display_Group[#Display_Group].text = feedArray[i].LastName
          	
          end



          if feedArray[i].EmailAddress ~= nil then

          	Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
          	Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
          	Display_Group[#Display_Group].x=background.x+55;Display_Group[#Display_Group].y=Display_Group[#Display_Group-1].y+Display_Group[#Display_Group-1].contentHeight+5
          	Display_Group[#Display_Group]:setFillColor( 0.3 )
          	Display_Group[#Display_Group].text = feedArray[i].EmailAddress


          	if feedArray[i].EmailAddress:len() > 33 then

          		Display_Group[#Display_Group].text = Display_Group[#Display_Group].text:sub(1,33)..".."

          	end
          	

          end




          if feedArray[i].PhoneNumber ~= nil and feedArray[i].PhoneNumber ~= "" then

          	Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
          	Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
          	Display_Group[#Display_Group].x=background.x+55;Display_Group[#Display_Group].y=Display_Group[#Display_Group-1].y+Display_Group[#Display_Group-1].contentHeight+5
          	Display_Group[#Display_Group]:setFillColor( 0.3 )
          	Display_Group[#Display_Group].text = feedArray[i].PhoneNumber

          	background.height = background.height+15

          end



		-- 	--background.height = 0

		-- 	for i=1,#Display_Group do

		-- 		background.height = background.height + Display_Group[i].contentHeight+10

		-- 	end

		-- --	background.height = background.height + 20

		-- 	--background.height = background.height-((background.height/5)*(5-#Display_Group))+5


		

		-- 	 --  group =  Createmenu(background)

  --  				--tempGroup:insert( group )

  --  				--group.isVisible=false


	  local line = display.newRect(tempGroup,W/2,background.y,W,1)
	  line.y=background.y+background.contentHeight-line.contentHeight
	  line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


	  scrollView:insert(tempGroup)

	  print( "@@@@@@@@@" )


end

end





local function CreateListUpdate( val,list)
       
       if val == "update" then

	       	  	 if page_count ~= 1 or page_count == 1 then

		         	for j=#groupArray, 1, -1 do 
						display.remove(groupArray[#groupArray])
						groupArray[#groupArray] = nil
					end

			  	 end


		        if scrollView.y ~=0 and page_count == 1 or page_count ~= 1 then

		        	print("scrollllll")

						scrollView:scrollToPosition
						{
							y = 0,
							time = 200,
						}

			    end
       
        end


        local feedArray = list


		for i=1,#feedArray do

				
			groupArray[#groupArray+1] = display.newGroup()

			local Display_Group = {}

			local tempGroup = groupArray[#groupArray]

			local bgheight = 65

			local Image 


			
			local background = display.newRect(tempGroup,0,0,W,55)

			local Initial_Height = 0

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



		

		if feedArray[i].ImagePath ~= nil then

				--  Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
				-- --Image.anchorY=0
				-- Image.x=30;Image.y=background.y+background.contentHeight/2


				local filePath = system.pathForFile( feedArray[i].MyUnitBuzzRequestAccessId..".png", system.DocumentsDirectory )
								            -- Play back the recording
				local file = io.open( filePath)
								            
						if file then

								 io.close( file )

											  Image = display.newImageRect(tempGroup,feedArray[i].MyUnitBuzzRequestAccessId..".png", system.DocumentsDirectory,35,35)
								--Image.anchorY=0
								Image.x=30;Image.y=background.y+background.contentHeight/2
							
							print( "here 1111" )

						else

							print( "not here 12" )

								networkArray[#networkArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..feedArray[i].ImagePath,
								"GET",
								
								function ( img_event)

									if ( img_event.isError ) then
										print ( "Network error - download failed" )
									else

									

										--	if Image ~= nil then Image:removeSelf();Image=nil end

											--img_event.response.filename

											local filePath = system.pathForFile( img_event.response.filename, system.DocumentsDirectory )
												            -- Play back the recording
												local file = io.open( filePath)
												            
												if file and img_event.response.filename ~= nil then

												 io.close( file )



												   Image = display.newImage(tempGroup,img_event.response.filename,system.DocumentsDirectory)


												else

													Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)

												end
											
											Image.width=35;Image.height=35
											--Image.anchorY=0
											Image.x=30;Image.y=background.y+background.contentHeight/2
											
								    		--event.row:insert(img_event.target)

								    			
								    		end

								    		end, feedArray[i].MyUnitBuzzRequestAccessId..".png", system.DocumentsDirectory)

						end
		else

					 Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
					--Image.anchorY=0
					Image.x=30;Image.y=background.y+background.contentHeight/2
					

		end





          --  local nameLabel = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)

          Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
          Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
          Display_Group[#Display_Group].x=background.x+55;Display_Group[#Display_Group].y=background.y+10
          Display_Group[#Display_Group]:setFillColor(Utils.convertHexToRGB(color.primaryColor))



          if feedArray[i].FirstName ~= nil then

          	Display_Group[#Display_Group].text = feedArray[i].FirstName.." "..feedArray[i].LastName

          else

          	Display_Group[#Display_Group].text = feedArray[i].LastName
          	
          end



          if feedArray[i].EmailAddress ~= nil then

          	Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
          	Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
          	Display_Group[#Display_Group].x=background.x+55;Display_Group[#Display_Group].y=Display_Group[#Display_Group-1].y+Display_Group[#Display_Group-1].contentHeight+5
          	Display_Group[#Display_Group]:setFillColor( 0.3 )
          	Display_Group[#Display_Group].text = feedArray[i].EmailAddress


          	if feedArray[i].EmailAddress:len() > 33 then

          		Display_Group[#Display_Group].text = Display_Group[#Display_Group].text:sub(1,33)..".."

          	end
          	

          end




          if feedArray[i].PhoneNumber ~= nil and feedArray[i].PhoneNumber ~= "" then

          	Display_Group[#Display_Group+1] = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,13)
          	Display_Group[#Display_Group].anchorX=0;Display_Group[#Display_Group].anchorY=0
          	Display_Group[#Display_Group].x=background.x+55;Display_Group[#Display_Group].y=Display_Group[#Display_Group-1].y+Display_Group[#Display_Group-1].contentHeight+5
          	Display_Group[#Display_Group]:setFillColor( 0.3 )
          	Display_Group[#Display_Group].text = feedArray[i].PhoneNumber

          	background.height = background.height+15

          end



		-- 	--background.height = 0

		-- 	for i=1,#Display_Group do

		-- 		background.height = background.height + Display_Group[i].contentHeight+10

		-- 	end

		-- --	background.height = background.height + 20

		-- 	--background.height = background.height-((background.height/5)*(5-#Display_Group))+5


		

		-- 	 --  group =  Createmenu(background)

  --  				--tempGroup:insert( group )

  --  				--group.isVisible=false


	  local line = display.newRect(tempGroup,W/2,background.y,W,1)
	  line.y=background.y+background.contentHeight-line.contentHeight
	  line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


	  scrollView:insert(tempGroup)



end

	
end





-- function get_GetMyUnitBuzzRequestAccessesNew(response1)


-- 			-- if page_count == 1 and scrollView.y ~=0 and search.text:len() == 1 then

-- 			-- 	for j=#groupArray, 1, -1 do 
-- 			-- 		display.remove(groupArray[#groupArray])
-- 			-- 		groupArray[#groupArray] = nil
-- 			-- 	end

-- 			-- 	scrollView:scrollToPosition
-- 			-- 	{
-- 			-- 		y = 0,
-- 			-- 		time = 200,
-- 			-- 	}

-- 			-- elseif page_count ~= 1 and scrollView.y ~=0 then

-- 			-- -- if page_count == 1 then

-- 			-- 		for j=#groupArray, 1, -1 do 
-- 			-- 		display.remove(groupArray[#groupArray])
-- 			-- 		groupArray[#groupArray] = nil
-- 			-- 		end

-- 			-- 	scrollView:scrollToPosition
-- 			-- 	{
-- 			-- 		y = 0,
-- 			-- 		time = 200,
-- 			-- 	}

-- 		 --    end

-- 		 	if page_count == 1 then

-- 				for j=#groupArray, 1, -1 do 
-- 					display.remove(groupArray[#groupArray])
-- 					groupArray[#groupArray] = nil
-- 				end

-- 				scrollView:scrollToPosition
-- 				{
-- 					y = 0,
-- 					time = 200,
-- 				}

-- 		    end


-- 		  totArray = response1


-- 		reqaccess_response = response1.MubRequestAccessList

-- 		ContactListResponse = reqaccess_response


-- 	    searchcontact_bg.isVisible = true
-- 	    searchcontact.isVisible = true
-- 	    count_bg.isVisible = true
-- 	    count.isVisible = true


-- 	    TotalCount = response1.TotalContactCount

-- 	    if TotalCount == 1 then

-- 	    	count.text = TotalCount.." Contact"

-- 	    else

-- 			count.text = TotalCount.." Contacts"

-- 	    end

	 

-- 	local function onTimer(event)

-- 				if reqaccess_response ~= nil then

-- 					if #reqaccess_response > 0  then

-- 						NoEvent.isVisible=false


-- 						local listValue = {}

-- 						for i=1,#reqaccess_response do

-- 							listValue[#listValue+1] = reqaccess_response[i]	

-- 						end


-- 						local function onTimerr(event)

-- 								if search.text:len() == 2 and search.text:len() > 2 then


-- 								elseif search.text:len() < 2 then

-- 									print( "here !!!!!!! new values"..#listValue )	
-- 									CreateList(listValue)

-- 							    end

-- 						end

-- 						timer.performWithDelay(100,onTimerr)


-- 					else

-- 						if #groupArray <= 0 then

-- 							NoEvent.isVisible=true

-- 							if status == "DENY" then

-- 								NoEvent.text=InviteAccessDetail.NoDeniedAccess

-- 							elseif status == "OPEN" then

-- 								NoEvent.text=InviteAccessDetail.NoPendingRequest

-- 							elseif status == "ADDREQUEST" then

-- 								NoEvent.text=InviteAccessDetail.NoTMAccess

-- 							end
-- 						end


-- 					end

-- 				end

-- 	end

-- 	timer.performWithDelay(500,onTimer)

-- end






function get_GetMyUnitBuzzRequestAccesses(response1)

			if page_count == 1 and search.isVisible == false then

				--search.text = ""

				for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
				end

				scrollView:scrollToPosition
				{
					y = 0,
					time = 200,
				}

		    end



		reqaccess_response = response1.MubRequestAccessList

		print("llllllll "..json.encode(reqaccess_response))

		ContactListResponse = reqaccess_response


	    searchcontact_bg.isVisible = true
	    searchcontact.isVisible = true
	    count_bg.isVisible = true
	    count.isVisible = true


	    TotalCount = response1.TotalContactCount

	    if TotalCount == 1 then

	    	count.text = TotalCount.." Contact"

	    elseif TotalCount ~= 0 then

	    	print("count 0")

			count.text = TotalCount.." Contacts"

		elseif TotalCount == 0 then

			    for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
				end

							NoEvent.isVisible=true

							if status == "DENY" then

								NoEvent.text=InviteAccessDetail.NoDeniedAccess

							elseif status == "OPEN" then

								NoEvent.text=InviteAccessDetail.NoPendingRequest

							elseif status == "ADDREQUEST" then

								NoEvent.text=InviteAccessDetail.NoTMAccess

							end

				count.text = TotalCount.." Contacts"


	    end


	  



		totArray = response1




	 

	local function onTimer(event)

				if reqaccess_response ~= nil and reqaccess_response ~= "" then

							if #reqaccess_response > 0  then

									NoEvent.isVisible=false

									local listValue = {}

									for i=1,#reqaccess_response do

										listValue[#listValue+1] = reqaccess_response[i]	

									end

									print( "here !!!!!!!"..#listValue )	


									CreateList(listValue)


							else

									if #groupArray <= 0 then

										NoEvent.isVisible=true

										if status == "DENY" then

											NoEvent.text=InviteAccessDetail.NoDeniedAccess

										elseif status == "OPEN" then

											NoEvent.text=InviteAccessDetail.NoPendingRequest

										elseif status == "ADDREQUEST" then

											NoEvent.text=InviteAccessDetail.NoTMAccess

										end

									end

							end

				else

					print("&&&&&&&&%%%%%")

							NoEvent.isVisible=true

							if status == "DENY" then

								NoEvent.text=InviteAccessDetail.NoDeniedAccess

							elseif status == "OPEN" then

								NoEvent.text=InviteAccessDetail.NoPendingRequest

							elseif status == "ADDREQUEST" then

								NoEvent.text=InviteAccessDetail.NoTMAccess

							end


				end






		-- if #reqaccess_response == 0 then

		-- 	print("********")
     
		-- 	 --    for j=#groupArray, 1, -1 do 
		-- 		-- 	display.remove(groupArray[#groupArray])
		-- 		-- 	groupArray[#groupArray] = nil
		-- 		-- end

		-- 		NoEvent.isVisible=true

		-- 		if status == "DENY" then

		-- 			NoEvent.text=InviteAccessDetail.NoDeniedAccess

		-- 		elseif status == "OPEN" then

		-- 			NoEvent.text=InviteAccessDetail.NoPendingRequest

		-- 		elseif status == "ADDREQUEST" then

		-- 			NoEvent.text=InviteAccessDetail.NoTMAccess

		-- 		end
		-- end




	end

	timer.performWithDelay(500,onTimer)

end






function get_GetMyUnitBuzzRequestAccesses1(response1)

			if page_count == 1 and search.isVisible == false then

				print("scroll ==  1")

				--search.text = ""

				for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
				end

				scrollView:scrollToPosition
				{
					y = 0,
					time = 200,
				}

			-- else


			-- 	print("scroll not 1")

			-- 	--page_count = 0

			-- 	--get_GetMyUnitBuzzRequestAccesses(response1)

			-- --	CreateList(response1)


			-- 	scrollView:scrollToPosition
			-- 	{
			-- 		y = 0,
			-- 		time = 200,
			-- 	}

		    end



		reqaccess_response = response1.MubRequestAccessList

		print("llllllll 1111 "..json.encode(reqaccess_response))

		ContactListResponse = reqaccess_response


		totArray = response1


	    searchcontact_bg.isVisible = true
	    searchcontact.isVisible = true
	    count_bg.isVisible = true
	    count.isVisible = true


	    TotalCount = response1.TotalContactCount

	    if TotalCount == 1 then

	    	count.text = TotalCount.." Contact"

	    elseif TotalCount ~= 0 then

	    	print("count 0 33333")

			count.text = TotalCount.." Contacts"

		elseif TotalCount == 0 then

			    for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
				end

							NoEvent.isVisible=true

							if status == "DENY" then

								NoEvent.text=InviteAccessDetail.NoDeniedAccess

							elseif status == "OPEN" then

								NoEvent.text=InviteAccessDetail.NoPendingRequest

							elseif status == "ADDREQUEST" then

								NoEvent.text=InviteAccessDetail.NoTMAccess

							end

				count.text = TotalCount.." Contacts"


	    end




	 

	local function onTimer(event)

				if reqaccess_response ~= nil and reqaccess_response ~= "" then

							if #reqaccess_response > 0  then

									NoEvent.isVisible=false

									local listValue = {}

									for i=1,#reqaccess_response do

										listValue[#listValue+1] = reqaccess_response[i]	

									end

									print( "here !!!!!!! 1111"..#listValue )	


									CreateListUpdate("update",listValue)


							else

									if #groupArray <= 0 then

										NoEvent.isVisible=true

										if status == "DENY" then

											NoEvent.text=InviteAccessDetail.NoDeniedAccess

										elseif status == "OPEN" then

											NoEvent.text=InviteAccessDetail.NoPendingRequest

										elseif status == "ADDREQUEST" then

											NoEvent.text=InviteAccessDetail.NoTMAccess

										end

									end

							end

				else

					print("&&&&&&&&%%%%%")

							NoEvent.isVisible=true

							if status == "DENY" then

								NoEvent.text=InviteAccessDetail.NoDeniedAccess

							elseif status == "OPEN" then

								NoEvent.text=InviteAccessDetail.NoPendingRequest

							elseif status == "ADDREQUEST" then

								NoEvent.text=InviteAccessDetail.NoTMAccess

							end


				end


	end

	timer.performWithDelay(500,onTimer)

end




	function getOriginalContactList( response )


		    if page_count == 1 and scrollView.y ~=0 and search.text:len() == 1 then

		    	print("_________111")

				for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
				end

				scrollView:scrollToPosition
				{
					y = 0,
					time = 200,
				}

			elseif page_count ~= 1 and scrollView.y ~=0 and search.text:len() == 2 then


				print("_________not 111")

					for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
					end

				scrollView:scrollToPosition
				{
					y = 0,
					time = 200,
				}

		    end


		    searchArraytotal=response




			if response ~= nil then

					 if #response>0 then

							   NoEvent.isVisible = false

								for i=1,#response do


									local added=false

									    if response[i].FirstName ~= nil and response[i].FirstName ~= "" then

												if string.find(response[i].FirstName:lower(),search.text:lower()) ~= nil then


													if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true


												end
										end
										if response[i].LastName ~= nil and response[i].LastName ~= "" then

											   if string.find(response[i].LastName:lower(),search.text:lower()) ~= nil then


													if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true


											    end
										end
										if response[i].EmailAddress ~= nil and response[i].EmailAddress ~= "" then 

												if string.find(response[i].EmailAddress:lower(),search.text:lower()) ~= nil then

													if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true
											    end

										end

										if response[i].PhoneNumber ~= nil and response[i].PhoneNumber ~= "" then 

											local storedvalue 

												storedvalue = string.gsub(response[i].PhoneNumber:lower(),"%(","") 
												storedvalue = string.gsub(storedvalue:lower(),"%)","") 
												storedvalue = string.gsub(storedvalue:lower(),"%-","")
												--storedvalue = string.gsub(storedvalue:lower()," ","",3) 

												print(storedvalue)


												if string.find(storedvalue,search.text:lower()) ~= nil then

													if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true

											    end

										end

									end


												CreateList(searchArray)



												if #searchArray > 0 then
													NoEvent.isVisible = false
												else
													NoEvent.isVisible = true
													NoEvent.text = "No Contacts Found"
												end

									 else


							                    if #response == 0 then

													print("not true 111 63457672457246")

													for j=#groupArray, 1, -1 do 
													display.remove(groupArray[#groupArray])
													groupArray[#groupArray] = nil
													end

														NoEvent.isVisible = true

														NoEvent.text = "No Contacts Found"

												end



								     end


			else

				print("no contacts")

					NoEvent.isVisible = true
					NoEvent.text = "No Contacts Found"

			end

			     --                if #response == 0 then

								-- 	print("not true 111")

								-- 		NoEvent.isVisible = true

								-- 		NoEvent.text = "No Contacts Found"

								-- end

			
	end








-- local function searchListener( event )

-- 	if ( event.phase == "began" ) then
       

--     elseif ( event.phase == "ended" or event.phase == "submitted" ) then
       
--         native.setKeyboardFocus( nil )

--     elseif ( event.phase == "editing" ) then

-- 			    	if event.text:len() == 1 or event.text:len() < 2 then

-- 							for i=1,#searchArraytotal do
-- 									searchArraytotal[i]=nil
-- 							end

-- 							print("length == 2 and < 3")

-- 							page_count=0
-- 							page_count = page_count+1


-- 							--Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,status,get_GetMyUnitBuzzRequestAccesses)

--                             get_GetMyUnitBuzzRequestAccessesNew(totArray)

--                            -- CreateList(totArray)


-- 		 			elseif event.text:len() == 2 or event.startPosition == (2) then

-- 			    		        print("length = 3")

-- 					    		Webservice.ContactAutoCompleteForRequestAccesses(event.text,status,getOriginalContactList)


-- 					elseif event.text:len() > 2 or event.text:len() ~= 1 or event.text:len() ~=2 and event.startPosition ~= (2) then

-- 			    		        print("length > 3")

-- 				    			for i=1,#searchArray do
-- 									searchArray[i]=nil
-- 								end



-- 								if #searchArraytotal>0 then

-- 									local added = false

-- 									 NoEvent.isVisible = false

-- 									 for i=1,#searchArraytotal do

-- 									    if searchArraytotal[i].FirstName ~= nil and searchArraytotal[i].FirstName ~= "" then


-- 												if string.find(searchArraytotal[i].FirstName:lower(),event.text:lower()) ~= nil and searchArraytotal[i].FirstName:find('%[') == nil then

-- 													if added == false then

-- 													searchArray[#searchArray+1] = searchArraytotal[i]

-- 													end

-- 													added=true

-- 												end

-- 										end

-- 										if searchArraytotal[i].LastName ~= nil or searchArraytotal[i].LastName ~= "" and searchArraytotal[i].LastName:find('%[') == nil then

-- 											   if string.find(searchArraytotal[i].LastName:lower(),event.text:lower()) ~= nil then

-- 													if added == false then

-- 													searchArray[#searchArray+1] = searchArraytotal[i]

-- 													end

-- 													added=true
-- 											    end

-- 										end

-- 										if searchArraytotal[i].EmailAddress ~= nil or searchArraytotal[i].EmailAddress ~= "" and searchArraytotal[i].EmailAddress:find('%[') == nil then 

-- 													if string.find(searchArraytotal[i].EmailAddress:lower(),event.text:lower()) ~= nil then

-- 													    if added == false then

-- 														searchArray[#searchArray+1] = searchArraytotal[i]

-- 														end

-- 														added=true

-- 												    end

-- 										end

-- 										if searchArraytotal[i].PhoneNumber ~= nil or searchArraytotal[i].PhoneNumber ~= "" and searchArraytotal[i].PhoneNumber:find('%[') == nil then 

-- 													if string.find(searchArraytotal[i].PhoneNumber:lower(),event.text:lower()) ~= nil then

-- 													    if added == false then

-- 														searchArray[#searchArray+1] = searchArraytotal[i]

-- 														end

-- 														added=true

-- 												    end

-- 										end

-- 									end


-- 										 CreateList(searchArray)


-- 										if #searchArray == 0 then

-- 											print("not true")

-- 												NoEvent.isVisible = true

-- 												NoEvent.text = "No Contacts Found"

-- 										end



-- 								else

-- 										NoEvent.isVisible = true

-- 										NoEvent.text = "No Contacts Found"

-- 								end


							



-- 								-- if testresponse then

-- 								-- 	page_count = 1

								    

-- 								-- else

-- 								-- 	NoEvent.isVisible = true

-- 								--     NoEvent.text = "No Contacts Found"

-- 								-- end
					    
-- 			        end

--     end
-- end




local function searchListener( event )

	if ( event.phase == "began" ) then
       

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
       
        native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then

			    	if event.text:len() == 1 or event.text:len() < 2 then


				   			 	print("length == 2 and < 3")

								page_count=0
								page_count = page_count+1

								for i=1,#searchArraytotal do
										searchArraytotal[i]=nil
								end


							--Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,status,get_GetMyUnitBuzzRequestAccesses1)

                            get_GetMyUnitBuzzRequestAccesses1(totArray)

                           -- CreateList(totArray)


		 			elseif event.text:len() == 2 or  event.startPosition == (2) then

			    		        print("length = 3")

			    		        for i=1,#searchArray do
									searchArray[i]=nil
								end

					    		Webservice.ContactAutoCompleteForRequestAccesses(event.text,status,getOriginalContactList)


					elseif event.text:len() > 2 or event.text:len() ~= 1 or event.text:len() ~=2 and event.startPosition ~= (2) then

			    		        print("length > 3")

				    			for i=1,#searchArray do
									searchArray[i]=nil
								end


								for i=1,#searchArraytotal do

									local added = false

									    if searchArraytotal[i].FirstName ~= nil and searchArraytotal[i].FirstName ~= "" then

												if string.find(searchArraytotal[i].FirstName:lower(),event.text:lower()) ~= nil then

													print("Here >>>>>>>>>>")

													NoEvent.isVisible = false

													if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true

												end

										end
										if searchArraytotal[i].LastName ~= nil and searchArraytotal[i].LastName ~= "" then

											   if string.find(searchArraytotal[i].LastName:lower(),event.text:lower()) ~= nil then

												print("Here last >>>>>>>>>>")

												NoEvent.isVisible = false

													if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true
											    end

										end
										if searchArraytotal[i].EmailAddress ~= nil and searchArraytotal[i].EmailAddress ~= "" then 

											local searchValue = event.text:lower()

												searchValue = string.gsub(searchValue,"%+" , "%+")

												if string.find(searchArraytotal[i].EmailAddress:lower(),searchValue) ~= nil then

												print("Here last email>>>>>>>>>>")

												NoEvent.isVisible = false

												if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true

											    end

										end

										if searchArraytotal[i].PhoneNumber ~= nil and searchArraytotal[i].PhoneNumber ~= "" then 

											   local storedvalue 

												storedvalue = string.gsub(searchArraytotal[i].PhoneNumber:lower(),"%(","") 
												storedvalue = string.gsub(storedvalue:lower(),"%)","") 
												storedvalue = string.gsub(storedvalue:lower(),"%-","")
												--storedvalue = string.gsub(storedvalue:lower()," ","",3) 

												print(storedvalue)

												if string.find(storedvalue,event.text:lower()) ~= nil then

												print("Here last phone>>>>>>>>>>")

												NoEvent.isVisible = false

												if added == false then

													searchArray[#searchArray+1] = searchArraytotal[i]

													end

													added=true

											    end

										end

								end



								


								 CreateList(searchArray)


								if #searchArray == 0 then

									print("not true")

										NoEvent.isVisible = true

										NoEvent.text = "No Contacts Found"

								end



								-- if testresponse then

								-- 	page_count = 1

								    

								-- else

								-- 	NoEvent.isVisible = true

								--     NoEvent.text = "No Contacts Found"

								-- end
					    
			        end

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








function reloadInvitAccess(reloadstatus)

		composer.hideOverlay( )

		status = reloadstatus

		if reloadstatus == "GRANT" then title.text = FlapMenu.Contacts_with_Access end
		if reloadstatus == "DENY" then title.text = FlapMenu.Denied_Access end
		if reloadstatus == "OPEN" then title.text = FlapMenu.Pending_Requests end
		if reloadstatus == "ADDREQUEST" then title.text = FlapMenu.TeamMember_without_Access end

		page_count=0
		page_count = page_count+1

		if search.text ~= "" then

              search.text = ""

              searchflag = "true"

		end

		Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,reloadstatus,get_GetMyUnitBuzzRequestAccesses)


end





 local function invite_scrollListener( event )

         	local phase = event.phase

         	if ( phase == "began" ) then 

         	elseif ( phase == "moved" ) then

         		elseif ( phase == "ended" ) then 

         	end


         	if ( event.limitReached ) then

         		if ( event.direction == "up" ) then print( "Reached bottom limit" )

         			
         			if status == "GRANT" then title.text = FlapMenu.Contacts_with_Access end
					if status == "DENY" then title.text = FlapMenu.Denied_Access end
					if status == "OPEN" then title.text = FlapMenu.Pending_Requests end
					if status == "ADDREQUEST" then title.text = FlapMenu.TeamMember_without_Access end


				if search.text == "" or search.text:len() == 1 and searchcontact.isVisible == true then

					print( "^^^^^^^^^^^^^^^^^^^^" )

					page_count = page_count+1

					Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,status,get_GetMyUnitBuzzRequestAccesses)

				else

				end


         			
         		elseif ( event.direction == "down" ) then print( "Reached top limit" )

         				if status == "GRANT" then title.text = FlapMenu.Contacts_with_Access end
					if status == "DENY" then title.text = FlapMenu.Denied_Access end
					if status == "OPEN" then title.text = FlapMenu.Pending_Requests end
					if status == "ADDREQUEST" then title.text = FlapMenu.TeamMember_without_Access end


					if search.text == "" or search.text:len() == 1 then

					page_count=0
					page_count = page_count+1

					Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,status,get_GetMyUnitBuzzRequestAccesses)

					else

					end



         		elseif ( event.direction == "left" ) then print( "Reached right limit" )

         		elseif ( event.direction == "right" ) then print( "Reached left limit" )

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
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,FlapMenu.Contacts_with_Access,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

--------------------- added code to show count ------------------------

	count_bg = display.newRect(sceneGroup,0,0,W,30)
	count_bg.x=W/2;count_bg.y = title_bg.y+title_bg.contentHeight
	count_bg.isVisible=false
	count_bg:setFillColor(0,0,0,0.1)


	count = display.newText(sceneGroup,"",0,0,native.systemFont,14)
	--count.anchorX = 0
	count.text = ""
	count.isVisible=false
	--count.x=W/2;
    count.x = 7
    count.anchorX = 0
	count.y = count_bg.y
	count:setFillColor(0)

----------------- added code for searching contacts -------------------

	-- searchcontact_bg = display.newRect(sceneGroup,0,0,W,30)
	-- searchcontact_bg.y = count_bg.y+count_bg.contentHeight
	-- searchcontact_bg.x = W/2
	-- searchcontact_bg.isVisible=false
	-- searchcontact_bg:setFillColor(0,0,0,0.2)

	-- searchcontact = display.newImageRect(sceneGroup,"res/assert/search(gray).png",18,18)
	-- searchcontact.x=searchcontact_bg.x+searchcontact_bg.contentWidth/2-searchcontact.contentWidth
	-- searchcontact:setFillColor(0)
	-- searchcontact.isVisible=false
	-- searchcontact.y=searchcontact_bg.y


	searchcontact_bg = display.newRect(sceneGroup,0,0,W,30)
	searchcontact_bg.y = title_bg.y
	searchcontact_bg.x = W - 30
	searchcontact_bg.anchorX = 0
	searchcontact_bg.id = "searchbg"
	searchcontact_bg.isVisible=false
	searchcontact_bg:setFillColor( Utils.convertHexToRGB(color.tabbar))

	searchcontact = display.newImageRect(sceneGroup,"res/assert/search_icon.png",18,18)
	searchcontact.x = W - 30
	searchcontact:setFillColor(0)
	searchcontact.alpha = 1
	searchcontact.id = "searchbg"
	searchcontact.anchorX = 0
	searchcontact.isVisible=false
	searchcontact.y=searchcontact_bg.y

	searchcontact:addEventListener( "touch", searchTouch )


	searchtext_bg = display.newRect(sceneGroup,0,0,W,30)
	searchtext_bg.y = count_bg.y+count_bg.contentHeight
	searchtext_bg.x = W/2
	searchtext_bg.isVisible=false
	searchtext_bg:setFillColor(0,0,0,0.2)


	search =  native.newTextField( searchtext_bg.x-searchtext_bg.contentWidth/2+7, searchtext_bg.y, searchtext_bg.contentWidth-15, 24 )
	search.anchorX=0
	search.size=14
	search.isFontSizeScaled = true
	search.text = ""
	--search:resizeHeightToFitFont()
	search:setReturnKey( "search" )
	search.placeholder = CommonWords.search
	search.hasBackground = true
	search.isVisible = false
	sceneGroup:insert(search)

	search:addEventListener( "userInput", searchListener )


-----------------------------------------------------------------------

	NoEvent = display.newText( sceneGroup, EventCalender.NoEvent , 0,0,0,0,native.systemFontBold,14)
	NoEvent.x=W/2;NoEvent.y=H/2
	NoEvent.isVisible=false
	NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

	-- if search.isVisible == true and searchtext_bg.isVisible == true then

	-- 		scrollView = widget.newScrollView
	-- 		{
	-- 			top = RecentTab_Topvalue+30,
	-- 			left = 0,
	-- 			width = W,
	-- 			height =H-RecentTab_Topvalue-30,
	-- 			hideBackground = true,
	-- 			isBounceEnabled=false,
	-- 			horizontalScrollDisabled = true,
	-- 			--scrollWidth = W,
	-- 			bottomPadding = 60,
	-- 			listener = invite_scrollListener,

	-- 		}

	-- 		sceneGroup:insert(scrollView)

	-- else    

		print("******")

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
				listener = invite_scrollListener,

			}

			scrollView.y = 100
			scrollView.anchorY = 0

			sceneGroup:insert(scrollView)


	--end

	MainGroup:insert(sceneGroup)
end





function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
		composer.removeHidden()


	elseif phase == "did" then

---------------------------------------search list---------------------------------------

				-- searchList_bg = display.newRect( searchGroup, 200, 200, 104, 304 )
				-- searchList_bg:setFillColor( 0 )
				-- searchList_bg.anchorY = 0


				-- searchList = widget.newTableView(
				-- {
				-- 	left = 200,
				-- 	top = 200,
				-- 	height = 100,
				-- 	width = 300,
				-- 	onRowRender = searchRender,
				-- 	onRowTouch = searchTouch,
				-- 	hideBackground = true,
				-- 	isBounceEnabled = false,
				-- 	noLines = true,
				-- 	   }
				-- 	   )
				-- searchList.anchorX=0
				-- searchList.anchorY=0
				-- searchList.isVisible = false
				-- searchList.anchorY = 1
				-- searchList_bg.anchorX = 0
				-- searchList_bg.isVisible = false

			 --  	searchGroup:insert( searchList )

-------------------------------------------------------------------------------------------

				search.text = ""

		   		status = event.params.status
		   		
		   		page_count = page_count+1


					if status == "GRANT" then title.text = FlapMenu.Contacts_with_Access end
					if status == "DENY" then title.text = FlapMenu.Denied_Access end
					if status == "OPEN" then title.text = FlapMenu.Pending_Requests end
					if status == "ADDREQUEST" then title.text = FlapMenu.TeamMember_without_Access end


		   		Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,event.params.status,get_GetMyUnitBuzzRequestAccesses)


		   		menuBtn:addEventListener("touch",menuTouch)
		   		
		   	end	
		   	
		   	MainGroup:insert(sceneGroup)

end




		   function scene:hide( event )

		   	local sceneGroup = self.view
		   	local phase = event.phase

				   	if event.phase == "will" then

				   		--composer.removeHidden()


				   		if search then search:removeSelf();search = nil end


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






	function get_removeorblockDetails( response)

		   	Request_response = response

		   	if popUpGroup.numChildren ~= nil then
				for j=popUpGroup.numChildren, 1, -1 do 
					display.remove(popUpGroup[popUpGroup.numChildren])
					popUpGroup[popUpGroup.numChildren] = nil
				end
			end


		   	function onCompletion(event)

		   		--if "clicked"==event.action then

		   			AlertGroup.isVisible = false

		   			ContactIdValue = Details.MyUnitBuzzRequestAccessId

		   			if popUpGroup.numChildren ~= nil then
		   				for j=popUpGroup.numChildren, 1, -1 do 
		   					display.remove(popUpGroup[popUpGroup.numChildren])
		   					popUpGroup[popUpGroup.numChildren] = nil
		   				end
		   			end

		   			page_count = 0

		   			page_count = page_count+1

		   			Webservice.GetMyUnitBuzzRequestAccesses(page_count,totalPageContent,status,get_GetMyUnitBuzzRequestAccesses)

		   		--end

		   	end


		   local option ={
							 {content=CommonWords.ok,positive=true},
						}
     if Request_response == "SUCCESS" then

		     	if id_value == "Remove Access" then

		     		--local remove_successful= native.showAlert(CommonWords.Remove, CareerPath.RemovedText, { CommonWords.ok} , onCompletion)

						genericAlert.createNew(CommonWords.Remove,CareerPath.RemovedText,option,onCompletion)

		     	elseif id_value == "Block Access" then

		     		genericAlert.createNew(CommonWords.Block,CareerPath.BlockedText,option,onCompletion)

		     		--local block_successful = native.showAlert(CommonWords.Block, CareerPath.BlockedText, { CommonWords.ok} , onCompletion)

		     	elseif id_value == "Deny Access" then

		     		genericAlert.createNew(CommonWords.Deny,CareerPath.DeniedText,option,onCompletion)

		     		--denyaccess = native.showAlert(CommonWords.Deny,  CareerPath.DeniedText, { CommonWords.ok } , onCompletion)

		     	elseif id_value == "Grant Access" then

		     		genericAlert.createNew(CommonWords.GrantAccessText,CareerPath.GrantSuccessText,option,onCompletion)

		     		--grantaccess = native.showAlert(CommonWords.GrantAccessText, CareerPath.GrantSuccessText, { CommonWords.ok} , onCompletion)

		     	elseif id_value == "Provide Access" then

		     		genericAlert.createNew(CommonWords.ProvideAccessText,CareerPath.ProvideAccessSuccessText,option,onCompletion)

		     		--accessprovided = native.showAlert(CommonWords.ProvideAccessText, CareerPath.ProvideAccessSuccessText , { CommonWords.ok } , onCompletion)

		     	end
	elseif Request_response == "GRANT" then

				genericAlert.createNew(CareerPath.AlreadyGranted,CareerPath.AlreadyGrantedText,option,onCompletion)

				--granted = native.showAlert(CareerPath.AlreadyGranted, CareerPath.AlreadyGrantedText, { CommonWords.ok} , onCompletion)

	elseif Request_response == "REMOVE" then

				genericAlert.createNew(CareerPath.AlreadyRemoved,CareerPath.AlreadyRemovedText,option,onCompletion)

				--Removed = native.showAlert(CareerPath.AlreadyRemoved, CareerPath.AlreadyRemovedText, { CommonWords.ok} , onCompletion)
				
	elseif Request_response == "ADDREQUEST" then

				genericAlert.createNew(CareerPath.AddRequest,CareerPath.AddRequestText,option,onCompletion)

				--addrequest = native.showAlert(CareerPath.AddRequest, CareerPath.AddRequestText, { CommonWords.ok} , onCompletion)

	elseif Request_response == "BLOCK" then

				genericAlert.createNew(CareerPath.AlreadyBlocked,CareerPath.AlreadyBlockedText,option,onCompletion)

				--addrequest = native.showAlert(CareerPath.AlreadyBlocked, CareerPath.AlreadyBlockedText, { CommonWords.ok} , onCompletion)
	end




	end



	return scene



--Webservice.ContactAutoCompleteForRequestAccesses(searchText,status,postExecution)
	
