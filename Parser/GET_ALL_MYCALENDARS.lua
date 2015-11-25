

require( "Webservice.ServiceManager" )
local json = require("json")


function GetAllMyCalendars()
local List_array = {}

response = Webservice.Get_All_MyCalendars()

response = response.response.body

response = json.decode(response)

		print("All calender : "..json.encode(response))
			--print("GetActiveTeammembers"..response[1].Last_Name)

			return response

		end


function GetTicklerEvents(CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic)
		local List_array = {}

		response = Webservice.Get_TicklerEvents(CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic)

		response = response.response.body

		response = json.decode(response)

		print("calender value pass by value : "..json.encode(response[1]))

		--print("GetActiveTeammembers"..json.decode(response.id))

		return response

end

function GetTicklerEventById(Id)
		local List_array = {}

		response = Webservice.Get_TicklerEventsById(Id)

		response = response.response.body

		response = json.decode(response)

		print("GetTicklerEventById : "..json.encode(response))

		--print("GetActiveTeammembers"..json.decode(response.id))

		return response

end




