function NACT_NPC:RandomPointToFocusedQuery(radius)
    local focusedLocation 
    if (self:GetFocused()) then
        focusedLocation = self:GetFocusedLocation()
    else
        focusedLocation = self.cFocusedLastPosition
    end

   Console.Log("Focused location : "..NanosTable.Dump(focusedLocation))
    if (focusedLocation and not focusedLocation:IsZero()) then
        self:RandomPointToQuery(focusedLocation, radius)
    end

end

function NACT_NPC:RandomPointToQuery(vLocation, radius)
    Events.CallRemote("NACT:NAVIGATION:RANDOM_QUERY", Player.GetByIndex(1), self:GetID(), vLocation, radius)
end

Events.SubscribeRemote("NACT:NAVIGATION:RANDOM_RESULT", function(player, iNpcID, vTargetPoints)
    local npc = NACT_NPC.GetByID(iNpcID)
    -- Console.Log("Gotten result : "..NanosTable.Dump(iNpcID).." with : "..NanosTable.Dump(vTargetPoints))
    if (npc) then
        if (npc.behavior and npc.behavior.OnRandomPointResult) then
            npc.behavior:OnRandomPointResult(vTargetPoints)
        end
    end
end)