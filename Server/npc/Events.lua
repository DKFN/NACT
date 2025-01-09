Character.Subscribe("Death", function(self)
    local nactNpc = NACT_NPC.GetFromCharacter(self)
    if (nactNpc) then
        nactNpc:Destroy()
    end
end)

-- Player.Subscribe("Death", function(player)
    
-- end)


function NACT_NPC:RegisterEvent(cNpcToHandle, sRegisteredEvent)
    cNpcToHandle:Subscribe(sRegisteredEvent, function(...)
        if (self.behavior) then
            local maybeCallback = self.behavior["On"..sRegisteredEvent]
            if (maybeCallback) then
                maybeCallback(self.behavior, ...)
            end
        end
    end)
end