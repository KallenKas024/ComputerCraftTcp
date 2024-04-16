local tcp = require("tcp")
tcp.Establish(1).BuildServer().SendTcpData("Hello world!")