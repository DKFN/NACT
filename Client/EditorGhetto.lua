local allPoints = {}

Console.RegisterCommand("naddcover", function()
    local LP = Client.GetLocalPlayer()
    local tPos = Vector()
    local eStance = 0

    local eChar = LP:GetControlledCharacter()
    if eChar and eChar:IsValid() then
        tPos = eChar:GetLocation()
        eStance = eChar:GetStanceMode()
    else
        tPos = LP:GetCameraLocation()
    end

    local sResult = ("{\n pos = Vector(%s, %s, %s),\n stance = %s\n}"):format(tPos.X, tPos.Y, tPos.Z, eStance)
    Console.Log("Copied cover info as : "..sResult)
    table.insert(allPoints, sResult)
    Client.CopyToClipboard(sResult)
end)

Console.RegisterCommand("nallcovers", function() 
    local sFinal = ""
    for i, s in ipairs(allPoints) do
        sFinal = sFinal..","..s
    end
    Console.Log(sFinal)
    Client.CopyToClipboard(sFinal)
end)

Console.RegisterCommand("nresetcovers", function()
    allPoints = {}
end)


Console.RegisterCommand("nallynpc", function()
    Events.CallRemote("NACT:DEBUG:SPAWN_ALLY_NPC", Client.GetLocalPlayer():GetCameraLocation())
end)
