
local Class = {}
Class.__index = Class 

function Class.Create(Bot)
	local intialData = {
		PROXY = Bot.GenerateProxyTable({}, Class.Track())
	}
	local class = setmetatable(intialData,Class)
	return class 
end 

function Class.Track(t,k,v)

	print("TABLE: ", t)
	print("INDEX : ",k)
	print("VALUE : ", v)


end 

function Class:IntiateTrade()
 
end




function Class

