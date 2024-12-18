-- TODO: This would be better in it's own class with start bone and end bones
-- TODO: Supports only one trace order at the time for the moment, make it compatible with multiple orders
-- TODO: For example (head to head, head to left arm, head to right arm, head to torso) for more accurate detection
-- TODO: And also add multiple interval so multiple NPCs can delegate traces to a few selected stable network authrorities
local iTracesRefresherInterval = {}


-- TODO: Not just for detection, this is the whole "Vision trace" logic there
Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:START", function(cNpc, cTarget, iBehaviorId, tMaybeTargetBones)
    if (iTracesRefresherInterval[iBehaviorId] ~= nil) then
        return
    end

    iTracesRefresherInterval[iBehaviorId] = Timer.SetInterval(function ()
        local vNpcLocation = cNpc:GetLocation()
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
                TraceMode.DrawDebug | TraceMode.ReturnEntity,
                {cNpc}
            )

            bTracesResults = bTracesResults or (tTraceResult.Success and tTraceResult.Entity == cTarget)
        end

        -- Console.Log("Trace result value : ".. NanosTable.Dump(tTraceResult))

        -- TODO: This should instead change just the toggling state. But I don't pay broadband in local testing lmao
        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", iBehaviorId, bTracesResults)
    end, 50)
end)

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", function(iBehaviorId)
    Console.Log("Trace is stopping")
    local iTracesRefresherHandle = iTracesRefresherInterval[iBehaviorId]
    if (iTracesRefresherHandle) then
        Timer.ClearInterval(iTracesRefresherHandle)
        iTracesRefresherInterval[iBehaviorId] = nil
    end
end)
