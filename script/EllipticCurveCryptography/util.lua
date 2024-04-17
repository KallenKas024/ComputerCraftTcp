local util = {}

util.byteTableMT = {
	__tostring = function(a)
		return tostring(table.unpack(a))
	end,

	__index = {
		toHex = function(self)
			return string.format(string.rep("%02x", #self), table.unpack(self))
		end,

		isEqual = function(self, t)
			if type(t) ~= "table" then
				return false
			end

			if #self ~= #t then
				return false
			end

			local ret = 0
			for index, value in ipairs(self) do
				ret = bit32.bor(ret, bit32.bxor(value, t[index]))
			end

			return ret == 0
		end
	}
}

-- util.byteTableMT.__index = util.byteTableMT

local yieldTime  -- variable to store the time of the last yield
local function yield()
    if yieldTime then -- check if it already yielded
        if os.clock() - yieldTime > 2 then -- if it were more than 2 seconds since the last yield
            os.queueEvent("someFakeEvent") -- queue the event
            os.pullEvent("someFakeEvent") -- pull it
            yieldTime = nil -- reset the counter
        end
    else
        yieldTime = os.clock() -- set the time of the last yield
    end
end

function util.stringToByteArray(str)
	if type(str) ~= "string" then
		return {}
	end

	local length = #str
	if length < 7000 then
		local buf = table.pack(string.byte(str, 1, -1))
		return buf
	end

	local arr = {}
	for i = 1, length do
		-- os.sleep(0)
		arr[i] = string.byte(str, i)
		yield()
	end

	return arr
end


return util
