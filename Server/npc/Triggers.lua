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
    local tTriggerData = {
        trigger = Trigger(Vector(self.character:GetLocation()), Rotator(), Vector(nRadius), eTriggerType, NACT_DEBUG_TRIGGERS, eDebugColor),
        enemyCount = 0,
        enemies = {},
        allyCount = 0,
        allies = {}
    }
    tTriggerData.trigger:AttachTo(self.character)
    tTriggerData.trigger:SetOverlapOnlyClasses({ "Character", "CharacterSimple" })

    local _self = self

    tTriggerData.trigger:Subscribe("BeginOverlap", function(self, entity)
        -- TODO add more checks (in the same team for example)
        if (self == tTriggerData.trigger and _self.character:GetID() ~= entity:GetID()) then
            if (_self.character:GetTeam() == entity:GetTeam()) then
                tTriggerData.allyCount = tTriggerData.allyCount + 1
                table.insert(tTriggerData.allies, entity)
            else 
                tTriggerData.enemyCount = tTriggerData.enemyCount + 1
                table.insert(tTriggerData.enemies, entity)
            end
            _self:Debug_PrintTriggerStates()
        end
    end)


    tTriggerData.trigger:Subscribe("EndOverlap", function(self, entity)
        if (self == tTriggerData.trigger and _self.character:GetID() ~= entity:GetID()) then
            if (_self.character:GetTeam() == entity:GetTeam()) then
                table_remove_by_value(tTriggerData.allies, entity)
                tTriggerData.allyCount = tTriggerData.allyCount + 1
            else
                tTriggerData.enemyCount = tTriggerData.enemyCount - 1
                table_remove_by_value(tTriggerData.enemies, entity)
            end
        end
        _self:Debug_PrintTriggerStates()
    end)
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

    local triggerPopulation = trigger[sPopulationType]
    if (triggerPopulation == nil) then
        self:Log("No population "..sPopulationType.." found in GetTriggerPopulation call with the name "..sTriggerName)
        return {}
    end

    local acc = {}
    for i, entity in ipairs(triggerPopulation) do
        if (entity:IsValid() and entity:GetHealth() > 0) then
            table.insert(acc, entity)
        end
    end
    return acc
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
