local tcp = require("tcp")
local device = peripheral.find("modem")
if device.isOpen ~= true then
    peripheral.find("modem", rednet.open)
end
if device ~= nil then
    print("find modem")
    tcp.Establish(0, "TMP0010D85CF", 100).BuildServer(true).SendTcpData("Hello world!", true)
end
