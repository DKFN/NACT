
local tTraces = {}


-- TODO: Not just for detection, this is the whole "Vision trace" logic there
Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:START", function(cNpc, cTarget, iBehaviorId, tMaybeTargetBones)
    if (tTraces[iBehaviorId] ~= nil) then
        return
    end

    tTraces[iBehaviorId] = {
        detected = false,
        handle = Timer.SetInterval(function ()
            local vNpcLocation = cNpc:GetLocation()

            -- TODO: Must fallback and check if GetBoneTransform is defined for CharacterSimple
            local vNpcHeadLocation = cNpc:GetBoneTransform("head")
            -- Console.Log("Bone transform locator : ".. NanosTable.Dump(vNpcHeadLocation))
            local sourceLocation
            if (vNpcHeadLocation) then
                sourceLocation = vNpcHeadLocation.Location
            else
                sourceLocation = vNpcLocation
            end

            local vEntityLocation = cTarget:GetLocation()
            local bTracesResults = false
            
            for i,boneName in ipairs(tMaybeTargetBones) do
                local targetLocation = cTarget:GetBoneTransform(boneName)

                local tTraceResult = Trace.LineSingle(
                    sourceLocation,
                    targetLocation.Location,
                    CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
                    -- TraceMode.DrawDebug | TraceMode.ReturnEntity,
                    TraceMode.ReturnEntity,
                    {cNpc}
                )

                bTracesResults = bTracesResults or (tTraceResult.Success and tTraceResult.Entity == cTarget)
            end

            -- Console.Log("Trace result value : ".. NanosTable.Dump(tTraceResult))

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
