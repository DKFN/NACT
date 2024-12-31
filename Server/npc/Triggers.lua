---
--- Triggers
---
function NACT_NPC:_registerTriggerBoxes()
    self.triggers = {
        detection = self:createTriggerBox(TriggerType.Sphere, 5000, Color.RED),
        midProximity = self:createTriggerBox(TriggerType.Sphere, 2000, TriggerType.Sphere, Color.ORANGE),
        closeProximity = self:createTriggerBox(TriggerType.Sphere, 1000, Color.BLUE),
        melee = self:createTriggerBox(TriggerType.Box, 70, Color.YELLOW)
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
                table.remove(tTriggerData.allies, entity)
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

function NACT_NPC:Debug_PrintTriggerStates()
    -- Console.Log("N.A.C.T. Npc ".. self:GetID() .. " Trigger states : ".. NanosTable.Dump(self.triggers))
end
