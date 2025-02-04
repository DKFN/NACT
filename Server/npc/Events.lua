Character.Subscribe("Death", function(character)
    NACT.CharacterCleanup(character)
end)

Player.Subscribe("Destroy", function(self)
    local character = self:GetControlledCharacter()
    if (character) then
        NACT.CharacterCleanup(character)
    end
end)

function NACT.CharacterCleanup(character)
    local territoryID = character:GetValue("NACT_TERRITORY_ID")
    Console.Log("Territory id : "..territoryID)
    if (territoryID) then
        local territory = NACT_Territory.GetByID(territoryID)
        if (territory) then
            Console.Log("Cleaning up !")
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