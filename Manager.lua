
function ReturnFile(name) -- Return File 
	local map = readfile("RoEx-Bot/map.lua")
	return readfile(map[name])
end 

function ExecuteTrade(gameName,userName,itemName)
	local bot = ReturnFile('Bot')
	
	local function GetModule()
		for _, instance in pairs(script.Parent.classes.modules:GetChildren()) do 
			if string.find(string.upper(gameName), instance.Name) then 
				return instance
			end 
		end 
	end 

	bot:LoadData({  -- INTIAL DATA 
		GAME_NAME = gameName;
		USER_NAME = userName;
		ITEM_NAME = itemName; 
		MODULE_NAME = GetModule().Name; 
	}) 


	if bot.DATA.MODULE_NAME then 
		print("Assigning Class") 
		local class = ReturnFile(bot.DATA.MODULE_NAME)
		bot:LoadData({Class = class.Create(bot)})
		if bot.DATA.MODULE then 
			bot:IntiateTrade()
		end
	end 
end 

CreateBot("Pet Simulator X", "", "")

CreateBot("Adopt Me", "", "")


