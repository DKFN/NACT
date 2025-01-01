NACT_Territory = BaseClass.Inherit("NACT_Territory")

function NACT_Territory:Constructor(tTerritoryConfig)
    self.coverPoints = tTerritoryConfig.coverPoints
    self.coverPointsPositions = {}
    for iCover, cover in ipairs(self.coverPoints) do
        table.insert(self.coverPointsPositions, cover.pos)
    end
    self.npcs = {}

    local _self = self

    -- TODO: It should be much better to get a player within the zone bounds instead
    -- TODO: Of relying on only focused entities, wich may not always be a player
    -- TODO: and will stop viability checks until a player is focused again
    -- TODO: And finding one random will cost much less because not looping all seconds
    self.coverViabilityHandleTimer = Timer.SetInterval(function()
        local reachablePlayers = {}
        local allCfocused = {}
        for iNpc, npc in ipairs(_self.npcs) do
            if (npc.cFocused) then
                local playerFocused = npc.cFocused:GetPlayer()
                if (playerFocused) then
                    table.insert(reachablePlayers, playerFocused)
                end
                table.insert(allCfocused, npc.cFocused)
            end
        end

        if (#reachablePlayers == 0) then
            Console.Log("No reachable players in range, not scanning viability of covers")
            return
        end

        local reachablePlayerIndex = math.random(1, #reachablePlayers)
        local authorityPlayer = reachablePlayers[reachablePlayerIndex]

        if (NACT_DEBUG_COVERS) then
            Console.Log("Authority player : "..NanosTable.Dump(authorityPlayer))
        end

        Events.CallRemote("NACT:TRACE:COVER:VIABILITY:QUERY", authorityPlayer, _self:GetID(), allCfocused, _self.coverPointsPositions)
    end, 1000)

end

function NACT_Territory:UpdateCoverViability(tViabilityResult)
    for iCover, bIsCoverViable in ipairs(tViabilityResult) do
        self.coverPoints[iCover].secure = bIsCoverViable
    end

    if (NACT_DEBUG_COVERS) then
        Console.Log("Cover points viability setup : "..NanosTable.Dump(self.coverPoints))
    end
end

function NACT_Territory:AddNPC(nactNpc)
    table.insert(self.npcs, nactNpc)
end

Events.SubscribeRemote("NACT:TRACE:COVER:VIABILITY:RESULT", function(player, iTerritoryID, tViabilityResult)
    local territoryOfResult = NACT_Territory.GetByID(iTerritoryID)
    if (territoryOfResult) then
        territoryOfResult:UpdateCoverViability(tViabilityResult)
    end
end)
