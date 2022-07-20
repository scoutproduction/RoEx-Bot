
local BOT_TEMPLATE = {}

function BOT_TEMPLATE.GenerateProxyTable(t, funct)
	local index = {}
	-- create metatable
	local mt = {
		__index = function (t,k)
			spawn(function() funct(t,k) end) -- threading like a boss
			print("*access to element " .. tostring(k))
			return t[index][k]   -- access the original table
		end,

		__newindex = function (t,k,v)
			spawn(function() funct(t,k,v) end) -- threading like a boss
			print("*update of element " .. tostring(k) ..
				" to " .. tostring(v))
			t[index][k] = v   -- update original table
		end
	}

	local proxy = {}
	proxy[index] = t
	setmetatable(proxy, mt)
	return proxy
end 


--dynamic 
BOT_TEMPLATE.CACHE = BOT_TEMPLATE.GenerateProxyTable({}, CACHE_INSTRUCTIONS)
BOT_TEMPLATE.CACHE.STATE = "Unassigned"
BOT_TEMPLATE.CACHE.READY = false 
BOT_TEMPLATE.CACHE.TRADING_ENABLED = false 

function CACHE_INSTRUCTIONS(t,k,v)
	if k == "STATE" then 
		warn("State Change")
	elseif k == "READY" then 
		warn("Ready Changed")
	elseif k == "TRADING_ENABLED" then 
		warn("Trading Enabled Changed")
	end 
end 

BOT_TEMPLATE.DATA = setmetatable({},{ __index = function(t,k)
	if BOT_TEMPLATE.LastPacket then 
		for i, v in pairs(BOT_TEMPLATE.LastPacket) do 
			if not BOT_TEMPLATE.DATA[i]  then 
				BOT_TEMPLATE.DATA[i] = v 
			end 
		end 
	end 
end})


function BOT_TEMPLATE:LoadData(packet)
	self.LastPacket = packet 
end 

function BOT_TEMPLATE:EditData(i,v)
	self.DATA[i] = v
end 

return BOT_TEMPLATE

