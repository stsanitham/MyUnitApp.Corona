----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
require( "res.value.style" )
require( "Webservice.ServiceManager" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local specialRecognitionListArray = {}

local BackFlag = false

openPage="specialRecognition"


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



local function onTimer ( event )

	print( "event time completion" )

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







local function Background_Touch( event )

	if event.phase == "began" then
		
		display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

		    local options = {
							effect = "flipFadeOutIn",
							time = 200,	
							params = { specialRecognition_Details = event.target.value, specialRecognition_id = event.target.id}
						 }

		    composer.showOverlay( "Controller.specialRecognitionDetailPage", options )

			
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

		title = display.newText(sceneGroup,CommonWords.SpecialRecognitionText,0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=5;title.y = title_bg.y
		title:setFillColor(0)

		NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent , 0,0,0,0,native.systemFontBold,16)
		NoEvent.x=W/2;NoEvent.y=H/2
		NoEvent.isVisible=false
		NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )


MainGroup:insert(sceneGroup)

end





function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		 function SpecialRecognitionList( list )

				for j=#specialRecognitionListArray, 1, -1 do 
					
					display.remove(specialRecognitionListArray[#specialRecognitionListArray])
					specialRecognitionListArray[#specialRecognitionListArray] = nil
				end

				for i=1, #list do

			        print(" special recognition list here ")

					specialRecognitionListArray[#specialRecognitionListArray+1] = display.newGroup()

					local tempGroup = specialRecognitionListArray[#specialRecognitionListArray]

					local tempHeight = title_bg.y + 30

					local background = display.newRect(tempGroup,0,0,W,18)

					if(specialRecognitionListArray[#specialRecognitionListArray-1]) ~= nil then
						tempHeight = specialRecognitionListArray[#specialRecognitionListArray-1][1].y + specialRecognitionListArray[#specialRecognitionListArray-1][1].height+15
					end

					background.anchorY = 0
					background.x=W/2;background.y=tempHeight
					background.id=list[i].SpecialRecognitionId
					background.alpha=0.01
					background.value = list[i]
					print( "Listy : "..json.encode(list[i]) )


					rightArrowPointer = display.newImageRect( sceneGroup, "res/assert/rightarrow.png", 20,20 )
					rightArrowPointer.x=25;
					rightArrowPointer.y=background.y+background.height/2-1
					rightArrowPointer.id="specialRecognition_arrow"
					rightArrowPointer.isVisible = true


					local GroupName_txt = display.newText(tempGroup,list[i].ReportName,0,0,native.systemFont,14)
					GroupName_txt.x=rightArrowPointer.x+25;GroupName_txt.y=background.y+background.height/2-2
					GroupName_txt.anchorX=0
					Utils.CssforTextView(GroupName_txt,sp_labelName)
					GroupName_txt:setFillColor(0,0,0)

					sceneGroup:insert(tempGroup)

					background:addEventListener( "touch", Background_Touch )

				end
				
		  end




		 function getAllSpecialRecognition(response )

			specialRecognition_response = response

					if specialRecognition_response ~= nil and #specialRecognition_response ~= 0 then
							
							NoEvent.text = ""

							SpecialRecognitionList(specialRecognition_response)

					else

							NoEvent.isVisible=true

					end
			end


		Webservice.GetAllSpecialRecognitions(getAllSpecialRecognition)



	elseif phase == "did" then

		menuBtn:addEventListener("touch",menuTouch)

		Runtime:addEventListener( "key", onKeyEvent )
		
	end	
	
MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then


		Runtime:removeEventListener( "key", onKeyEvent )


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