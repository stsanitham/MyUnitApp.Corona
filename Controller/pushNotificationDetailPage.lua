----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
require( "Webservice.ServiceManager" )
local deleteMessageGroup = require( "Controller.deleteMessageGroup" )
local style = require("res.value.style")
local json = require("json")

local status = "normal"


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,title_bg,title

local menuBtn

local photowidth = "";photoheight =""

local reciveImageFlag=false

openPage = "pushNotificationListPage"

local RecentTab_Topvalue = 70

local webView

local back_icon,short_msg_txt,short_msg_delete,short_msg_edit

local messageList_array = {}

local careerListArray = {}

local messagedetail_scrollView

local sentMessage_detail

--------------------------------------------------



-----------------Function-------------------------


			local function FocusComplete( event )

			if event.phase == "began" then

			native.setKeyboardFocus(nil)
			display.getCurrentStage():setFocus( event.target )

			display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then

			display.getCurrentStage():setFocus( nil )

			end

			return true

			end 




		local function closeDetails( event )
			
			if event.phase == "began" then

				display.getCurrentStage():setFocus( event.target )

					 -- if testimage then testimage:removeSelf();testimage = nil end

				  --    network.cancel(testimage)

				  --    os.remove(imagepathvalue)

				  --    reciveImageFlag=false

			elseif event.phase == "ended" then

			    display.getCurrentStage():setFocus( nil )

			    if webView then webView:removeSelf( );webView=nil end

				composer.hideOverlay("slideRight",300)

			end

		   return true

		end




	   function getDeletionresponse( response)

		  Request_response = response

	       if Request_response == true then

	      		 Utils.SnackBar(MessagePage.DeleteSuccess)

					local function onTimer ( event )

	         	          if webView then webView:removeSelf( );webView=nil end


							DeleteMessageGroup.isVisible = false

							status = "deleted"

							composer.hideOverlay("slideRight",500)

					end

    		     timer.performWithDelay(1000, onTimer )

	       end

       end





	function onDeleteOptionsTouch( event )

        if event.phase == "began" then

    	elseif event.phase == "ended" then

       		 native.setKeyboardFocus(nil)

		    	    DeleteMessageGroup.isVisible = true

		            message_id = messagelistvalue.MyUnitBuzzMessageId

		            print("Message Id : ",message_id)

	        	if event.target.id == "accept" then

	        		DeleteMessageGroup.isVisible = false

						if Details.MyUnitBuzzLongMessage ~= nil then

							local test = Details.MyUnitBuzzLongMessage

							content = test

							local saveData = [[<!DOCTYPE html>
							<html>

							<head>
							<meta charset="utf-8">
							<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
							</head>]]..test..[[</html>]]


				            local path = system.pathForFile( "longmessage.html",system.DocumentsDirectory )

							local file, errorString = io.open( path, "w+" )

									if not file then

									print( "File error: " .. errorString )

									else

									file:write( saveData )

					
									webView = native.newWebView(0, 0, display.viewableContentWidth-10, H - 260 )

									webView.hasBackground = false
									webView.x = short_msg_txt.x - 7
									webView.height =  H - 260 
									webView.y = short_msg_txt.y+short_msg_txt.contentHeight+12

									webView.anchorX=0;webView.anchorY=0
									webView:request( "longmessage.html", system.DocumentsDirectory )

									messagedetail_scrollView:insert( webView)

								    file:close()

								    end

						    file = nil

							end


        		    Webservice.DeleteMyUnitBuzzMessages(message_id,getDeletionresponse)

	        	elseif event.target.id == "reject" then

					                DeleteMessageGroup.isVisible = false

									if Details.MyUnitBuzzLongMessage ~= nil then

									 --    long_msg_text= display.newText(sceneGroup,detail_value.MyUnitBuzzLongMessage,0,0,W-30,0,native.systemFont,14)
										-- long_msg_text.x = 12
										-- long_msg_text.y = short_msg_txt.y+short_msg_txt.contentHeight+12
										-- long_msg_text.anchorX=0
										-- long_msg_text.anchorY = 0
										-- Utils.CssforTextView(long_msg_text,sp_labelName)
										-- long_msg_text:setFillColor(0)

										-- messagedetail_scrollView:insert(long_msg_text)

										local test = Details.MyUnitBuzzLongMessage

										content = test

										local saveData = [[<!DOCTYPE html>
										<html>

										<head>
										<meta charset="utf-8">
										<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
										</head>]]..test..[[</html>]]


							            local path = system.pathForFile( "longmessage.html",system.DocumentsDirectory )

										local file, errorString = io.open( path, "w+" )

												if not file then

												print( "File error: " .. errorString )

												else

												file:write( saveData )

				
												webView = native.newWebView(0, 0, display.viewableContentWidth-10, H - 260 )

												webView.hasBackground = false
												webView.x = short_msg_txt.x - 7
												webView.height =  H - 260 
												webView.y = short_msg_txt.y+short_msg_txt.contentHeight+12

												webView.anchorX=0;webView.anchorY=0
												webView:request( "longmessage.html", system.DocumentsDirectory )

												messagedetail_scrollView:insert( webView)

											    file:close()


											    end

									    file = nil

										end


	        	end
        
        end

    end





		local function onDeleteAction( event )

			if event.phase == "began" then

				display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then

			    display.getCurrentStage():setFocus( nil )


		                if event.target.id == "deleteoption" then

		                	if webView then webView:removeSelf( );webView=nil end

					    GetDeleteMessageAlertPopup()


					    accept_button:addEventListener("touch",onDeleteOptionsTouch)
			            reject_button:addEventListener("touch",onDeleteOptionsTouch)

				        elseif event.target.id == "editoption" then

									if event.params then

									messagelistvalue = event.params.messagelistvalues

									end


									local options = {
											isModal = true,
											effect = "slideRight",
											time = 300,
											params = {
											editvalues = messagelistvalue , pagevalue = "editpage"
										}
									}


				                      --composer.gotoScene("Controller.composeMessagePage",options)


									status="edit"

									pagevalue = "editpage"

									composer.hideOverlay()


				        end

			    -- DeleteMessageGroup.isVisible = true

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






