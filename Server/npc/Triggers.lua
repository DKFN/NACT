---
--- Triggers
---
function NACT_NPC:_registerTriggerBoxes()
    self.triggers = {
        detection = self:createTriggerBox(TriggerType.Sphere, 5000, Color.RED),
        midProximity = self:createTriggerBox(TriggerType.Sphere, 2000, TriggerType.Sphere, Color.ORANGE),
        closeProximity = self:createTriggerBox(TriggerType.Sphere, 1000, Color.BLUE),
        melee = self:createTriggerBox(TriggerType.Box, 100, Color.YELLOW)
    }

end

function NACT_NPC:createTriggerBox(eTriggerType, nRadius, eDebugColor)
    local tTriggerData = NACT.createTriggerBox(
        Vector(self.character:GetLocation()),
        self,
        eTriggerType,
        nRadius,
        eDebugColor
    )
    tTriggerData.trigger:AttachTo(self.character)
    return tTriggerData
end

--- Gets the entities that populates a trigger, enemies or allies. Given they are valid and alive
---@param sPopulationType any
function NACT_NPC:GetTriggerPopulation(sTriggerName, sPopulationType)
    local trigger = self.triggers[sTriggerName]
    if (trigger == nil) then
        self:Log("No trigger found in GetTriggerPopulation call with the name "..sTriggerName)
        return {}
    end

    return NACT.GetTriggerPopulation(trigger, sPopulationType)
end

function NACT_NPC:GetEnemiesInTrigger(sTriggerName)
    return self:GetTriggerPopulation(sTriggerName, "enemies")
end


function NACT_NPC:GetAlliesInTrigger(sTriggerName)
    return self:GetTriggerPopulation(sTriggerName, "allies")
end

function NACT_NPC:Debug_PrintTriggerStates()
    if (NACT_DEBUG_TRIGGERS) then
        Console.Log("N.A.C.T. Npc ".. self:GetID() .. " Trigger states : ".. NanosTable.Dump(self.triggers))
    end
end
