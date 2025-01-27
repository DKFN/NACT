---
--- Triggers
---

--- INTERNAL. Register the trigger boxes for a NACT_NPC
--- I mean you can use if you want, but, why ?
function NACT_NPC:_registerTriggerBoxes()
    self.triggers = {
        detection = self:createTriggerBox(TriggerType.Sphere, 5000, Color.RED),
        midProximity = self:createTriggerBox(TriggerType.Sphere, 2000, TriggerType.Sphere, Color.ORANGE),
        closeProximity = self:createTriggerBox(TriggerType.Sphere, 1000, Color.BLUE),
        melee = self:createTriggerBox(TriggerType.Box, 100, Color.YELLOW)
    }

end

--- INTERNAL. Creates a typical trigger box attached to a NACT Entity
---@param eTriggerType TriggerType
---@param nRadius number Radius of the sphere
---@param eDebugColor Color Debug color when NACT_DEBUG_TRIGGERS is true
---@return table Created trigger box
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
---@param sPopulationType "allies" | "enemies" 
---@return table Characters array of population in the trigger
function NACT_NPC:GetTriggerPopulation(sTriggerName, sPopulationType)
    -- Console.Log("Self triggers : "..NanosTable.Dump(self.triggers))
    local trigger = self.triggers[sTriggerName]
    if (trigger == nil) then
        self:Log("No trigger found in GetTriggerPopulation call with the name "..sTriggerName)
        return {}
    end

    return NACT.GetTriggerPopulation(trigger, sPopulationType)
end

--- Get the number of enemies in the given trigger of the NPC
---@param sTriggerName string "detection" "midrProximity" "closeProximity" "melee"
---@return table Array Characters array of enemies in the trigger
function NACT_NPC:GetEnemiesInTrigger(sTriggerName)
    return self:GetTriggerPopulation(sTriggerName, "enemies")
end

--- Get the number of allies in the given trigger of the NPC
---@param sTriggerName string "detection" "midrProximity" "closeProximity" "melee"
---@return table Array Characters array of allies in the trigger
function NACT_NPC:GetAlliesInTrigger(sTriggerName)
    return self:GetTriggerPopulation(sTriggerName, "allies")
end

--- INTERNAL. This will flood
function NACT_NPC:Debug_PrintTriggerStates()
    if (NACT_DEBUG_TRIGGERS) then
        Console.Log("N.A.C.T. Npc ".. self:GetID() .. " Trigger states : ".. NanosTable.Dump(self.triggers))
    end
end
