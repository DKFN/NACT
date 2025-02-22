NACT_Territory = BaseClass.Inherit("NACT_Territory")

local NACT_PROVISORY_COVER_VIABILITY_REFRESH_TIME = 500
-- local NACT_PROVISORY_COVER_VIABILITY_REFRESH_TIME = 5000
local NACT_PROVISORY_PLAYER_AUTHORITY_REFRESH_TIME = 10000

--- Territory is a zone controlled by NPCs.
--- 
--- It takes a parameter the following table:
--- 
--- ```lua
--- {
---     team = 1, -- The team of the territory
---     patrolRoutes = {} -- Optional, the patrol routes of this territory. You can also call AddPatrolRoute
--- }
--- ````
--- cover points and patrol routes 
---@param tTerritoryConfig TerritoryConfig @territory config map
---@param sTerritoryName string @name of the territory
function NACT_Territory:Constructor(tTerritoryConfig, sTerritoryName)
    self.coverPoints = {}
    self.coverPointsPositions = {}
    self.zoneBounds = tTerritoryConfig.zoneBounds
    self.name = sTerritoryName
    self:RefreshCoverPoints()

    self.npcs = {}
    self.patrolRoutes = NACT.ValueOrDefault(tTerritoryConfig.patrolRoutes, {})
    self.team = NACT.ValueOrDefault(tTerritoryConfig.team, 0)
    
    self.zone = NACT.createTriggerBox(
        tTerritoryConfig.zoneBounds.pos,
        self,
        TriggerType.Sphere,
        tTerritoryConfig.zoneBounds.radius,
        Color.GREEN,
        true
    )

    self.authorityPlayer = nil

    -- Stores all the players that had an authority at one point, and already had territory config sent to them
    self.authorityPlayerHistory = {}


    self.lastAlertRaisedAt = 0

--     Console.Log("Territory team : "..self.team)
    -- Console.Log("Territory cover points : "..NanosTable.Dump(self.coverPoints))

    local _self = self

    self.coverViabilityHandleTimer = Timer.SetInterval(function()
        if (not self.authorityPlayer or #self.coverPoints == 0) then
            -- Console.Log("No reachable players in range, not scanning viability of covers")
            return
        end

        local indexedSelectedEntity = {}
        local allCfocused = {}
        local i = 1

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
end

--- Gets the network authority of the territory or nil if not defined or valid
--- @return Player|nil @Current authority if defined and valid
function NACT_Territory:GetNetworkAuthority()
    if (self.authorityPlayer and self.authorityPlayer:IsValid()) then
        return self.authorityPlayer
    end
end

--- Updates the viability of cover points
---@param tViabilityResult array @[coverIndex]: <isCoverSafe>
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
    -- Console.Log("Called remove NPC"..#self.npcs)
    table_remove_by_value(self.npcs, nactNpc)
end

--- Gets all the enemies thare are in the territory
---@return table @Sequential array of enemies in the territory
function NACT_Territory:GetEnemiesInZone()
    return NACT.GetTriggerPopulation(self.zone, "enemies")
end


--- Gets all the enemies thare are in the territory
---@return table @Sequential array of allies in the territory
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
    self:UpdateCSSTAuthority()
end

--- INTERNAL. Switches authority for all clientside Triggers
function NACT_Territory:UpdateCSSTAuthority()
    for k, npc in ipairs(self.npcs) do
        
        -- Console.Log("Uppdate CSST "..NanosTable.Dump(self.npcs.triggers))
        for j, triggerData in pairs(npc.triggers) do
            triggerData.trigger:SetNetworkAuthority(self.authorityPlayer)
        end
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

--- Cleanns up a character from the territory and it's npcs. Switches authority if charcter belonged to player that was authority
---@param Character @Character to cleanup
function NACT_Territory:CleanupCharacter(character)
    for i, nactNpc in ipairs(self.npcs) do
        -- Console.Log("Dead character "..NanosTable.Dump(character).." scanning "..NanosTable.Dump(nactNpc.character))
        nactNpc:CleanupCharacter(character)
        if (nactNpc.character == character) then
            self:RemoveNPC(nactNpc)
            nactNpc:Destroy()
        end
    end

    if (self.authorityPlayer and self.authorityPlayer:GetControlledCharacter() == character) then
        -- Console.Log("Was authority, switching ")
        self:SwitchNetworkAuthority()
    end
end

--- Adds a patrol route instead of using the config table
---@param sPatrolRouteName string @The patrol route name to use
---@param tPatrol table @
function NACT_Territory:AddPatrolRoute(sPatrolRouteName, tPatrol)
    self.patrolRoutes[sPatrolRouteName] = tPatrol
end

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:RESULT", function(player, iTerritoryID, tViabilityResult)
    local territoryOfResult = NACT_Territory.GetByID(iTerritoryID)
    if (territoryOfResult) then
        -- Console.Log("Result of cover viability "..NanosTable.Dump(tViabilityResult))
        territoryOfResult:UpdateCoverViability(tViabilityResult)
    end
end)

--- Finds a territory by name
---@param sTerritoryName string @Name of the territory
---@return NACT_Territory | nil @Territory if it was found
function NACT_Territory.FindByName(sTerritoryName)
    for k, v in ipairs(NACT_Territory.GetAll()) do
        if v.name == sTerritoryName then
            return v
        end
    end
end