local function audioPlay( event )
			if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

					local audioname = event.target.id:match( "([^/]+)$" )

					--native.showAlert( "MUB", "audioname" ,{"ok"} )
					if not audioname then
						audioname = event.target.id
					end

					 local filePath = system.pathForFile( audioname, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )

		               
		                if event.target.value == "play" then
               	

		                	 local isChannel1Playing = audio.isChannelPlaying( 2 )
								if isChannel1Playing or isSimulator then

									 -- for i=#MeassageList, 1, -1 do 
										-- 		local group = MeassageList[#MeassageList]

										-- 		for j=group.numChildren, 1, -1 do 

													

										-- 			if group[j].value == "pause" then

										-- 				group[j]:setSequence( "play" )
										-- 				group[j].value="play"
	      			-- 									group[j]:play()

										-- 			end

									 --   		 	end
												
										-- end




									event.target:setSequence( "pause" )
			      					event.target:play()
			      					event.target.value="pause"
			      					if event.target.channel == 2 then
			      					 	audio.resume( 2 )

			      					end

								else

									local laserSound = audio.loadSound( filePath )
					                local laserChannel = audio.play( laserSound,{channel=2,onComplete = audioPlayComplete} )
					                event.target:setSequence( "pause" )
			      					event.target:play()
			      					event.target.value="pause"
			      					event.target.channel=2
								end
			           

	      				elseif event.target.value == "pause" then
	      						print( "pause" )
	      						 local isChannel1Playing = audio.isChannelPlaying( 2 )
									if isChannel1Playing or isSimulator then
									    audio.pause( 2 )
									end
									     event.target:setSequence( "play" )
				      					event.target:play()
				      					event.target.value="play"
									

									

	      				end

		            else

		            end

		-- network.download(
		-- event.target.id,
		-- "GET",
		-- recivedNetwork,
		-- event.target.id:match( "([^/]+)$" ),
		-- system.DocumentsDirectory
		-- )

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


	Background:addEventListener( "touch", FocusComplete )

    MainGroup:insert(sceneGroup)


end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

		elseif phase == "did" then


			if event.params then

				messagelistvalue = event.params.messagelistvalues

				print("\n\n\n Message Detail Values : \n\n ", json.encode(messagelistvalue))

				 -- photowidth = event.params.photowidthval

				 -- photoheight = event.params.photoheightval

					--  if photowidth ~= "" and photoheight ~= "" then

					--  print("width and height values : ",photowidth.."    "..photoheight)

					--  else

					-- 	photowidth = ""
					-- 	photoheight = ""

					--  end 

			end


			messagedetail_scrollView = widget.newScrollView
				{
					top = 70,
					left = 0,
					width = W,
					height =H-70,
					bottomPadding = 15,
					hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollDisabled = true,
					hideScrollBar = true,
				}


            sceneGroup:insert(messagedetail_scrollView)




 function DisplayDetailValues( detail_value)

		    print("********************************* : ", detail_value)

		    Details = detail_value


			back_icon_bg = display.newRect(sceneGroup,0,0,20,20)
			back_icon_bg.x= 5
			back_icon_bg.anchorX=0
			back_icon_bg.anchorY=0
			back_icon_bg.alpha=0.01
			back_icon_bg:setFillColor(0)
			back_icon_bg.y= title_bg.y-8

			back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
			back_icon.x= 10
			back_icon.anchorX=0
			back_icon.anchorY=0
			back_icon:setFillColor(0)
			back_icon.y= title_bg.y - 8

			title = display.newText(sceneGroup,Message.PageTitle,0,0,native.systemFont,18)
			title.anchorX = 0
			title.x=back_icon.x+20;title.y = title_bg.y
			title:setFillColor(0)



            if IsOwner == true then

			short_msg_delete= display.newImageRect(sceneGroup,"res/assert/delete.png",19,17)
			short_msg_delete.x= W-25
			short_msg_delete.anchorX=0
			short_msg_delete.id = "deleteoption"
			short_msg_delete.anchorY=0
			short_msg_delete:setFillColor(0)
			short_msg_delete.y= title_bg.y - 8
			--messagedetail_scrollView:insert(short_msg_delete)


			short_msg_edit= display.newImageRect(sceneGroup,"res/assert/editicon.png",23,23)
			short_msg_edit.x= short_msg_delete.x - 35
			short_msg_edit.anchorX=0
			short_msg_edit.anchorY=0
			short_msg_edit.id = "editoption"
			short_msg_edit.isVisible = true
			short_msg_edit:setFillColor(0)
			short_msg_edit.y= title_bg.y - 12

		    else

		    	--short_msg_txt.width = W-40
		    	--short_msg_txt.x=back_icon.x + 8
			    --short_msg_txt.y= back_icon.y

			end


            
            local timecreated = detail_value.MessageDate
			local time = makeTimeStamp(timecreated)

			--short_msg_timedate= display.newText(sceneGroup,os.date("%b %d, %Y %I:%M %p",time),0,0,W-130,0,native.systemFont,12)
			short_msg_timedate= display.newText(sceneGroup,"",0,0,W-130,0,native.systemFont,12)
			short_msg_timedate.x = W-63
			short_msg_timedate.y = title_bg.y +title_bg.contentHeight/2-58
			short_msg_timedate.anchorX=0
			short_msg_timedate.anchorY = 0
			short_msg_timedate:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
			--short_msg_timedate:setFillColor(0)
			messagedetail_scrollView:insert(short_msg_timedate)


                   print(os.date("%B %d, %Y",time) , os.date("%B %d, %Y",os.time(os.date( "*t" ))))

					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(os.date( "*t" ))) then

						short_msg_timedate.text =  os.date("%B %d, %Y",time).."  "..os.date("%I:%M %p",time)

						short_msg_timedate.x = W-150

				    else 


						local t = os.date( "*t" )
						t.day=t.day-1

						if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(t)) then

							short_msg_timedate.text = ChatPage.Yesterday.."  "..os.date("%I:%M %p",time)
							short_msg_timedate.x = W-150

						else

							short_msg_timedate.text = os.date("%B %d, %Y",time).."  "..os.date("%I:%M %p",time)
							short_msg_timedate.x = W-150

						end

			     	end

		

					short_msg_txt= display.newText(sceneGroup,detail_value.MyUnitBuzzMessage,0,0,W-80,0,native.systemFont,14)
					short_msg_txt.x=12
					short_msg_txt.y= short_msg_timedate.y+short_msg_timedate.contentHeight+12
					short_msg_txt.anchorX=0
					short_msg_txt.anchorY = 0
					Utils.CssforTextView(short_msg_txt,sp_labelName)
					short_msg_txt:setFillColor(0)
					messagedetail_scrollView:insert(short_msg_txt)


	if detail_value.MyUnitBuzzLongMessage ~= nil then

		 --    long_msg_text= display.newText(sceneGroup,detail_value.MyUnitBuzzLongMessage,0,0,W-30,0,native.systemFont,14)
			-- long_msg_text.x = 12
			-- long_msg_text.y = short_msg_txt.y+short_msg_txt.contentHeight+12
			-- long_msg_text.anchorX=0
			-- long_msg_text.anchorY = 0
			-- Utils.CssforTextView(long_msg_text,sp_labelName)
			-- long_msg_text:setFillColor(0)

			-- messagedetail_scrollView:insert(long_msg_text)

			local test = detail_value.MyUnitBuzzLongMessage

			content = test

			local saveData = [[<!DOCTYPE html>
			<html>

			<head>
			<meta charset="utf-8">
			<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
			</head>]]..test..[[</html>]]


            local path = system.pathForFile( "longmessage.html",system.DocumentsDirectory )

			local file, errorString = io.open( path, "w+" )

			if not file then

			print( "File error: " .. errorString )

			else

			file:write( saveData )

			
		    webView = native.newWebView(0, 0, display.viewableContentWidth-10, H - 260 )

			webView.hasBackground = false
			webView.x = short_msg_txt.x - 7
			webView.height =  H - 260 
			webView.y = short_msg_txt.y+short_msg_txt.contentHeight+12

			webView.anchorX=0;webView.anchorY=0
			webView:request( "longmessage.html", system.DocumentsDirectory )

			sceneGroup:insert(webView)

			messagedetail_scrollView:insert( webView)

		    file:close()

	end

		    file = nil





	if detail_value.ImageFilePath ~= null and detail_value.AudioFilePath ~= null then

					local function recivedNetwork( event )
					    if ( event.isError ) then
					        print( "Network error - download failed: ", event.response )
					    elseif ( event.phase == "began" ) then
					        print( "Progress Phase: began" )
					    elseif ( event.phase == "ended" ) then
					        print( "Displaying response image file" )
					        reciveImageFlag=true

							myImage = display.newImage( event.response.filename, event.response.baseDirectory, display.viewableContentWidth, display.contentHeight )
							--myImage.y = Imagenametext.y+Imagenametext.contentHeight+12
							myImage.y = webView.y+webView.contentHeight+12
							myImage.x = display.contentCenterX
							myImage.anchorY=0
							--myImage.width = display.viewableContentWidth - 20
							--myImage.height = display.viewableContentHeight - 200
							myImage.width = 100
							myImage.height = 100

						    sceneGroup:insert(myImage)

		                    messagedetail_scrollView:insert( myImage)




					        audionametext= display.newText(sceneGroup,detail_value.AudioFileName,0,0,W-80,0,native.systemFont,14)
							audionametext.x=W/2+40
							audionametext.y= myImage.y+myImage.contentHeight+12
							--audionametext.anchorX=0
							audionametext.anchorY = 0
							Utils.CssforTextView(audionametext,sp_labelName)
							audionametext:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
							messagedetail_scrollView:insert(audionametext)


							local audioname = detail_value.AudioFilePath:match( "([^/]+)$" )
							local audio

							filePath = system.pathForFile( audioname,system.DocumentsDirectory )
							local fhd = io.open( filePath )


							spinner.isVisible=false

							local bg = display.newRect( display.contentCenterX,0,W-250,50 )
							bg.y = audionametext.y+audionametext.contentHeight+12
							bg.anchorY =0
							bg.x = display.contentCenterX
							bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
							sceneGroup:insert(bg)
							messagedetail_scrollView:insert(bg)

							local sheetData2 = { width=30, height=30, numFrames=2, sheetContentWidth=60, sheetContentHeight=30 }
							local sheet1 = graphics.newImageSheet( "res/assert/playpause.png", sheetData2 )

							local sequenceData = {
							{ name="play", sheet=sheet1, start=1, count=1, time=220, loopCount=1 },
							{ name="pause", sheet=sheet1, start=2, count=1, time=220, loopCount=1 },
							}

							local playIcon = display.newSprite( sheet1, sequenceData )
							playIcon.x=bg.x+bg.contentWidth/2-35;playIcon.y=bg.y+bg.contentHeight/2 
							playIcon.id=detail_value.AudioFilePath
							playIcon.value="play"
							playIcon:addEventListener( "touch", audioPlay )
							playIcon:setSequence( "play" )
							playIcon:play()
							sceneGroup:insert(playIcon)
							messagedetail_scrollView:insert(playIcon)

					  		
					    end
					    
					end



					local testimage = 

						network.download(
						detail_value.ImageFilePath,
						"GET",
						recivedNetwork,
						detail_value.ImageFilePath:match( "([^/]+)$" ),
						system.DocumentsDirectory
						)

					end


		            imagepathvalue = detail_value.ImageFilePath
			


	end





		if detail_value.ImageFilePath ~= null then


					local function recivedNetwork( event )
					    if ( event.isError ) then
					        print( "Network error - download failed: ", event.response )
					    elseif ( event.phase == "began" ) then
					        print( "Progress Phase: began" )
					    elseif ( event.phase == "ended" ) then
					        print( "Displaying response image file" )
					        reciveImageFlag=true

							myImage = display.newImage( event.response.filename, event.response.baseDirectory, display.viewableContentWidth, display.contentHeight )
							--myImage.y = Imagenametext.y+Imagenametext.contentHeight+12
							myImage.y = webView.y+webView.contentHeight+12
							myImage.x = display.contentCenterX
							myImage.anchorY=0
							--myImage.width = display.viewableContentWidth - 20
							--myImage.height = display.viewableContentHeight - 200
							myImage.width = 100
							myImage.height = 100

						    sceneGroup:insert(myImage)

		                    messagedetail_scrollView:insert( myImage)
					  		
					    end
					end



			local testimage = 

				network.download(
				detail_value.ImageFilePath,
				"GET",
				recivedNetwork,
				detail_value.ImageFilePath:match( "([^/]+)$" ),
				system.DocumentsDirectory
				)


		imagepathvalue = detail_value.ImageFilePath

	end




	if detail_value.AudioFilePath ~= null then


			audionametext= display.newText(sceneGroup,detail_value.AudioFileName,0,0,W-80,0,native.systemFont,14)
			audionametext.x=W/2+40
			audionametext.y= webView.y+webView.contentHeight+12
			--audionametext.anchorX=0
			audionametext.anchorY = 0
			Utils.CssforTextView(audionametext,sp_labelName)
			audionametext:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
			messagedetail_scrollView:insert(audionametext)


			local audioname = detail_value.AudioFilePath:match( "([^/]+)$" )

			local audio


			filePath = system.pathForFile( audioname,system.DocumentsDirectory )
			local fhd = io.open( filePath )


			spinner.isVisible=false

			local bg = display.newRect( display.contentCenterX,0,W-250,50 )
			bg.y = audionametext.y+audionametext.contentHeight+12
			bg.anchorY =0
			bg.x = display.contentCenterX
			bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
			sceneGroup:insert(bg)
			messagedetail_scrollView:insert(bg)

			local sheetData2 = { width=30, height=30, numFrames=2, sheetContentWidth=60, sheetContentHeight=30 }
			local sheet1 = graphics.newImageSheet( "res/assert/playpause.png", sheetData2 )

			local sequenceData = {
			{ name="play", sheet=sheet1, start=1, count=1, time=220, loopCount=1 },
			{ name="pause", sheet=sheet1, start=2, count=1, time=220, loopCount=1 },
			}

			local playIcon = display.newSprite( sheet1, sequenceData )
			playIcon.x=bg.x+bg.contentWidth/2-35;playIcon.y=bg.y+bg.contentHeight/2 
			playIcon.id=detail_value.AudioFilePath
			playIcon.value="play"
			playIcon:addEventListener( "touch", audioPlay )
			playIcon:setSequence( "play" )
			playIcon:play()
			sceneGroup:insert(playIcon)
			messagedetail_scrollView:insert(playIcon)

	end




