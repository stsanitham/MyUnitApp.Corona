----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )


local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,title

local menuBtn

openPage="inviteAndaccessPage"

local RecentTab_Topvalue = 110

local groupArray={}

local feedArray={}

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


local function Createmenu( object )

local menuGroup = display.newGroup( )
	
	print( "here" )
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

		 	Blockbtn_txt = display.newText( menuGroup, "Block",0,0,native.systemFont,12 )
		 	Blockbtn_txt:setFillColor( 0.2 )
		 	Blockbtn_txt.x=Blockbtn.x;Blockbtn_txt.y=Blockbtn.y+Blockbtn.contentHeight/2


		elseif status == "DENY" then

			Grantbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Grantbtn.anchorY=0
		 	Grantbtn.y=menuBg.y+5;Grantbtn.x=menuBg.x
		 	Grantbtn:setFillColor( 0.4 )
		 	Grantbtn.alpha=0.01
		 	Grantbtn.id = "grant"
		 	Grantbtn.value = object.value

		 	Grantbtn_txt = display.newText( menuGroup, "Grant",0,0,native.systemFont,12 )
		 	Grantbtn_txt:setFillColor( 0.2 )
		 	Grantbtn_txt.x=Grantbtn.x;Grantbtn_txt.y=Grantbtn.y+Grantbtn.contentHeight/2

		 	removebtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	removebtn.anchorY=0
		 	removebtn.y=Grantbtn.y+Grantbtn.contentHeight+5;removebtn.x=menuBg.x
		 	removebtn:setFillColor( 0.4 )
		 	removebtn.alpha=0.01
		 	removebtn.id="remove"
		 	removebtn.value = object.value

		 	removebtn_txt = display.newText( menuGroup, "Remove",0,0,native.systemFont,12 )
		 	removebtn_txt:setFillColor( 0.2 )
		 	removebtn_txt.x=removebtn.x;removebtn_txt.y=removebtn.y+removebtn.contentHeight/2

		elseif status == "OPEN" then

			Grantbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Grantbtn.anchorY=0
		 	Grantbtn.y=menuBg.y+5;Grantbtn.x=menuBg.x
		 	Grantbtn:setFillColor( 0.4 )
		 	Grantbtn.alpha=0.01
		 	Grantbtn.id="grant"
		 	Grantbtn.value = object.value

		 	Grantbtn_txt = display.newText( menuGroup, "Grant",0,0,native.systemFont,12 )
		 	Grantbtn_txt:setFillColor( 0.2 )
		 	Grantbtn_txt.x=Grantbtn.x;Grantbtn_txt.y=Grantbtn.y+Grantbtn.contentHeight/2

		 	denybtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	denybtn.anchorY=0
		 	denybtn.y=Grantbtn.y+Grantbtn.contentHeight+5;denybtn.x=menuBg.x
		 	denybtn:setFillColor( 0.4 )
		 	denybtn.alpha=0.01
		 	denybtn.id="deny"
		 	denybtn.value = object.value

		 	denybtn_txt = display.newText( menuGroup, "Deny",0,0,native.systemFont,12 )
		 	denybtn_txt:setFillColor( 0.2 )
		 	denybtn_txt.x=denybtn.x;denybtn_txt.y=denybtn.y+denybtn.contentHeight/2

		 elseif status == "ADDREQUEST" then
			Provideacessbtn = display.newRect(menuGroup,0,0,menuBg.width,25)
		 	Provideacessbtn.anchorY=0
		 	Provideacessbtn.y=menuBg.y+5;Provideacessbtn.x=menuBg.x
		 	Provideacessbtn:setFillColor( 0.4 )
		 	Provideacessbtn.alpha=0.01
		 	Provideacessbtn.id="provideaccess"
		 	Provideacessbtn.value = object.value

		 	Provideacess_txt = display.newText( menuGroup, "Provide Access",0,0,native.systemFont,12 )
		 	Provideacess_txt:setFillColor( 0.2 )
		 	Provideacess_txt.x=Provideacessbtn.x;Provideacess_txt.y=Provideacessbtn.y+Provideacessbtn.contentHeight/2

		 	

		end
	return menuGroup

