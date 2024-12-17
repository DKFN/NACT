-- TODO: Supports only one trace order at the time for the moment, make it compatible with multiple orders
local iTracesRefresherInterval = nil

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:START", function(cNpc, cTarget, iBehaviorId)
    if (iTracesRefresherInterval ~= nil) then
        return
    end

    iTracesRefresherInterval = Timer.SetInterval(function ()
        local vNpcLocation = cNpc:GetLocation()
        local vEntityLocation = cTarget:GetLocation()

        local tTraceResult = Trace.LineSingle(
            vNpcLocation,
            vEntityLocation,
            CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
            TraceMode.DrawDebug | TraceMode.ReturnEntity,
            {cNpc}
        )

        -- Console.Log("Trace result value : ".. NanosTable.Dump(tTraceResult))

        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", iBehaviorId, tTraceResult.Success and tTraceResult.Entity == cTarget)
    end, 50)
end)

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", function()
    Console.Log("Trace is stopping")
    Timer.ClearInterval(iTracesRefresherInterval)
    iTracesRefresherInterval = nil
end)
