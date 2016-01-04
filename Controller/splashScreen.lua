----------------------------------------------------------------------------------
--
-- Splash Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
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

			local found=false
			db:exec([[select * from sqlite_master where name='logindetails';]],
			function(...) found=true return 0 end)

			if found then 
				print('table exists!')
				for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

					loginFlag=true

					Director_Name = row.MemberName

					EmailAddress = row.MemberEmail
					
				end

				profileName.text=Director_Name

					if EmailAddress ~= nil then

							local EmailTxt = EmailAddress

								if EmailTxt:len() > 26 then

									EmailTxt= EmailTxt:sub(1,26).."..."

								end

						profileEmail.text = EmailTxt

						end



					local options = {
						effect = "slideLeft",
						time =500,

					}


				composer.gotoScene( "Controller.eventCalenderPage", options )

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

		Webservice.GET_SEARCHBY_UnitNumberOrDirectorName("1",get_GetSearchByUnitNumberOrDirectorName)



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