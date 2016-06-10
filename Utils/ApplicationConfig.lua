ApplicationConfig = {}



----------local---------------


--[[

IsLive = false
ApplicationConfig.BASE_URL = "http://192.168.1.47:9080"
ApplicationConfig.IMAGE_BASE_URL = "http://c.dotnetethic.com/"

ApplicationConfig.API_PUBLIC_KEY = "Or2tf5TjnfLObg5qZ1VfLOd"
ApplicationConfig.OneSignal_Appid ="ed71d878-798a-11e5-aebf-bbd8b0261071"
ApplicationConfig.ProjectNumber = "800876064299"
ApplicationConfig.API_PRIVATE_KEY = "ZujprDvpDDi4lvcitlgaRksJtpKxT7SOHiMxoB17i28"
ApplicationConfig.Analysic_TrackId = "UA-51545075-5"

--]]



-----------Dev-----------------

----[[

IsLive = false
ApplicationConfig.BASE_URL = "http://api.myunitapp.dotnetethic.com"
ApplicationConfig.IMAGE_BASE_URL = "http://c.dotnetethic.com/"

ApplicationConfig.API_PUBLIC_KEY = "Or2tf5TjnfLObg5qZ1VfLOd"
ApplicationConfig.OneSignal_Appid ="ed71d878-798a-11e5-aebf-bbd8b0261071"
ApplicationConfig.ProjectNumber = "800876064299"
ApplicationConfig.API_PRIVATE_KEY = "ZujprDvpDDi4lvcitlgaRksJtpKxT7SOHiMxoB17i28"
ApplicationConfig.Analysic_TrackId = "UA-51545075-5"

--]]



---------Stagging--------------

--[[

IsLive = false
ApplicationConfig.BASE_URL = "http://api.myunitbuzz.spanunit.com"
ApplicationConfig.IMAGE_BASE_URL = "http://c.spanunit.com/"
ApplicationConfig.API_PUBLIC_KEY = "Or2tf5TjnfLObg5qZ1VfLOd"
ApplicationConfig.OneSignal_Appid ="ed71d878-798a-11e5-aebf-bbd8b0261071"
ApplicationConfig.ProjectNumber = "800876064299"
ApplicationConfig.API_PRIVATE_KEY = "ZujprDvpDDi4lvcitlgaRksJtpKxT7SOHiMxoB17i28"
ApplicationConfig.Analysic_TrackId = "UA-51545075-5"

--]]




--[[---------Android Live----------------

IsLive = true

ApplicationConfig.Version = "/Android/1.2.5"	    --1.2.2

ApplicationConfig.BASE_URL = "http://api.myunitbuzz.com/"..ApplicationConfig.Version

ApplicationConfig.OneSignal_Appid = "e1eb0e41-5e12-488b-800a-5596fab2d45a"

ApplicationConfig.IMAGE_BASE_URL = "http://c.unitwise.com/"

ApplicationConfig.API_PUBLIC_KEY = "gVbPxZHlEcnaM5LLEQ7j7Wc"

ApplicationConfig.ProjectNumber = "464801321790"

ApplicationConfig.API_PRIVATE_KEY = "5Doh1kteJKYZbSemCipRTGZiyzRAAhkSKEDhAf5TPcY"

ApplicationConfig.Analysic_TrackId = "UA-51545075-4"

--]]



--[[---------IOS Live----------------

IsLive = true


ApplicationConfig.Version = "/iOS/1.2.6"	    --1.1.2

ApplicationConfig.BASE_URL = "http://api.myunitbuzz.com/"..ApplicationConfig.Version

ApplicationConfig.OneSignal_Appid = "e1eb0e41-5e12-488b-800a-5596fab2d45a"

ApplicationConfig.IMAGE_BASE_URL = "http://c.unitwise.com/"

ApplicationConfig.API_PUBLIC_KEY = "1WpGzpHPab445FJgxSpo8NJ"

ApplicationConfig.ProjectNumber = "464801321790"

ApplicationConfig.API_PRIVATE_KEY = "i67cHiLg5p7XkrnLrW2L6x4xNsqpNworZgboKHGHpdc"

ApplicationConfig.Analysic_TrackId = "UA-51545075-4"

--]]



ApplicationConfig.testUrl = ApplicationConfig.BASE_URL.."/Therapy/List"

ApplicationConfig.GET_LIST_OF_RANKS = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetListOfMkRanks"

ApplicationConfig.REQUEST_ACCESS = ApplicationConfig.BASE_URL.."/MyUnitBuzz/MyUnitBuzzRequestAccess"

ApplicationConfig.SEND_MESSAGE = ApplicationConfig.BASE_URL.."/MyUnitBuzz/SaveMyUnitBuzzMessages"

ApplicationConfig.LOGIN_ACCESS = ApplicationConfig.BASE_URL.."/MyUnitBuzz/SignIn"

ApplicationConfig.GetMyUnitAppGoals = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetMyUnitBuzzGoalsbyUserId"

