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
                          List_bg.y = Marykay_bg.y+Marykay_bg.height+28 
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
                            List_bg.y = Country_bg.y+Country_bg.height+28 
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

                           List_bg.y = Language_bg.y+Language_bg.height+28 
                           list.y = List_bg.y
                          -- list.width = List_bg.width-1.5
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
            FirstName_bottom.isVisible = true
            Name_bottom.isVisible = true

          else

            FirstName.isVisible = false
            Name.isVisible = false
            FirstName_bg.isVisible = false
            Name_bg.isVisible = false
            FirstName_bottom.isVisible = false
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

      if  submit_spinner.isVisible == false then

        submit_spinner.isVisible=true
        registerBtn.width = registerBtn.contentWidth+20
        registerBtn_lbl.x=registerBtn.x-registerBtn.contentWidth/2+15
        submit_spinner.x=registerBtn_lbl.x+registerBtn_lbl.contentWidth+17

        registerBtn.width = registerBtn_lbl.contentWidth+40
        registerBtn.x=W/2-registerBtn.contentWidth/2
        registerBtn_lbl.x = registerBtn.x+7.5
        submit_spinner.x=registerBtn_lbl.x+registerBtn_lbl.contentWidth+17

        submit_spinner:start( )


        function getregistrationDetail( response )

          Register_response = response


          submit_spinner.isVisible = false

          registerBtn.width = registerBtn_lbl.width+20
          registerBtn_lbl.x=registerBtn.x-registerBtn.contentWidth/2+15
          submit_spinner.x=registerBtn_lbl.x+registerBtn_lbl.contentWidth+17
          registerBtn.width = registerBtn_lbl.contentWidth+15
          registerBtn.x=W/2-registerBtn.contentWidth/2
          registerBtn_lbl.x = registerBtn.x+7.5

          submit_spinner:stop( )


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

                end






                local function registerBtnRelease(event )

                  if event.phase == "began" then


                    elseif event.phase == "ended" then

                    local validation = true
                    native.setKeyboardFocus(nil)

--------------------- FirstName validation ------------------------

if FirstName.text == "" or FirstName.text == FirstName.id or FirstName.text == "*"..RequestAccess.FirstName_error then
  validation=false
  SetError("*"..RequestAccess.FirstName_error,FirstName)
end


--------------------- Name validation ------------------------

if Name.text == "" or Name.text == Name.id or Name.text == "*"..RequestAccess.Name_error then
  validation=false
  SetError("*"..RequestAccess.Name_error,Name)
end


--------------------- Email validation ------------------------

if Email.text ~= "" and Email.text ~= Email.id and Email.text ~= Email.EmailAddress_placeholder and Email.text ~= "*"..RequestAccess.Email_error then

  print("in if condition")
  if not Utils.emailValidation(Email.text) then
    validation=false
    SetError("*"..RequestAccess.EmailValidation_error,Email)
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
                                        SetError("*"..RequestAccess.Email_error,Email)

                                      end



--------------------- Phone validation ------------------------

if Phone.text == "" or Phone.text == "*"..RequestAccess.Phone_error or Phone.text == Phone.id or Phone.text:len() < 14  then
  validation=false
  SetError("*"..RequestAccess.Phone_error,Phone)
end



--------------------- Marykay validation ------------------------

