-- This is the test file used in developpement of features of N.A.C.T. do not incldue it in production
-- It is used with TestingMap from nanos-world


Package.Subscribe("Load", function()
    Console.Log("N.A.C.T. Debug tools enabled")

    local sTestZoneName = "ShedByTheSea"

    NACT_RegisterTerritory(sTestZoneName, {
        coverPoints = {},
        zoneBounds = {}
    })


    local wAk47 = AK47(Vector(1035, 154, 300), Rotator())
    local cDebugNPC = Character(Vector(6552.520, -8691.16, 467), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
    cDebugNPC:SetTeam(1)
    cDebugNPC:PickUp(wAk47)

    NACT_RegisterNpc(cDebugNPC, sTestZoneName)


    local wAk472 = AK47(Vector(1035, 154, 300), Rotator())
    local cDebugNPC2 = Character(Vector(8363.520, -4661.16, 467), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
    cDebugNPC2:SetTeam(1)
    cDebugNPC2:PickUp(wAk47)

    NACT_RegisterNpc(cDebugNPC2, sTestZoneName)
    Console.Log("Ok")
end)
