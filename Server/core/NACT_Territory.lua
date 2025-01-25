NACT_Territory = BaseClass.Inherit("NACT_Territory")

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

    Console.Log("Territory team : "..self.team)
    -- Console.Log("Territory cover points : "..NanosTable.Dump(self.coverPoints))

    -- TODO: Ce serait mieux d'avoir surement le trigger sur le joueur et que ce soit lui
    -- TODO: Qui reveille les npc. Bg Timmy
    local _self = self

    -- TODO: It should be much better to get a player within the zone bounds instead
    -- TODO: Of relying on only focused entities, wich may not always be a player
    -- TODO: and will stop viability checks until a player is focused again
    -- TODO: And finding one random will cost much less because not looping all seconds
    self.coverViabilityHandleTimer = Timer.SetInterval(function()
        local allCfocused = {}
        for iNpc, npc in ipairs(self.npcs) do
            if (npc.cFocused) then
                table.insert(allCfocused, npc.cFocused)
            end
        end
    
        if (NACT_DEBUG_COVERS) then
            Console.Log("Authority player : "..NanosTable.Dump(self.authorityPlayer))
        end

        if (not self.authorityPlayer) then
            Console.Log("No reachable players in range, not scanning viability of covers")
            return
        end
        -- TODO: There is also no need to resend cover positions each time, this is dumb. Just send it once while getting into the zone
        Events.CallRemote("NACT:TRACE:COVER:VIABILITY:QUERY", self.authorityPlayer, _self:GetID(), allCfocused)
    end, 500)

    self.authorityPlayerHandleTimer = Timer.SetInterval(function()
        self:SwitchNetworkAuthority()
    end, 10000)

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

--- 
---@param nactNpc any
function NACT_Territory:AddNPC(nactNpc)
    table.insert(self.npcs, nactNpc)
end

function NACT_Territory:RemoveNPC(nactNpc)
    table_remove_by_value(self.npcs, nactNpc)
end

function NACT_Territory:DebugDisplayCoverPoints()
    for iCover, coverPoint in ipairs(self.coverPointsPositions) do
        Trigger(coverPoint, Rotator(), Vector(50), TriggerType.Sphere, true, Color.RED)
        -- Console.Log("Debugging : "..NanosTable.Dump(t))
    end
end

function NACT_Territory:GetEnemiesInZone()
    return NACT.GetTriggerPopulation(self.zone, "enemies")
end

function NACT_Territory:GetAlliesInZone()
    return NACT.GetTriggerPopulation(self.zone, "allies")
end

function NACT_Territory:SwitchNetworkAuthority()
    local reachablePlayers = {}
    
    for iEnemy, enemy in ipairs(self:GetEnemiesInZone()) do
        if (enemy:GetPlayer()) then
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
        local distanceFromOrigin = self.zoneBounds.pos:Distance(coverPoint.pos)
        Console.Log("Distance from origin : "..distanceFromOrigin)
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

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:RESULT", function(player, iTerritoryID, tViabilityResult)
    local territoryOfResult = NACT_Territory.GetByID(iTerritoryID)
    if (territoryOfResult) then
        -- Console.Log("Result of cover viability "..NanosTable.Dump(tViabilityResult))
        territoryOfResult:UpdateCoverViability(tViabilityResult)
    end
end)
