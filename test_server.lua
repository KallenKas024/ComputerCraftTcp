local tcp = require("tcp")
local device = peripheral.find("modem")
if device.isOpen ~= true then
    peripheral.find("modem", rednet.open)
end
if device ~= nil then
    print("find modem")
    local tcpIns = tcp.Establish(0, "TMP0010D85CF", 100, true).BuildServer(true)
    tcpIns.SendTcpData("Hello world!", true)
    tcpIns.SendTcpData("Hello world! 2", true)
end
