ApplicationConfig = {}


	----------Dev---------------
IsLive = false
ApplicationConfig.BASE_URL = "http://api.myunitapp.dotnetethic.com"
ApplicationConfig.IMAGE_BASE_URL = "http://c.dotnetethic.com/"

ApplicationConfig.API_PUBLIC_KEY = "Or2tf5TjnfLObg5qZ1VfLOd"

ApplicationConfig.API_PRIVATE_KEY = "ZujprDvpDDi4lvcitlgaRksJtpKxT7SOHiMxoB17i28"

--[[------Stagging--------

IsLive = false
ApplicationConfig.BASE_URL = "http://api.myunitbuzz.spanunit.com"
ApplicationConfig.IMAGE_BASE_URL = "http://c.spanunit.com/"

ApplicationConfig.API_PUBLIC_KEY = "Or2tf5TjnfLObg5qZ1VfLOd"

ApplicationConfig.API_PRIVATE_KEY = "ZujprDvpDDi4lvcitlgaRksJtpKxT7SOHiMxoB17i28"]]

--[[---------Live----------------

IsLive = true

ApplicationConfig.Version = "/Android/1.0.0"

ApplicationConfig.BASE_URL = "http://api.myunitbuzz.com/"..ApplicationConfig.Version


ApplicationConfig.IMAGE_BASE_URL = "http://c.unitwise.com/"

ApplicationConfig.API_PUBLIC_KEY = "pS41tCI3ASAdaswRG7G4tUb"

ApplicationConfig.API_PRIVATE_KEY = "oyLvQ7ia7r2SsQMXjPJprzYeNBNK4azemXBYPwTHjLU"]]



ApplicationConfig.testUrl = ApplicationConfig.BASE_URL.."/Therapy/List"

ApplicationConfig.GET_LIST_OF_RANKS = ApplicationConfig.BASE_URL.."/MyUnitBuzz/GetListOfMkRanks"

ApplicationConfig.REQUEST_ACCESS = ApplicationConfig.BASE_URL.."/MyUnitBuzz/MyUnitBuzzRequestAccess"

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








