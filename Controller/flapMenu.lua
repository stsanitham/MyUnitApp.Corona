	----------------------------------------------------------------------------------
	--
	-- instagram Screen
	--
	----------------------------------------------------------------------------------

	local composer = require( "composer" )
	local scene = composer.newScene()
	local widget = require( "widget" )

	require( "res.value.style" )
	local Utility = require( "Utils.Utility" )
	require( "Webservice.ServiceManager" )
	local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
	local db = sqlite3.open( path )
	require( "Controller.genericAlert" )

	--------------- Initialization -------------------

	local W = display.contentWidth;H= display.contentHeight

	local Background,BgText

	local menuBtn

	menuArray_display = {}

	local space_value = 42

	local profilePic,UserEmail;

	local profilePic_path,ContactId

	---------------------------------------------------


	-----------------Function--------------------------

	local function unrequire( m )
		print( "unrequire" )
		package.loaded[m] = nil
		_G[m] = nil
		package.loaded["res.value.string_es_Us"] = nil

		return true
	end

	local function closeDetails( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

		end

		return true

	end

	local function MenuTouchAction(event)
		if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )

		elseif ( event.phase == "moved" ) then
			local dy = math.abs( ( event.y - event.yStart ) )
	        -- If the touch on the button has moved more than 10 pixels,
	        -- pass focus back to the scroll view so it can continue scrolling
	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	        	flapScroll:takeFocus( event )
	        end

	        elseif event.phase == "ended" then
	        display.getCurrentStage():setFocus( nil )


	        if event.target.id == "logout" then
	        	local function onComplete( event )
	        		--if event.action == "clicked" then
	        			local i = event
	        			if i == 1 then

	        				function get_logout(response)

	        					if response == 5 then

	        						if flapScroll ~= nil then flapScroll:removeSelf( );flapScroll=nil end

	        						for j=MainGroup.numChildren, 1, -1 do 
	        							display.remove(MainGroup[MainGroup.numChildren])
	        							MainGroup[MainGroup.numChildren] = nil
	        						end


	        						slideAction()

	        						
	        						local tablesetup = [[DROP TABLE logindetails;]]
	        						db:exec( tablesetup )

												-- local tablesetup_msg = [[DROP TABLE pu_MyUnitBuzz_Message;]]
												-- db:exec( tablesetup_msg )

												composer.gotoScene( "Controller.singInPage" )

											else

												slideAction()

											end


										end
										local logout_Userid,logout_ContactId,logout_AccessToken,logout_uniqueId

										for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

											logout_Userid = row.UserId
											logout_ContactId = row.ContactId
											logout_AccessToken = row.AccessToken
											logout_uniqueId = system.getInfo("deviceID")
											
										end


										Webservice.LogOut(logout_Userid,logout_ContactId,logout_AccessToken,logout_uniqueId,get_logout)

									elseif i == 2 then
					            --cancel
					        end
					  --  end
					end

					local option ={
							 {content=FlapMenu.LOG_OUT ,positive=true},
							 {content= FlapMenu.CANCEL,positive=true},
						}
						genericAlert.createNew("Log out", FlapMenu.Alert,option,onComplete)
				-- Show alert with two buttons
				--local alert = native.showAlert( "Log out", FlapMenu.Alert, { FlapMenu.LOG_OUT , FlapMenu.CANCEL }, onComplete )	
				
				return true
				
			end

			for i = 1, #menuArray_display do

				menuArray_display[i].alpha=0.01

			end

			event.target.alpha=1
			
			slideAction()


			if openPage ~= event.target.id then

				--menuArray_display[#menuArray_display].alpha=1

				for j=MainGroup.numChildren, 1, -1 do 
					display.remove(MainGroup[MainGroup.numChildren])
					MainGroup[MainGroup.numChildren] = nil
				end
				
				composer.removeHidden()

				if event.target.name == "GRANT" or event.target.name == "DENY" or event.target.name == "OPEN" or event.target.name == "ADDREQUEST" then

					local option={
						params = {status=event.target.name}
					}
					composer.gotoScene( "Controller."..event.target.id,option )

				else

					composer.gotoScene( "Controller."..event.target.id )

				end

			else
				if event.target.name == "GRANT" or event.target.name == "DENY" or event.target.name == "OPEN" or event.target.name == "ADDREQUEST" then

					print( '123' )
					reloadInvitAccess(event.target.name)

				end

			end


				--end
			end
			return true

		end
	------------------------------------------------------



	function scene:create( event )

		local sceneGroup = self.view


		local found=false
		db:exec([[select * from sqlite_master where name='logindetails';]],
			function(...) found=true return 0 end)

		if found then

			for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

				langid = row.LanguageId
				countryid = row.CountryId
				ContactId = row.ContactId

				profilePic_path = row.ProfileImageUrl
				
				loginFlag=true

				Director_Name = row.MemberName

				EmailAddress = row.MemberEmail


						---Check Facebook , Twitter and Google+----


						if row.GoogleUsername ~="" and row.GoogleToken ~="" and row.GoogleTokenSecret ~="" and row.GoogleUserId ~="" then

							isGoogle=true

						end

						if row.FacebookUsername ~="" and row.FacebookAccessToken ~="" then

							isFacebook=true

						end


						if row.TwitterUsername ~="" and row.TwitterToken ~="" and row.TwitterTokenSecret ~="" then

							isTwitter=true

						end



						------------------

						
						

					end

					if package.loaded["res.value.string_es_Us"] then print( "spani finish" ) unrequire("res.value.string_es_Us") end
					if package.loaded["res.value.string_fr_Ca"] then print( "string_fr_Ca finish" ) unrequire("res.value.string_fr_Ca") end
					if package.loaded["res.value.string_en_Ca"] then print( "string_en_Ca finish" ) unrequire("res.value.string_en_Ca") end
					if package.loaded["res.value.string"] then print( "string finish" ) unrequire("res.value.string") end
					

					if langid == "2"  and countryid == "1" then

						MyUnitBuzzString = require( "res.value.string_es_Us" )

					elseif langid == "3"  and countryid == "2" then

						MyUnitBuzzString = require( "res.value.string_fr_Ca" )

					elseif langid == "4" and countryid == "2" then

						MyUnitBuzzString = require( "res.value.string_en_Ca" )

					else

						MyUnitBuzzString = require( "res.value.string")

					end



				else

					MyUnitBuzzString = require( "res.value.string" )

				end



				MainGroup:insert(sceneGroup)

			end






function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

		elseif phase == "did" then

			panel.background = display.newRect( 0, 0, panel.width, panel.height )
			panel.background:setFillColor(1,1,1)
			panel:insert( panel.background )

			panel.flapTopBg = display.newRect(0,0,panel.width,H/4+10)
			panel.flapTopBg.anchorY=0;panel.flapTopBg.y=-panel.height/2
			panel.flapTopBg:setFillColor(Utils.convertHexToRGB(color.primaryColor))
			panel:insert( panel.flapTopBg )
			
			profileEmail = display.newText("",0,0,250,0,"Roboto-Regular",13.5)
			profileEmail.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+18
			profileEmail.anchorX=0
			profileEmail:setFillColor(1)
			profileEmail.anchorY=0
			Utils.CssforTextView(profileEmail,sp_Flatmenu_fieldValue)
			profileEmail.y=panel.flapTopBg.y+panel.flapTopBg.contentHeight-profileEmail.contentHeight-12
			panel:insert( profileEmail )

			profileName = display.newText(Director_Name,0,0,245,0,"Roboto-Regular",17.5)
			profileName.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+18
			profileName.anchorX=0
			profileName.y=profileEmail.y+profileEmail.contentHeight-profileName.contentHeight-12
			Utils.CssforTextView(profileName,sp_Flatmenu_labelName)
			profileName:setFillColor(1)
			panel:insert( profileName )

			local profilePic 

			profilePic = display.newImageRect("res/assert/usericon.png",65,60)
			profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+15
			profilePic.y=profileName.y-profilePic.contentHeight-18
			profilePic.anchorY=0
			profilePic.anchorX=0
			panel:insert( profilePic )

			if profilePic_path ~= nil and profilePic_path ~= "" then 

				local downloadid = network.download(ApplicationConfig.IMAGE_BASE_URL..""..profilePic_path,
					"GET",
					function ( img_event )

						if ( img_event.isError ) then
								print ( "Network error - download failed" )
						else

								if profilePic then profilePic:removeSelf( );profilePic=nil end

								print("response file "..img_event.response.filename)
								profilePic = display.newImageRect(img_event.response.filename,system.DocumentsDirectory,80,68)
								--profilePic.width=65;profilePic.height=65
								profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+15
								profilePic.y=profileName.y-profilePic.contentHeight-18
								profilePic.anchorY=0
								profilePic.anchorX=0


								local mask = graphics.newMask( "res/assert/mask1.png" )
								profilePic:setMask( mask )
								--profilePic.maskX = profilePic.x
								--profilePic.maskY = profilePic.y
								panel:insert( profilePic )
		    				    --event.row:insert(img_event.target)
		    			end

			    end, ContactId..".png", system.DocumentsDirectory)
				else
					profilePic = display.newImageRect("res/assert/usericon.png",65,60)
					profilePic.x=panel.flapTopBg.x-panel.flapTopBg.contentWidth/2+15
					profilePic.y=profileName.y-profilePic.contentHeight-18
					profilePic.anchorY=0
					profilePic.anchorX=0
					panel:insert( profilePic )

				end




				if EmailAddress ~= nil then

					local EmailTxt = EmailAddress

					if EmailTxt:len() > 26 then

						EmailTxt= EmailTxt:sub(1,26).."..."

					end

					profileEmail.text = EmailTxt

				end


				local LogoPic

				LogoPic = display.newImageRect("res/assert/logoSymbol.png",105,105)
				LogoPic.x=profilePic.x + profilePic.contentWidth + 45
				LogoPic.y=profileName.y-LogoPic.contentHeight + 52
				LogoPic:rotate(-45)
				LogoPic.alpha=0.5
				LogoPic.anchorY=0
				LogoPic.anchorX=0
				panel:insert( LogoPic )



			--[[	--HomePage

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=panel.flapTopBg.y+panel.flapTopBg.contentHeight-5
				panel:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Home"
				menuArray_display[#menuArray_display].id="LandingPage"

				Event_icon = display.newImageRect("res/assert/calen.png",15,15)
				Event_icon.anchorX = 0
				Event_icon.x=-panel.width/2+5
				Event_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				panel:insert( Event_icon )

				Event_text = display.newText(FlapMenu.Home,0,0,"Open Sans Regular",16)
				Event_text.anchorX = 0
				Event_text.x=Event_icon.x+Event_icon.contentWidth+5
				Event_text.y = Event_icon.y
				Utils.CssforTextView(Event_text,sp_Flatmenu_subHeader)
				panel:insert( Event_text )]]

				flapScroll = widget.newScrollView(
				{
					top = 0,
					left = 0,
					width = panel.width,
					height = H-panel.flapTopBg.contentHeight,
					hideBackground=true,
					horizontalScrollDisabled=true
				        -- scrollWidth = 600,
				        -- scrollHeight = 800,
				        -- listener = scrollListener
				    }
				    )
				flapScroll.anchorY=0
				-- flapScroll.anchorX=0
				-- flapScroll.y = panel.flapTopBg.y+panel.flapTopBg.contentHeight-5
				flapScroll.x=panel.x;flapScroll.y=panel.flapTopBg.y+panel.flapTopBg.contentHeight
				panel:insert( flapScroll )
				--EventCalender

				
				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=0
				menuArray_display[#menuArray_display].alpha=0.01
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "EventCalender"
				menuArray_display[#menuArray_display].id="eventCalenderPage"

				Event_icon = display.newImageRect("res/assert/calender.png",20,20)
				Event_icon.anchorX = 0
				Event_icon.x=17.5
				Event_icon.alpha=0.8
				Event_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				Event_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2 + 3
				flapScroll:insert( Event_icon )

				Event_text = display.newText(EventCalender.PageTitle,0,0,"Roboto-Regular",15.5)
				Event_text.anchorX = 0
				Event_text.x=Event_icon.x+Event_icon.contentWidth+17
				Event_text.y = Event_icon.y
				Event_text:setFillColor(0,0,0,0.8)
				--Utils.CssforTextView(Event_text,sp_Flatmenu_subHeader)
				flapScroll:insert( Event_text )

				-----
				--CareerPath

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].height
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "CareerPath"
				menuArray_display[#menuArray_display].id="careerPathPage"


				Career_icon = display.newImageRect("res/assert/unitCarrer.png",20,20)
				Career_icon.anchorX = 0
				Career_icon.alpha=0.8
				Career_icon.x=17.5
				Career_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				Career_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( Career_icon )

				Career_text = display.newText(CareerPath.PageTitle,0,0,"Roboto-Regular",15.5)
				Career_text.anchorX = 0
				Career_text:setFillColor(0,0,0,0.8)
				Career_text.x=Career_icon.x+Career_icon.contentWidth+17
				Career_text.y = Career_icon.y
				--Utils.CssforTextView(Career_text,sp_Flatmenu_subHeader)
				flapScroll:insert( Career_text )

				-----

				--Goals

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
			--	menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Goals"
				menuArray_display[#menuArray_display].id="goalsPage"


				Goals_icon = display.newImageRect("res/assert/unitGoals.png",20,20)
				Goals_icon.anchorX = 0
				Goals_icon.x=17.5
				Goals_icon.alpha=0.8
				Goals_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				Goals_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( Goals_icon )

				Goals_text = display.newText(Goals.PageTitle,0,0,"Roboto-Regular",15.5)
				Goals_text.anchorX = 0
				Goals_text:setFillColor(0,0,0,0.8)
				--Utils.CssforTextView(Goals_text,sp_Flatmenu_subHeader)
				Goals_text.x=Goals_icon.x+Goals_icon.contentWidth+17
				Goals_text.y = Goals_icon.y
				
				flapScroll:insert( Goals_text )

				-----

				--Resource

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Resource"

				menuArray_display[#menuArray_display].id="resourcePage"


				Resource_icon = display.newImageRect("res/assert/resource.png",20,20)
				Resource_icon.anchorX = 0
				Resource_icon.x=17.5
				Resource_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				Resource_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( Resource_icon )

				Resource_text = display.newText(ResourceLibrary.PageTitle ,0,0,"Roboto-Regular",15.5)
				Resource_text.anchorX = 0
				Resource_text.x=Resource_icon.x+Resource_icon.contentWidth+17
				Resource_text.y = Resource_icon.y
				Resource_text:setFillColor(0,0,0,0.8)
				--Utils.CssforTextView(Resource_text,sp_Flatmenu_subHeader)
				flapScroll:insert( Resource_text )

				-----

				--Image Library

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Image_Library"
				menuArray_display[#menuArray_display].id="imageLibPage"


				img_lib_icon = display.newImageRect("res/assert/imglib.png",20,20)
				img_lib_icon.anchorX = 0
				img_lib_icon.x=17.5
				img_lib_icon.alpha=0.8
				img_lib_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				img_lib_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( img_lib_icon )

				img_lib_text = display.newText(ImageLibrary.PageTitle ,0,0,"Roboto-Regular",15.5)
				img_lib_text.anchorX = 0
				img_lib_text:setFillColor(0,0,0,0.8)
				img_lib_text.x=img_lib_icon.x+img_lib_icon.contentWidth+17
				img_lib_text.y = img_lib_icon.y
				
				flapScroll:insert( img_lib_text )

				-----


				--Message

				--if IsOwner == true then

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Messages"
				menuArray_display[#menuArray_display].id="pushNotificationListPage"

				message_icon = display.newImageRect("res/assert/message.png",20,20)
				message_icon.anchorX = 0
				message_icon.x=17.5
				message_icon.alpha=0.8
				message_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				message_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( message_icon )

				message_text = display.newText(Message.PageTitle ,0,0,"Roboto-Regular",15.5)
				message_text.anchorX = 0
				message_text:setFillColor(0,0,0,0.8)
				message_text.x=message_icon.x+message_icon.contentWidth+17
				message_text.y = message_icon.y
				
				flapScroll:insert( message_text )



						--end
				--------------------------Messages--------------------------------------------------------

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Chats"
				menuArray_display[#menuArray_display].id="MessagingPage"

				chat_message_icon = display.newImageRect("res/assert/chat.png",20,20)
				chat_message_icon.anchorX = 0
				--chat_message_icon:setFillColor(1,1,1)
				chat_message_icon.x=17.5
				chat_message_icon.alpha=0.8
				chat_message_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				chat_message_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( chat_message_icon )

				chat_message_text = display.newText(FlapMenu.chatMessageTitle ,0,0,"Roboto-Regular",15.5)
				chat_message_text.anchorX = 0
				chat_message_text:setFillColor(0,0,0,0.8)
				chat_message_text.x=chat_message_icon.x+chat_message_icon.contentWidth+17
				chat_message_text.y = chat_message_icon.y
				
				flapScroll:insert( chat_message_text )



				----Special Recognition

				rect = display.newRect(0,0,panel.width,1)
				rect.x = menuArray_display[#menuArray_display].x;
				rect.anchorX=0
				--rect:setFillColor(Utility.convertHexToRGB(color.LtyGray))
				rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
				rect:setFillColor(color.Gray)
				flapScroll:insert( rect )

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value+5)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=1
				menuArray_display[#menuArray_display]:setFillColor( 0,0,0,0.2)
				menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display].name = "SpecialRecognition"
				menuArray_display[#menuArray_display].id="specialRecognition"
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)

				specialRecognitionLbl = display.newText(string.upper(CommonWords.SpecialRecognitionText),0,0,panel.contentWidth,0,native.systemFontBold,15.5)
				specialRecognitionLbl.anchorX = 0
				specialRecognitionLbl.x=17.5
				specialRecognitionLbl:setFillColor(Utils.convertHexToRGB(color.secondaryColor))
				specialRecognitionLbl.y= rect.y+24
				flapScroll:insert( specialRecognitionLbl )




				if IsOwner == true then

				--Invite/Access

				rect = display.newRect(0,0,panel.width,1)
				rect.x = menuArray_display[#menuArray_display].x;
				rect.anchorX=0
				rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight;
				rect:setFillColor(color.Gray)
				flapScroll:insert( rect )

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display].name = "Social"
				menuArray_display[#menuArray_display].id="social"


				socilaLbl = display.newText(CommonWords.InviteAccessText,0,0,panel.contentWidth,0,"Roboto-Bold",sp_commonLabel.textSize)
				socilaLbl.anchorX = 0
				socilaLbl.x=40
				socilaLbl:setFillColor(0)
				socilaLbl.y= rect.y+21
				flapScroll:insert( socilaLbl )

				--Contacts with Access

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight-5
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "GRANT"
				menuArray_display[#menuArray_display].id="inviteAndaccessPage"

				invite_icon = display.newImageRect("res/assert/contacts.png",20,20)
				invite_icon.anchorX = 0
				--invite_icon:setFillColor(1,1,1)
				invite_icon.x=17.5
				invite_icon.alpha=0.8
				invite_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2 
				flapScroll:insert( invite_icon )

				invite_text = display.newText(FlapMenu.Contacts_with_Access ,0,0,"Roboto-Regular",15.5)
				invite_text.anchorX = 0
				invite_text:setFillColor(0,0,0,0.8)
				invite_text.x=invite_icon.x+invite_icon.contentWidth+17
				invite_text.y = invite_icon.y
				
				flapScroll:insert( invite_text )

				---Denied Access

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "DENY"
				menuArray_display[#menuArray_display].id="inviteAndaccessPage"

				invite_icon = display.newImageRect("res/assert/deniedAcc.png",20,20)
				invite_icon.anchorX = 0
				invite_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				invite_icon.x=17.5
				invite_icon.alpha=0.8
				invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2 
				flapScroll:insert( invite_icon )

				invite_text = display.newText(FlapMenu.Denied_Access ,0,0,"Roboto-Regular",15.5)
				invite_text.anchorX = 0
				invite_text:setFillColor(0,0,0,0.8)
				invite_text.x=invite_icon.x+invite_icon.contentWidth+17
				invite_text.y = invite_icon.y
				
				flapScroll:insert( invite_text )

				--Pending Requests

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "OPEN"
				menuArray_display[#menuArray_display].id="inviteAndaccessPage"

				invite_icon = display.newImageRect("res/assert/pending.png",20,20)
				invite_icon.anchorX = 0
				invite_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				invite_icon.x=17.5
				invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2 
				flapScroll:insert( invite_icon )

				invite_text = display.newText(FlapMenu.Pending_Requests,0,0,"Roboto-Regular",15.5)
				invite_text.anchorX = 0
				invite_text:setFillColor(0,0,0,0.8)
				invite_text.x=invite_icon.x+invite_icon.contentWidth+17
				invite_text.y = invite_icon.y
				
				flapScroll:insert( invite_text )

				--Team Member without Access

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "ADDREQUEST"
				menuArray_display[#menuArray_display].id="inviteAndaccessPage"

				invite_icon = display.newImageRect("res/assert/teammenber.png",20,20)
				invite_icon.anchorX = 0
				invite_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
				invite_icon.x=17.5
				invite_icon.alpha=0.8
				invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2 
				flapScroll:insert( invite_icon )

				invite_text = display.newText(FlapMenu.TeamMember_without_Access,0,0,"Roboto-Regular",15.5)
				invite_text.anchorX = 0
				invite_text:setFillColor(0,0,0,0.8)
				invite_text.x=invite_icon.x+invite_icon.contentWidth+17
				invite_text.y = invite_icon.y
				
				flapScroll:insert( invite_text )

			    --Add New Access

			    menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			    menuArray_display[#menuArray_display].anchorY=0
			    menuArray_display[#menuArray_display].anchorX=0
			    menuArray_display[#menuArray_display].alpha=0.01
			   -- menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			    menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight+3
			    flapScroll:insert( menuArray_display[#menuArray_display] )
			    menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			    menuArray_display[#menuArray_display].name = "Add New Access"
			    menuArray_display[#menuArray_display].id="addNewAccessPage"

			    invite_icon = display.newImageRect("res/assert/addNew.png",20,20)
			    invite_icon.anchorX = 0
			    invite_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
			    invite_icon.x=17.5
			    invite_icon.alpha=0.8
			    invite_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2 
			    flapScroll:insert( invite_icon )

			    invite_text = display.newText(FlapMenu.AddNewAccess ,0,0,"Roboto-Regular",15.5)
			    invite_text.anchorX = 0
			    invite_text:setFillColor(0,0,0,0.8)
			    invite_text.x=invite_icon.x+invite_icon.contentWidth+17
			    invite_text.y = invite_icon.y
			    
			    flapScroll:insert( invite_text )

			end

				-----


				rect = display.newRect(0,0,panel.width,1)
				rect.x = menuArray_display[#menuArray_display].x;
				rect.anchorX=0
				rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
				rect:setFillColor(color.Gray)
				flapScroll:insert( rect )


				if isGoogle == true or isFacebook == true or isTwitter == true then


					menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
					menuArray_display[#menuArray_display].anchorY=0
					menuArray_display[#menuArray_display].anchorX=0
					menuArray_display[#menuArray_display].alpha=0.01
					--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
					menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
					flapScroll:insert( menuArray_display[#menuArray_display] )
					menuArray_display[#menuArray_display].name = "Social"
					menuArray_display[#menuArray_display].id="social"



					socilaLbl = display.newText(FlapMenu.Social_Media,0,0,panel.contentWidth,0,"Roboto-Bold",sp_commonLabel.textSize)
					socilaLbl.anchorX = 0
					socilaLbl.x=40
					socilaLbl:setFillColor(0)
					socilaLbl.y= rect.y+21
					flapScroll:insert( socilaLbl )


				end


				if isFacebook == true then

					



			--Facebook

			menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
			menuArray_display[#menuArray_display].anchorY=0
			menuArray_display[#menuArray_display].anchorX=0
			menuArray_display[#menuArray_display].alpha=0.01
			--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
			menuArray_display[#menuArray_display].y=socilaLbl.y+socilaLbl.contentHeight
			flapScroll:insert( menuArray_display[#menuArray_display] )
			menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
			menuArray_display[#menuArray_display].name = "Facebook"
			menuArray_display[#menuArray_display].id="facebookPage"


			Facebook_icon = display.newImageRect("res/assert/facebook.png",20,20)
			Facebook_icon.anchorX = 0
			Facebook_icon.x=17.5
			--Facebook_icon:setFillColor(0,0,0,0.8)
			Facebook_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
			flapScroll:insert( Facebook_icon )

			Facebook_text = display.newText(Facebook.PageTitle,0,0,"Roboto-Regular",15.5)
			Facebook_text.anchorX = 0
			Facebook_text:setFillColor(0,0,0,0.8)
			Facebook_text.x=Facebook_icon.x+Facebook_icon.contentWidth+17
			Facebook_text.y = Facebook_icon.y
			
			flapScroll:insert( Facebook_text )

				-----


			end

			if isTwitter == true then
				--Twitter

				menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
				menuArray_display[#menuArray_display].anchorY=0
				menuArray_display[#menuArray_display].anchorX=0
				menuArray_display[#menuArray_display].alpha=0.01
				--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
				menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
				flapScroll:insert( menuArray_display[#menuArray_display] )
				menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
				menuArray_display[#menuArray_display].name = "Twitter"
				menuArray_display[#menuArray_display].id="twitterPage"


				Twitter_icon = display.newImageRect("res/assert/twiter.png",20,20)
				Twitter_icon.anchorX = 0
				Twitter_icon.x=17.5
				--Twitter_icon:setFillColor(0,0,0,0.8)
				Twitter_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
				flapScroll:insert( Twitter_icon )

				Twitter_text = display.newText(Twitter.PageTitle,0,0,"Roboto-Regular",15.5)
				Twitter_text.anchorX = 0
				Twitter_text.x=40
				Twitter_text:setFillColor(0,0,0,0.8)
				Twitter_text.x=Twitter_icon.x+Twitter_icon.contentWidth+17
				Twitter_text.y = Twitter_icon.y
				
				flapScroll:insert( Twitter_text )

				-----
			end

			if isGoogle == true then

						--Google +

						menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
						menuArray_display[#menuArray_display].anchorY=0
						menuArray_display[#menuArray_display].anchorX=0
						menuArray_display[#menuArray_display].alpha=0.01
						--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
						menuArray_display[#menuArray_display].y=menuArray_display[#menuArray_display-1].y+menuArray_display[#menuArray_display-1].contentHeight
						flapScroll:insert( menuArray_display[#menuArray_display] )
						menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
						menuArray_display[#menuArray_display].name = "Google +"
						menuArray_display[#menuArray_display].id="googlePlusPage"

						Google_icon = display.newImageRect("res/assert/googlePlus.png",20,20)
						Google_icon.anchorX = 0
						Google_icon.x=17.5
						--Google_icon:setFillColor(0,0,0,0.8)
						Google_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
						flapScroll:insert( Google_icon )

						Googl_text = display.newText(Google_Plus.PageTitle,0,0,"Roboto-Regular",15.5)
						Googl_text.anchorX = 0
						Googl_text.x=40
						Googl_text:setFillColor(0,0,0,0.8)
						Googl_text.x=Google_icon.x+Google_icon.contentWidth+17
						Googl_text.y = Google_icon.y

						flapScroll:insert( Googl_text )

					end


					rect = display.newRect(0,0,panel.width,1)
					rect.x = menuArray_display[#menuArray_display].x;
					rect.anchorX=0
					rect.y = menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight+5;
					rect:setFillColor(color.Gray)
					flapScroll:insert( rect )

						--rect.isVisible=false
			

						--Logout

						menuArray_display[#menuArray_display+1] = display.newRect(0,0,panel.width,space_value)
						menuArray_display[#menuArray_display].anchorY=0
						menuArray_display[#menuArray_display].anchorX=0
						menuArray_display[#menuArray_display].alpha=0.01
						--menuArray_display[#menuArray_display]:setFillColor( Utils.convertHexToRGB(color.flap_selected ))
						menuArray_display[#menuArray_display].y=rect.y+rect.contentHeight
						flapScroll:insert( menuArray_display[#menuArray_display] )
						menuArray_display[#menuArray_display]:addEventListener("touch",MenuTouchAction)
						menuArray_display[#menuArray_display].name = "Logout"
						menuArray_display[#menuArray_display].id="logout"


						Logout_icon = display.newImageRect("res/assert/logout.png",20,20)
						Logout_icon.anchorX = 0
						Logout_icon.x=17.5
						Logout_icon:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
						Logout_icon.y=menuArray_display[#menuArray_display].y+menuArray_display[#menuArray_display].contentHeight/2
						flapScroll:insert( Logout_icon )

						Logout_text = display.newText(FlapMenu.PageTitle,0,0,"Roboto-Regular",15.5)
						Logout_text.anchorX = 0
						Logout_text:setFillColor(0,0,0,0.8)
						--Utils.CssforTextView(Logout_text,sp_Flatmenu_subHeader)
						Logout_text.x=Logout_icon.x+Logout_icon.contentWidth+17
						Logout_text.y = Logout_icon.y


						flapScroll:insert( Logout_text )

						-----
						if not isSimulator then

							if chatReceivedFlag == true then

								chatReceivedFlag = false

								if MessageId ~= "0" and MessageId ~= nil then


									for i = 1, #menuArray_display do

										if menuArray_display[i].name ~= nil and menuArray_display[i].name == "Messages" then

											menuArray_display[i].alpha=1

										end

									end

									local options = {
										isModal = true,
										effect = "slideLeft",
										time = 300,
										params = {
											pagenameval = "pn_detailpage",
										}
									}

									composer.gotoScene( "Controller.pushNotificationDetailPage", options)

								else


									for i = 1, #menuArray_display do

										if menuArray_display[i].name ~= nil and menuArray_display[i].name == "Chats" then

											menuArray_display[i].alpha=1

										end

									end

									composer.gotoScene( "Controller.MessagingPage" )

								end

							else


								composer.gotoScene( "Controller.eventCalenderPage" )

							end

						else

							print( "##$" )
										--composer.gotoScene( "Controller.audioRecordPage", options )
							composer.gotoScene( "Controller.eventCalenderPage" )

						end

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


							return scene