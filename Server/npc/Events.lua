Character.Subscribe("Death", function(self)
    local nactNpc = NACT_NPC.GetFromCharacter(self)
    if (nactNpc) then
        nactNpc:Destroy()
    end
end)

-- Player.Subscribe("Death", function(player)
    
-- end)