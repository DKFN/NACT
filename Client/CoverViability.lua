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
            local traceResult = Trace.LineSingle(
                coverPos,
                finalLoc,
                CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
                --TraceMode.DrawDebug | TraceMode.ReturnEntity
                TraceMode.ReturnEntity
            )

            coverViable = coverViable and (traceResult.Entity ~= entity)

            tViabilityOfCovers[iCover] = coverViable
            if (not coverViable) then
                break;
            end
        end
    end

    Console.Log("Received trace cover viability result"..NanosTable.Dump(tViabilityOfCovers))

    Events.CallRemote("NACT:TRACE:COVER:VIABILITY:RESULT", iTerritoryID, tViabilityOfCovers)
end)