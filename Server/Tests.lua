-- This is the test file used in developpement of features of N.A.C.T. do not incldue it in production
-- It is used with TestingMap from nanos-world


NACT_TEST_SCENARIO = 4
NACT_NPC_TEAMS = 1

local StillNpc = {behaviors =  {NACT_Idle, NACT_Detection, NACT_Alert, NACT_Combat}}
local PatrollingNpc = {behaviors = {NACT_Idle, NACT_Patrol, NACT_Alert, NACT_Combat}}

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

    if (NACT_TEST_SCENARIO == 4) then
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
            },
            coverPoints = {
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
                       -- Snipe towers
                       {
                        pos = Vector(-3511.5757605439, 13100.655554854, 866.1500135608),
                        stance = 2
                       },{
                        pos = Vector(-7846.6844823689, 13867.384277843, 876.15001270163),
                        stance = 2
                       }
            }
        })

        local wAk47 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        wAk47:SetAutoReload(false)
        local cDebugNPC = Character(Vector(-6246.35, 13107.7, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC:PickUp(wAk47)
        cDebugNPC:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC, "TankBataillonSmall", PatrollingNpc)

       -- (false) then 
        local wAk472 = AK47(Vector(3350.32, 9236.51, 188.45), Rotator())
        wAk472:SetAutoReload(false)
        local cDebugNPC2 = Character(Vector(-3890.89, 14194.73, 198.14), Rotator(0, 0, 0), "nanos-world::SK_Mannequin")
        cDebugNPC2:PickUp(wAk472)
        cDebugNPC2:SetTeam(NACT_NPC_TEAMS)
        NACT.RegisterNpc(cDebugNPC2, "TankBataillonSmall", StillNpc)

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
        -- end
    end
end)

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
