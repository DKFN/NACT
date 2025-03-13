
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
    local coverViable = true
    for iEntity, entity in ipairs(tAllFocusedEntities) do
        local finalLoc
        local entityPreciseLocation = entity:GetSocketTransform("head")
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
            break;
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
            end
            tViabilityOfCovers[iTerritoryID][iCover] = coverViable
        end
    end
end

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:POSITIONS", function(_iTerritoryID, allPositions)
    iTerritoryID = _iTerritoryID
    coverPositionsByTerritoryID[iTerritoryID] = allPositions
    tViabilityOfCovers[iTerritoryID] = {}
    currentTickIndex = 1
end)

-- local benchmarkCoverViabilityTime = os.clock()
Client.Subscribe("Tick", function()
    if (not iTerritoryID or not coverPositionsByTerritoryID[iTerritoryID][currentTickIndex]) then
        return
    end

    ScanCoverPoint(coverPositionsByTerritoryID[iTerritoryID][currentTickIndex], currentTickIndex, iTerritoryID)
    
    if (currentTickIndex >= #coverPositionsByTerritoryID[iTerritoryID]) then
        -- local took = os.clock() - benchmarkCoverViabilityTime
        -- Console.Log("Cover viability took"..NanosTable.Dump(took).. "s scanned "..currentTickIndex.." cover points")
        currentTickIndex = 1
        -- benchmarkCoverViabilityTime = os.clock()
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
    local tCoverViabilities = tViabilityOfCovers[iTerritoryID]
    if (tCoverViabilities) then
        Events.CallRemote("NACT:TRACE:COVER:VIABILITY:RESULT", iTerritoryID, tViabilityOfCovers[iTerritoryID])
    end
end)

Events.SubscribeRemote("NACT:TRACE:COVER_VIABILITY:STOP", function()
    -- Console.Log("Trace viability is stopping")
    tAllFocusedEntities = {}
    if (iTerritoryID) then
       tViabilityOfCovers[iTerritoryID] = {}
       iTerritoryID = nil
    end
end)
