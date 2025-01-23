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