if Marykay.text == "" or Marykay.text == Marykay.id or Marykay.text == "*"..RequestAccess.Marykayid_error or Marykay.text == Marykay.placeholder then

                          --  if not Utils.marykayid_Validation( Marykay.text ) then

                          validation=false
                          SetError("*"..RequestAccess.Marykayidinvalid_error,Marykay)
                          
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

    if "*" == event.target.text:sub(1,1) then
      event.target.text=""
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
          SetError("*"..RequestAccess.EmailValidation_error,Email)

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
                      FirstName_bottom.isVisible = false
                      Name_bg.isVisible = false
                      Name_bottom.isVisible = false
                      Name.isVisible = false
                      Email_bg.isVisible = false
                      Email_bottom.isVisible = false
                      Email.isVisible = false
                      Phone_bg.isVisible = false
                      Phone_bottom.isVisible = false
                      Phone.isVisible = false

                      Marykay_id.isVisible = false
                      Marykay_id_helptext.isVisible = false
                      Marykay_bg.isVisible = false
                      Marykay.isVisible = false
                      Marykay_bottom.isVisible = false
                      Country_bg.isVisible = false
                      Countrytxt.isVisible = false
                      Country_bottom.isVisible = false
                      Language_bg.isVisible = false
                      Languagetxt.isVisible = false
                      Language_bottom.isVisible = false
                      Position_bg.isVisible = false
                      Positiontxt.isVisible = false
                      CountryLbl.isVisible = false
                      Country_icon.isVisible = false
                      LanguageLbl.isVisible = false
                      Language_icon.isVisible = false
                      PositionLbl.isVisible = false
                      Position_icon.isVisible = false
                      Position_bottom.isVisible = false
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

                 print("ttttt")

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

                                      cancelBtn_lbl.isVisible = false

                                      List.arrayName = positionArray
                                      List.label = PositionLbl
                                      List.value = "position"

                                      CreateList("position",List,List_bg)
                                      
                                    else
                                      List_bg.isVisible = false
                                      List:deleteAllRows()
                                      List.isVisible = false

                                      cancelBtn_lbl.isVisible = true

                                    end


                                  else

                                    List.isVisible = false
                                    List_bg.isVisible = false
                                    List:deleteAllRows()

                                  end

                                end

                              end










                              local function addevent_scrollListener(event )

                                local x, y = scrollView:getContentPosition()

                                local phase = event.phase

                                if ( phase == "began" ) then 

                                elseif ( phase == "moved" ) then 

                                  if y > -20 then
                                    FirstName.isVisible = true
                                    FirstName_bottom.isVisible = true
                                  else
                                    FirstName.isVisible = false
                                    FirstName_bottom.isVisible = false
                                  end



                                  if y > -30 then
                                    Name.isVisible = true
                                    Name_bottom.isVisible = true
                                  else
                                    Name.isVisible = false
                                    Name_bottom.isVisible = false
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

  Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
  Background.x=W/2;Background.y=H/2

  tabBar = display.newRect(sceneGroup,W/2,0,W,40)
  tabBar.y=tabBar.height/2
  tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))
  
  BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
  BgText.x=5;BgText.y=20
  BgText.anchorX=0

  title_bg = display.newRect(sceneGroup,0,0,W,30)
  title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
  title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )


  backBtn_bg_intro = display.newRect(sceneGroup,0,0,40,30)
  backBtn_bg_intro.x=20;backBtn_bg_intro.y=BgText.y+BgText.contentHeight/2+24
  backBtn_bg_intro.id = "cancel"
  backBtn_bg_intro.alpha=0.01

  backBtn_intro = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
  backBtn_intro.x=15;backBtn_intro.y=BgText.y+BgText.contentHeight/2+17
  backBtn_intro:setFillColor(0)
  backBtn_intro.xScale=-1
  backBtn_intro.id = "cancel"
  backBtn_intro.anchorY=0

  title = display.newText(sceneGroup,RegistrationScreen.Introduction,0,0,native.systemFont,18)
  title.anchorX = 0
  title.id = "cancel"
  title.x=backBtn_intro.x+15;title.y = title_bg.y
  title:setFillColor(0)


  backBtn_bg_intro:addEventListener("touch",backAction)
  backBtn_intro:addEventListener("touch",backAction)
  title:addEventListener("touch",backAction)

  Background:addEventListener("touch",touchBg)



  local t = "<p><span style=\"color: #bb0444;\"><span style=\"font-size: 24px;\"><strong>MyUnitBuzz</strong></p>\n\n<p>MyUnitBuzz is a complimentary communication app that offers Mary Kay Directors and NSDs a new and innovative way to connect with their Unit and an easier way for them to share exciting news and event details.&nbsp;</p>\n\n<p>With MyUnitBuzz, you can instantly share exciting news, pictures, and even send event invitations and training materials.&nbsp;</p>\n\n<p>&nbsp;</p>\n\n<p><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\"><strong>MyUnitBuzz Features:&nbsp;</strong></p>\n\n<ul>\n\t<li>\n\t<p>Customizable Messages</p>\n\t</li>\n\t<li>\n\t<p>Event Calendar</p>\n\t</li>\n\t<li>\n\t<p>Social Media</p>\n\t</li>\n\t<li>\n\t<p>Unit Career Path</p>\n\t</li>\n\t<li>\n\t<p>Unit Goals</p>\n\t</li>\n\t<li>\n\t<p>Image Library</p>\n\t</li>\n\t<li>\n\t<p>Document Library&nbsp;</p>\n\t</li>\n\t<li>\n\t<p>Chat&nbsp;</p>\n\t</li>\n\t<li>\n\t<p>Invite/Access&nbsp;</p><li>\n\t<p>Special Recognition</p>\n\t</li>\n\t</li>\n</ul>\n\n<p>&nbsp;</p>\n\n<p><strong><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\">Who can use MyUnitBuzz?&nbsp;</strong></p>\n\n<p>MyUnitBuzz is exclusively designed for Mary Kay Directors and NSDs, who are existing UnitWise members, to use to communicate with their Unit. Independent Beauty Consultants are able to join after being granted access to their Director&rsquo;s or NSD&rsquo;s MyUnitBuzz group.&nbsp;</p>\n\n<p>&nbsp;</p>\n\n<p><strong><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\">How do I Invite my Unit to MyUnitBuzz?</strong></p>\n\n<p>It&rsquo;s easier than you might think to invite your Unit to MyUnitBuzz!&nbsp;</p>\n\n<p>To let your Unit join you in the MyUnitBuzz app, provide them your Unit number, their user email address, and the temporary password that you&rsquo;ve created.&nbsp;</p>\n\n<p>&nbsp;</p>\n\n<p><strong><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\">What can MyUnitBuzz do for my Unit members?&nbsp;</strong></p>\n\n<p>Invite your Unit to your MyUnitBuzz app and start sharing team goals and important information with ease! With features like the event calendar, your Unit members can view details and see their assigned tasks during an event.&nbsp;</p>\n\n<p>You&nbsp;can also keep your Unit members on track by sharing important goals and accomplishments through the app. Plus, you can share training documents to keep them up to date, too!&nbsp;</p>\n\n<p>And you can do all this and more right from the palm of your hand!</p>\n"

    --local t = "<p><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\"><strong>MyUnitBuzz</strong></p>\n\n<p>MyUnitBuzz is a complimentary communication app that offers Mary Kay Directors and NSDs a new and innovative way to connect with their Unit and an easier way for them to share exciting news and event details.&nbsp;</p>\n\n<p>With MyUnitBuzz, you can instantly share exciting news, pictures, and even send event invitations and training materials.&nbsp;</p>\n\n<p><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\"><strong>MyUnitBuzz Features:&nbsp;</strong></p>\n\n<ul>\n\t<li>\n\t<p>Customizable Messages</p>\n\t</li>\n\t<li>\n\t<p>Event Calendar</p>\n\t</li>\n\t<li>\n\t<p>Social Media</p>\n\t</li>\n\t<li>\n\t<p>Unit Career Path</p>\n\t</li>\n\t<li>\n\t<p>Unit Goals</p>\n\t</li>\n\t<li>\n\t<p>Image Library</p>\n\t</li>\n\t<li>\n\t<p>Document Library&nbsp;</p>\n\t</li>\n</ul>\n\n<p><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\"><strong>Who can use MyUnitBuzz?&nbsp;</strong></p>\n\n<p>MyUnitBuzz is exclusively designed for Mary Kay Directors and NSDs, who are existing UnitWise members, to use to communicate with their Unit. Independent Beauty Consultants are able to join after being granted access to their Director&rsquo;s or NSD&rsquo;s MyUnitBuzz group.&nbsp;</p>\n\n<p><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\"><strong>How do I Invite my Unit to MyUnitBuzz?</strong></p>\n\n<p>It&rsquo;s easier than you might think to invite your Unit to MyUnitBuzz!&nbsp;</p>\n\n<p>To let your Unit join you in the MyUnitBuzz app, provide them your Unit number, their user email address, and the temporary password that you&rsquo;ve created.&nbsp;</p>\n\n<p><span style=\"color: #bb0444;\"><span style=\"font-size: 18px;\"><strong>What can MyUnitBuzz do for my Unit members?&nbsp;</strong></p>\n\n<p>Invite your Unit to your MyUnitBuzz app and start sharing team goals and important information with ease! With features like the event calendar, your Unit members can view details and see their assigned tasks during an event.&nbsp;</p>\n\n<p>You can also keep your Unit members on track by sharing important goals and accomplishments through the app. Plus, you can share training documents to keep them up to date, too!&nbsp;</p>\n\n<p>And you can do all this and more right from the palm of your hand!</p>\n"


    content = t

    local saveData = [[<!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    </head>]]..t..[[</html>]]

    local path = system.pathForFile( "introduction.html", system.DocumentsDirectory )

    local file, errorString = io.open( path, "w" )

    if not file then
      print( "File error: " .. errorString )
    else
      file:write( saveData )
      io.close( file )
    end

    file = nil

    webView = native.newWebView( display.contentCenterX, display.contentCenterY+15, display.viewableContentWidth, display.viewableContentHeight-110)
    webView.hasBackground=false
    webView:request( "introduction.html", system.DocumentsDirectory )
    sceneGroup:insert( webView )

    

    CreateAccountBtn = display.newRect(sceneGroup,0,0,W,35)
    CreateAccountBtn.x=W/2;CreateAccountBtn.y = H - 35
    CreateAccountBtn.width = W
    CreateAccountBtn.anchorY = 0
    CreateAccountBtn:setFillColor( 0,0,0,0.4 )
    CreateAccountBtn.id="create_account"

    CreateAccountBtn_text = display.newText(sceneGroup,RegistrationScreen.CreateAccount,0,0,native.systemFont,16)
    CreateAccountBtn_text.anchorX = 0
    CreateAccountBtn_text.anchorY = 0
    CreateAccountBtn_text.x=CreateAccountBtn.x-65
    CreateAccountBtn_text.y=CreateAccountBtn.y+8
    CreateAccountBtn_text:setFillColor(0)


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
              top = 35,
              left = 0,
              width = W,
              height = H-35,
              hideBackground = true,
              isBounceEnabled=false,
              horizontalScrollDisabled = true,
              friction = .4,
              bottomPadding = 50,
              listener = addevent_scrollListener,
            }

            sceneGroup:insert( scrollView )


            scrollView.isVisible = true

            
            backBtn_bg = display.newRect(sceneGroup,0,0,40,30)
            backBtn_bg.x=22;backBtn_bg.y=BgText.y+BgText.contentHeight/2+23
            backBtn_bg.id = "cancel"
            backBtn_bg.alpha=0.01

            backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
            backBtn.x=15;backBtn.y=BgText.y+BgText.contentHeight/2+16
            backBtn.xScale=-1
            backBtn.id = "cancel"
            backBtn.anchorY=0
            backBtn:setFillColor(0)

            page_title = display.newText(sceneGroup,RegistrationScreen.Registrationtext,0,0,native.systemFont,18)
            page_title.x=backBtn.x+14;page_title.y=backBtn.y+7.5
            page_title.anchorX=0
            page_title.id = "cancel"
            page_title:setFillColor(Utils.convertHexToRGB(color.Black))

            CreateAccountBtn.isVisible = false
            CreateAccountBtn_text.isVisible = false



                                -------------------------------------- first name -------------------------------------------

                                FirstName_bg = display.newRect(W/2, page_title.y+5, W-20, 25)
                                FirstName_bg.y =  page_title.y+5
                                FirstName_bg.alpha = 0.01
                                scrollView:insert(FirstName_bg)


                                FirstName = native.newTextField(W/2+3, page_title.y+5, W-20, 25)
                                FirstName.id="First Name"
                                FirstName.size=14   
                                FirstName.y =  page_title.y+5
                                FirstName.hasBackground = false
                                FirstName:setReturnKey( "next" )
                                FirstName.placeholder=RequestAccess.FirstName_placeholder
                                scrollView:insert(FirstName)

                                FirstName_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                FirstName_bottom.x=W/2
                                FirstName_bottom.y= FirstName.y+13
                                scrollView:insert(FirstName_bottom)

                                -------------------------------------Last name ----------------------------------------------

                                Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
                                Name_bg.y = FirstName_bg.y+FirstName_bg.height+7
                                Name_bg.alpha = 0.01
                                scrollView:insert(Name_bg)

                                
                                Name = native.newTextField( W/2+3, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
                                Name.id="Last Name"
                                Name.y = FirstName_bg.y+FirstName_bg.height+7
                                Name.size=14
                                Name:setReturnKey( "next" )
                                Name.hasBackground = false  
                                Name.placeholder = RequestAccess.LastName_placeholder
                                scrollView:insert(Name)

                                Name_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                Name_bottom.x=W/2
                                Name_bottom.y= Name.y+13
                                scrollView:insert(Name_bottom)


                                ----------------------------------Email address---------------------------------
                                

                                Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+7, W-20, 25 )
                                Email_bg.alpha = 0.01
                                scrollView:insert(Email_bg)


                                Email = native.newTextField(W/2+3, Name_bg.y+Name_bg.height+7, W-20, 25 )
                                Email.id="Email"
                                Email.size=14   
                                Email:setReturnKey( "next" )
                                Email.hasBackground = false
                                Email.placeholder=RequestAccess.EmailAddress_placeholder
                                scrollView:insert(Email)


                                Email_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                Email_bottom.x=W/2
                                Email_bottom.y= Email.y+13
                                scrollView:insert(Email_bottom)


                                -----------------------------------phone------------------------------------------
                                

                                Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.height+7, W-20, 25)
                                Phone_bg.alpha = 0.01
                                scrollView:insert(Phone_bg)

                                
                                Phone = native.newTextField(W/2+3, Email_bg.y+Email_bg.height+7, W-20, 25)
                                Phone.id="Phone"
                                Phone.size=14   
                                Phone:setReturnKey( "next" )
                                Phone.hasBackground = false
                                Phone.placeholder=RequestAccess.Phone_placeholder
                                Phone.inputType = "number"
                                scrollView:insert(Phone)


                                Phone_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                Phone_bottom.x=W/2
                                Phone_bottom.y= Phone.y+13
                                scrollView:insert(Phone_bottom)


                                -----------------------------------Marykay_id------------------------------------------

                                Marykay_id = display.newText(scrollView,RegistrationScreen.MaryKayIdtext,0,0,native.systemFont,14)
                                Marykay_id.x=16;Marykay_id.y=Phone_bottom.y+18
                                Marykay_id.anchorX=0
                                Marykay_id:setFillColor(Utils.convertHexToRGB(color.Black))
                                scrollView:insert(Marykay_id)


                                Marykay_id_helptext = display.newText(scrollView,"http://www.marykay.com/",0,0,native.systemFont,12)
                                Marykay_id_helptext.x=16;Marykay_id_helptext.y=Marykay_id.y+20
                                Marykay_id_helptext.anchorX=0
                                Marykay_id_helptext:setFillColor(Utils.convertHexToRGB(color.Black))
                                scrollView:insert(Marykay_id_helptext)


                                Marykay_bg = display.newRect(W/2, Marykay_id_helptext.y+Marykay_id_helptext.height+12, W-20, 25)
                                Marykay_bg.alpha = 0.01
                                scrollView:insert(Marykay_bg)

                                Marykay = native.newTextField(W/2+3, Marykay_id_helptext.y+Marykay_id_helptext.height+12, W-20, 25)
                                Marykay.id="Marykay_Id"
                                Marykay.size=14 
                                Marykay.placeholder = RequestAccess.Marykayid_placeholder
                                Marykay:setReturnKey( "next" )
                                Marykay.hasBackground = false
                                scrollView:insert(Marykay)

                                Marykay_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                Marykay_bottom.x=W/2
                                Marykay_bottom.y= Marykay.y+13
                                scrollView:insert(Marykay_bottom)


                                ------------------------------   Country and its dropdown   --------------------------------



                                Country_bg = display.newRect(W/2, Marykay_bg.y+Marykay_bg.height+12, W-20, 28)
                                Country_bg.alpha = 0.01
                                Country_bg.id = "country_bg"
                                Country_bg:addEventListener( "touch", TouchSelection )
                                scrollView:insert(Country_bg)


                                Countrytxt = display.newText(scrollView,RegistrationScreen.Countrytext,13,Marykay_bg.y+Marykay_bg.height+12,native.systemFont,14 )
                                Countrytxt.anchorX=0
                                Countrytxt.value=0
                                Countrytxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                Countrytxt.x=leftPadding
                                Countrytxt.y=Marykay_bg.y+Marykay_bg.height+12
                                scrollView:insert(Countrytxt)


                                Country_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                Country_bottom.x=W/2
                                Country_bottom.y= Countrytxt.y+13
                                scrollView:insert(Country_bottom)


                                CountryLbl = display.newText(scrollView,RegistrationScreen.CountryUsaText,W/2,Marykay_bg.y+Marykay_bg.height+12,native.systemFont,14 )
                                CountryLbl.anchorX=0
                                CountryLbl.value=0
                                CountryLbl.id="country_name"
                                CountryLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                CountryLbl.x=W/2 - 20
                                CountryLbl.y=Marykay_bg.y+Marykay_bg.height+12
                                scrollView:insert(CountryLbl)



                                Country_icon = display.newImageRect(scrollView,"res/assert/right-arrow(gray-).png",15/2,30/2 )
                                Country_icon.x=W-20
                                Country_icon.id = "country_bg"
                                Country_icon:setFillColor(0)
                                Country_icon.y=Marykay_bg.y+Marykay_bg.height+12
                                scrollView:insert(Country_icon)




                                 ------------------------------   Language and its dropdown   --------------------------------


                                 Language_bg = display.newRect(W/2, Country_bg.y+Country_bg.height+12, W-20, 28)
                                 Language_bg.alpha =0.01
                                 Language_bg.id = "language_bg"
                                 Language_bg:addEventListener( "touch", TouchSelection )
                                 scrollView:insert(Language_bg)

                                 Languagetxt = display.newText(scrollView,RegistrationScreen.Languagetext,13,Country_bg.y+Country_bg.height+12,native.systemFont,14 )
                                 Languagetxt.anchorX=0
                                 Languagetxt.value=0
                                 Languagetxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                 Languagetxt.x=leftPadding
                                 Languagetxt.y=Country_bg.y+Country_bg.height+12
                                 scrollView:insert(Languagetxt)

                                 Language_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                 Language_bottom.x=W/2
                                 Language_bottom.y= Languagetxt.y+13
                                 scrollView:insert(Language_bottom)


                                 LanguageLbl = display.newText(scrollView,RegistrationScreen.SelectLanguage,W/2,Country_bg.y+Country_bg.height+12,native.systemFont,14 )
                                 LanguageLbl.anchorX=0
                                 LanguageLbl.value=0
                                 LanguageLbl.id="language"
                                 LanguageLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                 LanguageLbl.x=W/2 - 20
                                 scrollView:insert(LanguageLbl)
                                 LanguageLbl.y=Country_bg.y+Country_bg.height+12


                                 Language_icon = display.newImageRect(scrollView,"res/assert/right-arrow(gray-).png",15/2,30/2 )
                                 Language_icon.x=W-20
                                 Language_icon:setFillColor(0)
                                 scrollView:insert(Language_icon)
                                 Language_icon.y=Country_bg.y+Country_bg.height+12


                                 ------------------------------   Country and its dropdown   --------------------------------


                                 Position_bg = display.newRect(W/2, Language_bg.y+Language_bg.height+12, W-20, 28)
                                 Position_bg.alpha = 0.01
                                 Position_bg.id = "position_bg"
                                 Position_bg:addEventListener( "touch", TouchSelection )
                                 scrollView:insert(Position_bg)


                                 Positiontxt = display.newText(scrollView,RegistrationScreen.Positiontext,13,Language_bg.y+Language_bg.height+12,native.systemFont,14 )
                                 Positiontxt.anchorX=0
                                 Positiontxt.value=0
                                 Positiontxt:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                 Positiontxt.x=leftPadding
                                 Positiontxt.y=Language_bg.y+Language_bg.height+12
                                 scrollView:insert(Positiontxt)

                                 Position_bottom = display.newImageRect(scrollView,"res/assert/line-large.png",W-20,5)
                                 Position_bottom.x=W/2
                                 Position_bottom.y= Positiontxt.y+13
                                 scrollView:insert(Position_bottom)


                                 PositionLbl = display.newText(scrollView,RegistrationScreen.SelectPosition,W/2,Language_bg.y+Language_bg.height+12,native.systemFont,14 )
                                 PositionLbl.anchorX=0
                                 PositionLbl.value=0
                                 PositionLbl.id="position"
                                 PositionLbl:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
                                 PositionLbl.x=W/2 - 20
                                 PositionLbl.y=Language_bg.y+Language_bg.height+12
                                 scrollView:insert(PositionLbl)


                                 Position_icon = display.newImageRect(scrollView,"res/assert/right-arrow(gray-).png",15/2,30/2 )
                                 Position_icon.x=W-20
                                 scrollView:insert(Position_icon)
                                 Position_icon:setFillColor(0)
                                 Position_icon.y=Language_bg.y+Language_bg.height+12



                                  ---------------------    submit button   ---------------------------------------------------


                                  registerBtn = display.newRect( 0,0,0,0 )
                                  registerBtn.x=W/2-15;registerBtn.y = Position_bg.y+Position_bg.height/2+40
                                  registerBtn.width=100
                                  registerBtn.height=30
                                  registerBtn.anchorX=0
                                  registerBtn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
                                  scrollView:insert(registerBtn)
                                  registerBtn.id="Register"


                                  registerBtn_lbl = display.newText( scrollView,RegistrationScreen.RegisterBtnText,0,0,native.systemFont,16 )
                                  registerBtn_lbl.y=registerBtn.y
                                  registerBtn_lbl.anchorX=0
                                  scrollView:insert(registerBtn_lbl)

                                  registerBtn.width = registerBtn_lbl.contentWidth+15
                                  registerBtn.x=W/2-registerBtn.contentWidth/2
                                  registerBtn_lbl.x = registerBtn.x+7.5



                                  local options = {
                                    width = 25,
                                    height = 25,
                                    numFrames = 4,
                                    sheetContentWidth = 50,
                                    sheetContentHeight = 50
                                  }

                                  local submit_spinnerSingleSheet = graphics.newImageSheet( "res/assert/requestProcess.png", options )

                                  submit_spinner = widget.newSpinner
                                  {
                                    width = 25,
                                    height = 25,
                                    deltaAngle = 10,
                                    sheet = submit_spinnerSingleSheet,
                                    startFrame = 1,
                                    incrementEvery = 20
                                  }


                                  submit_spinner.isVisible=false
                                  submit_spinner.x=registerBtn_lbl.x+registerBtn_lbl.contentWidth+15
                                  submit_spinner.y=registerBtn.y+registerBtn.contentHeight+5

                                        --registerBtn:addEventListener( "touch", sumbitBtnRelease )


                                        -- cancelBtn = display.newRect( 0,0,0,0 )
                                        -- cancelBtn.x=W/2;cancelBtn.y = Position_bg.y+Position_bg.height/2+30
                                        -- cancelBtn.width=100
                                        -- cancelBtn.height=30
                                        -- cancelBtn.anchorX=0
                                        -- sceneGroup:insert(cancelBtn)
                                        -- cancelBtn.id="Register"


                                        cancelBtn_lbl = display.newText( scrollView,CommonWords.cancel,0,0,native.systemFont,13 )
                                        cancelBtn_lbl.y= Position_bg.y+Position_bg.height/2+40
                                        cancelBtn_lbl.x = W - 60
                                        cancelBtn_lbl.id = "cancel"
                                        cancelBtn_lbl:setFillColor( 0,0,0.5 )
                                        cancelBtn_lbl.anchorX=0
                                        scrollView:insert(cancelBtn_lbl)



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


                                        List_bg = display.newRect( scrollView, 200, 100, W-20, 85 )
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


                                  CreateAccountBtn:addEventListener("touch",createAccount)



                                  
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