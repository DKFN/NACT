Character.Subscribe("Death", function(character)
    -- Makes sure it is processed next tick so every event registered have time to process before entity is destroyed
    Timer.SetTimeout(function()
        NACT.CharacterCleanup(character)
    end)
end)

Player.Subscribe("Destroy", function(self)
    local character = self:GetControlledCharacter()
    if (character) then
        NACT.CharacterCleanup(character)
    end
end)

function NACT.CharacterCleanup(character)
    local territoryID = character:GetValue("NACT_TERRITORY_ID")
    if (territoryID) then
        local territory = NACT_Territory.GetByID(territoryID)
        if (territory) then
            territory:CleanupCharacter(character)
        end
    end
end

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