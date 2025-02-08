local table_insert = table.insert

---Creates a trigger box for NACT while keeping track of all the allies and enemies that enter or leave the trigger box
---@param vTriggerLocation Vector Location to spawn the trigger
---@param linkedTerritoryOrNpc NACT_NPC | NACT_Territory The NACT entity to attach the trigger to
---@param eTriggerType TriggerType The trigger type to create
---@param nRadius number Radius of the trigger
---@param eDebugColor Color the debug color when debugging triggers
---@param bServerTrigger Boolean either this trigger is serverside or clientside (CSSTT)
---@param checkEvery Number Every ticks to check. 1 will check every tick, 20 will check every 20 ticks
---@return table Trigger table
function NACT.createTriggerBox(
        vTriggerLocation,
        linkedTerritoryOrNpc,
        eTriggerType,
        nRadius,
        eDebugColor,
        bServerTrigger,
        checkEvery
    )

    local trigger
    if (bServerTrigger) then
        trigger = Trigger(vTriggerLocation, Rotator(), Vector(nRadius), eTriggerType, NACT_DEBUG_TRIGGERS, eDebugColor)
        trigger:SetOverlapOnlyClasses({ "Character", "CharacterSimple" })
    else
        trigger = CSSTT(eTriggerType, vTriggerLocation, nRadius, CollisionChannel.Pawn, {}, checkEvery)
        -- trigger = CSST(vTriggerLocation, Rotator(), Vector(nRadius), eTriggerType, NACT_DEBUG_TRIGGERS, eDebugColor)
        -- trigger:SetOverlapOnlyClasses({ "Character", "CharacterSimple" })
    end

    local tTriggerData = {
        trigger = trigger,
        enemies = {},
        allies = {}
    }

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

            if (linkedClass == NACT_Territory) then
                entity:SetValue("NACT_TERRITORY_ID", linkedTerritoryOrNpc:GetID())
                if (not linkedTerritoryOrNpc.authorityPlayer and entity.GetPlayer and entity:GetPlayer()) then
                    Console.Log("Player entered in territory without network authority. Switching authority")
                    linkedTerritoryOrNpc:SwitchNetworkAuthority()
                end
            end
            
        end

        --Console.Log("After b overlap enemies : "..(#tTriggerData.enemies))
        --Console.Log("After b overlap allies : "..(#tTriggerData.allies))
        
    end)

    tTriggerData.trigger:Subscribe("EndOverlap", function(self, entity)
        if (self == tTriggerData.trigger and linkedID ~= entity:GetID()) then
            if (linkedTeam == entity:GetTeam()) then
                table_remove_by_value(tTriggerData.allies, entity)
            else
                table_remove_by_value(tTriggerData.enemies, entity)
            end

            
            if (linkedClass == NACT_Territory) then
                entity:SetValue("NACT_TERRITORY_ID", nil)
                local maybePlayer = entity.GetPlayer and entity:GetPlayer()
                if (maybePlayer and linkedTerritoryOrNpc.authorityPlayer == maybePlayer) then
                    Console.Log("Player left territory was network authority. Switching authority")
                    linkedTerritoryOrNpc:SwitchNetworkAuthority()
                end
            end
        end

        
        -- Console.Log("After e overlap enemies : "..(#tTriggerData.enemies))
        -- Console.Log("After e overlap allies : "..(#tTriggerData.allies))
    end)

    -- Console.Log("CSST Value "..NanosTable.Dump(tTriggerData.trigger))
    
    return tTriggerData
end

---Gets the trigger population of the trigger in parameter
---@param tTrigger table TriggerTable to scan
---@param sPopulationType "enemies" | "allies"
---@return table Array array of characters that populates the trigger
function NACT.GetTriggerPopulation(tTrigger, sPopulationType)
    local triggerPopulation = tTrigger[sPopulationType]
    if (triggerPopulation == nil) then
        Console.Error("No population "..sPopulationType.." found in GetTriggerPopulation call with the name "..sTriggerName)
        return {}
    end

    local acc = {}
    for i, entity in ipairs(triggerPopulation) do
        if (entity:IsValid() and not entity:IsBeingDestroyed() and entity:GetHealth() > 0) then
            table.insert(acc, entity)
        end
    end
    return acc
end
