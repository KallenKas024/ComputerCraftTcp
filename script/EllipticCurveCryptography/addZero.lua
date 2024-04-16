T = {}

T.ZeroTable = function ()
    local tb = {}
    for i=0, 5 do
        tb[i] = 0
    end
    return tb
end

T.ZERO = T.ZeroTable()

return T