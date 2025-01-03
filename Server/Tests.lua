-- This is the test file used in developpement of features of N.A.C.T. do not incldue it in production
-- It is used with TestingMap from nanos-world


NACT_TEST_SCENARIO = 1

Package.Subscribe("Load", function()
    Console.Log("N.A.C.T. Debug tools enabled")
    local StillNpc = {behaviors =  {NACT_Idle, NACT_Detection, NACT_Combat}}
    local PatrollingNpc = {behaviors = {NACT_Idle, NACT_Patrol, NACT_Combat}}

    if (NACT_TEST_SCENARIO == 1) then
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
        wAk47:SetAutoReload(false)
        local cDebugNPC = Character(Vector(6552.520, -8691.16, 467), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC:SetTeam(1)
        cDebugNPC:PickUp(wAk47)

        NACT_RegisterNpc(cDebugNPC, sTestZoneName, StillNpc)


        local wAk472 = AK47(Vector(1035, 154, 300), Rotator())
        wAk472:SetAutoReload(false)
        local cDebugNPC2 = Character(Vector(8363.520, -4661.16, 467), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC2:SetTeam(1)
        cDebugNPC2:PickUp(wAk472)

        NACT_RegisterNpc(cDebugNPC2, sTestZoneName, StillNpc)
        Console.Log("Ok")
    end

    if (NACT_TEST_SCENARIO == 2) then
        local bigEnemyCamp = NACT_RegisterTerritory("BigEnemyCamp", {
            patrolRoutes = {
                aroundCamp = {
                    points = {
                        Vector(-1387.71, 9813.96, 128.85),
                        Vector(-312.75, 7883.72, 215.93),
                        Vector(-629.08, 4125.37, 218.37),
                        Vector(-3505.57, 4941.68, 234),
                        Vector(-6482.53, 6998.78, 199),
                        Vector(-6746.36, 9696.54, 136.40),
                        Vector(-3670.74, 9917.47, 136.26)
                    },
                    walkMethod = "circle"
                }
            },
            coverPoints = {}
        })

        
        local wAk473 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        local cDebugNPC3 = Character(Vector(3350.32, 9236.51, 188.45), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC3:PickUp(wAk473)
        cDebugNPC3:SetTeam(1)
        NACT_RegisterNpc(cDebugNPC3, "BigEnemyCamp", PatrollingNpc)

    end
end)

Player.Subscribe("Spawn", function(player)
    --player:GetCharacter():SetTeam(1)

end)
