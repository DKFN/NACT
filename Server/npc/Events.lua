Character.Subscribe("Death", function(self)
    local nactNpc = NACT_NPC.GetFromCharacter(self)
    if (nactNpc) then
        nactNpc:Destroy()
    end
end)


Character.Subscribe("TakesDamage", function(self, damageTaken)
    local nactNpc = NACT_NPC.GetFromCharacter(self)
    if (nactNpc) then
        local currentBehavior = nactNpc.behavior
        if (currentBehavior and currentBehavior.OnTakeDamage) then
            currentBehavior:OnTakeDamage(damageTaken)
        end
    end
end)
-- Player.Subscribe("Death", function(player)
    
-- end)