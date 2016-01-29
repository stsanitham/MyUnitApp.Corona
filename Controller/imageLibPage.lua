----------------------------------------------------------------------------------
--
-- img lib Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local widget = require( "widget" )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn
local  List_array = {}
local imageArray = {}

openPage="imageLibPage"



--------------------------------------------------


-----------------Function-------------------------



local function downloadAction(filename,file)


	native.showAlert( file, ResourceLibrary.Download_alert, { CommonWords.ok} )

			local localpath = system.pathForFile( filename, system.TemporaryDirectory )
						
					local path = system.pathForFile("/storage/sdcard1/"..filename)                         -- Change this path to the path of an image on your computer
					------------------------------------------------------------------------
					--------------------------- Read ----------------------------
						local file, reason = io.open( localpath, "r" )                               -- Open the image in read mode
						local contents
						if file then
						    contents = file:read( "*a" )                                        -- Read contents
						    io.close( file )                                                    -- Close the file (Important!)
						else
						    print("Invalid path")
						    return
						end

					--------------------------- Write ----------------------------
	
						local file = io.open( path, "w" )                                    -- Open the destination path in write mode
		
							if file then
							    file:write(contents)                                                -- Writes the contents to a file
							    io.close(file)                                                      -- Close the file (Important!)
							else
								path = system.pathForFile("/storage/sdcard0/"..filename)
								local file = io.open( path, "w" )                                    -- Open the destination path in write mode
								if file then
								    file:write(contents)                                                -- Writes the contents to a file
								    io.close(file)                                                      -- Close the file (Important!)
								else
								   path = system.pathForFile("/storage/sdcard/"..filename)
									local file = io.open( path, "w" )                                    -- Open the destination path in write mode
									if file then
										file:write(contents)                                                -- Writes the contents to a file
										io.close(file)                                                      -- Close the file (Important!)
									else
									    print("Error")
									    return
									 end
								 end
							end
	
end

