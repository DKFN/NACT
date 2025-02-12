Console.Log("N.A.C.T. Nanos Advanced Combat Tactics v"..Package:GetVersion())
Console.Log("N.A.C.T. https://github.com/DKFN/NACT")

Package.Require("./core/Index.lua")
Package.Require("./behaviors/Index.lua")
Package.Require("./npc/Index.lua")


Package.Export("NACT", NACT)
Package.Export("NACT_Idle", NACT_Idle)
Package.Export("NACT_Detection", NACT_Detection)
Package.Export("NACT_Patrol", NACT_Patrol)
Package.Export("NACT_Alert", NACT_Alert)
Package.Export("NACT_Combat", NACT_Combat)
Package.Export("NACT_Engage", NACT_Engage)
Package.Export("NACT_Seek", NACT_Seek)
Package.Export("NACT_Cover", NACT_Cover)
Package.Export("NACT_ZombieMelee", NACT_ZombieMelee)

Package.Require("./Debug.lua")

