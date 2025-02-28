
local tTraces = {}
local Trace = Trace

local NACT_VISION_REFRESH_RATE = 50
-- local NACT_VISION_REFRESH_RATE = 500

--- Requests the client to start the vision towards an entity
---@param cNpc Character The character of the requestor NACT_NPC
---@param cTarget Character The character to focus
---@param iBehaviorId NACT_Behavior_ID ID of the requestor behavior
---@param tMaybeTargetBones table array of bones to trace towards
Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:START", function(cNpc, cTarget, iBehaviorId, tMaybeTargetBones)
    if (tTraces[iBehaviorId] ~= nil) then
        return
    end

    tTraces[iBehaviorId] = {
        detected = false,
        handle = Timer.SetInterval(function ()
            if not cTarget or not cNpc or not cTarget:IsValid() then
                Console.Warn("Trace query to entity while entity is nil, this should be avoided")
                return
            end
            -- TODO: Must fallback and check if GetBoneTransform is defined for CharacterSimple
            -- Console.Log("Bone transform locator : ".. NanosTable.Dump(vNpcHeadLocation))
            local vSourceLocation = GetDetailledLocationOfTarget(cNpc, "head")

            local bTracesResults = GetTraceResultFromListOfBones(vSourceLocation, cTarget, tMaybeTargetBones, {cNpc})

            local tTrace = tTraces[iBehaviorId]
            if (bTracesResults ~= tTrace.detected) then
                tTraces[iBehaviorId].detected = bTracesResults
                Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", iBehaviorId, bTracesResults)
            end
        end, NACT_VISION_REFRESH_RATE)
    }
end)

--- Stops the tracing for the behavior
---@param iBehaviorId NACT_Behavior_ID the ID of the requestor behavior
Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", function(iBehaviorId)
    -- Console.Log("Trace is stopping")
    local tTrace = tTraces[iBehaviorId]
    if (tTrace and tTrace.handle) then
        Timer.ClearInterval(tTrace.handle)
        tTraces[iBehaviorId] = nil
        -- Clears any pending vision when stopping traces
        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", iBehaviorId, false)
    end
end)

--- Do a "Look around" the NPC will trace towards the enemies and try to find a new focused entity
---@param sourceNpc Character the character of the requestor NPC
---@param tAllEnemies table Array with all the enemies that could be visible
---@param iNpcID NACT_NPC_ID The ID of the requestor NPC
---@param tTargetBones table Array of bones to scan
Events.SubscribeRemote("NACT:TRACE:NPC_LOOK_AROUND:QUERY", function(sourceNpc, tAllEnemies, iNpcID, tTargetBones)
    
    local tEnnemyLookupResult = {}
    local closestTargetDistance = 9999999999999
    local closestTarget = nil
    local sourceLocation = sourceNpc:GetLocation()
    -- Console.Log("Attemp trace hit of : "..NanosTable.Dump(tAllEnemies))
    for i, ennemy in ipairs(tAllEnemies) do
        local traceResultEntity = GetTraceResultFromListOfBones(
            GetDetailledLocationOfTarget(sourceNpc, "head"),
            ennemy,
            tTargetBones,
            {sourceNpc}
        )
        -- Console.Log(iNpcID.."Trace result for "..NanosTable.Dump(ennemy)..NanosTable.Dump(traceResultEntity))
        if (traceResultEntity) then
            local distanceToEntity = ennemy:GetLocation():Distance(sourceLocation)
            -- Console.Log(iNpcID.."Distance to entity"..distanceToEntity)
            if (distanceToEntity < closestTargetDistance) then
                closestTargetDistance = distanceToEntity
                closestTarget = tAllEnemies[i]
            end
        end
    end
    -- Console.Log("Closest target : "..NanosTable.Dump(closestTarget))
    Events.CallRemote("NACT:TRACE:NPC_LOOK_AROUND:RESULT", iNpcID, closestTarget)
end)

--- INTERNAL. Vision trace line single
---@param vSourceLocation Vector Source location of the trace
---@param vTargetLocation Vector Target location of the trace
---@param entitiesToIgnore array Entities that should be ignored by the trace
---@return { Success: boolean, Location: Vector, Normal: Vector, Entity: Actor, BoneName: string, ActorName: string, ComponentName: string, SurfaceType: SurfaceType, UV: Vector2D }
function ClientsideVisionTrace(vSourceLocation, vTargetLocation, entitiesToIgnore)
    return Trace.LineSingle(
        vSourceLocation,
        vTargetLocation,
        CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
        -- TraceMode.DrawDebug | TraceMode.ReturnEntity,
        TraceMode.ReturnEntity,
        entitiesToIgnore
    )
end

--- If the target provides GetBoneTransform function gets the bone location ortherwise, returns the origin of the Character
---@param cTarget Character The target of the query
---@param sTargetBone string Bone name
---@return Vector
function GetDetailledLocationOfTarget(cTarget, sTargetBone)
    if (cTarget.GetBoneTransform) then
        return cTarget:GetBoneTransform(sTargetBone).Location
    else
        return cTarget:GetLocation()
    end
end

--- Launches a lot of traces. If atleast one trace is successful then it will
---@param vSourceLocation any
---@param cTarget any
---@param tTargetBones any
---@param tIgnoreEntityList any
---@return unknown
function GetTraceResultFromListOfBones(vSourceLocation, cTarget, tTargetBones, tIgnoreEntityList)
    local bTracesResults = false

    for i,boneName in ipairs(tTargetBones) do
        local targetLocation = GetDetailledLocationOfTarget(cTarget, boneName)

        -- Console.Log("Launching trace results target bone : "..NanosTable.Dump(boneName))
        local tTraceResult = ClientsideVisionTrace(
            vSourceLocation,
            targetLocation,
            tIgnoreEntityList
        )

        -- TODO: Breaking here could save a lot of performance !
        bTracesResults = bTracesResults or (tTraceResult.Success and tTraceResult.Entity == cTarget)
        
        -- Console.Log("bTracesResults : "..NanosTable.Dump(bTracesResults))
    end
    return bTracesResults
end
