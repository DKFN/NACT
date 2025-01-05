
local tTraces = {}


-- TODO: Not just for detection, this is the whole "Vision trace" logic there
Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:START", function(cNpc, cTarget, iBehaviorId, tMaybeTargetBones)
    if (tTraces[iBehaviorId] ~= nil) then
        return
    end

    tTraces[iBehaviorId] = {
        detected = false,
        handle = Timer.SetInterval(function ()
            -- TODO: Must fallback and check if GetBoneTransform is defined for CharacterSimple
            -- Console.Log("Bone transform locator : ".. NanosTable.Dump(vNpcHeadLocation))
            local vSourceLocation = GetDetailledLocationOfTarget(cNpc, "head")

            local bTracesResults = GetTraceResultFromListOfBones(vSourceLocation, cTarget, tMaybeTargetBones, {cNpc})

            local tTrace = tTraces[iBehaviorId]
            if (bTracesResults ~= tTrace.detected) then
                tTraces[iBehaviorId].detected = bTracesResults
                Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", iBehaviorId, bTracesResults)
            end
        end, 50)
    }
end)

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", function(iBehaviorId)
    Console.Log("Trace is stopping")
    local tTrace = tTraces[iBehaviorId]
    if (tTrace and tTrace.handle) then
        Timer.ClearInterval(tTrace.handle)
        tTraces[iBehaviorId] = nil
        -- Clears any pending vision when stopping traces
        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", iBehaviorId, false)
    end
end)


Events.SubscribeRemote("NACT:TRACE:NPC_LOOK_AROUND:QUERY", function(sourceNpc, tAllEnemies, iNpcID, tTargetBones)
    local tEnnemyLookupResult = {}
    Console.Log("Attemp trace hit of : "..NanosTable.Dump(tAllEnemies))
    for i, ennemy in ipairs(tAllEnemies) do
        local traceResultEntity = GetTraceResultFromListOfBones(
            GetDetailledLocationOfTarget(sourceNpc, "head"),
            ennemy,
            tTargetBones
        )
        Console.Log("Trace result for "..NanosTable.Dump(ennemy)..NanosTable.Dump(traceResultEntity))
        if (traceResultEntity) then
            Events.CallRemote("NACT:TRACE:NPC_LOOK_AROUND:RESULT", iNpcID, tAllEnemies[i])
            break;
        end
    end
end)


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

function GetDetailledLocationOfTarget(cTarget, sTargetBone)
    if (cTarget.GetBoneTransform) then
        return cTarget:GetBoneTransform(sTargetBone).Location
    else
        return cTarget:GetLocation()
    end
end

function GetTraceResultFromListOfBones(vSourceLocation, cTarget, tTargetBones, tIgnoreEntityList)
    local bTracesResults = false

    for i,boneName in ipairs(tTargetBones) do
        local targetLocation = GetDetailledLocationOfTarget(cTarget, boneName)

        local tTraceResult = ClientsideVisionTrace(
            vSourceLocation,
            targetLocation,
            tIgnoreEntityList
        )

        bTracesResults = bTracesResults or (tTraceResult.Success and tTraceResult.Entity == cTarget)
    end
    return bTracesResults
end
