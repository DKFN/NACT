
local coverPositionsByTerritoryID = {}
local tViabilityOfCovers = {}
local tAllFocusedEntities = {}

local NACT_TICK_COVER_TIME = 1000
local NACT_TICK_COVER_TO_SCAN = 10
local currentTickStartIndex = 1
local currentTickStopIndex = NACT_TICK_COVER_TO_SCAN
local coverRefreshInterval = nil
local scanCompletedOnce = false

local iTerritoryID = nil

local currentTickIndex = 1

--- 
---@param coverPos any
---@param iCover any
---@param iTerritoryID any
local function ScanCoverPoint(coverPos, iCover, iTerritoryID)

    --Console.Log("Scan cover point territory id :"..iTerritoryID)
    Console.Log("All focused : "..NanosTable.Dump(tAllFocusedEntities))
    for iEntity, entity in ipairs(tAllFocusedEntities) do
        local coverViable = true
        local finalLoc
        local entityPreciseLocation = entity:GetBoneTransform("head")
        if (entityPreciseLocation) then
            finalLoc = entityPreciseLocation.Location
        else
            finalLoc = entity:GetLocation()
        end

        Console.Log("Cover : "..NanosTable.Dump(coverPos))

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

                Console.Log(iCover.." Cover status "..NanosTable.Dump(coverViable))
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
    Console.Log("Received positions :"..NanosTable.Dump(coverPositionsByTerritoryID[iTerritoryID]))


    -- TODO: This sucks it seems to not really iterate on all cover points 
end)

Client.Subscribe("Tick", function()
    if (not iTerritoryID) then
        return
    end

    ScanCoverPoint(coverPositionsByTerritoryID[iTerritoryID][currentTickIndex], currentTickIndex, iTerritoryID)
    
    if (currentTickIndex >= #coverPositionsByTerritoryID[iTerritoryID]) then
        currentTickIndex = 1
    else
        currentTickIndex = currentTickIndex + 1
    end
end)

-- TODO Traces here should be distributed ASAP because they are very costly

-- TODO: Store in an array the state by the cover point index
-- TODO: And each tick only try a few traces and every tick move along the array
-- TODO: To update the cover point viability
-- TODO: Also store in the array 
Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:QUERY", function(_iTerritoryID, tQueryAllFocusedEntities)
    local tAllCoverPositions = coverPositionsByTerritoryID[iTerritoryID]
    tAllFocusedEntities = tQueryAllFocusedEntities
    iTerritoryID = _iTerritoryID

    Console.Log("Query for territory Id : "..iTerritoryID)

    Console.Log("Query for territory Id : "..NanosTable.Dump(tViabilityOfCovers))
    if (not tAllCoverPositions) then
        Console.Warn("Positions of territory not received yet, viability scan abandonned")
        return
    end
    Events.CallRemote("NACT:TRACE:COVER:VIABILITY:RESULT", iTerritoryID, tViabilityOfCovers[iTerritoryID])
end)

Events.Subscribe("NACT:TRACE:COVER_VIABILITY:STOP", function()
    Console.Log("Trace viability is stopping")
    if (coverRefreshInterval) then
        Timer.ClearInterval(coverRefreshInterval)
    end
end)
