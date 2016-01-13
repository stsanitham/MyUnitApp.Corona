----------------------------------------------------------------------------------
--
-- Splash Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local style = require("res.value.style")
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

		--timer.performWithDelay( 2000, SplashTimeOut )

		function get_GetSearchByUnitNumberOrDirectorName(response)

			--list_response_total = response

			UnitnumberList = response


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



					local options = {
						effect = "slideLeft",
						time =500,

					}


				--composer.gotoScene( "Controller.eventCalenderPage", options )

				composer.gotoScene( "Controller.flapMenu" )


			else

				print('not table exists!')

				local options = {
						    effect = "slideLeft",
						    time = Splash_TimeOut,
						    params = { responseValue=response}
						}


						composer.gotoScene( "Controller.singInPage", options )

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

								Webservice.GET_SEARCHBY_UnitNumberOrDirectorName("1",get_GetSearchByUnitNumberOrDirectorName)

							else

								if isAndroid then 

									system.openURL( "https://play.google.com/store/apps/details?id=com.spanenterprises.myunitbuzz" )

									os.exit()

								elseif isIos then
									system.openURL( "https://itunes.apple.com/in/app/myunitbuzz/id1068478993?mt=8" )
								end

							end
					else

						Webservice.GET_SEARCHBY_UnitNumberOrDirectorName("1",get_GetSearchByUnitNumberOrDirectorName)

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