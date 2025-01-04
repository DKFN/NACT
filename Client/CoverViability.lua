-- This allows to launch more traces to be more precise in the secure behavior
-- (For example doing a kind of "box" instead of a mono trace)
local tracePrecisionsVectorOffsets = {
    Vector(0, 0, 0),
    Vector(0, 0, 100),
}

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:QUERY", function(iTerritoryID, tAllFocusedEntities, tAllCoverPositions)
    local tViabilityOfCovers = {}

    for iCover, coverPos in ipairs(tAllCoverPositions) do
        local coverViable = true
        for iEntity, entity in ipairs(tAllFocusedEntities) do
            local finalLoc
            local entityPreciseLocation = entity:GetBoneTransform("head")
            if (entityPreciseLocation) then
                finalLoc = entityPreciseLocation.Location
            else
                finalLoc = entity:GetLocation()
            end
            for i, vTracePrecisionOffset in ipairs(tracePrecisionsVectorOffsets) do
                local traceResult = Trace.LineSingle(
                    coverPos,
                    finalLoc  + vTracePrecisionOffset,
                    CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
                    -- TraceMode.DrawDebug | TraceMode.ReturnEntity
                    TraceMode.ReturnEntity
                )

                coverViable = coverViable and (traceResult.Entity ~= entity)

                tViabilityOfCovers[iCover] = coverViable
                if (not coverViable) then
                    break;
                end
            end
        end
    end

    -- Console.Log("Received trace cover viability result"..NanosTable.Dump(tViabilityOfCovers))

    Events.CallRemote("NACT:TRACE:COVER:VIABILITY:RESULT", iTerritoryID, tViabilityOfCovers)
end)