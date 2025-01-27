-- Player.Subscribe("Death", function(player)
    
-- end)

---Registers an event on this NPC and delegates it on the behavior via the "On" callback
---@param cNpcToHandle NACT_NPC to delegate the event to
---@param sRegisteredEvent string event name to be delegated
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