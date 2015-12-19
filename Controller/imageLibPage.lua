----------------------------------------------------------------------------------
--
-- img lib Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
require( "Parser.GET_ALL_MYUNITAPP_IMAGE" )
local widget = require( "widget" )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn
local  List_array = {}

openPage="imageLibPage"



--------------------------------------------------


-----------------Function-------------------------
local function listTouchAction( event)
	
	local function share()
		local isAvailable = native.canShowPopup( "social", "facebook" )

    -- If it is possible to show the popup
    if isAvailable then
    	local listener = {}
    	function listener:popup( event )
    	end

        -- Show the popup
        native.showPopup( "social",
        {
            service = "facebook", -- The service key is ignored on Android.
            message = "Images share test",
            listener = listener,
            image = 
            {
            { filename = "imageLib.png", baseDir = system.TemporaryDirectory },
            },
            
            })
    else
    	if environment == "simulator" then
    		native.showAlert( "Build for device", "This plugin is not supported on the Corona Simulator, please build for an iOS/Android device or the Xcode simulator", { "OK" } )
    	else
            -- Popup isn't available.. Show error message
            native.showAlert( "Cannot send share message.", "Please setup your share account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
        end
    end

end

local function networkListener( downloan_event )
	if ( downloan_event.isError ) then
		elseif ( downloan_event.phase == "began" ) then
			elseif ( downloan_event.phase == "ended" ) then
			spinner_hide()
			if event.id == "share" then
				print("share")
				share()
				elseif event.id =="download" then
					print("download")
					local sdImg = display.newImage( "imageLib.png",system.TemporaryDirectory )
					sdImg.alpha = 0.01
					sdImg.x=W/2;sdImg.y=H/2

					local function captureWithDelay()
						local capture = display.capture( sdImg )
						sdImg:removeSelf();sdImg=nil
						--capture:removeSelf();capture=nil
					end

					timer.performWithDelay( 100, captureWithDelay )


				end


			end
		end

		spinner_show()
		print(event.value)

local destDir = system.TemporaryDirectory  -- Location where the file is stored
local result, reason = os.remove( system.pathForFile( "imageLib.png", destDir ) )

network.download(
	event.value,
	"GET",
	networkListener,
	"imageLib.png",
	system.TemporaryDirectory
	)




end
local function listTouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		listTouchAction(event.target)

	end

	return true
end
local function onRowRender_ImageLib( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local Lefticon = display.newImageRect(row,"res/assert/user.png",15,15)
    Lefticon.x=30;Lefticon.y=rowHeight/2

    local text = display.newText(row,List_array[row.index].ImageFileName,0,0,native.systemFont,16)
    text.x=Lefticon.x+Lefticon.contentWidth+10;text.y=rowHeight/2
    text.anchorX=0
    text:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

    local seprate_bg = display.newRect(row,0,0,120,rowHeight)
    seprate_bg.anchorX=0
    seprate_bg.x=W/2+80;seprate_bg.y=rowHeight/2-1
    seprate_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


    local line = display.newRect(row,W/2,rowHeight/2,W,1.1)
    line.y=rowHeight-1.1
    line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


    local shareImg_bg = display.newRect(row,0,0,25,25)
    shareImg_bg.x=seprate_bg.x+25;shareImg_bg.y=seprate_bg.y
    shareImg_bg.id="share"
    shareImg_bg.alpha=0.01
    shareImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath

    local shareImg = display.newImageRect(row,"res/assert/upload.png",15,15)
    shareImg.x=seprate_bg.x+25;shareImg.y=seprate_bg.y
    shareImg.id="share"
    shareImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath


    local downImg_bg = display.newRect(row,0,0,25,25)
    downImg_bg.x=shareImg.x+30;downImg_bg.y=seprate_bg.y
    downImg_bg.id="download"
    downImg_bg.alpha=0.01
    downImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath

    local downImg = display.newImageRect(row,"res/assert/download.png",15,15)
    downImg.x=shareImg.x+30;downImg.y=seprate_bg.y
    downImg.id="download"
    downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath

    shareImg:addEventListener("touch",listTouch)
    downImg:addEventListener("touch",listTouch)
    shareImg_bg:addEventListener("touch",listTouch)
    downImg_bg:addEventListener("touch",listTouch)

    row.ImageId = List_array[row.index].ImageId
    row.FilePath = List_array[row.index].FilePath

end

local function onRowTouch_ImageLib( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

		

		elseif ( "release" == phase ) then
			print("FilePath : "..row.FilePath)

			local options = {
			effect = "flip",
			time =100,
			params = { FilePath = row.FilePath }
		}

		composer.showOverlay( "Controller.imageSlideView", options )


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

	title = display.newText(sceneGroup,"Image Library",0,0,native.systemFont,18)
	title.anchorX = 0 ;title.anchorY=0
	title.x=5;title.y = tabBar.y+tabBar.contentHeight/2+10
	title:setFillColor(0)

	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then


		elseif phase == "did" then

			composer.removeHidden()

			function get_Allimage(response)
				List_array = response

				Image_Lib_list = widget.newTableView
				{
				left = 0,
				top = 75,
				height = H-75,
				width = W,
				onRowRender = onRowRender_ImageLib,
				onRowTouch = onRowTouch_ImageLib,
				hideBackground = true,
				isBounceEnabled = false,
				noLines = true,
			}

			sceneGroup:insert(Image_Lib_list)

			for i = 1, #List_array do
		    -- Insert a row into the tableView
		    Image_Lib_list:insertRow{ rowHeight = 40,rowColor = 
		    {
		    default = { 1, 1, 1, 0 },
		    over={ 1, 0.5, 0, 0 },

		    }}
		end
	end

	Webservice.GET_ALL_MYUNITAPP_IMAGE(get_Allimage)



	menuBtn:addEventListener("touch",menuTouch)
	BgText:addEventListener("touch",menuTouch)


end	

MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then


		elseif phase == "did" then

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

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