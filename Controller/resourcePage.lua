----------------------------------------------------------------------------------
--
-- resource Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local lfs = require("lfs")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="resourcePage"



--------------------------------------------------


-----------------Function-------------------------


local function downloadAction(filename)

			local localpath = system.pathForFile( filename, system.TemporaryDirectory )
						
					local path = system.pathForFile("/storage/sdcard1/"..filename)    

					--------------------------- Read ----------------------------
						local file, reason = io.open( localpath, "r" )                              
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

							native.showAlert( filename, ResourceLibrary.Download_alert, { CommonWords.ok} )

end

local function showShare(fileNameString)


			    local popupName = "quickLook"
			    local isAvailable = native.canShowPopup( popupName )
			    local isSimulator = "simulator" == system.getInfo( "environment" )

			    local items =
			{
			    { type = "url", value = { filename = fileNameString, baseDir = system.TemporaryDirectory } },
			     --{ type = "UIActivityTypePostToFacebook", value = "UIActivityTypePostToFacebook" },
			      { type = "string", value = " " },

			}
						    -- If it is possible to show the popup
			    if isAvailable then
			        

			        local popupOptions = 
						    {
						        files =  -- Files you wish to load into the quick look preview
						        { 
						            { filename=fileNameString, baseDir=system.TemporaryDirectory },
						      
						        },
						        startIndex = 1,  -- The file you wish to start the preview at; default is 1
						        listener = quickLookListener  -- Callback listener
						    }

						    -- Show the quick look popup
						    native.showPopup( "quickLook", popupOptions )

			    else
			  
			            --native.showAlert( "Error", "Can't display the view controller. Are you running iOS 7 or later?", { "OK" } )
			        
			    end
end

local function share(fileName)
		local isAvailable = native.canShowPopup( "social", "share" )

		print( "fileName : "..fileName )

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
		            --message = "Images share test",
		            listener = listener,
		            image = 
		            {
		            { filename = fileName, baseDir = system.TemporaryDirectory },
		            },
		            
		            })
		    else
		 
		            --native.showAlert( "Cannot send share message.", "Please setup your share account or check your network connection (on android this means that the package/app (ie Twitter) is not installed on the device)", { "OK" } )
		       
		    end

end


local function listTouchAction( event)
	
local tempreverse = string.find(string.reverse( event.value ),"%.")
fileExt = event.value:sub( event.value:len()-tempreverse+2,event.value:len())

local function networkListener( downloan_event )
	if ( downloan_event.isError ) then
		elseif ( downloan_event.phase == "began" ) then
			elseif ( downloan_event.phase == "ended" ) then
			spinner_hide()


				if event.id =="download" then
					

							downloadAction(downloan_event.response.filename)


				elseif event.id =="share" then

						if isAndroid then

							share(downloan_event.response.filename)
							
						else

							showShare(downloan_event.response.filename)

						end

				end


			end
		end

		spinner_show()

local destDir = system.TemporaryDirectory 
local result, reason = os.remove( system.pathForFile( "imageLib.png", destDir ) )


