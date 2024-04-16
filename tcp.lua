fun = {}
fun.ZERO = require("script.EllipticCurveCryptography.addZero").ZERO
fun.Establish = function(clientID, tmpProtocol, tmpTimeOut)
tcp = {}
tcp.pub = ""
tcp.pri = ""
tcp.pk = ""
tcp.finalKey = ""
tcp.clientID = clientID
tcp.tmpProtocol = tmpProtocol
tcp.tmpTimeout = tmpTimeOut
function kp()
	local ecdh = require("script.EllipticCurveCryptography.init")
	-- local rand = require("script.EllipticCurveCryptography.random")
	local tmp = ecdh.keypair()
	tcp.pri = string.format(string.rep("%02x", #tmp[1]), table.unpack(tmp[1]))
	tcp.pub = string.format(string.rep("%02x", #tmp[2]), table.unpack(tmp[2]))
end

kp()

tcp.BuildServer = function (isprint)
	rednet.send(tcp.clientID, tcp.pub, tcp.tmpProtocol)
	if isprint ~= nil then
		print("SendPubKey")
	end
	_, tcp.pk, _2 = rednet.receive(tcp.tmpProtocol, tcp.tmpTimeOut)
	local ecdh = require("script.EllipticCurveCryptography.init")
	tcp.finalKey = ecdh.exchange(tcp.pri, tcp.pk).toHex()
	return tcp
end

tcp.BuildClient = function (isprint)
	_, tcp.pk, _2 = rednet.receive(tcp.tmpProtocol, tcp.tmpTimeOut)
	if isprint ~= nil then
		print("ReceivePubKey")
	end
	local ecdh = require("script.EllipticCurveCryptography.init")
	tcp.finalKey = ecdh.exchange(tcp.pri, tcp.pk).toHex()
	return tcp
end

tcp.SendTcpData = function(msg, isprint)
	local ecdh = require("script.EllipticCurveCryptography.init")
    local encodingMsg = ecdh.encrypt(msg, tcp.finalKey).toHex()
	local sign = ecdh.sign(tcp.pri, tcp.finalKey).toHex()
	rednet.send(tcp.clientID, {encodingMsg, sign}, tcp.finalKey)
	if isprint ~= nil then
		print("Sended Data")
	end
end

tcp.ReceiveTcpData = function(timeout, isprint)
	local _, tb_data, _2 = rednet.receive(tcp.finalKey, timeout)
	if isprint ~= nil then
		print("Got Data")
	end
	local eMsg = tb_data[1]
	local signData = tb_data[2]
	local ecdh = require("script.EllipticCurveCryptography.init")
	local sign = ecdh.verify(tcp.pk, tcp.finalKey, signData)
	if sign then
		local msg = ecdh.decrypt(eMsg, tcp.finalKey).toHex()
		return msg
	else
		return nil
	end
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
