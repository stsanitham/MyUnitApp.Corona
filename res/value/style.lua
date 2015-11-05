color = require("res.value.color")

--------sp_commonLabel-------
sp_commonLabel={}
sp_commonLabel.textSize = 16
sp_commonLabel.textColor = color.Black



-----------------EditBoxStyle---------------------------------

EditBoxStyle={}
EditBoxStyle.height = 40
EditBoxStyle.textSize = 15
EditBoxStyle.textColor = color.Black
EditBoxStyle.textColorHint = color.Black
EditBoxStyle.background = "assert/"

------------------CheckBoxStyle--------------------------------

CheckBoxStyle={}
CheckBoxStyle.paddingLeft = 17
CheckBoxStyle.textColor = color.checkBoxColor
CheckBoxStyle.textSize = 16
CheckBoxStyle.button = "assert/ckeckbox.png"


-------------------RadioButtonStyle----------------------------

RadioButtonStyle={}
RadioButtonStyle.height = 40
RadioButtonStyle.paddingLeft = 10
RadioButtonStyle.textSize = 16	
RadioButtonStyle.button = "assert/radioBtn.png"


--------------------sp_textfield_Outfocus - HeaderTextStyle-----------------------------

sp_textfield_Outfocus={}
sp_textfield_Outfocus.textSize = 22
sp_textfield_Outfocus.textStyle = "bold"
sp_textfield_Outfocus.textColor = color.White

---------------------sp_header - HeaderStyle---------------------------------

sp_header={}
sp_header.height = 45
sp_header.background = ""

---------------------SubHeaderTextStyle---------------------------

SubHeaderTextStyle={}
SubHeaderTextStyle.textSize = 20
SubHeaderTextStyle.textStyle = "bold"
SubHeaderTextStyle.textColor = color.Black

----------------------SubHeaderStyle------------------------------

SubHeaderStyle={}
SubHeaderStyle.height = 40
SubHeaderStyle.background = color.subHeader


-----------------------SubTitleTextStyle---------------------------

SubTitleTextStyle={}
SubTitleTextStyle.textSize = 17
SubTitleTextStyle.textStyle = "bold"
SubTitleTextStyle.textColor = color.Black

------------------------PopHeaderStyle-----------------------------

PopHeaderStyle={}
PopHeaderStyle.height = 45
PopHeaderStyle.background = color.popup_color


-------------------------VerticalLine------------------------------

VerticalLine={}
VerticalLine.width = 1
VerticalLine.background = color.sb__button_text_color

--------------------------HorizatalLine--------------------------

HorizatalLine = {}
HorizatalLine.height = 1
HorizatalLine.background = color.sb__button_text_color

------------------------SnackBar--------------------------------


SnackBar = {}
SnackBar.padding = 12
SnackBar.textStyle = "bold"
SnackBar.textColor = color.sb__button_text_color
SnackBar.textSize = 14
SnackBar.textAllCaps = true
SnackBar.editable = false
SnackBar.gravity = "center"	