ApplicationConfig.GetAllMyUnitAppImage = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetAllMyUnitBuzzImagebyUserId"

ApplicationConfig.GetAllMyUnitAppDocument = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetAllMyUnitBuzzDocumentbyUserId"

ApplicationConfig.GetActiveTeammembers = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetActiveTeammembers"

ApplicationConfig.GetActiveTeammemberDetails = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetContactsTeamBuilding"

ApplicationConfig.GetAllMyCalendars = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/GetAllMyCalendars"

ApplicationConfig.GetTicklerEvents = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/GetTicklerEvents"

ApplicationConfig.GetTicklerEventById = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/GetTicklerEventById"

ApplicationConfig.GetSearchByUnitNumberOrDirectorName = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetAllUnitNumber"

ApplicationConfig.ForgotPassword = ApplicationConfig.BASE_URL.."/MyUnitBuzz/ForgotPassword"

ApplicationConfig.GetUpComingEvents = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/GetUpComingEvents"

ApplicationConfig.GetLatestVersionCommonAppForAndroid = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetLatestVersionCommonAppForAndroid"

ApplicationConfig.GetLatestVersionCommonAppForIos = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetLatestVersionCommonAppForIos"

ApplicationConfig.SignOut = ApplicationConfig.BASE_URL.."/MyUnitBuzz/SignOut"

ApplicationConfig.GetSocialMediaTokens = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetSocialMediaTokens"

ApplicationConfig.CreateTickler = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/CreateTickler"

ApplicationConfig.DOCUMENT_UPLOAD = ApplicationConfig.BASE_URL.."/MyUnitBuzz/DocumentUpload"

ApplicationConfig.GetContactsWithLead = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetContactsWithLeadAutoComplete"

ApplicationConfig.CreateQuickcContact = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/CreateQuickcContact"

ApplicationConfig.DeleteTicklerEvent = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/DeleteTicklerEvent"

ApplicationConfig.GetUnitWiseRegister = ApplicationConfig.BASE_URL.."/MyUnitBuzz/CheckNotInUnitWiseRegister"

ApplicationConfig.SaveAttachmentDetails = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/SaveAttachmentDetails"

ApplicationConfig.RemoveOrBlockContact = ApplicationConfig.BASE_URL.."/MyUnitBuzz/UpdateContactStatus"

ApplicationConfig.AccessPermissionDetails = ApplicationConfig.BASE_URL.."/MyUnitBuzz/SaveAccessPermissionsDetails"

ApplicationConfig.SaveMyUnitBuzzGoals = ApplicationConfig.BASE_URL.."/MyUnitBuzz/SaveMyUnitBuzzGoals"

ApplicationConfig.UpdateTicklerRecur = ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/UpdateTicklerRecur"

ApplicationConfig.GetMyUnitBuzzRequestAccesses = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetMyUnitBuzzRequestAccesses"

ApplicationConfig.GetGeneratePassword = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GeneratePassword"

ApplicationConfig.CheckExistsRequestStatus = ApplicationConfig.BASE_URL.."/MyUnitBuzz/MyUnitBuzzCheckExistsRequestStatus"

ApplicationConfig.GetUserPreferencebyUserId =  ApplicationConfig.BASE_URL.."/MyUnitBuzzCalendar/GetUserPreferencebyUserId"

ApplicationConfig.GetMyUnitBuzzRequestAccessPermissionsDetail = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetMyUnitBuzzRequestAccessPermissionsDetail"

ApplicationConfig.CreateMessageChatGroup = ApplicationConfig.BASE_URL.."/MyUnitBuzz/CreateMessageChatGroup"

ApplicationConfig.GetChatMessageGroupList = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetChatMessageGroupList"

ApplicationConfig.AddTeamMemberToChatGroup = ApplicationConfig.BASE_URL.."/MyUnitBuzz/AddTeamMemberToChatGroup"

ApplicationConfig.GetMessagessListbyMessageStatus = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetMessagessListbyMessageStatus"

ApplicationConfig.DeleteMyUnitBuzzMessages = ApplicationConfig.BASE_URL.."/MyUnitBuzz/DeleteMyUnitBuzzMessages"

ApplicationConfig.GetActiveChatTeammembersList = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetActiveChatTeammembersList"

ApplicationConfig.GetMessageGroupTeamMemberList = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetMessageGroupTeamMemberList"

ApplicationConfig.UpdateLastActivityDate = ApplicationConfig.BASE_URL.."/MyUnitBuzz/UpdateLastActivityDate"

ApplicationConfig.GetContactInformation = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetContactInformation"

ApplicationConfig.GetAllSpecialRecognitions = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetAllSpecialRecognitions"

ApplicationConfig.GetSpecialRecognitionPageContent = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetSpecialRecognitionPageContent"

ApplicationConfig.GetAllCountry = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetAllCountry"

ApplicationConfig.GetCountryLanguagesbyCountryCode = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetCountryLanguagesbyCountryCode"

ApplicationConfig.GetPositionbyCountryIdandLanguageId = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetPositionbyCountryIdandLanguageId"


