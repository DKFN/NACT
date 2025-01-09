function NACT.createTriggerBox(vTriggerLocation, linkedTerritoryOrNpc, eTriggerType, nRadius, eDebugColor)
    local tTriggerData = {
        trigger = Trigger(vTriggerLocation, Rotator(), Vector(nRadius), eTriggerType, NACT_DEBUG_TRIGGERS, eDebugColor),
        enemies = {},
        allies = {}
    }
    tTriggerData.trigger:SetOverlapOnlyClasses({ "Character", "CharacterSimple" })

    local linkedClass = linkedTerritoryOrNpc:GetClass()
    local linkedTeam
    local linkedID

    if (linkedClass == NACT_NPC) then
        linkedTeam = linkedTerritoryOrNpc.character:GetTeam()
        linkedID = linkedTerritoryOrNpc.character:GetID()
    end

    if (linkedClass == NACT_Territory) then
        linkedTeam = linkedTerritoryOrNpc.team
        linkedID = nil
    end

    tTriggerData.trigger:Subscribe("BeginOverlap", function(self, entity)
        if (self == tTriggerData.trigger and linkedID ~= entity:GetID()) then
            if (linkedTeam == entity:GetTeam()) then
                table.insert(tTriggerData.allies, entity)
            else
                table.insert(tTriggerData.enemies, entity)
            end
        end
    end)

    tTriggerData.trigger:Subscribe("EndOverlap", function(self, entity)
        if (self == tTriggerData.trigger and linkedID ~= entity:GetID()) then
            if (linkedTeam == entity:GetTeam()) then
                table_remove_by_value(tTriggerData.allies, entity)
            else
                table_remove_by_value(tTriggerData.enemies, entity)
            end
        end
    end)
    
    return tTriggerData
end

function NACT.GetTriggerPopulation(tTrigger, sPopulationType)
    local triggerPopulation = tTrigger[sPopulationType]
    if (triggerPopulation == nil) then
        Console.Error("No population "..sPopulationType.." found in GetTriggerPopulation call with the name "..sTriggerName)
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