end


	      -- sceneGroup:insert(messagedetail_scrollView)
            

            DisplayDetailValues(messagelistvalue)


			menuBtn:addEventListener("touch",menuTouch)

			back_icon:addEventListener("touch",closeDetails)
			back_icon_bg:addEventListener("touch",closeDetails)
			title:addEventListener("touch",closeDetails)

				if IsOwner == true then

				short_msg_delete:addEventListener("touch",onDeleteAction)
				short_msg_edit:addEventListener("touch",onDeleteAction)

			    end

            Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end





	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if phase == "will" then

			Runtime:removeEventListener("key",onKeyEventDetail)

            if webView then webView:removeSelf( );webView=nil end

				if DeleteMessageGroup.numChildren ~= nil then

				  	 	for j=DeleteMessageGroup.numChildren, 1, -1 do 
				  						display.remove(DeleteMessageGroup[DeleteMessageGroup.numChildren])
				  						DeleteMessageGroup[DeleteMessageGroup.numChildren] = nil
				  	 	end
	            end


             if testimage then testimage:removeSelf();testimage = nil end

			  network.cancel(testimage)


		elseif phase == "did" then
               

			--	event.parent:resumeGame(status,messagelistvalue)


				if status == "edit" then

					    print("edit values ************* : ",json.encode(messagelistvalue))

						event.parent:resumeGame(status,messagelistvalue,pagevalue)
				else
					    status="back"

						event.parent:resumeGame(status,messagelistvalue)
				end

                

				menuBtn:removeEventListener("touch",menuTouch)

				back_icon:removeEventListener("touch",closeDetails)
			    back_icon_bg:removeEventListener("touch",closeDetails)
				title:removeEventListener("touch",closeDetails)


				


			if IsOwner == true then

			short_msg_delete:removeEventListener("touch",onDeleteAction)
			short_msg_edit:removeEventListener("touch",onDeleteAction)

		    end

		    Background:removeEventListener( "touch", FocusComplete )


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