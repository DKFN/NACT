--- Finds a random point in vPoint with radius
---@param iNpcID NACT_NPC_ID Requestor NPC id
---@param vPoint Vector Center point of the query
---@param radius number radius to apply to the search
Events.SubscribeRemote("NACT:NAVIGATION:RANDOM_QUERY", function(iNpcID, vPoint, radius)
    -- Console.Log("Asking for navpoint from npc : "..iNpcID)
    local randomPointFound = Navigation.GetRandomReachablePointInRadius(vPoint, radius)
    -- Console.Log("Result : "..NanosTable.Dump(randomPointFound))
    Events.CallRemote("NACT:NAVIGATION:RANDOM_RESULT", iNpcID, randomPointFound)
end)