end

local function ListmenuTouch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			--Createmenu(event.target)

		

			local group = groupArray[event.target.id]

			if group[group.numChildren].isVisible == true then

				group[group.numChildren].isVisible = false

			else

				-- for(i=1,group.numChildren) do

				-- 	group[i].isVisible = true

				-- end

				group[group.numChildren].isVisible = true
			end

	end

return true

end


local function onRowRender( event )

print( "#########" )
 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( row, inviteArray[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 25
    rowTitle.y = rowHeight * 0.5

    row.name = inviteArray[row.index]




end

local function onRowTouch( event )

 -- Get reference to the row group
 local phase = event.phase
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    	if "press" == phase then
                print( "Pressed row: " .. row.index )

        elseif "release" == phase then
		    inviteList.isVisible=false
		    List_bg.isVisible=false

		    if row.name == titleValue.text then

		    else
		    	status = StatusArray[row.index]
		    	titleValue.text = row.name
		    	Webservice.GetMyUnitBuzzRequestAccesses(StatusArray[row.index],get_GetMyUnitBuzzRequestAccesses)

		    end

		end

	


end

local function CreateList(list,scrollView)

	local feedArray = list

	for j=#groupArray, 1, -1 do 
		display.remove(groupArray[#groupArray])
		groupArray[#groupArray] = nil
	end

	for i=1,#feedArray do


			groupArray[#groupArray+1] = display.newGroup()

			local tempGroup = groupArray[#groupArray]
			local bgheight = 100
			
		
			local background = display.newRect(tempGroup,0,0,W-10,bgheight)
			local Initial_Height = 1

			if(groupArray[#groupArray-1]) ~= nil then
				Initial_Height = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].height+2.5
			end

			background.anchorY = 0
			background.anchorX = 0
			background.x=5;background.y=Initial_Height
			background.strokeWidth = 1
			background:setStrokeColor( Utils.convertHexToRGB("#d2d3d4") )
			background:setFillColor(1)


			local list_bg = display.newRect( tempGroup, 0, 0, 35, 35 )
			list_bg:setFillColor( 0.3 )
			local list = display.newImageRect( tempGroup, "res/assert/list.png",8/2,34/2)
		    list.x = background.x+background.contentWidth-10
		    list.y=background.y+5
		    list.anchorY=0
		    list_bg.x=list.x-5
		    list_bg.y=list.y+5
		    list_bg.alpha=0.01
		    list_bg.value = feedArray[i]
		    list_bg.id=i
		    list_bg:addEventListener( "touch", ListmenuTouch )


			local Name = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			Name.anchorX=0;Name.anchorY=0
			Name.x=background.x+5;Name.y=background.y+5
			Name:setFillColor( 0.3 )

			if feedArray[i].FirstName ~= nil then

				Name.text = "Name : "..feedArray[i].LastName..", "..feedArray[i].FirstName

			else

				Name.text = "Name : "..feedArray[i].LastName

			end

			local Email = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			Email.anchorX=0;Email.anchorY=0
			Email.x=background.x+5;Email.y=Name.y+Name.contentHeight+5
			Email:setFillColor( 0.3 )

			if feedArray[i].EmailAddress ~= nil then

				Email.text = "EmailAddress : "..feedArray[i].EmailAddress

			end

			local Phone = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			Phone.anchorX=0;Phone.anchorY=0
			Phone.x=background.x+5;Phone.y=Email.y+Email.contentHeight+5
			Phone:setFillColor( 0.3 )

			if feedArray[i].PhoneNumber ~= nil then

				Phone.text = "Phone : "..feedArray[i].PhoneNumber

			end

			local MKRank = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			MKRank.anchorX=0;MKRank.anchorY=0
			MKRank.x=background.x+5;MKRank.y=Phone.y+Phone.contentHeight+5
			MKRank:setFillColor( 0.3 )

			if feedArray[i].MkRankLevel ~= nil then

				MKRank.text = "MKRank : "..feedArray[i].MkRankLevel
			else

				MKRank.text = "MKRank : "
			end

			local ActiveOn = display.newText(tempGroup,"",0,0,W-20,0,native.systemFont,11)
			ActiveOn.anchorX=0;ActiveOn.anchorY=0
			ActiveOn.x=background.x+5;ActiveOn.y=MKRank.y+MKRank.contentHeight+5
			ActiveOn:setFillColor( 0.3 )

			if feedArray[i].MkRankLevel ~= nil then

				local time = Utils.makeTimeStamp(feedArray[i].UpdateTimeStamp)

				
				ActiveOn.text = "Activity On : "..tostring(os.date("%m/%d/%Y %I:%m %p",time))

			end

			   group =  Createmenu(list_bg)

   				tempGroup:insert( group )

   				group.isVisible=false

			scrollView:insert(tempGroup)


	end

end

local function TouchAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
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

	title = display.newText(sceneGroup,"Invite/Access",0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


		titleDropdown = display.newRect( W/2, 80, W-10, 28)
		titleDropdown.id="title"
		titleDropdown.anchorY=0
		titleDropdown.alpha=0.01
		sceneGroup:insert(titleDropdown)
		titleDropdown:addEventListener( "touch", TouchAction )

		titleValue = display.newText(sceneGroup,"Contacts with Access",titleDropdown.x-titleDropdown.contentWidth/2+15,titleDropdown.y,native.systemFont,14 )
		titleValue.alpha=0.7
		titleValue.anchorX=0
		titleValue:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		titleValue.x=15
		titleValue.y=titleDropdown.y+titleDropdown.contentHeight/2

	  	SelectEvent_icon = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2 )
	  	SelectEvent_icon.x=titleDropdown.x+titleDropdown.contentWidth/2-15
	  	SelectEvent_icon.y=titleValue.y

		BottomImage = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		BottomImage.x=W/2;BottomImage.y=titleValue.y+titleValue.contentHeight-5


	MainGroup:insert(sceneGroup)
end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		composer.removeHidden()

	elseif phase == "did" then


		scrollView = widget.newScrollView
					{
					top = RecentTab_Topvalue,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue,
					hideBackground = true,
					isBounceEnabled=true,
					horizontalScrollDisabled = true,
			   		scrollWidth = W,
					bottomPadding = 60,
		   			listener = Facebook_scrollListener,
		}


	
		

		inviteList = widget.newTableView(
		    {
		        left = 5,
		        top = 0,
		        height = 160,
		        width = 300,
		        onRowRender = onRowRender,
		        onRowTouch = onRowTouch,
		        hideBackground = false,
		        isBounceEnabled = false,
		        noLines = true,

		       -- listener = scrollListener
		    }
		)

	  	inviteList.anchorY=0
	  	inviteList.y=titleDropdown.y+titleDropdown.contentHeight
	  	sceneGroup:insert( inviteList )
	  	inviteList.isVisible = false

	  	List_bg = display.newRect(200, 200, 104, 304 )
		List_bg:setFillColor( 0 )
		sceneGroup:insert( List_bg )
	  	List_bg.anchorY = 0
	  	List_bg.isVisible = false
	  	List_bg.x=inviteList.x
	  	List_bg.y=inviteList.y
	  	List_bg.width = inviteList.width+2
	  	List_bg.height = inviteList.height+1


			for i = 1, #inviteArray do
		    -- Insert a row into the tableView
		    inviteList:insertRow{ rowHeight = 40,rowColor = 
		    {
		    default = { 1, 1, 1, 0 },
		    over={ 1, 0.5, 0, 0 },

		    }}
		end

	  	

sceneGroup:insert(scrollView)


		function get_GetMyUnitBuzzRequestAccesses(response)

			CreateList(response,scrollView)

		end

		Webservice.GetMyUnitBuzzRequestAccesses("GRANT",get_GetMyUnitBuzzRequestAccesses)

		menuBtn:addEventListener("touch",menuTouch)
		
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