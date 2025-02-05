---
--- Triggers
---

--- INTERNAL. Register the trigger boxes for a NACT_NPC
--- I mean you can use if you want, but, why ?
function NACT_NPC:_registerTriggerBoxes(tNpcTriggerConfig)
    Console.Log("NPC CONFIG : "..NanosTable.Dump(tNpcTriggerConfig))
    self.triggers = {}
    if (tNpcTriggerConfig.detection) then
        self.triggers.detection = self:createTriggerBox(TriggerType.Sphere, 3000, Color.RED)
    end
    if (tNpcTriggerConfig.midProximity) then
        self.triggers.midProximity = self:createTriggerBox(TriggerType.Sphere, 1500, TriggerType.Sphere, Color.ORANGE)
    end
    
    if (tNpcTriggerConfig.closeProximity) then
        self.triggers.closeProximity = self:createTriggerBox(TriggerType.Sphere, 1000, Color.BLUE)
    end
    
    if (tNpcTriggerConfig.melee) then
        self.triggers.melee = self:createTriggerBox(TriggerType.Sphere, 120, Color.YELLOW)    
    end
    -- Console.Log("AFT : "..NanosTable.Dump(self.triggers))
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
    -- Console.Log("Created trigger box "..NanosTable.Dump(tTriggerData.trigger))
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
