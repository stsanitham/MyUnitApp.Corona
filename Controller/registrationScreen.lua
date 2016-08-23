----------------------------------------------------------------------------------
--
-- Registration Screen
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
require( "Controller.genericAlert" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,backBtn_bg,backBtn_intro,backBtn_bg_intro

local menuBtn

local List , scrollView

local RecentTab_Topvalue = 70

local countryArray = {}

local countryArrayDetail = {}

--local countryArray = RegistrationScreen.countryArray

--local languageArray = RegistrationScreen.languageArray

--local languageArray1 = RegistrationScreen.languageArray1

local languageArray = {}

local languageArrayDetail = {}

local positionArray = RegistrationScreen.positionArray

local refresh_list

local leftPadding = 15

local BackFlag = false

openPage="registartionScreen"


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




local function SetError( displaystring, object )

  object.text=displaystring
  object.size=10
  object:setTextColor(1,0,0)


end



local function onKeyEvent( event )

  local phase = event.phase
  local keyName = event.keyName

  if phase == "up" then

    if keyName=="back" then

      if BackFlag == false then

       if initialvalue == "introduction" then

        local options = {
          effect = "slideRight",
          time = 300,   
        }

        composer.gotoScene( "Controller.singInPage", options )

        return true

      else

        Utils.SnackBar(ChatPage.PressAgain)

        BackFlag = true

        timer.performWithDelay( 3000, onTimer )

        return true


      end


    elseif BackFlag == true then

      if initialvalue == "createaccount" then

       os.exit() 

     end

   end


   
 end

end

return false
end





local function touchBg( event )
  if event.phase == "began" then

    elseif event.phase == "ended" then

    native.setKeyboardFocus(nil)

  end
  return true
end






local function onRowRender( event )

local row = event.row

local rowHeight = row.contentHeight
local rowWidth = row.contentWidth

local rowTitle
local renderArray

renderArray = List.arrayName

    ------------------ to set the list of array items in the list ------------------------

    rowTitle = display.newText( row, renderArray[row.index].name, 0, 0, nil, 14 )

    row.name = renderArray[row.index].name
    row.value = renderArray[row.index].countrycode
    row.countryId = renderArray[row.index].countryId

    rowTitle:setFillColor( 0 )
    rowTitle.anchorX = 0
    rowTitle.x = 15
    rowTitle.y = rowHeight * 0.5

    ---------------------------------------------------------------------------------------

    local tick = display.newImageRect( row, "res/assert/tick.png", 16,16 )
    tick.x = rowWidth -13
    tick.y = rowHeight * 0.5

    -------------to make the tick mark for the item that has been selected ----------


    if CountryLbl.text == row.name  or  LanguageLbl.text == row.name or  PositionLabelValue == row.name then

      print(" true tick")

             -- print(PositionLabelValue.. "     0000000     "..renderArray[row.index].name)
             tick.isVisible = true
           else
            tick.isVisible = false

          end



        -- if List.arrayName == languageArray or List.arrayName == languageArray1 or List.arrayName == positionArray then

        --         print(List.label.."  "..List.arrayName[row.index])

        --           if List.label == List.arrayName[row.index] then

        --                 tick.isVisible = true

        --           else
        --                 tick.isVisible = false
        --           end

        -- end


    -----------------------------------------------------------------------------------

  end











  local function CreateList(event,list,List_bg)
    
          if event == "country" then

                        --List_bg.height = 72.75

                        -- List_bg.height = 72.75
                        -- list.height = List_bg.height
                        -- List_bg.y = Marykay_bg.y+Marykay_bg.height+28
                        -- List.y = List_bg.y

                        -- list.x = List_bg.x
                        
                        -- list.width = List_bg.width-1.5


                        List_bg.x = list.x
                          --bg.y = event.target.y+event.target.contentHeight
                          List_bg.width =list.width+2
                          List_bg.height =list.height
                          List_bg.y = Country_bg.y+list.contentHeight+23
                          list.y = List_bg.y
                          list:deleteAllRows()



          elseif event == "language" then

                            -- if CountryLbl.text == RegistrationScreen.CountryUsaText then

                            --     List.label = languageArray

                            -- elseif CountryLbl.text == RegistrationScreen.CountryCanadaText then

                            --     List.label = languageArray

                            -- end


                            -- List_bg.height = 49.5

                            -- list.y = List_bg.y
                            -- list.width = List_bg.width-1.5


                            List_bg.x = list.x
                            List_bg.y = Language_bg.y+list.contentHeight+23
                            list.y = List_bg.y
                            --bg.y = event.target.y+event.target.contentHeight
                            List_bg.width =list.width+2
                            List_bg.height =list.height
                            list:deleteAllRows()


                          -- List_bg.height = 72.75
                          -- --List_bg.height = 39
                          -- list.height = List_bg.height
                          -- List_bg.y = Country_bg.y+Country_bg.height+28
                          -- List.y = List_bg.y

                          -- list.x = List_bg.x
                          -- list.y = List_bg.y
                          -- list.width = List_bg.width-1.5

        elseif event == "position" then

                          -- List_bg.height = 77
                          -- list.height = List_bg.height+20
                          -- List_bg.y = Language_bg.y+Language_bg.height+28
                          -- List.y = List_bg.y

                          -- list.x = List_bg.x
                          -- list.y = List_bg.y
                          -- list.width = List_bg.width-1.5

                           -- list.y = List_bg.y

                           List_bg.y =Position_bg.y+list.contentHeight+23
                           list.y = List_bg.y
                          -- list.width = List_bg.width-1.5
                         -- list.height = list.contentHeight+30
                          List_bg.x = list.x
                            --bg.y = event.target.y+event.target.contentHeight
                            List_bg.width =list.width+2
                            List_bg.height =list.height+1
                            list:deleteAllRows()

                          end

                          list:deleteAllRows()



                          for i = 1, #List.arrayName do


                            list:insertRow(
                            {
                              isCategory = false,
                              rowHeight = 36,
                              rowColor = { default={0.9}, over={0.8} },
                            }
                            )


                          end


        end
    local function getPositionDetails( response )

                          if response ~= nil then

                              for i=1,#positionArray do

                                positionArray[i] = nil

                              end


                              for i=1,#response do

                                if response[i].PositionName ~= nil then

                                  positionArray[#positionArray+1] = {name = response[i].PositionName, countrycode = response[i].PositionId}

                                end

                              end


                             -- PositionLbl.text = response[1].PositionName
                             PositionLbl.text = RegistrationScreen.SelectPosition
                             PositionLbl.countrycode = response[1].PositionId
                             PositionLabelValue = PositionLbl.text


                             PositionLbl:setFillColor( 0 )
                             PositionLbl.size = 14


                           --  if PositionLbl.text:len() > 22 then

                           --     PositionLbl.text =  PositionLbl.text:sub(1,22)..".."

                           --  end


                    end

         end


         local function getLanguageDetails( response )

                if response ~= nil then

                    for i=1,#languageArray do

                      languageArray[i]=nil

                    end


                    for i=1,#response do

                      if response[i].LanguageName ~= nil then

                        languageArray[#languageArray+1] = {name = response[i].LanguageName,countrycode = response[i].LanguageId}

                      end

                    end


                      --  LanguageLbl.text = response[1].LanguageName
                        LanguageLbl.text = RegistrationScreen.SelectLanguage
                        LanguageLbl.countrycode = response[1].LanguageId


                        Webservice.GetPositionbyCountryIdandLanguageId( CountryLbl.countrycode ,response[1].LanguageId,getPositionDetails)

                       -- languageArray = languageArray

                       -- CreateList("language",List,List_bg)

                       -- LanguageLbl.text = languagename
                       -- LanguageLbl.languageId = languageId

                        LanguageLbl:setFillColor( 0 )
                        LanguageLbl.size = 14

                   end

           end






           local function onRowTouch(event) 

            local row = event.row

            if event.phase == 'release' then

              List_bg.isVisible = false
              List:deleteAllRows()
              List.isVisible = false


              renderArray = {}

              renderArray = List.arrayName 
              tempLable = List.label


              print("row touch render array : "..json.encode(renderArray))


              row.id = row.index
              row.name = renderArray[row.index].name
              row.countrycode = renderArray[row.index].countrycode
              row.countryId = renderArray[row.index].countryId


              print( "Check : "..json.encode(row) )

              tempLable.text = row.name
              tempLable.value = row.id
              tempLable.countrycode = row.countrycode
              tempLable.countryId = row.countryId

              tempLable.size = 14
              tempLable:setTextColor(0)


              if List.value == "country" then

               Webservice.GetCountryLanguagesbyCountryCode( row.countrycode,getLanguageDetails)

             elseif List.value == "language" then

               Webservice.GetPositionbyCountryIdandLanguageId( CountryLbl.countrycode ,row.countrycode,getPositionDetails)

             elseif List.value == "position" then

              if PositionLbl.text:len() > 22 then

               PositionLabelValue = PositionLbl.text

               PositionLbl.text =  PositionLabelValue:sub(1,22)..".."

             elseif PositionLbl.text:len() <= 22 then

               PositionLabelValue = PositionLbl.text

               PositionLbl.text =  PositionLabelValue

             end

           end


           scrollTo(0)

         end

       end







       local function scrollTo(position)

        scrollView:scrollToPosition
        {
          y = position,
          time = 500,
        }

        local function onTimer( event )

          if position == 0 then

            FirstName.isVisible = true
            Name.isVisible = true
            FirstName_bg.isVisible = true
            Name_bg.isVisible = true
            FirstName_bg.isVisible = true
            Name_bg.isVisible = true

          else

            FirstName.isVisible = false
            Name.isVisible = false
            FirstName_bg.isVisible = false
            Name_bg.isVisible = false
            FirstName_bg.isVisible = false
            Name_bottom.isVisible = false

          end

        end

        timer.performWithDelay(350, onTimer)

      end



    local function onComplete(event)

              if 1 == event then

               Phone.isVisible=true
               Marykay.isVisible=true

              end

          end


      local function alertFun(value,flag)

        local function onComplete( event )

        -- if event.action == "clicked" then

          local i = event

          if i == 1 then  

            if flag == 1 then

              local options = {
                effect = "slideRight",
                time = 600,
              }
              composer.gotoScene( "Controller.singInPage", options )

            end
            
         -- end
        end
      end

       Phone.isVisible=false
       Marykay.isVisible=false

       local option ={
               {content=CommonWords.ok,positive=true},
            }
      
      genericAlert.createNew(RegistrationScreen.RegistrationCompleted ,value,option,onComplete)


      --local alert = native.showAlert( RegistrationScreen.RegistrationCompleted , value, { CommonWords.ok }, onComplete )

    end 



    local function RegistrationProcess( )

     


        function getregistrationDetail( response )

          Register_response = response




          FirstName.text = ""
          Name.text = ""
          Email.text = ""
          Phone.text = ""
          Marykay.text = ""
          CountryLbl.text = countryArray[1].name
                        --LanguageLbl.text = languageArray[1].name
                       LanguageLbl.text = RegistrationScreen.SelectLanguage
                       -- PositionLbl.text = positionArray[1].name
                       PositionLbl.text = RegistrationScreen.SelectPosition
                       
                       
                       if Register_response.StatusType == "Success"  then

                        alertFun(RegistrationScreen.SuccessMessage,1)

                      end


                    end


                    print(FirstName.text.."\n"..Name.text.."\n"..Email.text.."\n"..Phone.text.."\n"..Marykay.text.."\n"..CountryLbl.countryId.."\n"..LanguageLbl.countrycode.."\n"..PositionLbl.text.."\n"..PositionLbl.countrycode)

                    Webservice.MubDirectorRegister(FirstName.text,Name.text,Email.text,Phone.text,Marykay.text,CountryLbl.countryId,LanguageLbl.countrycode,PositionLbl.countrycode,getregistrationDetail)

             

                end






                local function registerBtnRelease(event )

                  if event.phase == "began" then


                    elseif event.phase == "ended" then

                    local validation = true
                    native.setKeyboardFocus(nil)

--------------------- FirstName validation ------------------------

if FirstName.text == "" or FirstName.text == FirstName.id or FirstName.text == RequestAccess.FirstName_error then
  validation=false
  SetError(RequestAccess.FirstName_error,FirstName)
end


--------------------- Name validation ------------------------

if Name.text == "" or Name.text == Name.id or Name.text == RequestAccess.Name_error then
  validation=false
  SetError(RequestAccess.Name_error,Name)
end


--------------------- Email validation ------------------------

if Email.text ~= "" and Email.text ~= Email.id and Email.text ~= Email.EmailAddress_placeholder and Email.text ~= RequestAccess.Email_error then

  print("in if condition")
  if not Utils.emailValidation(Email.text) then
    validation=false
    SetError(RequestAccess.EmailValidation_error,Email)
  else

    local function getEmailValidationStatus(response)

      print("email response :"..json.encode(response))

      if response == false then

        native.setKeyboardFocus(Email)

            Phone.isVisible=false
             Marykay.isVisible=false
             local option ={
               {content=CommonWords.ok,positive=true},
            }
            genericAlert.createNew(RegistrationScreen.EmailRegistered, RegistrationScreen.EmailRegisteredText,option,onComplete)

       -- local alert = native.showAlert( RegistrationScreen.EmailRegistered , RegistrationScreen.EmailRegisteredText , { CommonWords.ok } )

      else

                                              -- native.setKeyboardFocus(Phone)

                                            end

                                          end

                                          Webservice.IsUserAvailable(Email.text,getEmailValidationStatus)

                                        end

                                      else

                                        print("in else condition")
                                        validation=false
                                        SetError(RequestAccess.Email_error,Email)

                                      end



--------------------- Phone validation ------------------------

if Phone.text == "" or Phone.text == RequestAccess.Phone_error or Phone.text == Phone.id or Phone.text:len() < 14  then
  validation=false
  SetError(RequestAccess.Phone_error,Phone)
end



--------------------- Marykay validation ------------------------

if Marykay.text == "" or Marykay.text == Marykay.id or Marykay.text == RequestAccess.Marykayid_error or Marykay.text == Marykay.placeholder then

                          --  if not Utils.marykayid_Validation( Marykay.text ) then

                          validation=false
                          SetError(RequestAccess.Marykayidinvalid_error,Marykay)
                          
                          --  end

                          print("tfryrtyrty")

                   -- else

                           -- validation=false
                           -- SetError("*"..RequestAccess.Marykayid_error,Marykay)

                         end


--------------------- Language validation ------------------------

if LanguageLbl.text == "" or LanguageLbl.text == RegistrationScreen.SelectLanguage or LanguageLbl.text == RegistrationScreen.SelectLanguage_Errormsg then

  validation=false

  LanguageLbl:setFillColor( 1,0,0 )
  LanguageLbl.size = 10
  LanguageLbl.text = RegistrationScreen.SelectLanguage_Errormsg

end


--------------------- Position validation ------------------------

if PositionLbl.text == "" or PositionLbl.text == RegistrationScreen.SelectPosition or PositionLbl.text == RegistrationScreen.SelectPosition_Errormsg then

  validation=false

  PositionLbl:setFillColor( 1,0,0 )
  PositionLbl.size = 10
  PositionLbl.text = RegistrationScreen.SelectPosition_Errormsg 

end


--------------------- scroll down the page ------------------------

if PositionLbl.text ~= "" or PositionLbl.text ~= RegistrationScreen.SelectPosition then

  print("scrolling")

  scrollTo(0)

end

---------------------- validation true process ------------------------

if(validation == true) then

  print("validation true")

  RegistrationProcess()

end

end

return true

end






local function textfield( event )

  if ( event.phase == "began" ) then


    event.target:setTextColor(color.black)
    current_textField = event.target;
    current_textField.size=14


    if (event.target.id == "First Name") or (event.target.id == "Last Name") or (event.target.id == "Email") or (event.target.id == "Phone") or (event.target.id == "Marykay_Id") then

      if "E" == event.target.text:sub(1,1) then
        event.target.text=""
      end

    else 

      if "S" == event.target.text:sub(1,1) then
        event.target.text=""
      end

    end


  elseif ( event.phase == "submitted" ) then

    if current_textField then

      if(event.target.id == "First Name") then

        native.setKeyboardFocus(Name)


      elseif(event.target.id == "Last Name") then

        native.setKeyboardFocus(Email)


      elseif(event.target.id == "Email") then

        if not Utils.emailValidation(Email.text) then

          validation=false
          SetError(RequestAccess.EmailValidation_error,Email)

          native.setKeyboardFocus(Phone)

        else

          local function getEmailValidationStatus(response)

            if response == false then

             native.setKeyboardFocus(Email)

             Phone.isVisible=false
             Marykay.isVisible=false
             local option ={
               {content=CommonWords.ok,positive=true},
            }
            genericAlert.createNew(RegistrationScreen.EmailRegistered, RegistrationScreen.EmailRegisteredText,option,onComplete)

            -- local alert = native.showAlert( RegistrationScreen.EmailRegistered , RegistrationScreen.EmailRegisteredText , { CommonWords.ok } )

           else

             native.setKeyboardFocus(Phone)

           end

         end

         Webservice.IsUserAvailable(Email.text,getEmailValidationStatus)

       end



     elseif(event.target.id == "Phone") then

      native.setKeyboardFocus(Marykay)


    elseif (event.target.id == "Marykay_Id") then
      
      native.setKeyboardFocus( nil )

    end

  end

                --scrollTo( 0 )


                elseif event.phase == "ended" then

            --scrollTo( 0 )
            event.target:setSelection(event.target.text:len(),event.target.text:len())


          elseif ( event.phase == "editing" ) then


            if(event.target.id == "First Name") or (event.target.id == "Last Name") or (event.target.id == "Marykay_Id") then

             if event.text:len() > 50 then

              event.target.text = event.target.text:sub(1,50)

              print("reached the limit of 50")

            end


            if not event.newCharacters:match("[%w%s]+") then
             local prevPos = event.startPosition - 1
             event.target.text = string.sub( event.target.text,1,prevPos)
             print("O")
           end


         end



         
         if (event.target.id == "Marykay_Id") then

          if event.text:len() > 50 then

            event.target.text = event.target.text:sub(1,50)

          end

        end



        if(event.target.id == "Email") then

          if event.text:len() > 100 then

            event.target.text = event.target.text:sub(1,100)

          end

                   -- if not event.newCharacters:match("[^!#$%&*()%_=';:?/><|]+") or event.newCharacters:match("[{,}]+") then
                   --     local prevPos = event.startPosition - 1
                   --     event.target.text = string.sub( event.target.text,1,prevPos)
                   --     print("O")
                   -- end

                 end



                 if(event.target.id =="Phone") then

                  local text = event.target.text

                  if event.target.text:len() > event.startPosition then

                    text = event.target.text:sub(1,event.startPosition )

                  end



                  local maskingValue =Utils.PhoneMasking(tostring(text))

                  
                  event.target.text=maskingValue

                  event.target:setSelection(maskingValue:len()+1,maskingValue:len()+1)

                                      -- if isIos then

                                      -- if (event.target.id == "Phone") then

                                      --       Background:addEventListener("touch",touchBg)

                                      -- end

                                      -- end

                                      
                                    end
                                    
                                  end


                                end





                                local function backAction( event )

                                  if event.phase == "began" then

                                    display.getCurrentStage():setFocus( event.target )

                                    elseif event.phase == "ended" then

                                    display.getCurrentStage():setFocus( nil )

                                    if event.target.id == "cancel" then

                                      local options = {
                                        effect = "slideRight",
                                        time = 300,   
                                      }

                                      composer.gotoScene( "Controller.singInPage", options )

                       --return true

                     end

                     if webView then 
                      webView.isVisible = false
                    end

                    CreateAccountBtn.isVisible = false
                    CreateAccountBtn_text.isVisible = false
                    
                    if List then
                      List.isVisible = false
                      List_bg.isVisible = false
                    end

                    if backBtn_bg then
                      backBtn_bg.isVisible = false
                      backBtn.isVisible = false

                      page_title.isVisible = false
                      FirstName_bg.isVisible = false
                      FirstName.isVisible = false
                      Name_bg.isVisible = false
                      Name.isVisible = false
                      Email_bg.isVisible = false
                      Email.isVisible = false
                      Phone_bg.isVisible = false
                      Phone.isVisible = false

                      Marykay_id.isVisible = false
                      Marykay_id_helptext.isVisible = false
                      Marykay_bg.isVisible = false
                      Marykay.isVisible = false
                      Country_bg.isVisible = false
                      Countrytxt.isVisible = false
                      Language_bg.isVisible = false
                      Languagetxt.isVisible = false
                      Position_bg.isVisible = false
                      Positiontxt.isVisible = false
                      CountryLbl.isVisible = false
                      Country_icon.isVisible = false
                      LanguageLbl.isVisible = false
                      Language_icon.isVisible = false
                      PositionLbl.isVisible = false
                      Position_icon.isVisible = false
                      registerBtn.isVisible = false
                      registerBtn_lbl.isVisible = false
                      registerBtn.isVisible = false
                      cancelBtn_lbl.isVisible = false

                    end
                    
                    if backBtn_intro then
                      backBtn_intro.isVisible = false
                      backBtn_bg_intro.isVisible = false
                      title.isVisible = false
                    end
                    
           -- scrollView.isVisible = false

         end

         return true

       end




       local function getCountryList(response)

        if response ~= nil then


          for i=1,#countryArray do

            countryArray[i] = nil

          end

          for i=1,#response do

            if response[i].CountryName ~= nil then

              countryArray[#countryArray+1] = {name = response[i].CountryName,countrycode=response[i].CountryCode,countryId = response[i].CountryId}
              
            end



            CountryLbl.text = countryArray[1].name
            CountryLbl.countrycode = countryArray[1].countrycode
            CountryLbl.countryId = countryArray[1].countryId

                     -- List.countrycode =  countryArray[i].countrycode

                     -- print("List.arrayName : "..countryArray[1].name.." "..countryArray[2].name)
                     -- print(List.countrycode)


                     Webservice.GetCountryLanguagesbyCountryCode(countryArray[1].countrycode,getLanguageDetails)


                   end


                 end


               end





               local function TouchSelection( event )

                print(event.phase)

                if event.phase == "began" then

                 display.getCurrentStage():setFocus( nil )

                 native.setKeyboardFocus( nil )


                 if event.target.id == "country_bg" then

                   native.setKeyboardFocus( nil )

                   if List.isVisible == false then

                    List.isVisible = true
                    List_bg.isVisible = true

                    List.arrayName = countryArray
                    List.label = CountryLbl
                    List.value = "country"

                                          --  print( "::::::::::: 111"..json.encode(countryArray).." "..CountryLbl.text)


                                          CreateList("country",List,List_bg)
                                          
                                        else
                                          List_bg.isVisible = false
                                          List:deleteAllRows()
                                          List.isVisible = false

                                        end


                                      elseif  event.target.id == "language_bg" then


                                       native.setKeyboardFocus( nil )

                                       if List.isVisible == false then

                                        List.isVisible = true
                                        List_bg.isVisible = true

                                        List.arrayName = languageArray

                                        print( "::::::::::: "..json.encode(languageArray).." "..LanguageLbl.text)

                                        List.label = LanguageLbl
                                        List.value = "language"

                                        CreateList("language",List,List_bg)
                                        
                                      else
                                        List_bg.isVisible = false
                                        List:deleteAllRows()
                                        List.isVisible = false

                                      end



                                    elseif  event.target.id == "position_bg" then


                                     native.setKeyboardFocus( nil )

                                     if List.isVisible == false then

                                      List.isVisible = true
                                      List_bg.isVisible = true


                                      List.arrayName = positionArray
                                      List.label = PositionLbl
                                      List.value = "position"

                                      CreateList("position",List,List_bg)
                                      
                                    else
                                      List_bg.isVisible = false
                                      List:deleteAllRows()
                                      List.isVisible = false


                                    end


                                  else

                                    List.isVisible = false
                                    List:deleteAllRows()

                                  end

                                end

                              end



                              local function addevent_scrollListener(event )

                                local x, y = scrollView:getContentPosition()

                                local phase = event.phase

                                if ( phase == "began" ) then 

                                elseif ( phase == "moved" ) then 

                                  if y > -25 then
                                    FirstName.isVisible = true
                                    FirstName_bg.isVisible = true
                                  else
                                    FirstName.isVisible = false
                                    FirstName_bg.isVisible = false
                                  end



                                  if y > -55 then
                                    Name.isVisible = true
                                    Name_bg.isVisible = true
                                  else
                                    Name.isVisible = false
                                    Name_bg.isVisible = false
                                  end


                                  elseif ( phase == "ended" ) then 



                                end

            -- In the event a scroll limit is reached...
            if ( event.limitReached ) then
              if ( event.direction == "up" ) then print( "Reached bottom limit" )
              elseif ( event.direction == "down" ) then print( "Reached top limit" )
              elseif ( event.direction == "left" ) then print( "Reached right limit" )
              elseif ( event.direction == "right" ) then print( "Reached left limit" )
              end
            end

            return true
          end






------------------------------------------------------

function scene:create( event )

  local sceneGroup = self.view

  Background = display.newRect(sceneGroup,0,0,W,H)
  Background.x=W/2;Background.y=H/2

  tabBar = display.newRect(sceneGroup,W/2,0,W,40)
  tabBar.y=tabBar.height/2
  tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))
  
  BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",131,31)
  BgText.x=W/2;BgText.y=20

  local tabImage = display.newImageRect( sceneGroup, "res/assert/file_icon1.png", 111/2,111/2 )
  tabImage.x=W/2+W/3;tabImage.y=tabBar.y+tabBar.contentHeight/2

  backBtn_bg_intro = display.newRect(sceneGroup,0,0,40,30)
  backBtn_bg_intro.x=20;backBtn_bg_intro.y=BgText.y
  backBtn_bg_intro.id = "cancel"
  backBtn_bg_intro.alpha=0.01

  backBtn_intro = display.newImageRect(sceneGroup,"res/assert/back_icon.png",36/2,30/2)
  backBtn_intro.x=25;backBtn_intro.y=BgText.y
  backBtn_intro.id = "cancel"

  title = display.newText(sceneGroup,RegistrationScreen.Introduction:upper( ),0,0,"Roboto-Bold",18)
  title.anchorX = 0
  title.id = "cancel"
  title.x=4.5;title.y = tabBar.y+tabBar.contentHeight+5
  title:setFillColor(0)


  backBtn_bg_intro:addEventListener("touch",backAction)
  backBtn_intro:addEventListener("touch",backAction)
  title:addEventListener("touch",backAction)

  Background:addEventListener("touch",touchBg)


    webView = native.newWebView( display.contentCenterX, display.contentCenterY+5, display.viewableContentWidth, display.viewableContentHeight-140)
    webView.hasBackground=false
    webView:request(  "res/assert/introduction.html", system.ResourceDirectory )
    sceneGroup:insert( webView )

    

    CreateAccountBtn_bg = display.newRect(sceneGroup,0,0,W,35)
    CreateAccountBtn_bg.x=W/2;CreateAccountBtn_bg.y = H - 35
    CreateAccountBtn_bg.width = W
    CreateAccountBtn_bg.anchorY = 0
    CreateAccountBtn_bg.id="create_account"


     CreateAccountBtn = display.newImageRect(sceneGroup,"res/assert/white_btnbg.png",550/2,50)
    CreateAccountBtn.x=W/2;CreateAccountBtn.y =H-35
    CreateAccountBtn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

    CreateAccountBtn_text = display.newText(sceneGroup,RegistrationScreen.CreateAccount,0,0,"Roboto-Regular",16)
    CreateAccountBtn_text.x=W/2
    CreateAccountBtn_text.y=CreateAccountBtn.y


    MainGroup:insert(sceneGroup)

  end





  function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then

      if event.params then

        initialvalue = event.params.introvalue

      end


    elseif phase == "did" then

      composer.removeHidden()

      function createAccount( event )

        if event.phase == "began" then

          display.getCurrentStage():setFocus( event.target )

          elseif event.phase == "ended" then

          display.getCurrentStage():setFocus( nil )

          if event.target.id == "create_account" then

            webView.isVisible = false
            backBtn_intro.isVisible = false
            backBtn_bg_intro.isVisible = false
            title.isVisible = false

            initialvalue = "createaccount"


            scrollView = widget.newScrollView
            {
              top = 95,
              left = 0,
              width = W,
              height = H-195,
              hideBackground = true,
              isBounceEnabled=false,
              horizontalScrollDisabled = true,
             -- friction = .4,
              listener = addevent_scrollListener,
            }

            sceneGroup:insert( scrollView )


            scrollView.isVisible = true

            
            backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
            backBtn_bg.x=22;backBtn_bg.y=BgText.y
            backBtn_bg.id = "cancel"
            backBtn_bg.alpha=0.01

            backBtn = display.newImageRect(sceneGroup,"res/assert/back_icon.png",36/2,30/2)
            backBtn.x=25;backBtn.y=BgText.y
            backBtn.id = "cancel"

            page_title = display.newText(sceneGroup,RegistrationScreen.Registrationtext:upper( ),0,0,"Roboto-Bold",18)
            page_title.x=25/2;page_title.y= tabBar.y+tabBar.contentHeight+5
            page_title.anchorX=0
            page_title.id = "cancel"
            page_title:setFillColor(Utils.convertHexToRGB(color.Black))

            CreateAccountBtn.isVisible = false
            CreateAccountBtn_text.isVisible = false



                                -------------------------------------- first name -------------------------------------------

                                FirstName_bg = display.newLine(W/2-150, 15, W/2+150, 15)
                                FirstName_bg.y = 32
                                FirstName_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                FirstName_bg.strokeWidth = 1
                                scrollView:insert(FirstName_bg)

                                FirstName = native.newTextField(W/2+7, page_title.y+5, W-20, 25)
                                FirstName.id="First Name"
                                FirstName.font=native.newFont("Roboto-Light",14)
                                FirstName.y = FirstName_bg.y-12
                                FirstName.hasBackground = false
                                FirstName:setReturnKey( "next" )
                                FirstName.placeholder=RequestAccess.FirstName_placeholder
                                scrollView:insert(FirstName)

                                FirstName_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                FirstName_mandatory.x=15
                                FirstName_mandatory.y=FirstName_bg.y-18
                                FirstName_mandatory:setTextColor( 1, 0, 0 )
                                scrollView:insert(FirstName_mandatory)

                                -- FirstName_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                -- FirstName_bottom.x=W/2
                                -- FirstName_bottom.y= FirstName.y+13
                                -- scrollView:insert(FirstName_bottom)

                                -------------------------------------Last name ----------------------------------------------

                                Name_bg = display.newLine(W/2-150, FirstName_bg.y+40, W/2+150, FirstName_bg.y+40)
                                Name_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                Name_bg.strokeWidth = 1
                                scrollView:insert(Name_bg)

                                Name_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                Name_mandatory.x=15
                                Name_mandatory.y=Name_bg.y-Name_mandatory.contentHeight/2-8
                                Name_mandatory:setTextColor( 1, 0, 0 )
                                scrollView:insert(Name_mandatory)

                                Name = native.newTextField( W/2+7, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
                                Name.id="Last Name"
                                Name.y = Name_bg.y-12
                                Name.font=native.newFont("Roboto-Light",14)
                                Name:setReturnKey( "next" )
                                Name.hasBackground = false  
                                Name.placeholder = RequestAccess.LastName_placeholder
                                scrollView:insert(Name)

                                -- Name_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                -- Name_bottom.x=W/2
                                -- Name_bottom.y= Name.y+13
                                -- scrollView:insert(Name_bottom)


                                ----------------------------------Email address---------------------------------
                                

                                Email_bg = display.newLine(W/2-150, Name_bg.y+40, W/2+150, Name_bg.y+40)
                                Email_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                Email_bg.strokeWidth = 1
                                scrollView:insert(Email_bg)

                                Email_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                Email_mandatory.x=15
                                Email_mandatory.y=Email_bg.y-Email_mandatory.contentHeight/2-8
                                Email_mandatory:setTextColor( 1, 0, 0 )
                                scrollView:insert(Email_mandatory)

                                Email = native.newTextField(W/2+7, Name_bg.y+Name_bg.height+7, W-20, 25 )
                                Email.id="Email"
                                Email.y = Email_bg.y-12
                                Email.font=native.newFont("Roboto-Light",14)
                                Email:setReturnKey( "next" )
                                Email.hasBackground = false
                                Email.placeholder=RequestAccess.EmailAddress_placeholder
                                scrollView:insert(Email)


                                -- Email_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                -- Email_bottom.x=W/2
                                -- Email_bottom.y= Email.y+13
                                -- scrollView:insert(Email_bottom)


                                -----------------------------------phone------------------------------------------
                                

                                Phone_bg = display.newLine(W/2-150, Email_bg.y+40, W/2+150, Email_bg.y+40)
                                Phone_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                Phone_bg.strokeWidth = 1
                                scrollView:insert(Phone_bg)

                                Phone_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                Phone_mandatory.x=15
                                Phone_mandatory.y=Phone_bg.y-Phone_mandatory.contentHeight/2-8
                                Phone_mandatory:setTextColor( 1, 0, 0 )
                                scrollView:insert(Phone_mandatory)

                                Phone = native.newTextField(W/2+7, Email_bg.y+Email_bg.height+7, W-20, 25)
                                Phone.id="Phone"
                                Phone.y = Phone_bg.y-12
                                Phone.font=native.newFont("Roboto-Light",14)
                                Phone:setReturnKey( "next" )
                                Phone.hasBackground = false
                                Phone.placeholder=RequestAccess.Phone_placeholder
                                Phone.inputType = "number"
                                scrollView:insert(Phone)


                                -- Phone_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                -- Phone_bottom.x=W/2
                                -- Phone_bottom.y= Phone.y+13
                                -- scrollView:insert(Phone_bottom)


                                -----------------------------------Marykay_id------------------------------------------

                                Marykay_id = display.newText(scrollView,RegistrationScreen.MaryKayIdtext:upper( ),0,0,"Roboto-Bold",14)
                                Marykay_id.x=16;Marykay_id.y=Phone_bg.y+22
                                Marykay_id.anchorX=0
                                Marykay_id:setFillColor(Utils.convertHexToRGB(color.Black))
                                scrollView:insert(Marykay_id)

                                Marykay_id_helptext = display.newText(scrollView,"http://www.marykay.com/",0,0,"Roboto-Italic",12)
                                Marykay_id_helptext.x=16;Marykay_id_helptext.y=Marykay_id.y+20
                                Marykay_id_helptext.anchorX=0
                                Marykay_id_helptext:setFillColor(Utils.convertHexToRGB(color.secondaryColor))
                                scrollView:insert(Marykay_id_helptext)

                                Marykay_bg =  display.newLine(W/2-150, Marykay_id_helptext.y+42, W/2+150, Marykay_id_helptext.y+42)
                                Marykay_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                Marykay_bg.strokeWidth = 1
                                scrollView:insert(Marykay_bg)

                                Marykay_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                Marykay_mandatory.x=15
                                Marykay_mandatory.y=Marykay_bg.y-Marykay_mandatory.contentHeight/2-8
                                Marykay_mandatory:setTextColor( 1, 0, 0 )
                                scrollView:insert(Marykay_mandatory)

                                Marykay = native.newTextField(W/2+7, Marykay_id_helptext.y+Marykay_id_helptext.height+12, W-20, 25)
                                Marykay.id="Marykay_Id"
                                Marykay.y = Marykay_bg.y-12
                                Marykay.font=native.newFont("Roboto-Light",14)
                                Marykay.placeholder = RequestAccess.Marykayid_placeholder
                                Marykay:setReturnKey( "next" )
                                Marykay.hasBackground = false
                                scrollView:insert(Marykay)

                                -- Marykay_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                -- Marykay_bottom.x=W/2
                                -- Marykay_bottom.y= Marykay.y+13
                                -- scrollView:insert(Marykay_bottom)


                                ------------------------------   Country and its dropdown   --------------------------------



                                Country_bg = display.newLine(W/2-150, Marykay_bg.y+42, W/2+150, Marykay_bg.y+42)
                                Country_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                Country_bg.strokeWidth = 1
                                Country_bg.id="country_bg"
                                scrollView:insert(Country_bg)

                                Countrytxt = display.newText(scrollView,RegistrationScreen.Countrytext,13,Country_bg.y+Country_bg.height+12,"Roboto-Light",14 )
                                Countrytxt.anchorX=0
                                Countrytxt.value=0
                                Countrytxt:setFillColor( Utils.convertHexToRGB(color.Black))
                                Countrytxt.y = Country_bg.y-12

                                Countrytxt.x=leftPadding
                                scrollView:insert(Countrytxt)


                                -- Country_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                -- Country_bottom.x=W/2
                                -- Country_bottom.y= Countrytxt.y+13
                                -- scrollView:insert(Country_bottom)


                                CountryLbl = display.newText(scrollView,RegistrationScreen.CountryUsaText,W/2,Country_bg.y+Country_bg.height+12,"Roboto-Light",14 )
                                CountryLbl.anchorX=0
                                CountryLbl.value=0
                                CountryLbl.id="country_bg"
                                CountryLbl:setFillColor( Utils.convertHexToRGB(color.Black))
                                CountryLbl.x=W/2 - 21.5
                                CountryLbl.y = Country_bg.y-12
                                scrollView:insert(CountryLbl)



                                Country_icon = display.newImageRect(scrollView,"res/assert/right-arrow(gray-).png",15/2,30/2 )
                                Country_icon.x=W-20
                                Country_icon.rotation=90
                                Country_icon.id = "country_bg"
                                Country_icon.y=Country_bg.y-12
                                scrollView:insert(Country_icon)

                                Country_bg:addEventListener( "touch", TouchSelection )
                                CountryLbl:addEventListener( "touch", TouchSelection )
                                Country_icon:addEventListener( "touch", TouchSelection )




                                 ------------------------------   Language and its dropdown   --------------------------------


                                 Language_bg = display.newLine(W/2-150, Country_bg.y+42, W/2+150, Country_bg.y+42)
                                 Language_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                 Language_bg.strokeWidth = 1
                                 Language_bg.id = "language_bg"
                                 Language_bg:addEventListener( "touch", TouchSelection )
                                 scrollView:insert(Language_bg)

                                 Languagetxt = display.newText(RegistrationScreen.Languagetext,13,Country_bg.y+Country_bg.height+12,"Roboto-Light",14 )
                                 Languagetxt.anchorX=0
                                 Languagetxt.value=0
                                 Languagetxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                 Languagetxt.x=leftPadding
                                 Languagetxt.y=Language_bg.y-12
                                 scrollView:insert(Languagetxt)

                                 -- Language_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                 -- Language_bottom.x=W/2
                                 -- Language_bottom.y= Languagetxt.y+13
                                 -- scrollView:insert(Language_bottom)


                                Language_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                Language_mandatory.x= leftPadding -2
                                Language_mandatory.y=Language_bg.y-Language_mandatory.contentHeight/2-8
                                Language_mandatory:setTextColor( 1, 0, 0 )
                                scrollView:insert(Language_mandatory)


                                 LanguageLbl = display.newText(RegistrationScreen.SelectLanguage,W/2,Country_bg.y+Country_bg.height+12,"Roboto-Light",14 )
                                 LanguageLbl.anchorX=0
                                 LanguageLbl.value=0
                                 LanguageLbl.id="language_bg"
                                 LanguageLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                 LanguageLbl.x=W/2 - 23
                                 scrollView:insert(LanguageLbl)
                                 LanguageLbl.y=Language_bg.y-12


                                 Language_icon = display.newImageRect("res/assert/right-arrow(gray-).png",15/2,30/2 )
                                 Language_icon.x=W-20
                                 Language_icon.rotation=90

                                 Language_icon.id="language_bg"
                                 scrollView:insert(Language_icon)
                                Language_icon.y=Language_bg.y-12

                                   Language_bg:addEventListener( "touch", TouchSelection )
                                   LanguageLbl:addEventListener( "touch", TouchSelection )
                                   Language_icon:addEventListener( "touch", TouchSelection )

                                 ------------------------------   Country and its dropdown   --------------------------------


                                 Position_bg = display.newLine(W/2-150, Language_bg.y+42, W/2+150, Language_bg.y+42)
                                 Position_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
                                 Position_bg.strokeWidth = 1
                                 Position_bg.id = "position_bg"
                                 Position_bg:addEventListener( "touch", TouchSelection )
                                 scrollView:insert(Position_bg)

                                  Position_mandatory = display.newText("*",0,0,"Roboto-Light",14)
                                  Position_mandatory.x= leftPadding -2
                                  Position_mandatory.y=Position_bg.y-Position_mandatory.contentHeight/2-8
                                  Position_mandatory:setTextColor( 1, 0, 0 )
                                  scrollView:insert(Position_mandatory)

                                 Positiontxt = display.newText(scrollView,RegistrationScreen.Positiontext,13,Language_bg.y+Language_bg.height+12,"Roboto-Light",14 )
                                 Positiontxt.anchorX=0
                                 Positiontxt.value=0
                                 Positiontxt:setFillColor( Utils.convertHexToRGB(color.Black))
                                 Positiontxt.x=leftPadding
                                 Positiontxt.y=Position_bg.y-12
                                 scrollView:insert(Positiontxt)

                                 -- Position_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                 -- Position_bottom.x=W/2
                                 -- Position_bottom.y= Positiontxt.y+13
                                 -- scrollView:insert(Position_bottom)


                                 PositionLbl = display.newText(scrollView,RegistrationScreen.SelectPosition,W/2,Language_bg.y+Language_bg.height+12,"Roboto-Light",14 )
                                 PositionLbl.anchorX=0
                                 PositionLbl.value=0
                                 PositionLbl.id = "position_bg"
                                 PositionLbl:setFillColor( Utils.convertHexToRGB(color.Black))
                                 PositionLbl.x=W/2 - 23
                                 PositionLbl.y=Position_bg.y-12
                                 scrollView:insert(PositionLbl)


                                 Position_icon = display.newImageRect(scrollView,"res/assert/right-arrow(gray-).png",15/2,30/2 )
                                 Position_icon.x=W-20
                                 Position_icon.id = "position_bg"
                                 scrollView:insert(Position_icon)
                                  Position_icon.rotation=90
                                  Position_icon.y=Position_bg.y-12

                                   Position_bg:addEventListener( "touch", TouchSelection )
                                   Position_icon:addEventListener( "touch", TouchSelection )
                                  PositionLbl:addEventListener( "touch", TouchSelection )


                                  ---------------------    submit button   ---------------------------------------------------


                                  registerBtn = display.newImageRect("res/assert/white_btnbg.png",550/2,50)
                                 registerBtn.x=W/2;registerBtn.y = H-registerBtn.contentHeight-20
                                  registerBtn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
                                  sceneGroup:insert(registerBtn)
                                  registerBtn.id="Register"


                                  registerBtn_lbl = display.newText( RegistrationScreen.RegisterBtnText,0,0,native.systemFont,16 )
                                  registerBtn_lbl.y=registerBtn.y
                                  sceneGroup:insert(registerBtn_lbl)

                                  registerBtn.x=W/2
                                  registerBtn_lbl.x = registerBtn.x+7.5



                               
                                
                                        --registerBtn:addEventListener( "touch", sumbitBtnRelease )


                                        -- cancelBtn = display.newRect( 0,0,0,0 )
                                        -- cancelBtn.x=W/2;cancelBtn.y = Position_bg.y+Position_bg.height/2+30
                                        -- cancelBtn.width=100
                                        -- cancelBtn.height=30
                                        -- cancelBtn.anchorX=0
                                        -- sceneGroup:insert(cancelBtn)
                                        -- cancelBtn.id="Register"

                                        cancelBtn = display.newImageRect("res/assert/white_btnbg.png",550/5,50/2)
                                        cancelBtn.x=W/2;cancelBtn.y = registerBtn.y+45
                                        cancelBtn:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
                                        cancelBtn.alpha=0.2
                                        sceneGroup:insert(cancelBtn)
                                        cancelBtn.id="cancel"

                                        cancelBtn_lbl = display.newText( CommonWords.cancel,0,0,"Roboto-Regular",13 )
                                        cancelBtn_lbl.y= cancelBtn.y
                                        cancelBtn_lbl.x = cancelBtn.x
                                        cancelBtn_lbl.id = "cancel"
                                        cancelBtn_lbl:setFillColor( Utils.convertHexToRGB(color.Black)  )
                                        sceneGroup:insert(cancelBtn_lbl)



                                        backBtn_bg:addEventListener("touch",backAction)
                                        page_title:addEventListener("touch",backAction)
                                        cancelBtn_lbl:addEventListener("touch",backAction)
                                        registerBtn:addEventListener("touch", registerBtnRelease)

                                        FirstName:addEventListener("userInput", textfield)
                                        Name:addEventListener("userInput", textfield)
                                        Email:addEventListener("userInput", textfield)
                                        Phone:addEventListener("userInput", textfield)
                                        Marykay:addEventListener("userInput", textfield)


                                        -- List_bg = display.newRect( scrollView,W/2,Marykay_bg.y+Marykay_bg.height+28,W-20,50)
                                        -- List_bg.x = W/2
                                        -- List_bg.y = Marykay_bg.y+Marykay_bg.height+28
                                        -- List_bg.width = W-20
                                        -- List_bg.height = 50
                                        -- List_bg:setFillColor( 0 )
                                        -- scrollView:insert(List_bg)


                                        List_bg = display.newRect(  200, 100, W-20, 85 )
                                        List_bg:setFillColor( 0 )
                                        List_bg.x = W/2
                                        List_bg.width = W-20
                                        List_bg.height = 85
                                        List_bg.y = Marykay_bg.y+Marykay_bg.height+28 
                                        List_bg.anchorY = 0
                                        List_bg.isVisible=false

                                        scrollView:insert(List_bg)



                                        List = widget.newTableView(
                                        {
                                          left = 10,
                                          top = 200,
                                          height = 73,
                                          width = 300,
                                          onRowRender = onRowRender,
                                          onRowTouch = onRowTouch,
                                          hideBackground = true,
                                          isBounceEnabled = false,
                                                --bottomPadding = 24,
                                                noLines = true,
                                               -- listener = scrollListener
                                             }
                                             )

                                        List.anchorY=0
                                        List.isVisible = false

                                        scrollView:insert(List)

                                        List_bg.anchorY = 0
                                        List_bg.isVisible = false


                                      else


                                        scrollView.isVisible = false

                                        initialvalue = "introduction"
                                        

                                      end

                                      Webservice.GetAllCountry(getCountryList)

                                      Runtime:addEventListener( "key", onKeyEvent )

                                    end

                                    return true

                                  end


                                  CreateAccountBtn_bg:addEventListener("touch",createAccount)



                                  
                                end 
                                
                                MainGroup:insert(sceneGroup)

                              end




                              function scene:hide( event )

                                local sceneGroup = self.view
                                local phase = event.phase

                                if event.phase == "will" then

                                  if webView then webView:removeSelf( );webView=nil end

                                  Runtime:removeEventListener( "key", onKeyEvent )

                                  CreateAccountBtn:removeEventListener("touch",createAccount)

                                  if List then List:removeSelf( );List=nil end
                                  if scrollView then scrollView:removeSelf( );scrollView=nil end


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