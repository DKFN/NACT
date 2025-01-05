Character.Subscribe("Death", function(self)
    local iMaybeNactNpcId = self:GetValue("NACT_NPC_ID")
    if (iMaybeNactNpcId) then
        local nactNpc = NACT_NPC.GetByID(iMaybeNactNpcId)
        if (nactNpc) then
            nactNpc:Destroy()
        else
            Console.Error("N.A.C.T. entity with NACT_NPC_ID "..iMaybeNactNpcId.." is dead but was not found for destruction")
        end
    end
end)

-- Player.Subscribe("Death", function(player)
    
-- end)