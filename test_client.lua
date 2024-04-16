local tcp = require("tcp")
local device = peripheral.find("modem")
if device.isOpen ~= true then
    peripheral.find("modem", rednet.open)
end
if device ~= nil then
    print("find modem")
    local data = tcp.Establish(1, "TMP0010D85CF", 100).BuildClient(true).ReceiveTcpData(100, true)
    if data == nil then
        print("nil")
    end
    print(data)
end
