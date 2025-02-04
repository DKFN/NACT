NACT_Territory = BaseClass.Inherit("NACT_Territory")

local NACT_PROVISORY_COVER_VIABILITY_REFRESH_TIME = 500
-- local NACT_PROVISORY_COVER_VIABILITY_REFRESH_TIME = 5000
local NACT_PROVISORY_PLAYER_AUTHORITY_REFRESH_TIME = 10000

--- Territory is a zone controlled by NPCs and contains the configuration of
--- cover points and patrol routes 
---@param tTerritoryConfig TerritoryConfig territory config map
function NACT_Territory:Constructor(tTerritoryConfig)
    self.coverPoints = {}
    self.coverPointsPositions = {}
    self.zoneBounds = tTerritoryConfig.zoneBounds
    self:RefreshCoverPoints()

    self.npcs = {}
    self.patrolRoutes = tTerritoryConfig.patrolRoutes
    self.team = tTerritoryConfig.team
    
    self.zone = NACT.createTriggerBox(
        tTerritoryConfig.zoneBounds.pos,
        self,
        TriggerType.Sphere,
        tTerritoryConfig.zoneBounds.radius,
        Color.GREEN
    )

    self.authorityPlayer = nil

    -- Stores all the players that had an authority at one point, and already had territory config sent to them
    self.authorityPlayerHistory = {}


    self.lastAlertRaisedAt = 0

--     Console.Log("Territory team : "..self.team)
    -- Console.Log("Territory cover points : "..NanosTable.Dump(self.coverPoints))

    local _self = self

    self.coverViabilityHandleTimer = Timer.SetInterval(function()
        if (not self.authorityPlayer) then
            -- Console.Log("No reachable players in range, not scanning viability of covers")
            return
        end

        local indexedSelectedEntity = {}
        local allCfocused = {}
        local i = 1

        -- TODO: This duplicates the same character if it is focused by multiple NPCS.
        -- TODO: This is useless, we can only add one time
        for iNpc, npc in ipairs(self.npcs) do
            if (npc.cFocused and npc.cFocused:IsValid() and not indexedSelectedEntity[npc.cFocused:GetID()]) then
                allCfocused[i] = npc.cFocused
                indexedSelectedEntity[npc.cFocused:GetID()] = true
                i = i + 1
            end
        end
    
        if (self.authorityPlayer and self.authorityPlayer:IsValid()) then
            Events.CallRemote("NACT:TRACE:COVER:VIABILITY:QUERY", self.authorityPlayer, _self:GetID(), allCfocused)
        else
            self:SwitchNetworkAuthority()
        end
    end, NACT_PROVISORY_COVER_VIABILITY_REFRESH_TIME)

    self.authorityPlayerHandleTimer = Timer.SetInterval(function()
        self:SwitchNetworkAuthority()
    end, NACT_PROVISORY_PLAYER_AUTHORITY_REFRESH_TIME)

    if (NACT_DEBUG_EDITOR_MODE) then
        self:DebugDisplayCoverPoints()
    end

end

--- Updates the viability of cover points
---@param tViabilityResult array [coverIndex]: <isCoverSafe>
function NACT_Territory:UpdateCoverViability(tViabilityResult)
    for iCover, bIsCoverViable in ipairs(tViabilityResult) do
        self.coverPoints[iCover].secure = bIsCoverViable
    end

    if (NACT_DEBUG_COVERS) then
        Console.Log("Cover points viability setup : "..NanosTable.Dump(self.coverPoints))
    end
end

--- INTERNAL. Adds an NPC handled by the territory
---@param nactNpc NACT_NPC
function NACT_Territory:AddNPC(nactNpc)
    table.insert(self.npcs, nactNpc)
end

