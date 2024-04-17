fun = {}
fun.ZERO = require("script.EllipticCurveCryptography.addZero").ZERO
fun.Establish = function(clientID, tmpProtocol, tmpTimeOut, isprintKP)
tcp = {}
tcp.pub = {}
tcp.pri = {}
tcp.pk = {}
tcp.finalKey = ""
tcp.clientID = clientID
tcp.tmpProtocol = tmpProtocol
tcp.tmpTimeout = tmpTimeOut
tcp.isprintKP = isprintKP
function kp()
	local ecdh = require("script.EllipticCurveCryptography.init")
	-- local rand = require("script.EllipticCurveCryptography.random")
	if tcp.isprintKP ~= nil then
		print("Creating Keypair ...")
	end
	-- math.randomseed()
	local epoch = math.random(9999999)
	if tcp.isprintKP ~= nil then
		print("Seed = " .. tostring(epoch))
	end
	local tmp = ecdh.keypair(epoch)
	if tcp.isprintKP ~= nil then
		print("CreatedKeypair")
	end
	tcp.pri = tmp[1]
	tcp.pub = tmp[2]
	if tcp.isprintKP ~= nil then
		print("PriKey = " .. tostring(tcp.pri))
		print("PubKey = " .. tostring(tcp.pub))
	end
end

function hex_to_bytes(hex)
    local bytes = {}
    for i = 1, #hex, 2 do
        local byte = string.sub(hex, i, i+1)
        table.insert(bytes, tonumber(byte, 16))
    end
    return bytes
end

kp()

tcp.BuildServer = function (isprint)
	rednet.send(tcp.clientID, tcp.pub, tcp.tmpProtocol)
	if isprint ~= nil then
		print("SendPubKey")
	end
	_, tcp.pk, _2 = rednet.receive(tcp.tmpProtocol, tcp.tmpTimeOut)
	local ecdh = require("script.EllipticCurveCryptography.init")
	local tmpEx = ecdh.exchange(tcp.pri, tcp.pk)
	tcp.finalKey =  string.format(string.rep("%02x", #tmpEx), table.unpack(tmpEx))
	if isprint ~= nil then
		print("finalKey -> " .. tcp.finalKey)
	end
	return tcp
end

tcp.BuildClient = function (isprint)
	_, tcp.pk, _2 = rednet.receive(tcp.tmpProtocol, tcp.tmpTimeOut)
	if isprint ~= nil then
		print("ReceivePubKey")
	end
	local ecdh = require("script.EllipticCurveCryptography.init")
	local tmpEx = ecdh.exchange(tcp.pri, tcp.pk)
	tcp.finalKey = string.format(string.rep("%02x", #tmpEx), table.unpack(tmpEx))
	if isprint ~= nil then
		print("finalKey -> " .. tcp.finalKey)
	end
	rednet.send(clientID, tcp.pub, tcp.tmpProtocol)
	if isprint ~= nil then
		print("SendedPubKey")
	end
	return tcp
end

tcp.SendTcpData = function(msg, isprint)
	rednet.send(tcp.clientID, msg, tcp.finalKey)
	if isprint ~= nil then
		print("Sended Data")
	end
end

tcp.ReceiveTcpData = function(timeout, isprint)
	local _, data, _2 = rednet.receive(tcp.finalKey, timeout)
	if isprint ~= nil then
		print("Got Data")
	end
	return data
end

tcp.close = function (side)
	return rednet.close(side)
end

tcp.isOpen = function (side)
	return rednet.isOpen(side)
end

	return tcp
end

return fun
