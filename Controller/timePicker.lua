
timePicker = {}
local widget = require( "widget" )
local W = display.contentWidth;H= display.contentHeight


local Min = {}
	local Hour = {}
	for i = 1,60 do Min[i] = i end
	for j = 1,12 do Hour[j] = j end

	local columnData = { 
		{
			align = "right",
			width = 125,
			startIndex = 5,
			labels = Hour,
		},
		{
			align = "center",
			width = 70,
			startIndex = 18,
			labels = Min,
		},
		{
			align = "center",
			width = 65,
			startIndex = 2,
			labels = {"AM","PM"},
		},
	}



	



timePicker.getTimeValue = function(listner)


	local getValuesButton,pickerWheel,doneBg

local function showValues( event )
		-- Retrieve the current values from the picker
		local values = pickerWheel:getValues()
		
		-- Update the status box text
		--statusText.text = "Column 1 Value: " .. values[1].value .. "\nColumn 2 Value: " .. values[2].value .. "\nColumn 3 Value: " .. values[3].value
		--[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			print( "Column", i, "index is:", values[i].index )
		end
		--]]
		display.remove(doneBg);doneBg=nil
		display.remove(getValuesButton);getValuesButton=nil
		display.remove(pickerWheel);pickerWheel=nil
		listner(values[1].value..":"..values[2].value.." "..values[3].value)
		
		return true
	end



	pickerWheel = widget.newPickerWheel {
		top = display.contentHeight-200,
		columns = columnData
	}
	pickerWheel.x = display.contentCenterX

	doneBg = display.newRect(W/2,0,W,35)
	doneBg:setFillColor( 1 )
	doneBg.x=W/2;doneBg.y=pickerWheel.y-pickerWheel.contentHeight/2

	getValuesButton = widget.newButton {
		left = 10,
		top = 135,
		width = 192,
		height = 32,
		id = "Done",
		label = "Done",
		onRelease = showValues,
	}
	getValuesButton.x = W-80
	getValuesButton.y = doneBg.y



end


return timePicker