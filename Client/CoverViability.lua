-- This allows to launch more traces to be more precise in the secure behavior
-- (For example doing a kind of "box" instead of a mono trace)

local coverPositionsByTerritoryID = {}
Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:POSITIONS", function(iTerritoryID, allPositions)
    coverPositionsByTerritoryID[iTerritoryID] = allPositions
end)

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:QUERY", function(iTerritoryID, tAllFocusedEntities)
    local tViabilityOfCovers = {}

    local tAllCoverPositions = coverPositionsByTerritoryID[iTerritoryID]

    if (not tAllCoverPositions) then
        Console.Warn("Positions of territory not received yet, viability scan abandonned")
        return
    end

    -- TODO: We should also launch a trace towards the player camera for third person combat
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

            local traceResultToHead = Trace.LineSingle(
                coverPos,
                finalLoc,
                CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
                -- TraceMode.DrawDebug | TraceMode.ReturnEntity
                TraceMode.ReturnEntity
            )

            coverViable = coverViable and (traceResultToHead.Entity ~= entity)

            if (not coverViable) then
                tViabilityOfCovers[iCover] = coverViable
            else
                local playerOfEntity = entity:GetPlayer()
                if (playerOfEntity) then        
                    local traceResultToCamera = Trace.LineSingle(
                        coverPos,
                        playerOfEntity:GetCameraLocation(),
                        CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
                        -- TraceMode.DrawDebug | TraceMode.ReturnEntity
                        TraceMode.ReturnEntity
                    )

                    -- Console.Log("Cover status "..NanosTable.Dump(traceResultToCamera))
                    coverViable = coverViable and traceResultToCamera.Success
                    tViabilityOfCovers[iCover] = coverViable
                end
            end
            
            
        end
    end

    -- Console.Log("Received trace cover viability result"..NanosTable.Dump(tViabilityOfCovers))

    Events.CallRemote("NACT:TRACE:COVER:VIABILITY:RESULT", iTerritoryID, tViabilityOfCovers)
end)
