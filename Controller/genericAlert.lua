
genericAlert = {}
local W,H = display.contentWidth, display.contentHeight;
local leftPadding = 10
local genericButton = {}


function genericAlert.createNew(title,content,values,action)

	local AnimateGroup = display.newGroup( )

	local function TouchAction( event )

		if event.phase == "ended" then
				print( "touch action" )
				if event.target.id ~= 0 then 
					for i=1,#genericButton do
						genericButton[i]=nil
					end
					for j=AnimateGroup.numChildren, 1, -1 do 
		        		display.remove(AnimateGroup[AnimateGroup.numChildren])
		        		AnimateGroup[AnimateGroup.numChildren] = nil
		        	end
					for j=genericAlertGroup.numChildren, 1, -1 do 
		        		display.remove(genericAlertGroup[genericAlertGroup.numChildren])
		        		genericAlertGroup[genericAlertGroup.numChildren] = nil
		        	end


					if action ~= nil then
						action(event.target.id)
					end
				end


		end

		return true
	end

	Background = display.newImageRect(genericAlertGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.alpha = 0.35
	Background.id=0
	Background:addEventListener("touch",TouchAction)

	genericAlertGroup:insert( AnimateGroup )

	genericAlert_bg = display.newImageRect(AnimateGroup,"res/assert/alertbg.png", W-20, 60 )
	genericAlert_bg.x,genericAlert_bg.y = leftPadding_value + 140, H/2-11
	genericAlert_bg:setFillColor(1)


	genericAlert_content = display.newText(content,0,0,W-40,0,native.systemFont,14)
	genericAlert_content.x = 20
	genericAlert_content.anchorX= 0	
	genericAlert_content.anchorY= 0	
	genericAlert_content.y=genericAlert_bg.y-genericAlert_bg.contentHeight/2+10
	genericAlert_content:setFillColor(0,0,0,0.8)
	AnimateGroup:insert(genericAlert_content)



	if #values == 1 or #values == 2 then
		genericAlert_bg.height = genericAlert_bg.height + genericAlert_content.contentHeight+5
		genericAlert_content.y=genericAlert_bg.y-genericAlert_bg.contentHeight/2+10

			genericButton[#genericButton+1] = display.newText( values[1].content, 0,0,native.systemFont,14 )
			genericButton[#genericButton].anchorX=1;genericButton[#genericButton].anchorY=0
			genericButton[#genericButton].y=genericAlert_content.y+genericAlert_content.contentHeight+10
			genericButton[#genericButton].x=genericAlert_bg.x+genericAlert_bg.contentWidth/2-20
			genericButton[#genericButton]:setTextColor( Utils.convertHexToRGB(color.tabBarColor) )
			genericButton[#genericButton].id=1
			AnimateGroup:insert(genericButton[#genericButton])
			genericButton[#genericButton]:addEventListener( "touch", TouchAction )

		if #values == 2 then

				genericButton[#genericButton+1] = display.newText( values[2].content, 0,0,native.systemFont,14 )
				genericButton[#genericButton].anchorX=1;genericButton[#genericButton].anchorY=0
				genericButton[#genericButton].y=genericAlert_content.y+genericAlert_content.contentHeight+10
				genericButton[#genericButton].x=genericButton[#genericButton-1].x-genericButton[#genericButton-1].contentWidth-15
				genericButton[#genericButton]:setTextColor( Utils.convertHexToRGB(color.tabBarColor) )
				genericButton[#genericButton].id=2
				AnimateGroup:insert(genericButton[#genericButton])
				genericButton[#genericButton]:addEventListener( "touch", TouchAction )
		end

	else
		genericAlert_bg.height = genericAlert_bg.height + genericAlert_content.contentHeight+(15 * #values)
		genericAlert_content.y=genericAlert_bg.y-genericAlert_bg.contentHeight/2+10

		for i=1,#values do
				genericButton[#genericButton+1] = display.newText( values[i].content, 0,0,native.systemFont,14 )
				genericButton[#genericButton].anchorX=1;genericButton[#genericButton].anchorY=0
				if genericButton[#genericButton-1] ~= nil then 
					genericButton[#genericButton].y=genericButton[#genericButton-1].y+genericButton[#genericButton-1].contentHeight+10
				else
					genericButton[#genericButton].y=genericAlert_content.y+genericAlert_content.contentHeight+10
				end
				genericButton[#genericButton].x=genericAlert_bg.x+genericAlert_bg.contentWidth/2-20
				genericButton[#genericButton]:setTextColor( Utils.convertHexToRGB(color.tabBarColor) )
				genericButton[#genericButton].id=i
				AnimateGroup:insert(genericButton[#genericButton])
				genericButton[#genericButton]:addEventListener( "touch", TouchAction )
		end


	end

	local random = math.random( 1,2 )
	if random == 1 then
		AnimateGroup.y= -W+100
	else
		AnimateGroup.y=W+100
	end

		transition.to( AnimateGroup, {time=400,y=0,transition=easing.outBack} )


end

--[[	local option ={
			 {content="yes",positive=true},
			{content="no",positive=false}
			}
		genericAlert.createNew("MUB","Are you sure to delete?",option)]]
