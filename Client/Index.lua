Package.Require("./NpcVision.lua")
Package.Require("./CoverViability.lua")


local navmeshReturn = Navigation.FindPathToLocation(Vector(-9923.82, 1637.54, 195.76), Vector(-11021.99, -2479.44, 182.67))
Console.Log("Navmesh hit : "..NanosTable.Dump(navmeshReturn))
