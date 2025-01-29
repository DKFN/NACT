-- This is the test file used in developpement of features of N.A.C.T. do not incldue it in production
-- It is used with TestingMap from nanos-world


NACT_TEST_SCENARIO = 4
NACT_NPC_TEAMS = 1

local StillNpc = {behaviors = {
    { class = NACT_Idle },
    { class = NACT_Detection},
    { class = NACT_Alert},
    { class = NACT_Combat},
    { class = NACT_Engage},
    { class = NACT_Seek},
    { class = NACT_Cover},

}}
local PatrollingNpc = {behaviors = {
    { class = NACT_Idle },
    { class = NACT_Patrol},
    { class = NACT_Alert},
    { class = NACT_Combat},
    { class = NACT_Engage},
    { class = NACT_Seek},
    { class = NACT_Cover},
}}


local PatrollingNpcGatefront = {behaviors = {
    { class = NACT_Idle },
    { class = NACT_Patrol, config = {
        patrolPath = "gateFront"
    }},
    { class = NACT_Alert},
    { class = NACT_Combat},
    { class = NACT_Engage},
    { class = NACT_Seek},
    { class = NACT_Cover},
}}


local PatrollingNpcFrontCamp = {behaviors = {
    { class = NACT_Idle },
    { class = NACT_Patrol, config = {
        patrolPath = "frontCamp",
        waitForMin = 2000,
        waitForMax = 2000
    }},
    { class = NACT_Alert},
    { class = NACT_Combat},
    { class = NACT_Engage},
    { class = NACT_Seek},
    { class = NACT_Cover},
}}

local PatrollingNpcFrontDatacenter = {behaviors = {
    { class = NACT_Idle },
    { class = NACT_Patrol, config = {
        patrolPath = "frontDatacenter",
        waitForMin = 2000,
        waitForMax = 2000
    }},
    { class = NACT_Alert},
    { class = NACT_Combat},
    { class = NACT_Engage},
    { class = NACT_Seek},
    { class = NACT_Cover},
}}

local ZombieNpc = {}

-- ZombieNpc:AddBehavior(NACT_Idle, {timerTime = 1000})
-- npc:SetBehaviorConfig(NACT_Patrol, {maxIdleAtPoint = 5000})
-- npc:SetBehaviorValue(NACT_Patrol, "maxIdleAtPoint", 5000)

-- tBehaviorConfig = {
--    class = NACT_Patrol,
--    config = {
--        maxIdleAtPoint = 5000
--    }
--}

