function NACT_NPC:RandomPointToFocusedQuery(radius) 
    local focusedLocation = self:GetFocusedLocation()
    if (focusedLocation) then
        Events.CallRemote("NACT:NAVIGATION:RANDOM_QUERY", self:GetID(), focusedLocation)
    end

end

Events.SubscribeRemote("NACT:NAVIGATION:RANDOM_RESULT", function(player, iNpcID, vTargetPoints)
    local npc = NACT_NPC.GetByID(iNpcID)
    if (npc) then
        if (npc.currentBehavior and npc.currentBehavior.OnRandomPointResult) then
            npc.currentBehavior:OnRandomPointResult(vTargetPoints)
        end
    end
end)