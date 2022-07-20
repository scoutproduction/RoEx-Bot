
local Class = {}
Class.__index = Class 

local tradeId = 'None'

function Class.Create(Bot)
	local intialData = {
		DESIRED_PET = Bot.DATA.ITEM_NAME;
		USERNAME =Bot.DATA.USER_NAME;
		PROXY = Bot.GenerateProxyTable({}, Class.Track())
	}
	local class = setmetatable(intialData,Class)
	return class 
end 

function Class.Track(t,k,v)
	
	print("TABLE: ", t)
	print("INDEX : ",k)
	print("VALUE : ", v)
	
	if tostring(k) == "get trade" then
		tradeId = v[1][1]
		print(tradeId)
	end
end 

function Class:IntiateTrade()
	local DESIRED_PET = self.DESIRED_PET
	local USERNAME = self.USERNAME
	local PROXY = self.PROXY

	local thumbnails = {}
	local library = require(game.ReplicatedStorage.Framework.Library)
	local directory = library.Directory
	local remotes = game.Workspace.__THINGS.__REMOTES


	print('running script')
--	wait(30)

	local function GetThumbnails()
		for index, pet in pairs(directory.Pets) do
			if pet.name == DESIRED_PET then
				thumbnails['normal'] = pet.thumbnail
				if pet.goldenThumbnail then
					thumbnails['golden'] = pet.goldenThumbnail
				end
				if pet.darkMatterThumbnail then
					thumbnails['dark'] = pet.darkMatterThumbnail
				end
			end
		end
		return thumbnails
	end

	local player = game.Players.LocalPlayer
	local pets = player.PlayerGui.Trading.Frame.Trade.Client.Pets

	local function GetId()
		for index, pet in pairs(pets:GetChildren()) do
			print(pet)
			if pet:IsA("TextButton") then
				for i, icon in pairs(GetThumbnails()) do
					if pet.PetIcon.Image == icon then
						return pet.Name
					end
				end
			end
		end
	end

	local mt = setmetatable(getrawmetatable(game),PROXY) 
	setreadyonly(mt,false)
	
	
	--[[mt.__namecall = function(self, ...)
		local args = { ... }
		local method = getnamecallmethod()

		if tostring(self) == "get trade" and method == "InvokeServer" then
			tradeId = args[1][1]
		end
		
		setreadyonly(mt,true)
		return namecall(self, ...)
	end
]]--


		
	
   --- WE NEED TO SET THE TRADE ID IN PROXY 

	remotes['send trade invite']:InvokeServer({ USERNAME })
	
	repeat wait() 
	until tradeId ~= "None"
		print(tradeId, " pet id: ", GetId())
		remotes['add trade pet']:InvokeServer({ tradeId, GetId() })
		wait(3)
		remotes['ready trade']:InvokeServer({ tradeId }) 
end

