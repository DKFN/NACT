--- Query the player that has the network authority on the territory for a random point to the focused location
--- or it's last known position
---@param radius number for the search to the random point
function NACT_NPC:RandomPointToFocusedQuery(radius)
    local focusedLocation 
    if (self:GetFocused()) then
        focusedLocation = self:GetFocusedLocation()
    else
        focusedLocation = self.cFocusedLastPosition
    end

   -- Console.Log("Focused location : "..NanosTable.Dump(focusedLocation))
    if (focusedLocation and not focusedLocation:IsZero()) then
        self:RandomPointToQuery(focusedLocation, radius)
    end

end

--- Query the player that has the network authority on the territory for a random point in the range of the poinst
---@param vLocation Vector point at the center of the random point query
---@param radius number radius for the search
function NACT_NPC:RandomPointToQuery(vLocation, radius)
    local authorityPlayer = self.territory.authorityPlayer
    if (authorityPlayer) then
        Events.CallRemote("NACT:NAVIGATION:RANDOM_QUERY", authorityPlayer, self:GetID(), vLocation, radius)    
    end
end

--- Event return for the navigation query result. Will call "OnRandomPointResult" on the behavior if defined
---@param player Player player that made the calculation
---@param iNpcID number ID of the NPC that made the query
---@param vTargetPoints Vector Result of the random point query
Events.SubscribeRemote("NACT:NAVIGATION:RANDOM_RESULT", function(player, iNpcID, vTargetPoints)
    local npc = NACT_NPC.GetByID(iNpcID)
    -- Console.Log("Gotten result : "..NanosTable.Dump(iNpcID).." with : "..NanosTable.Dump(vTargetPoints))
    if (npc) then
        if (npc.behavior and npc.behavior.OnRandomPointResult) then
            npc.behavior:OnRandomPointResult(vTargetPoints)
        end
    end
end)