Package.Subscribe("Load", function()
    Console.Log("N.A.C.T. Debug tools enabled")

    if (NACT_TEST_SCENARIO == 1) then
        local sTestZoneName = "ShedByTheSea"

        NACT.RegisterTerritory(sTestZoneName, {
            zoneBounds = {
                pos = Vector(4930.06, -6576.22, 199.34),
                radius = 7000
            },
            team = NACT_NPC_TEAMS,
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
            }
        })


        local wAk47 = AK47(Vector(1035, 154, 300), Rotator())
        wAk47:SetAutoReload(false)
        local cDebugNPC = Character(Vector(6552.520, -8691.16, 467), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC:SetTeam(1)
        cDebugNPC:PickUp(wAk47)

        NACT.RegisterNpc(cDebugNPC, sTestZoneName, StillNpc)


        local wAk472 = AK47(Vector(1035, 154, 300), Rotator())
        wAk472:SetAutoReload(false)
        local cDebugNPC2 = Character(Vector(8363.520, -4661.16, 467), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC2:SetTeam(1)
        cDebugNPC2:PickUp(wAk472)

        NACT.RegisterNpc(cDebugNPC2, sTestZoneName, StillNpc)
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

    if (NACT_TEST_SCENARIO == 4) then

        local mapCoverPoints = {
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
            },
            -- Gate entry
            {
            pos = Vector(-6665.8082319788, 11384.733197963, 166.15000552429),
            stance = 2
            },{
            pos = Vector(-6600.9221781876, 11463.135792647, 166.14999758894),
            stance = 2
            },{
            pos = Vector(-6199.0228529485, 11164.271944692, 166.15000114056),
            stance = 2
            },{
            pos = Vector(-6177.164259758, 11262.107719069, 166.15000209214),
            stance = 2
            },{
            pos = Vector(-5649.7293741759, 11058.773716527, 166.15000001372),
            stance = 2
            },{
            pos = Vector(-5623.3118551857, 11161.358841135, 166.15000640405),
            stance = 2
            },{
            pos = Vector(-5057.3858621357, 10954.052178828, 166.15000619084),
            stance = 2
            },{
            pos = Vector(-5024.0868939499, 11049.728447278, 166.14999885063),
            stance = 2
            },{
            pos = Vector(-4590.4891920393, 11047.379089287, 166.14999904019),
            stance = 2
            },{
            pos = Vector(-4672.0545732511, 11105.755361528, 166.15000419065),
            stance = 2
            },{
            pos = Vector(-5112.9282784332, 11195.02105258, 166.15000113102),
            stance = 2
            },{
            pos = Vector(-5081.75387741, 11372.338464912, 166.15000233248),
            stance = 2
            },{
            pos = Vector(-5209.9486013768, 11221.26417189, 166.14999716575),
            stance = 2
            },{
            pos = Vector(-5169.8575127939, 11448.612882202, 166.1500017754),
            stance = 2
            },{
            pos = Vector(-4985.4166373083, 11820.788596138, 166.14999900525),
            stance = 2
            },{
            pos = Vector(-5081.4386763728, 11852.804752257, 166.15000111712),
            stance = 2
            },{
            pos = Vector(-4942.2285297951, 12066.376481254, 166.15000176432),
            stance = 2
            },{
            pos = Vector(-5040.2321727684, 12086.487230265, 166.15000001211),
            stance = 2
            },{
            pos = Vector(-5949.3253573494, 11426.023632948, 166.14999881792),
            stance = 2
            },{
            pos = Vector(-5915.790893953, 11615.967376579, 166.15000276653),
            stance = 2
            },{
            pos = Vector(-6042.8667487584, 11472.124044663, 166.15000241872),
            stance = 2
            },{
            pos = Vector(-6011.4991893693, 11649.30800096, 166.14999691621),
            stance = 2
            },{
            pos = Vector(-5845.0558412741, 12163.504922434, 166.15000171527),
            stance = 2
            },{
            pos = Vector(-5803.9930627884, 12396.385219278, 166.14999559267),
            stance = 2
            },{
            pos = Vector(-5895.0865539147, 12455.67563165, 166.15000101417),
            stance = 2
            },{
            pos = Vector(-5935.2557179885, 12227.877883382, 166.15000083135),
            stance = 2
            },{
            pos = Vector(-6001.9299172832, 12753.084251182, 166.14999836833),
            stance = 2
            },{
            pos = Vector(-5979.7877056308, 12850.73711914, 166.15000135882),
            stance = 2
            },{
            pos = Vector(-5463.2908298529, 12655.098437701, 166.15000450229),
            stance = 2
            },{
            pos = Vector(-5420.1221846752, 12749.035796161, 166.15000205794),
            stance = 2
            },{
            pos = Vector(-4880.3379224048, 12546.337017467, 166.1500015392),
            stance = 2
            },{
            pos = Vector(-4842.7901271999, 12641.269778354, 166.15000531333),
            stance = 2
            },{
            pos = Vector(-4392.5805109376, 12646.805482681, 166.14999850443),
            stance = 2
            },{
            pos = Vector(-4464.7053810362, 12716.579889874, 166.15000090949),
            stance = 2
            },{
            pos = Vector(-6411.7500740783, 13054.14018137, 166.14999795473),
            stance = 2
            },{
            pos = Vector(-6484.225280739, 12984.911112348, 166.15000265087),
            stance = 2
            },{
            pos = Vector(-5642.7311188946, 13155.000293785, 166.14999743324),
            stance = 2
            },{
            pos = Vector(-5601.3780238053, 13249.256989081, 166.14999878504),
            stance = 2
            },{
            pos = Vector(-5166.1986728338, 13083.842114659, 166.1500016457),
            stance = 2
            },{
            pos = Vector(-5127.6468598459, 13178.594507602, 166.15000403036),
            stance = 2
            },{
            pos = Vector(-4644.7488907685, 13092.538428404, 198.14999126331),
            stance = 1
            },{
            pos = Vector(-6067.0002928582, 13328.997872454, 198.1499984206),
            stance = 1
            },
            -- Gate posts
            {
                pos = Vector(-3974.6959453191, 11284.738695225, 191.14999814684),
                stance = 2
               },{
                pos = Vector(-3907.9970939544, 11683.018549127, 191.14999820304),
                stance = 2
               },{
                pos = Vector(-4127.6912546854, 11657.748573447, 223.15000012296),
                stance = 1
               },{
                pos = Vector(-4173.5269037944, 11399.112993734, 223.15000857493),
                stance = 1
               },{
                pos = Vector(-4192.0023321904, 11200.035446822, 198.15000771557),
                stance = 1
               },{
                pos = Vector(-3794.0886317211, 11129.78361071, 198.15000238267),
                stance = 1
               },{
                pos = Vector(-3656.0881245157, 11309.618812996, 198.15000385792),
                stance = 1
               },{
                pos = Vector(-3613.5885178672, 11551.344930187, 198.15000203257),
                stance = 1
               },{
                pos = Vector(-3675.6275274714, 11764.954985422, 198.14999689875),
                stance = 1
               },{
                pos = Vector(-4071.1644346436, 11834.700334553, 198.1499876126),
                stance = 1
               },{
                pos = Vector(-4239.2718261098, 11723.161978911, 198.14999805232),
                stance = 1
               },{
                pos = Vector(-4296.1940444156, 11400.299231002, 198.15000372632),
                stance = 1
               },{
                pos = Vector(-7162.0340103208, 12028.779508668, 191.14999650788),
                stance = 2
               },{
                pos = Vector(-7090.5321293505, 12426.322589618, 191.14999344537),
                stance = 2
               },{
                pos = Vector(-6877.5746767414, 12361.350322665, 223.14999781291),
                stance = 1
               },{
                pos = Vector(-6940.9197000569, 12002.553314067, 223.15000154991),
                stance = 1
               },{
                pos = Vector(-6887.2162523928, 12513.353409458, 198.15000282502),
                stance = 1
               },{
                pos = Vector(-7267.0214585245, 12580.320934549, 198.15000132004),
                stance = 1
               },{
                pos = Vector(-7421.7012587026, 12298.791741243, 198.15000201468),
                stance = 1
               },{
                pos = Vector(-7364.9901514922, 11941.624072197, 198.15000259096),
                stance = 1
               },{
                pos = Vector(-6980.2158740016, 11873.779898056, 198.15000728313),
                stance = 1
               },
               -- Tank repair
               {
                pos = Vector(-4351.9973760318, 13680.224336555, 166.15000058413),
                stance = 2
               },{
                pos = Vector(-3261.9293786869, 13810.116162163, 166.15000018979),
                stance = 2
               },{
                pos = Vector(-3359.2531311668, 13698.959930482, 166.1500004678),
                stance = 2
               },{
                pos = Vector(-3875.0778015878, 14023.001452908, 198.14999930075),
                stance = 1
               },{
                pos = Vector(-3955.3473765788, 14434.114896647, 166.14999943465),
                stance = 2
               },{
                pos = Vector(-3833.944634151, 14516.870715387, 166.15000223567),
                stance = 2
               },{
                pos = Vector(-4452.4354780403, 14941.779092797, 166.15000675096),
                stance = 2
               },{
                pos = Vector(-4365.4682797915, 15059.544411689, 166.15000172652),
                stance = 2
               },
               -- Tank parking
               {
                pos = Vector(-6099.9626002672, 14168.757484742, 198.14999720778),
                stance = 1
                },{
                pos = Vector(-6498.0479865328, 14001.427038516, 198.1499987141),
                stance = 1
                },{
                pos = Vector(-7072.4205579219, 14397.301627095, 198.15000481993),
                stance = 1
                },{
                pos = Vector(-7479.8543152526, 14220.924763348, 198.14999311168),
                stance = 1
                },{
                pos = Vector(-7164.3211056526, 13930.039380951, 198.14999621752),
                stance = 1
                },{
                pos = Vector(-5845.4473766898, 14966.074166651, 198.14999777409),
                stance = 1
                },{
                pos = Vector(-6260.546777373, 14786.710488148, 198.14999646704),
                stance = 1
                },{
                pos = Vector(-5977.4354241043, 14505.997299449, 198.1500067791),
                stance = 1
                },{
                    pos = Vector(-6827.1878415665, 15171.674364608, 198.1499935527),
                    stance = 1
                   },{
                    pos = Vector(-7205.8533069783, 15013.313467666, 198.14999450268),
                    stance = 1
                   },{
                    pos = Vector(-6888.1239393845, 14699.066330852, 198.15000508849),
                    stance = 1
                   },{
                    pos = Vector(-6470.6471596293, 14882.644460919, 198.14999407123),
                    stance = 1
                   },{
                    pos = Vector(-7021.5506902516, 15602.638551728, 166.15000230568),
                    stance = 2
                   },{
                    pos = Vector(-7055.6726065247, 15460.39652069, 166.15000073854),
                    stance = 2
                   },{
                    pos = Vector(-5961.2612447359, 15492.612208515, 166.14999508063),
                    stance = 2
                   },{
                    pos = Vector(-6009.2977808397, 15352.695968042, 166.14999729115),
                    stance = 2
                   },{
                    pos = Vector(-4921.05620009, 15439.023637631, 166.15000709106),
                    stance = 2
                   },{
                    pos = Vector(-4933.1039123888, 15292.892703044, 166.14999838351),
                    stance = 2
                   },{
                    pos = Vector(-5014.9135945213, 16079.457137202, 198.1500072515),
                    stance = 1
                   },{
                    pos = Vector(-4409.5080222067, 16093.794051495, 166.14999777393),
                    stance = 2
                   },{
                    pos = Vector(-3779.2216127718, 15522.499563349, 166.150004726),
                    stance = 2
                   },
                   -- Far buildings
                   {
                    pos = Vector(-3120.4976205057, 15296.503476065, 256.14998533973),
                    stance = 2
                   },{
                    pos = Vector(-3216.046679334, 14754.635491847, 256.15000984593),
                    stance = 2
                   },{
                    pos = Vector(-2996.8326402732, 14586.952130658, 256.14999980053),
                    stance = 2
                   },{
                    pos = Vector(-2830.7998475966, 14148.278943062, 256.14998810188),
                    stance = 2
                   },{
                    pos = Vector(-2812.4085046287, 15632.844198469, 256.15000133071),
                    stance = 2
                   },{
                    pos = Vector(-2643.7114621257, 16705.437369214, 223.15000445846),
                    stance = 1
                   },{
                    pos = Vector(-2470.3639980587, 16405.035881319, 223.15001047428),
                    stance = 1
                   },{
                    pos = Vector(-2099.9430039394, 16813.417596198, 198.15000965817),
                    stance = 1
                   },{
                    pos = Vector(-2022.4804188657, 14785.925264412, 198.15000663631),
                    stance = 1
                   },{
                    pos = Vector(-2350.2510638438, 15764.509357596, 198.15000752934),
                    stance = 1
                   },{
                    pos = Vector(-3290.9892807174, 17770.227106717, 198.15000419771),
                    stance = 1
                   },{
                    pos = Vector(-4067.3528773444, 17907.173427935, 198.14999735781),
                    stance = 1
                   },{
                    pos = Vector(-4006.1188327967, 16708.2734487, 256.15001699849),
                    stance = 2
                   },{
                    pos = Vector(-3633.1210736477, 16642.505317911, 256.14999521804),
                    stance = 2
                   },{
                    pos = Vector(-4114.0664974789, 16976.116731103, 256.14999703152),
                    stance = 2
                   },{
                    pos = Vector(-4459.0177223647, 17036.913810059, 256.14998743331),
                    stance = 2
                   },{
                    pos = Vector(-3391.070932684, 16848.602723625, 256.14999128726),
                    stance = 2
                   },{
                    pos = Vector(-3105.4744680957, 16798.32983813, 256.14999650183),
                    stance = 2
                   },{
                    pos = Vector(-5795.2772223429, 16416.951113447, 256.14998675004),
                    stance = 2
                   },{
                    pos = Vector(-6123.3752736881, 16227.523293467, 256.15101235861),
                    stance = 2
                   },{
                    pos = Vector(-6900.0879327468, 16299.538150322, 288.14998870575),
                    stance = 1
                   },{
                    pos = Vector(-6421.6692861559, 16338.344158622, 256.15001190838),
                    stance = 2
                   },{
                    pos = Vector(-5763.4441486684, 16718.308859794, 256.15000600524),
                    stance = 2
                   },
                   {
                    pos = Vector(-19497.901272341, 917.04903813433, 166.15000753155),
                    stance = 2
                   },{
                    pos = Vector(-19644.205187321, 949.50538920559, 166.84276736633),
                    stance = 2
                   },{
                    pos = Vector(-19992.774184257, 1648.3462206378, 166.14999864907),
                    stance = 2
                   },{
                    pos = Vector(-20139.004375422, 1623.6213460774, 166.15000822715),
                    stance = 2
                   },{
                    pos = Vector(-21361.826108456, 1301.6781525074, 166.14999841368),
                    stance = 2
                   },{
                    pos = Vector(-21428.553529972, 1168.4786179888, 166.42505343054),
                    stance = 2
                   },{
                    pos = Vector(-21869.005214492, 1805.1632539538, 166.1500025292),
                    stance = 2
                   },{
                    pos = Vector(-21713.18274043, 1802.4980259705, 166.14999978572),
                    stance = 2
                   },{
                    pos = Vector(-21220.284995635, 3144.9974432357, 230.14999475933),
                    stance = 2
                   },{
                    pos = Vector(-21546.084977634, 3144.7502705784, 230.14999025668),
                    stance = 2
                   },{
                    pos = Vector(-21595.110942598, 2899.7506817584, 262.15099214371),
                    stance = 1
                   },{
                    pos = Vector(-21216.145022547, 2899.9561987035, 262.14999695242),
                    stance = 1
                   },{
                    pos = Vector(-21907.879408132, 2899.9978513681, 230.15000192792),
                    stance = 2
                   },{
                    pos = Vector(-22166.899294873, 2510.7885665666, 230.14998574505),
                    stance = 2
                   },{
                    pos = Vector(-21826.524363041, 2096.0181248647, 230.14999361116),
                    stance = 2
                   },{
                    pos = Vector(-21351.518594737, 2096.1198491817, 262.15099723162),
                    stance = 1
                   },{
                    pos = Vector(-20934.397079932, 2096.0121261556, 262.15000907198),
                    stance = 1
                   },{
                    pos = Vector(-20613.055580294, 2519.8760793371, 230.14998919277),
                    stance = 2
                   },{
                    pos = Vector(-21771.297125611, 4193.2035803405, 230.1499975774),
                    stance = 2
                   },{
                    pos = Vector(-21469.58672996, 4191.0052783624, 230.15001243235),
                    stance = 2
                   },{
                    pos = Vector(-21408.510576565, 4436.0094997832, 262.15099477608),
                    stance = 1
                   },{
                    pos = Vector(-21794.228201725, 4436.0072851867, 262.14999010723),
                    stance = 1
                   },{
                    pos = Vector(-22117.129496697, 4436.1004856819, 230.14999010723),
                    stance = 2
                   },{
                    pos = Vector(-22387.995725458, 4844.8337907307, 230.15001457217),
                    stance = 2
                   },{
                    pos = Vector(-22096.300011292, 5239.9003055707, 230.14998798765),
                    stance = 2
                   },{
                    pos = Vector(-21651.547580459, 5239.9684335139, 262.14998737801),
                    stance = 1
                   },{
                    pos = Vector(-21147.236092774, 5239.9052947334, 230.14998934454),
                    stance = 2
                   },{
                    pos = Vector(-20834.028280356, 4826.8990667133, 230.15001007145),
                    stance = 2
                   },{
                    pos = Vector(-21147.798308232, 4436.0270914835, 230.14999296449),
                    stance = 2
                   },{
                    pos = Vector(-22239.992801531, 3720.3194845904, 166.15000156453),
                    stance = 2
                   },{
                    pos = Vector(-22391.779322996, 3674.0805820468, 166.19309341516),
                    stance = 2
                   },{
                    pos = Vector(-20788.002656845, 3700.7053978621, 166.14999985833),
                    stance = 2
                   },{
                    pos = Vector(-20641.757364096, 3679.8878824833, 166.15000154415),
                    stance = 2
                   },{
                    pos = Vector(-20193.030115369, 3698.5655145894, 166.15000054237),
                    stance = 2
                   },{
                    pos = Vector(-20046.997210458, 3698.8458521432, 166.14999761242),
                    stance = 2
                   },{
                    pos = Vector(-19590.291743703, 3141.9904285087, 230.14997574318),
                    stance = 2
                   },{
                    pos = Vector(-19267.186289532, 3141.9964396886, 230.1499925119),
                    stance = 2
                   },{
                    pos = Vector(-19597.029194797, 2896.9845804829, 262.15099196259),
                    stance = 1
                   },{
                    pos = Vector(-19203.67518319, 2896.9704477171, 262.15000508806),
                    stance = 1
                   },{
                    pos = Vector(-19925.742978386, 2896.8750403259, 230.15000207314),
                    stance = 2
                   },{
                    pos = Vector(-20187.899863823, 2486.0678668189, 230.14999930089),
                    stance = 2
                   },{
                    pos = Vector(-19852.797406548, 2093.0107017017, 230.15000323394),
                    stance = 2
                   },{
                    pos = Vector(-19364.820022148, 2093.1817854896, 230.15000323394),
                    stance = 2
                   },{
                    pos = Vector(-18946.662512911, 2093.0008351228, 230.14998704383),
                    stance = 2
                   },{
                    pos = Vector(-18634.100484747, 2494.5467303941, 230.1499938675),
                    stance = 2
                   },{
                    pos = Vector(-18900.941176693, 2896.9060705678, 230.14999907972),
                    stance = 2
                   },{
                    pos = Vector(-18714.019863356, 3698.5418034476, 166.15000653695),
                    stance = 2
                   },{
                    pos = Vector(-18567.990039651, 3683.3357779164, 166.14999508459),
                    stance = 2
                   },{
                    pos = Vector(-18958.154410959, 4191.2499630149, 230.1500063497),
                    stance = 2
                   },{
                    pos = Vector(-19281.248340441, 4191.0248201117, 230.15000030431),
                    stance = 2
                   },{
                    pos = Vector(-19380.969885674, 4436.0352728399, 262.15001380455),
                    stance = 1
                   },{
                    pos = Vector(-18948.001254779, 4436.0090549014, 262.15001380455),
                    stance = 1
                   },{
                    pos = Vector(-18638.384589541, 4436.001400914, 230.15000051229),
                    stance = 2
                   },{
                    pos = Vector(-18408.001576806, 4852.7938244125, 230.15000340291),
                    stance = 2
                   },{
                    pos = Vector(-18648.12572523, 5239.8756892822, 230.14999991455),
                    stance = 2
                   },{
                    pos = Vector(-19234.663129505, 5239.9726384418, 230.15099936523),
                    stance = 2
                   },{
                    pos = Vector(-19625.184231495, 5239.9003054049, 230.14999735027),
                    stance = 2
                   },{
                    pos = Vector(-19961.900660953, 4843.4232801057, 230.1499993168),
                    stance = 2
                   },{
                    pos = Vector(-19636.170241646, 4436.1002888741, 230.14999767661),
                    stance = 2
                   },{
                    pos = Vector(-20391.167094608, 4331.7566273331, 166.14999447828),
                    stance = 2
                   },{
                    pos = Vector(-20395.538155459, 4478.0059422946, 166.14999720755),
                    stance = 2
                   },{
                    pos = Vector(-20779.427011911, 5898.5582014727, 166.15000469709),
                    stance = 2
                   },{
                    pos = Vector(-20726.174987269, 6036.5488137181, 166.15000296085),
                    stance = 2
                   },{
                    pos = Vector(-20787.188758418, 6423.1632709546, 166.14999937692),
                    stance = 2
                   },{
                    pos = Vector(-20722.105226361, 6554.2091975382, 166.14999901358),
                    stance = 2
                   },{
                    pos = Vector(-21538.176593481, 6554.919857831, 166.15000184203),
                    stance = 2
                   },{
                    pos = Vector(-21607.31564997, 6426.1278822443, 166.1499973455),
                    stance = 2
                   },{
                    pos = Vector(-21546.963195625, 6039.9547011892, 166.15000055053),
                    stance = 2
                   },{
                    pos = Vector(-21617.8112705, 5912.054161752, 166.14999645019),
                    stance = 2
                   },{
                    pos = Vector(-19722.106667868, 6029.4548733322, 166.14999880966),
                    stance = 2
                   },{
                    pos = Vector(-19639.093192489, 5908.7720712995, 166.1500019155),
                    stance = 2
                   },{
                    pos = Vector(-19644.32343171, 6425.7558599739, 166.15000386054),
                    stance = 2
                   },{
                    pos = Vector(-19736.70422122, 6541.043451351, 166.14999894487),
                    stance = 2
                   },{
                    pos = Vector(-18815.529960635, 6554.4474870781, 166.14999807699),
                    stance = 2
                   },{
                    pos = Vector(-18744.239141223, 6426.9619910761, 166.14999952115),
                    stance = 2
                   },{
                    pos = Vector(-18786.652753414, 6051.1606403627, 166.14999470467),
                    stance = 2
                   },{
                    pos = Vector(-18733.553385518, 5913.1296616725, 166.15000000715),
                    stance = 2
                   },{
                    pos = Vector(-18010.621044117, 7209.3134588296, 166.15000215952),
                    stance = 2
                   },{
                    pos = Vector(-18102.403705396, 7325.0279339958, 166.15000143149),
                    stance = 2
                   },{
                    pos = Vector(-18005.948705634, 7731.9619149429, 166.15000162755),
                    stance = 2
                   },{
                    pos = Vector(-18083.033406789, 7856.1152868356, 166.14999818347),
                    stance = 2
                   },{
                    pos = Vector(-22335.248396294, 8169.03141908, 166.14999830122),
                    stance = 2
                   },{
                    pos = Vector(-22387.163547037, 8030.3405585594, 166.14999704841),
                    stance = 2
                   },{
                    pos = Vector(-22345.003263232, 7654.6126702798, 166.15000599401),
                    stance = 2
                   },{
                    pos = Vector(-22422.375904136, 7530.6682711327, 166.68484321508),
                    stance = 2
                   },{
                    pos = Vector(-21490.046125624, 7214.1854353122, 206.14999144686),
                    stance = 2
                   },{
                    pos = Vector(-21143.031239399, 7233.5621050405, 206.15001246904),
                    stance = 2
                   },{
                    pos = Vector(-20847.022864761, 7045.0105588821, 206.14999431369),
                    stance = 2
                   },{
                    pos = Vector(-20398.328022034, 7045.147624503, 206.15000684921),
                    stance = 2
                   },{
                    pos = Vector(-19904.99676804, 7045.1008228077, 206.15000745837),
                    stance = 2
                   },{
                    pos = Vector(-19483.995925087, 7283.1268866994, 206.14999104967),
                    stance = 2
                   },{
                    pos = Vector(-19187.942025227, 7271.3584013846, 206.14998920151),
                    stance = 2
                   },{
                    pos = Vector(-18701.010756107, 7045.1007478228, 206.14998536532),
                    stance = 2
                   },{
                    pos = Vector(-19904.999952711, 8387.5381823749, 206.14999388742),
                    stance = 2
                   },{
                    pos = Vector(-19507.99642034, 8291.4705306116, 206.15000335904),
                    stance = 2
                   },{
                    pos = Vector(-19211.968457952, 8201.694980195, 206.15000128737),
                    stance = 2
                   },{
                    pos = Vector(-18865.999988121, 8245.8088381495, 206.15001168308),
                    stance = 2
                   },{
                    pos = Vector(-20362.100371353, 7770.0158182348, 223.14999247081),
                    stance = 1
                   },{
                    pos = Vector(-20819.0197373, 7555.4699866268, 730.93695588082),
                    stance = 2
                   },{
                    pos = Vector(-20819.070233971, 7118.1523326649, 730.93695588082),
                    stance = 2
                   },{
                    pos = Vector(-19692.511820886, 7730.9322543215, 731.14999727875),
                    stance = 2
                   },{
                    pos = Vector(-19303.999954032, 7753.1260858658, 731.15000143281),
                    stance = 2
                   },{
                    pos = Vector(-18848.96752796, 7755.1622769381, 731.14999963075),
                    stance = 2
                   },{
                    pos = Vector(-21287.847028977, 7629.9851650444, 731.15000160133),
                    stance = 2
                   },{
                    pos = Vector(-21288.478374351, -1465.8621410624, 209.1499963959),
                    stance = 1
                   },{
                    pos = Vector(-21170.450278129, -1141.6698005486, 209.1500016822),
                    stance = 1
                   },{
                    pos = Vector(-20417.488684873, -1407.0068252078, 198.73988718402),
                    stance = 1
                   },{
                    pos = Vector(-20762.807297012, -1655.3071164232, 198.06444367825),
                    stance = 1
                   },{
                    pos = Vector(-20317.607841791, -1824.2552389655, 198.16877159336),
                    stance = 1
                   },{
                    pos = Vector(-20156.917323021, -1957.4619485058, 198.16877159336),
                    stance = 1
                   },{
                    pos = Vector(-19795.940629505, -1720.4009383634, 198.76528066028),
                    stance = 1
                   },{
                    pos = Vector(-19725.538027422, -2164.3673556851, 198.24664395679),
                    stance = 1
                   }
                   -- Snipe towers
                   -- {
                   -- pos = Vector(-3511.5757605439, 13100.655554854, 866.1500135608),
                   -- stance = 2
                   -- },{
                   -- pos = Vector(-7846.6844823689, 13867.384277843, 876.15001270163),
                   -- stance = 2
                   -- }
        }        
        NACT.SetMapCoverPoints(mapCoverPoints)
        local bigEnemyCamp = NACT.RegisterTerritory("TankBataillonSmall", {
            zoneBounds = {
                pos = Vector(-4942.06, 15364.73, 338.15),
                radius = 7000
            },
            team = NACT_NPC_TEAMS,
            patrolRoutes = {
                gateFront = {
                    points = {
                        Vector(-6246.35, 13107.7, 198.14),
                        Vector(-4612.09, 12864.16, 198.14),
                        Vector(-5339.6, 12211.33, 198.14)
                    },
                    walkMethod = "circle"
                }
            }
        })



        -- if (false) then 
        local wAk47 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        wAk47:SetAutoReload(false)
        local cDebugNPC = Character(Vector(-6246.35, 13107.7, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC:PickUp(wAk47)
        cDebugNPC:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC, "TankBataillonSmall", PatrollingNpcGatefront)
        -- end

        local wAk472 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        wAk472:SetAutoReload(false)
        local cDebugNPC2 = Character(Vector(-3890.89, 14194.73, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC2:PickUp(wAk472)
        cDebugNPC2:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC2, "TankBataillonSmall", StillNpc)

        -- if (false) then 
        local wAk473 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk473:SetAutoReload(false)
        local cDebugNPC3 = Character(Vector(-5136, 15071.8, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC3:PickUp(wAk473)
        cDebugNPC3:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC3, "TankBataillonSmall", StillNpc)

        local wAk474 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk474:SetAutoReload(false)
        local cDebugNPC4 = Character(Vector(-7563.89, 14397.17, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC4:PickUp(wAk474)
        cDebugNPC4:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC4, "TankBataillonSmall", StillNpc)


        
        local wAk475 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk475:SetAutoReload(false)
        local cDebugNPC5 = Character(Vector(-7040.63, 14560.22, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC5:PickUp(wAk475)
        cDebugNPC5:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC5, "TankBataillonSmall", StillNpc)

        
        local wAk476 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk476:SetAutoReload(false)
        local cDebugNPC6 = Character(Vector(-6894.24, 15736.28, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC6:PickUp(wAk476)
        cDebugNPC6:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC6, "TankBataillonSmall", StillNpc)

        
        local wAk477 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk477:SetAutoReload(false)
        local cDebugNPC7 = Character(Vector(-5777.03, 16448.89, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC7:PickUp(wAk477)
        cDebugNPC7:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC7, "TankBataillonSmall", StillNpc)

        
        local wAk478 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk478:SetAutoReload(false)
        local cDebugNPC8 = Character(Vector(-5099.22, 17197.28, 256.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC8:PickUp(wAk478)
        cDebugNPC8:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC8, "TankBataillonSmall", StillNpc)

        
        local wAk479 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
        wAk479:SetAutoReload(false)
        local cDebugNPC9 = Character(Vector(-4245.41, 17259.10, 288.1), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC9:PickUp(wAk479)
        cDebugNPC9:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC9, "TankBataillonSmall", StillNpc)

        local wAk4710 = AK47(Vector(-4703.67, 11625.8, 198.14), Rotator())
        wAk4710:SetAutoReload(false)
        local cDebugNPC10 = Character(Vector(-4703.67, 11625.8, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC10:PickUp(wAk4710)
        cDebugNPC10:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC10, "TankBataillonSmall", StillNpc)

        
        local wAk4711 = AK47(Vector(-4703.67, 11625.8, 198.14), Rotator())
        wAk4711:SetAutoReload(false)
        local cDebugNPC11 = Character(Vector(-6291.85, 11901.37, 198.15), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC11:PickUp(wAk4711)
        cDebugNPC11:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC11, "TankBataillonSmall", StillNpc)

        
        local wAk4712 = AK47(Vector(6931.17, 11625.8, 198.14), Rotator())
        wAk4712:SetAutoReload(false)
        local cDebugNPC12 = Character(Vector(-6931.17, 13029.47, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC12:PickUp(wAk4712)
        cDebugNPC12:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC12, "TankBataillonSmall", StillNpc)

        local wAk4713 = AK47(Vector(6931.17, 11625.8, 198.14), Rotator())
        wAk4713:SetAutoReload(false)
        local cDebugNPC13 = Character(Vector(-7257.26, 11606.09, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC13:PickUp(wAk4713)
        cDebugNPC13:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC13, "TankBataillonSmall", StillNpc)

        
        local wAk4714 = AK47(Vector(6931.17, 11625.8, 198.14), Rotator())
        wAk4714:SetAutoReload(false)
        local cDebugNPC14 = Character(Vector(-4309.89, 10443.71, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC14:PickUp(wAk4714)
        cDebugNPC14:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC14, "TankBataillonSmall", StillNpc)

        
        local wAk4715 = AK47(Vector(6931.17, 11625.8, 198.14), Rotator())
        wAk4715:SetAutoReload(false)
        local cDebugNPC15 = Character(Vector(-3097.35, 11408.16, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC15:PickUp(wAk4715)
        cDebugNPC15:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC15, "TankBataillonSmall", StillNpc)
        -- end



        local datacenter = NACT.RegisterTerritory("Datacenter", {
            zoneBounds = {
                pos = Vector(-20461.71, 4215.02, 198.15),
                radius = 7000
            },
            team = NACT_NPC_TEAMS,
            patrolRoutes = {
                frontCamp = {
                    points = {
                        Vector(-20417.73, 4071.38, 198.1),
                        Vector(-18437.47, 3902.86, 198.1),
                        Vector(-18685.67, 1708.65, 198.1),
                        Vector(-20263.24, 1713.28, 198.3)
                    },
                    walkMethod = "circle"
                },
                frontDatacenter = {
                    points = {
                        Vector(-20470.18, 5574.34, 198.1),
                        Vector(-18956.80, 5598.01, 198.15),
                        Vector(-19032.64, 6649.92, 198.1),
                        Vector(-21786.70, 6764.08, 198.15),
                        Vector(-21990.64, 5685.85, 198.15)
                    },
                    walkMethod = "circle"
                }
            }
        })

        -- Front camp still
        
        createNpc(
            Vector(-19422.69, 732, 209.11),
            "Datacenter",
            StillNpc,
            32
        )

        createNpc(
            Vector(-19428.62, 1045.73, 198),
            "Datacenter",
            StillNpc,
            32
        )

        
        createNpc(
            Vector(-19150.44, 994.46, 198),
            "Datacenter",
            StillNpc,
            180
        )
        -- Front of the camp patrol 
        createNpc(
            Vector(-20572, 3381, 198.14),
            "Datacenter",
            PatrollingNpcFrontCamp)
    
        createNpc(
            Vector(-20782.60, 3271.27, 198.14),
            "Datacenter",
            PatrollingNpcFrontCamp)
        
        createNpc(
            Vector(-20828.22, 3450.78, 198.14),
            "Datacenter",
            PatrollingNpcFrontCamp)
        
        createNpc(
            Vector(-21068.89, 3353.80, 198.14),
            "Datacenter",
            PatrollingNpcFrontCamp)
        
            
        createNpc(
            Vector(-21034.03, 3497.95, 198.14),
            "Datacenter",
            PatrollingNpcFrontCamp)
        
        -- Front datacenter patrol

        createNpc(
            Vector(-22220, 5713.35, 198.14),
            "Datacenter",
            PatrollingNpcFrontDatacenter)

        createNpc(
            Vector(-22201, 5982.13, 198.14),
            "Datacenter",
            PatrollingNpcFrontDatacenter)

        createNpc(
            Vector(-22201, 6223.13, 198.14),
            "Datacenter",
            PatrollingNpcFrontDatacenter)

        createNpc(
            Vector(-22521.72, 5587.45, 201),
            "Datacenter",
            PatrollingNpcFrontDatacenter)
        createNpc(
            Vector(-22534.61, 5885.02, 208),
            "Datacenter",
            PatrollingNpcFrontDatacenter)
    
            
        createNpc(
            Vector(-18285.59, 5708.36, 201),
            "Datacenter",
            PatrollingNpcFrontDatacenter)
            
        createNpc(
            Vector(-18274.88, 6127.55, 198),
            "Datacenter",
            PatrollingNpcFrontDatacenter)
    
            createNpc(
                Vector(-17978.54, 6214.51, 228.52),
                "Datacenter",
                PatrollingNpcFrontDatacenter)

        -- Inside barracks

        createNpc(
            Vector(-20820.94, 2096, 262.15),
            "Datacenter",
            StillNpc,
            -51
        )

        
        createNpc(
            Vector(-20710.91, 2498.84, 262.15),
            "Datacenter",
            StillNpc,
            136
        )

        
        createNpc(
            Vector(-21147.08, 2524.08, 262.15),
            "Datacenter",
            StillNpc,
            -29
        )

        
        createNpc(
            Vector(-21891.32, 2173.25, 262.15),
            "Datacenter",
            StillNpc,
            122
        )
        
        createNpc(
            Vector(-22360.21, 2600.15, 198.12),
            "Datacenter",
            StillNpc,
            122
        )

        createNpc(
            Vector(-20137.31, 2500, 262.15),
            "Datacenter",
            StillNpc
        )

        createNpc(
            Vector(-19733.85, 2487, 262.15),
            "Datacenter",
            StillNpc,
            160
        )

        createNpc(
            Vector(-19401.52, 2093, 262.15),
            "Datacenter",
            StillNpc,
            100
        )

        createNpc(
            Vector(-19132.30, 2530.75, 262.15),
            "Datacenter",
            StillNpc
        )

        
        createNpc(
            Vector(-18635.43, 2500, 262.15),
            "Datacenter",
            StillNpc,
            160
        )

        createNpc(
            Vector(-18921.44, 4885.45, 262.15),
            "Datacenter",
            StillNpc,
            160
        )
        
        createNpc(
            Vector(-19184.24, 4624.71, 262.15),
            "Datacenter",
            StillNpc,
            100
        )

        createNpc(
            Vector(-19381.06, 4840.34, 262.15),
            "Datacenter",
            StillNpc
        )

        
        createNpc(
            Vector(-18417.34, 4867.61, 262.15),
            "Datacenter",
            StillNpc,
            180
        )

        createNpc(
            Vector(-18647.91, 4586, 262.15),
            "Datacenter",
            StillNpc,
            180
        )
        
        createNpc(
            Vector(-18646.53, 5070.16, 262.15),
            "Datacenter",
            StillNpc,
            180
        )

        createNpc(
            Vector(-21468.96, 5054.09, 262.15),
            "Datacenter",
            StillNpc,
            -100
        )
        createNpc(
            Vector(-21637.05, 5016.84, 262.15),
            "Datacenter",
            StillNpc,
            -100
        )
        createNpc(
            Vector(-21839.53, 5027.27, 262.15),
            "Datacenter",
            StillNpc,
            -100
        )
        
        createNpc(
            Vector(-21835.30, 4835.48, 262.15),
            "Datacenter",
            StillNpc,
            100
        )
        createNpc(
            Vector(-21516.70, 4799.38, 262.15),
            "Datacenter",
            StillNpc,
            100
        )

        local jeffBezos = createNpc(
            Vector(-20486.08, 7139.81, 763.14),
            "Datacenter",
            StillNpc,
            100
        )

        jeffBezos.character:SetHealth(4000)
        -- jeffBezos.character:SetScale(Vector(2,2, 2))
        jeffBezos.character:SetSpeedMultiplier(2)
        jeffBezos.character:SetFootstepVolumeMultiplier(20)
        jeffBezos.character:SetMesh("nanos-world::SK_PostApocalyptic")
        -- jeffBezos.character:SetHighlightEnabled(true)
    end
end)


function createNpc(vInitialPosition, sNpcTerritory, tNpcConfig, tMaybeYaw)
    local wAk4715 = AK47(Vector(6931.17, 11625.8, 198.14), Rotator())
    wAk4715:SetAutoReload(false)
    local cDebugNPC15 = Character(vInitialPosition, Rotator(0, NACT.ValueOrDefault(tMaybeYaw, 0), 0), "nanos-world::SK_Mannequin")
    cDebugNPC15:PickUp(wAk4715)
    cDebugNPC15:SetTeam(NACT_NPC_TEAMS)
    Console.Log("Jeff bezos "..NanosTable.Dump(cDebugNPC15))
    return NACT.RegisterNpc(cDebugNPC15, sNpcTerritory, tNpcConfig)
end

Player.Subscribe("Spawn", function(player)
    --player:GetCharacter():SetTeam(1)

end)


Events.SubscribeRemote("NACT:DEBUG:SPAWN_ALLY_NPC", function(player, vLocationToSpawn)
    local wAk473 = AK47(Vector(-5136, 15071.8, 188.45), Rotator())
    wAk473:SetAutoReload(false)
    local cDebugNPC3 = Character(vLocationToSpawn, Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
    cDebugNPC3:PickUp(wAk473)
    NACT.RegisterNpc(cDebugNPC3, "TankBataillonSmall", StillNpc)
end)
