-- This is the test file used in developpement of features of N.A.C.T. do not incldue it in production
-- It is used with TestingMap from nanos-world


Package.Subscribe("Load", function()
    Console.Log("N.A.C.T. Debug tools enabled")

    local sTestZoneName = "ShedByTheSea"

    NACT_RegisterTerritory(sTestZoneName, {
        -- TODO: In the future they should be calculated automatically
        -- TODO: In the meantime it would be nice to have some debug options that will
        -- TODO: With chat commands write the cover points with the current gait mode
        -- TODO: Like:
        -- TODO: /nact editor on
        -- TODO: /nact load "ShedByTheSea"
        -- TODO: /nact cover show
        -- TODO: /nact cover add
        -- TODO: /nact cover remove
        -- TODO: /nact save "SedByTheSea"
        coverPoints = {
            {
                pos = Vector(9799.259, -2928.79, 123.70),
                stance = StanceMode.Crouching,
                -- TODO Move from NACT_Territory when it exists
                secure = false,
                takenBy = nil
            },
            {
                pos = Vector(9659.35, -2664.49, 178.55),
                stance = StanceMode.Crouching,
                secure = false,
                takenBy = nil
            },
            {
                pos = Vector(6443.207, 9828.52, 232.66),
                stance = StanceMode.Standing,
                secure = false,
                takenBy = nil
            },
            {
                pos = Vector(6579.92, -10027.65, 201.87),
                stance = StanceMode.Standing,
                secure = false,
                takenBy = nil
            }
        },
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
    cDebugNPC2:PickUp(wAk472)

    NACT_RegisterNpc(cDebugNPC2, sTestZoneName)
    Console.Log("Ok")
end)

Player.Subscribe("Spawn", function(player)
    --player:GetCharacter():SetTeam(1)

end)