local function showShare(fileNameString)

			
			    local popupName = "activity"
			    local isAvailable = native.canShowPopup( popupName )
			    local isSimulator = "simulator" == system.getInfo( "environment" )

			    local items =
			{
			    { type = "image", value = { filename = fileNameString, baseDir = system.TemporaryDirectory } },
			     --{ type = "UIActivityTypePostToFacebook", value = "UIActivityTypePostToFacebook" },
			      { type = "string", value = " " },

			}
						    -- If it is possible to show the popup
			    if isAvailable then
			        local listener = {}
			        function listener:popup( event )
			            print( "name(" .. event.name .. ") type(" .. event.type .. ") activity(" .. tostring(event.activity) .. ") action(" .. tostring(event.action) .. ")" )
			        end

			        -- Show the popup
			        native.showPopup( popupName,
			        {
			            items = items,
			            -- excludedActivities = { "UIActivityTypeCopyToPasteboard", },
			            listener = listener,
			            permittedArrowDirections={ "up", "down" }
			        })
			    else
			  
			            --native.showAlert( "Error", "Can't display the view controller. Are you running iOS 7 or later?", { "OK" } )
			        
			    end
			end


	local function share(fileName)



		print( "fileName : "..fileName )

		local isAvailable = native.canShowPopup( "social", "share" )

		    -- If it is possible to show the popup
		    if isAvailable then
		    	local listener = {}
		    	function listener:popup( event )
		    		 native.setKeyboardFocus(nil)
		    	end

		        -- Show the popup
		        native.showPopup( "social",
		        {
		            service = "share", -- The service key is ignored on Android.
		           -- message = "Images share test",
		            listener = listener,
		            image = 
		            {
		            { filename = fileName, baseDir = system.TemporaryDirectory },
		            },
		            
		            })
		    else
		 
		            --native.showAlert( "Cannot send share message.", "Please setup your share account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		       
		    end

		    	--showShare(fileName)

end

local function listTouchAction( event)
	
	print( event.filename )


local function networkListener( downloan_event )
	if ( downloan_event.isError ) then
		elseif ( downloan_event.phase == "began" ) then
			elseif ( downloan_event.phase == "ended" ) then
			spinner_hide()

				if event.id =="download" then
					
							downloadAction(downloan_event.response.filename,event.filename)


				elseif event.id =="share" then

						if isAndroid then

							share(downloan_event.response.filename)
							
						else

							showShare(downloan_event.response.filename)

						end

				end


			end
		end


local destDir = system.TemporaryDirectory 
local result, reason = os.remove( system.pathForFile( "imageLib.png", destDir ) )


spinner_show()

network.download(
	event.value,
	"GET",
	networkListener,
	event.value:match( "([^/]+)$" ),
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

    --local Lefticon = display.newImageRect(row,"res/assert/image-active.png",25,25)
    --Lefticon.x=30;Lefticon.y=rowHeight/2

    local Lefticon

    if List_array[row.index].FilePath ~= nil then

			Lefticon = display.newImageRect(row,"res/assert/twitter_placeholder.png",35,35)
			Lefticon.x=30;Lefticon.y=rowHeight/2
			print( List_array[row.index].ImageFileName )



			imageArray[#imageArray+1] = network.download(ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath,
				"GET",
				function ( img_event )
					if ( img_event.isError ) then
						print ( "Network error - download failed" )
					else
						if Lefticon then Lefticon:removeSelf();Lefticon=nil end

						print("response file "..img_event.response.filename)
						Lefticon = display.newImage(row,img_event.response.filename,system.TemporaryDirectory)
						Lefticon.width=35;Lefticon.height=35
						Lefticon.x=30;Lefticon.y=rowHeight/2
    				--event.row:insert(img_event.target)
    			end

    			end, List_array[row.index].FilePath:match( "([^/]+)$" ), system.TemporaryDirectory)
		else
			Lefticon = display.newImageRect(row,"res/assert/twitter_placeholder.png",35,35)
			Lefticon.x=30;Lefticon.y=rowHeight/2

		end



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


    local shareImg_bg = display.newRect(row,0,0,35,35)
    shareImg_bg.x=seprate_bg.x+25;shareImg_bg.y=seprate_bg.y
    shareImg_bg.id="share"
    shareImg_bg.alpha=0.01
    shareImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    shareImg_bg.filename = List_array[row.index].ImageFileName

    local shareImg = display.newImageRect(row,"res/assert/upload.png",15,15)
    shareImg.x=seprate_bg.x+25;shareImg.y=seprate_bg.y
    shareImg.id="share"
    shareImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    shareImg.filename = List_array[row.index].ImageFileName

    if isAndroid then

    local downImg_bg = display.newRect(row,0,0,25,25)
    downImg_bg.x=shareImg.x+30;downImg_bg.y=seprate_bg.y
    downImg_bg.id="download"
    downImg_bg.alpha=0.01
    downImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    downImg_bg.filename = List_array[row.index].ImageFileName

    local downImg = display.newImageRect(row,"res/assert/download.png",15,15)
    downImg.x=shareImg.x+30;downImg.y=seprate_bg.y
    downImg.id="download"
    downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath

    --work
    downImg.filename = List_array[row.index].ImageFileName
    downImg:addEventListener("touch",listTouch)
    downImg_bg:addEventListener("touch",listTouch)

	else

		seprate_bg.width = seprate_bg.contentWidth/2
		seprate_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
		shareImg_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
		shareImg.x=seprate_bg.x+seprate_bg.contentWidth/2

	end


    shareImg:addEventListener("touch",listTouch)
   
    shareImg_bg:addEventListener("touch",listTouch)
   

    row.ImageId = List_array[row.index].ImageId
    row.FilePath = List_array[row.index].FilePath

end

local function onRowTouch_ImageLib( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

	elseif ( "release" == phase ) then

			local options = {
			effect = "flip",
			time =100,
			params = { ImageList = List_array,count = row.index }
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

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )


	title = display.newText(sceneGroup,ImageLibrary.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then


		elseif phase == "did" then

			composer.removeHidden()

			ga.enterScene("Image Library")

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

			if #List_array == 0  then
				NoEvent = display.newText( sceneGroup, ImageLibrary.NoImage, 0,0,0,0,native.systemFontBold,16)
				NoEvent.x=W/2;NoEvent.y=H/2
				NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
			end


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