--- INTERNAL. Removes an NPC from the territory
---@param nactNpc NACT_NPC
function NACT_Territory:RemoveNPC(nactNpc)
    Console.Log("Called remove NPC"..#self.npcs)
    table_remove_by_value(self.npcs, nactNpc)
end

--- INTERNAL. Used by the editor mode. This will create a trigger for each cover point. Usage in production not good.
function NACT_Territory:DebugDisplayCoverPoints()
    for iCover, coverPoint in ipairs(self.coverPointsPositions) do
        Trigger(coverPoint, Rotator(), Vector(50), TriggerType.Sphere, true, Color.RED)
        -- Console.Log("Debugging : "..NanosTable.Dump(t))
    end
end

--- Gets all the enemies thare are in the territory
---@return table Array of enemies in the territory
function NACT_Territory:GetEnemiesInZone()
    return NACT.GetTriggerPopulation(self.zone, "enemies")
end


--- Gets all the enemies thare are in the territory
---@return table Array of enemies in the territory
function NACT_Territory:GetAlliesInZone()
    return NACT.GetTriggerPopulation(self.zone, "allies")
end

--- INTERNAL. Switches the network authority of the player that will handle all client ops of the territory
function NACT_Territory:SwitchNetworkAuthority()
    local reachablePlayers = {}

    if (self.authorityPlayer and self.authorityPlayer:IsValid()) then
        Events.CallRemote("NACT:TRACE:COVER_VIABILITY:STOP", self.authorityPlayer)
    end
    
    for iEnemy, enemy in ipairs(self:GetEnemiesInZone()) do
        local pMaybePlayer = enemy:GetPlayer()
        if (pMaybePlayer and pMaybePlayer:IsValid()) then
            table.insert(reachablePlayers, enemy:GetPlayer())
        end
    end

    if (#reachablePlayers ~= 0) then
        local reachablePlayerIndex = math.random(1, #reachablePlayers)
        self.authorityPlayer = reachablePlayers[reachablePlayerIndex]
        if (not self.authorityPlayerHistory[self.authorityPlayer]) then
            self.authorityPlayerHistory[self.authorityPlayer] = true
            Events.CallRemote("NACT:TRACE:COVER:VIABILITY:POSITIONS", self.authorityPlayer, self:GetID(), self.coverPointsPositions)
        end
    else
        self.authorityPlayer = nil
    end
end

--- This function will refresh the cover points of the territory by getting the map cover points
--- thart are in the zone bounds. For now this only supports sphere
function NACT_Territory:RefreshCoverPoints()
    local selectedCoverPoints = {}
    local coverPointsPosition = {}
    for i, coverPoint in ipairs(NACT.GetMapCoverPoints()) do
        -- Console.Log("Scanning cover point : "..NanosTable.Dump(coverPoint))
        local distanceFromOrigin = self.zoneBounds.pos:Distance(coverPoint.pos)
        -- Console.Log("Distance from origin : "..distanceFromOrigin)
        if (distanceFromOrigin <= self.zoneBounds.radius) then
            selectedCoverPoints[#selectedCoverPoints+1] = coverPoint
            coverPointsPosition[#coverPointsPosition+1] = coverPoint.pos
        else
            -- Console.Log("Cover point was not selected "..NanosTable.Dump(coverPoint))
        end
    end
    self.coverPoints = selectedCoverPoints
    self.coverPointsPositions = coverPointsPosition
end

function NACT_Territory:CleanupCharacter(character)
    for i, v in ipairs(self.npcs) do
        Console.Log("Dead character "..NanosTable.Dump(character).." scanning "..NanosTable.Dump(v.character))
        v:CleanupCharacter(character)
        if (v.character == character) then
            v:Destroy()
        end
    end

    if (self.authorityPlayer and self.authorityPlayer:GetControlledCharacter() == character) then
        self:SwitchNetworkAuthority()
    end
end

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:RESULT", function(player, iTerritoryID, tViabilityResult)
    local territoryOfResult = NACT_Territory.GetByID(iTerritoryID)
    if (territoryOfResult) then
        -- Console.Log("Result of cover viability "..NanosTable.Dump(tViabilityResult))
        territoryOfResult:UpdateCoverViability(tViabilityResult)
    end
end)
