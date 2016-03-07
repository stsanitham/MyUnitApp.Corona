----------------------------------------------------------------------------------
--
-- Splash Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local style = require("res.value.style")
local OneSignal = require("plugin.OneSignal")
--local string = require("res.value.string")


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local Splash_TimeOut = 500

require( "Webservice.ServiceManager" )

local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


--------------------------------------------------


-----------------Function-------------------------

local function SplashTimeOut( event )
	timer.cancel(event.source)

	
end

------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/bg-image.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	BgText = display.newImageRect(sceneGroup,"res/assert/splashlogo.png",398/2,81/2)
	BgText.x=W/2;BgText.y=H/2

	

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	local function AfterVersionCheck()

			local Director_Name,EmailAddress

			local loginFlag = false

			local tablefound=false
			db:exec([[select * from sqlite_master where name='logindetails';]],
			function(...) tablefound=true return 0 end)

			if tablefound then 
				print('table exists!')


				--local tablesetup = [[DROP TABLE logindetails;]]
			--	db:exec( tablesetup )


			for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

					loginFlag=true

					Director_Name = row.MemberName

					EmailAddress = row.MemberEmail
					
			end

			local profileImageUrl,GoogleUsername,GoogleToken,GoogleTokenSecret,GoogleUserId,FacebookUsername,FacebookAccessToken,TwitterUsername,TwitterToken,TwitterTokenSecret

			function get_userSocialSetting(response)

				if response.MyUnitBuzzContacts.IsOwner ~= nil then

						IsOwner = response.MyUnitBuzzContacts.IsOwner
      			else
      					IsOwner = " "
      			end

      			if response.MyUnitBuzzContacts.TimeZone ~= nil then

						TimeZone = response.MyUnitBuzzContacts.TimeZone


      			else


      					TimeZone = " "

      			end


				if response.GoogleSettings ~= nil then

					if response.GoogleSettings.GoogleUsername ~= nil then

					GoogleUsername = response.GoogleSettings.GoogleUsername

					else
						GoogleUsername=""
					end





					if response.GoogleSettings.GoogleToken ~= nil then
						GoogleToken = response.GoogleSettings.GoogleToken
					else
						GoogleToken=""
					end

					if response.GoogleSettings.GoogleTokenSecret ~= nil then
						GoogleTokenSecret = response.GoogleSettings.GoogleTokenSecret
					else
						GoogleTokenSecret=""
					end

					if response.GoogleSettings.GoogleUserId ~= nil then

						GoogleUserId = response.GoogleSettings.GoogleUserId
					else
						GoogleUserId=""
					end

				else

					GoogleUsername=""
					GoogleToken=""
					GoogleTokenSecret=""
					GoogleUserId=""	
				end

				if response.FacebookSettings ~= nil then

					if response.FacebookSettings.FacebookUsername ~= nil then
				FacebookUsername = response.FacebookSettings.FacebookUsername
					else
						FacebookUsername=""
					end

					if response.FacebookSettings.FacebookAccessToken ~= nil then
						FacebookAccessToken = response.FacebookSettings.FacebookAccessToken
					else
						FacebookAccessToken=""
					end
				else

					FacebookUsername=""
					FacebookAccessToken=""

				end

				if response.TwitterSettings ~= nil then

					if response.TwitterSettings.TwitterUsername ~= nil then
					TwitterUsername = response.TwitterSettings.TwitterUsername
					else
							TwitterUsername=""
					end

					if response.TwitterSettings.TwitterToken ~= nil then
						TwitterToken = response.TwitterSettings.TwitterToken
					else
						TwitterToken=""
					end

					if response.TwitterSettings.TwitterTokenSecret ~= nil then
						TwitterTokenSecret = response.TwitterSettings.TwitterTokenSecret
					else
						TwitterTokenSecret=""
					end

				else

					TwitterUsername=""
					TwitterToken=""
					TwitterTokenSecret=""

				end

				if response.MyUnitBuzzContacts then

			if response.MyUnitBuzzContacts.ImagePath ~= nil then
						profileImageUrl = response.MyUnitBuzzContacts.ImagePath
					else
						profileImageUrl=""
					end
			else
						profileImageUrl=""
			end



				local q = [[UPDATE logindetails SET ProfileImageUrl=']]..profileImageUrl..[[',GoogleUsername=']]..GoogleUsername..[[',GoogleToken=']]..GoogleToken..[[',GoogleTokenSecret=']]..GoogleTokenSecret..[[',GoogleUserId=']]..GoogleUserId..[[',FacebookUsername=']]..FacebookUsername..[[',FacebookAccessToken=']]..FacebookAccessToken..[[',TwitterUsername=']]..TwitterUsername..[[',TwitterToken=']]..TwitterToken..[[',TwitterTokenSecret=']]..TwitterTokenSecret..[[' WHERE id=1;]]
				db:exec( q )
				
				--composer.gotoScene( "Controller.flapMenu" )

						function IdsAvailable(userId, pushToken)

							    GCMValue = userId

						        composer.gotoScene( "Controller.flapMenu" )
						   
						    if (pushToken) then -- nil if there was a connection issue or on iOS notification permissions were not accepted.
						        print("pushToken:" .. pushToken)
						    end

						end

						OneSignal.IdsAvailableCallback(IdsAvailable)

						if isSimulator then


						        composer.gotoScene( "Controller.flapMenu" )

						end

			end		

				
			Webservice.Get_SocialMediaTokens(get_userSocialSetting)
		


			else

				print('not table exists!')

				

						function IdsAvailable(userId, pushToken)


						    print("userId:" .. userId)

						   -- native.showAlert("userId", userId, { "OK" } )
						     
						   
						        GCMValue = userId

						        local options = {
								    effect = "slideLeft",
								    time = Splash_TimeOut,
								    params = { responseValue=response}
								}


								composer.gotoScene( "Controller.singInPage", options )
						   
						    if (pushToken) then -- nil if there was a connection issue or on iOS notification permissions were not accepted.
						        print("pushToken:" .. pushToken)
						    end

						end

						OneSignal.IdsAvailableCallback(IdsAvailable)

						if isSimulator then


						        local options = {
								    effect = "slideLeft",
								    time = Splash_TimeOut,
								    params = { responseValue=response}
								}


								composer.gotoScene( "Controller.singInPage", options )

						end

			end



	end

		function get_versionFromWeb(response)

					

					if system.getInfo( "environment" ) == "device" then

							--local alert = native.showAlert( response,system.getInfo( "appVersionString" ), { CommonWords.ok } )

							local responseVersion = string.gsub( response, "%.", "", 3 )
							local installedVersion = string.gsub( system.getInfo( "appVersionString" ), "%.", "", 3 )

							local contents = " "
							-- Path for the file to read
							local path = system.pathForFile( "version.txt", system.DocumentsDirectory )

							-- Open the file handle
							local file, errorString = io.open( path, "r" )

							if not file then
							    -- Error occurred; output the cause
							    print( "File error: " .. errorString )
							else
							    -- Read data from file
							    contents = file:read( "*a" )
							    -- Output the file contents
							    -- Close the file handle
							    io.close( file )
							end

							file = nil


							local storedContent = string.gsub( contents, "%.", "", 3 )

							if storedContent < installedVersion then

								local found=false
								db:exec([[select * from sqlite_master where name='logindetails';]],
								function(...) found=true return 0 end)

								if found then 
									print('table exists!')


									local tablesetup = [[DROP TABLE logindetails;]]
									db:exec( tablesetup )

								end

							end


							if (tonumber(responseVersion)<=tonumber(installedVersion)) then

			
									AfterVersionCheck()

							else

								local function onComplete( event )
									if event.action == "clicked" then

									    	if isAndroid then 

											system.openURL( "market://details?id=com.spanenterprises.myunitbuzz" )

											os.exit()

										elseif isIos then

											system.openURL( "https://itunes.apple.com/in/app/myunitbuzz/id1068478993?mt=8" )
											
										end
									     
									end
								end

								local alert = native.showAlert("MyUnitBuzz","Update the latest version from the Play Store" , { "Update"}, onComplete )


								

							end
					else

						AfterVersionCheck()
					
					end


				

		end


		

		if isAndroid then

			Webservice.GetLatestVersionCommonApp("android",get_versionFromWeb)

		elseif isIos then

			Webservice.GetLatestVersionCommonApp("ios",get_versionFromWeb)
		else

			Webservice.GetLatestVersionCommonApp("android",get_versionFromWeb)

		end

		

	elseif phase == "did" then


		end	

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