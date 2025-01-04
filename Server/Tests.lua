-- This is the test file used in developpement of features of N.A.C.T. do not incldue it in production
-- It is used with TestingMap from nanos-world


NACT_TEST_SCENARIO = 3

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
                },
                
                {
                    pos = Vector(6427.33, -9828.09, 225.01),
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
            coverPoints = {
                -- Pillars
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1593.31, 7752.51, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1404.31, 7977.59, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1555.09, 8191.83, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1831.69, 8091.83, 199.11),
                    secure = false,
                    takenBy = nil
                },
                -- House 1
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-2102.33, 6983.11, 225.62),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1862.27, 6476.46, 171.86),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1974.46, 6508.96, 225.62),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-2176.58, 6395.58, 225.62),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-1560.02, 6549.36, 199.11),
                    secure = false,
                    takenBy = nil
                },
                -- House 2
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-3793.58, 8632.55, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-3715.83, 8342.52, 214.06),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4184.83, 8213.54, 214.06),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4173.97, 8327.27, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4180.46, 7931.48, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-3930.42, 7931.42, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-3600.11, 8069.73, 199.11),
                    secure = false,
                    takenBy = nil
                },

                -- House 3
                
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4665.83, 6939.65, 236.85),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4705.88, 7438.09, 236.85),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4919.11, 7440.97, 236.85),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4974.38, 7579.03, 199.11),
                    secure = false,
                    takenBy = nil
                },
                {
                    stance = StanceMode.Standing,
                    pos = Vector(-4483.30, 7309.64, 199.11),
                    secure = false,
                    takenBy = nil
                },
            }
        })

        
        local wAk473 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        local cDebugNPC3 = Character(Vector(3350.32, 9236.51, 188.45), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC3:PickUp(wAk473)
        cDebugNPC3:SetTeam(1)
        NACT_RegisterNpc(cDebugNPC3, "BigEnemyCamp", PatrollingNpc)

        
        local wAk474 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        local cDebugNPC4 = Character(Vector(-2810.47, 6807.50, 199.3), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC4:PickUp(wAk474)
        cDebugNPC4:SetTeam(1)
        NACT_RegisterNpc(cDebugNPC4, "BigEnemyCamp", StillNpc)

        local wAk475 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        local cDebugNPC5 = Character(Vector(-3893.92, 7539.05, 199.3), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC5:PickUp(wAk475)
        cDebugNPC5:SetTeam(1)
        NACT_RegisterNpc(cDebugNPC5, "BigEnemyCamp", StillNpc)

        local wAk476 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        local cDebugNPC6 = Character(Vector(-4267.27, 6199.80, 199.3), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC6:PickUp(wAk476)
        cDebugNPC6:SetTeam(1)
        NACT_RegisterNpc(cDebugNPC6, "BigEnemyCamp", StillNpc)

    end

    if (NACT_TEST_SCENARIO == 3) then
        local sTestZoneName = "SolideLaMap"
        NACT_RegisterTerritory(sTestZoneName, {
            coverPoints = {
                {
                pos = Vector(-3788.0, -288.62, 198.14),
                stance = StanceMode.Standing,
                secure = false,
                takenBy = nil
            }, {
                pos = Vector(-3788.0, -592, 198.14),
                stance = StanceMode.Standing,
                secure = false,
                takenBy = nil
            }, {
                pos = Vector(-3223, 328.5, 198.1),
                stance = StanceMode.Crouching,
                secure = false,
                takenBy = nil
            }, {
                pos = Vector(-4063, 1323, 198.1),
                stance = StanceMode.Crouching,
                secure = false,
                takenBy = nil
            }
        },
            zoneBounds = {},
            patrolRoutes = {}
        })
        

        
        local wAk47 = AK47(Vector(1035, 154, 300), Rotator())
        wAk47:SetAutoReload(false)
        local cDebugNPC = Character(Vector(-3982.9, -417.69, 198), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC:SetTeam(1)
        cDebugNPC:PickUp(wAk47)

        NACT_RegisterNpc(cDebugNPC, sTestZoneName, StillNpc)

        local wAk472 = AK47(Vector(1035, 154, 300), Rotator())
        wAk472:SetAutoReload(false)
        local cDebugNPC2 = Character(Vector(-3634.6, -714.73, 198), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC2:SetTeam(1)
        cDebugNPC2:PickUp(wAk472)

        NACT_RegisterNpc(cDebugNPC2, sTestZoneName, StillNpc)

    end
end)

Player.Subscribe("Spawn", function(player)
    --player:GetCharacter():SetTeam(1)

end)
