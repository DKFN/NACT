--- Move but also look towards point
---@param vPoint Vector @Point to go
---@param nAcceptanceRadius Number @Acce
function NACT_NPC:MoveToPoint(vPoint, nAcceptanceRadius)
    self:MoveTo(vPoint)
    self.character:LookAt(vPoint)
end

--- MoveTo without looking to point.
--- Falls back to SetLocation if there is no network authority
---@param vPoint Vector @Point to go
function NACT_NPC:MoveTo(vPoint)
    local authority = self.character:GetNetworkAuthority()
    if (authority and authority:IsValid()) then
        self.character:MoveTo(vPoint, 1)
    else
        self.character:SetLocation(vPoint)
    end
end


--- Query the player that has the network authority on the territory for a random point to the focused location
--- or it's last known position
--- 
--- The querying is async. Reply will be passed in a `OnRandomPointResult` callback in your behavior if it is defined, as such:
--- 
--- ```lua
--- My_Behavior:OnRandomPointResult(vTargetPoint)
--- ```
---@param radius number @Radius for the search to the random point
function NACT_NPC:RandomPointToFocusedQuery(radius)
    local focusedLocation 
    if (self:GetFocused()) then
        focusedLocation = self:GetFocusedLocation()
    else
        focusedLocation = self.cFocusedLastPosition
    end

    if (focusedLocation and not focusedLocation:IsZero()) then
        self:RandomPointToQuery(focusedLocation, radius)
    end

end

--- Query the player that has the network authority on the territory for a random point in the range of the poinst
---@param vLocation Vector @Point at the center of the random point query
---@param radius number @Radius for the search
function NACT_NPC:RandomPointToQuery(vLocation, radius)
    local authorityPlayer = self.territory:GetNetworkAuthority()
    if (authorityPlayer) then
        Events.CallRemote("NACT:NAVIGATION:RANDOM_QUERY", authorityPlayer, self:GetID(), vLocation, radius)
    end
end

--- Distance to the focused entity
---@return number @Distance to the focused entity. 0 if the entity was not found
function NACT_NPC:GetDistanceToFocused()
    local focusedLocation = self:GetFocusedLocation()
    if (focusedLocation) then
        return self.character:GetLocation():Distance(focusedLocation)
    else
        return 0 -- This should never be zero in real life. Maybe this will cause problems one day.
    end
end

--- Returns the focused location. This will return nothing if the focused entity becomes out of sight
---@return Vector Focused|nil @Location of the focused entity if found, nil ortherwise
function NACT_NPC:GetFocusedLocation()
    if (self:GetFocused()) then
        return self.cFocused:GetLocation()
    end
end

--- Event return for the navigation query result. Will call "OnRandomPointResult" on the behavior if defined
---@param player Player @player that made the calculation
---@param iNpcID number @ID of the NPC that made the query
---@param vTargetPoints Vector @Result of the random point query
Events.SubscribeRemote("NACT:NAVIGATION:RANDOM_RESULT", function(player, iNpcID, vTargetPoints)
    local npc = NACT_NPC.GetByID(iNpcID)
    -- Console.Log("Gotten result : "..NanosTable.Dump(iNpcID).." with : "..NanosTable.Dump(vTargetPoints))
    if (npc) then
        if (npc.behavior and npc.behavior.OnRandomPointResult) then
            npc.behavior:OnRandomPointResult(vTargetPoints)
        end
    end
end)