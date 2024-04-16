local tcp = require("tcp")
tcp.Establish(0).BuildClient().ReceiveTcpData(function (sender, msg)
    print(msg)
end)