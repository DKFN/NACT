
local coverPositionsByTerritoryID = {}
local tViabilityOfCovers = {}
local tAllFocusedEntities = {}

local coverRefreshInterval = nil
local iTerritoryID = nil
local currentTickIndex = 1

--- 
---@param coverPos any
---@param iCover any
---@param iTerritoryID any
local function ScanCoverPoint(coverPos, iCover, iTerritoryID)

    --Console.Log("Scan cover point territory id :"..iTerritoryID)
    -- Console.Log("All focused : "..NanosTable.Dump(tAllFocusedEntities))
    for iEntity, entity in ipairs(tAllFocusedEntities) do
        local coverViable = true
        local finalLoc
        local entityPreciseLocation = entity:GetBoneTransform("head")
        if (entityPreciseLocation) then
            finalLoc = entityPreciseLocation.Location
        else
            finalLoc = entity:GetLocation()
        end

        -- Console.Log("Cover : "..NanosTable.Dump(coverPos))

        local traceResultToHead = Trace.LineSingle(
            coverPos,
            finalLoc,
            CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
            -- TraceMode.DrawDebug | TraceMode.ReturnEntity
            TraceMode.ReturnEntity
        )

        coverViable = coverViable and (traceResultToHead.Entity ~= entity)

        if (not coverViable) then
            tViabilityOfCovers[iTerritoryID][iCover] = coverViable
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

                -- Console.Log(iCover.." Cover status "..NanosTable.Dump(coverViable))
                coverViable = coverViable and traceResultToCamera.Success
                tViabilityOfCovers[iTerritoryID][iCover] = coverViable
            end
        end
    end
end

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:POSITIONS", function(_iTerritoryID, allPositions)
    iTerritoryID = _iTerritoryID
    coverPositionsByTerritoryID[iTerritoryID] = allPositions
    tViabilityOfCovers[iTerritoryID] = {}
    -- Console.Log("Received positions :"..NanosTable.Dump(coverPositionsByTerritoryID[iTerritoryID]))


    -- TODO: This sucks it seems to not really iterate on all cover points 
end)

Client.Subscribe("Tick", function()
    if (not iTerritoryID or not coverPositionsByTerritoryID[iTerritoryID][currentTickIndex]) then
        return
    end

    ScanCoverPoint(coverPositionsByTerritoryID[iTerritoryID][currentTickIndex], currentTickIndex, iTerritoryID)
    
    if (currentTickIndex >= #coverPositionsByTerritoryID[iTerritoryID]) then
        currentTickIndex = 1
    else
        currentTickIndex = currentTickIndex + 1
    end
end)

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:QUERY", function(_iTerritoryID, tQueryAllFocusedEntities)
    local tAllCoverPositions = coverPositionsByTerritoryID[iTerritoryID]
    tAllFocusedEntities = tQueryAllFocusedEntities
    iTerritoryID = _iTerritoryID

    if (not tAllCoverPositions) then
        -- Console.Warn("Positions of territory not received yet, viability scan abandonned")
        return
    end
    Events.CallRemote("NACT:TRACE:COVER:VIABILITY:RESULT", iTerritoryID, tViabilityOfCovers[iTerritoryID])
end)

Events.Subscribe("NACT:TRACE:COVER_VIABILITY:STOP", function()
    -- Console.Log("Trace viability is stopping")
    if (coverRefreshInterval) then
        Timer.ClearInterval(coverRefreshInterval)
    end
end)
