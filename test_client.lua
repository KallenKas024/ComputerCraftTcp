local tcp = require("tcp")
local device = peripheral.find("modem")
if device.isOpen ~= true then
    peripheral.find("modem", rednet.open)
end
if device ~= nil then
    print("find modem")
    local tcpIns = tcp.Establish(1, "TMP0010D85CF", 100, true).BuildClient(true)
    local data = tcpIns.ReceiveTcpData(100, true)
    local data2 = tcpIns.ReceiveTcpData(100, true)
    if data == nil then
        print("nil")
    end
    if data2 == nil then
        print("nil2")
    end
    print(data)
    print(data2)
end