network.download(
	event.value,
	"GET",
	networkListener,
	event.filename,
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


local function onRowRender_DocLib( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local tempValue = ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath

    local tempreverse = string.find(string.reverse( tempValue ),"%.")

	fileExt = tempValue:sub( tempValue:len()-tempreverse+2,tempValue:len())

	print( "file ext : "..fileExt )

	if fileExt == "png" or fileExt == "jpg" or fileExt == "jpeg" or fileExt == "gif" or fileExt == "bmp" or fileExt == "tif" then

		tempValue="res/assert/image-active.png"

	elseif fileExt == "doc" or fileExt == "docx" or fileExt == "txt" or fileExt == "xls"  or fileExt == "xlsx" or fileExt == "ppt"  or fileExt == "pptx"  or fileExt == "xps"  or fileExt == "pps" or fileExt == "wma" or fileExt == "pub" or fileExt == "js" or fileExt == "swf" or fileExt == "xml" or fileExt == "html" or fileExt == "htm" or fileExt == "rtf"  then

			tempValue="res/assert/word-active.png"

	elseif fileExt == "pdf" then

			tempValue="res/assert/pdf-active.png"

	elseif fileExt == "mpg" or fileExt == "au" or fileExt == "aac" or fileExt == "aif" or fileExt == "gsm" or fileExt == "mid" or fileExt == "mp3" or fileExt == "rm"  or fileExt == "wav" then

		tempValue="res/assert/audio.png"
	
	elseif fileExt == "mpeg" or fileExt == "avi" then

		tempValue="res/assert/video.png"

	else

		tempValue="res/assert/image-active.png"

	end

    local Lefticon = display.newImageRect(row,tempValue,25,25)
    Lefticon.x=30;Lefticon.y=rowHeight/2


    local text = display.newText(row,List_array[row.index].DocumentFileName,0,0,native.systemFont,16)
    text.x=Lefticon.x+Lefticon.contentWidth/2+10;text.y=rowHeight/2
    text.anchorX=0
    text:setFillColor(Utils.convertHexToRGB(color.Black))


    local seprate_bg = display.newRect(row,0,0,120,rowHeight)
    seprate_bg.anchorX=0
    seprate_bg.x=W/2+80;seprate_bg.y=rowHeight/2-1
    seprate_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


    local shareImg_bg = display.newRect(row,0,0,50,35)
    shareImg_bg.x=seprate_bg.x+25;shareImg_bg.y=seprate_bg.y
    shareImg_bg.id="share"
    shareImg_bg.alpha=0.01
    shareImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    shareImg_bg.filename = List_array[row.index].DocumentFileName

    local shareImg = display.newImageRect(row,"res/assert/upload.png",15,15)
    shareImg.x=seprate_bg.x+25;shareImg.y=seprate_bg.y
    shareImg.id="share"
    shareImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    shareImg.filename = List_array[row.index].DocumentFileName





    if isAndroid then

    	    local downImg_bg = display.newRect(row,0,0,45,35)
    downImg_bg.x=shareImg_bg.x+shareImg_bg.contentWidth/2+downImg_bg.contentWidth/2;downImg_bg.y=seprate_bg.y
    downImg_bg.id="download"
    downImg_bg.alpha=0.01
    downImg_bg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    downImg_bg.filename = List_array[row.index].DocumentFileName

   local downImg = display.newImageRect(row,"res/assert/download.png",15,15)
    downImg.x=shareImg.x+40;downImg.y=seprate_bg.y
    downImg.id="download"
    downImg.value=ApplicationConfig.IMAGE_BASE_URL..""..List_array[row.index].FilePath
    downImg.filename =  List_array[row.index].DocumentFileName


    local line = display.newRect(row,W/2,rowHeight/2,W+30,1.1)
    line.y=rowHeight-1.1
    line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


    downImg:addEventListener("touch",listTouch)
    downImg_bg:addEventListener("touch",listTouch)
	else

		seprate_bg.width = seprate_bg.contentWidth/2
		seprate_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
		shareImg_bg.x=seprate_bg.x+seprate_bg.contentWidth/2
		shareImg.x=seprate_bg.x+seprate_bg.contentWidth/2
	end

	   shareImg_bg:addEventListener("touch",listTouch)
    shareImg:addEventListener("touch",listTouch)

    row.ImageId = List_array[row.index].DocumentCategoryId
    row.FilePath = List_array[row.index].FilePath
    row.fileName = List_array[row.index].DocumentFileName

end

local function onRowTouch_DocLib( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then


	system.openURL( ApplicationConfig.IMAGE_BASE_URL..row.FilePath )

	--composer.gotoScene( "Controller.imageSlideView", options )


	elseif ( "release" == phase ) then



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


	title = display.newText(sceneGroup,ResourceLibrary.PageTitle,0,0,native.systemFont,18)
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

			ga.enterScene("Resource Library")

			function get_allDocument(response)

				List_array=response

				Document_Lib_list = widget.newTableView
				{
				left = -10,
				top = 75,
				height = H-75,
				width = W+10,
				onRowRender = onRowRender_DocLib,
				onRowTouch = onRowTouch_DocLib,
				hideBackground = true,
				isBounceEnabled = false,
			--noLines = true,
		}

		sceneGroup:insert(Document_Lib_list)

		if #List_array == 0  then
				NoEvent = display.newText( sceneGroup, ResourceLibrary.NoDocument, 0,0,0,0,native.systemFontBold,16)
				NoEvent.x=W/2;NoEvent.y=H/2
				NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
		end

		for i = 1, #List_array do
		    -- Insert a row into the tableView
		    Document_Lib_list:insertRow{ rowHeight = 45,rowColor = 
		    {
		    default = { 1, 1, 1, 0 },
		    over={ 1, 0.5, 0, 0 },

		    }}
		end

	end

	List_array = Webservice.GET_ALL_MYUNITAPP_DOCUMENT(get_allDocument)





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