local NACT_PROVISORY_VISION_LOOKUP_BONES = {
    "head", "lowerarm_l", "lowerarm_r", "foot_l", "foot_r"
}

---
--- Tracing and Vision
---

--- INTERNAL. Stop the tracing for the vision logic
function NACT_NPC:StopTracing()
    if (self.tracingLaunched and self.tracingAuthority:IsValid()) then
        Console.Log("Calling stop event for traces")
        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", self.tracingAuthority, self:GetID()) --, self.npc.character, self.npc.cFocused)
        self.tracingLaunched = false
    end
end

--- INTERNAL. Starts the tracing for the vision logic
function NACT_NPC:StartTracing()
    if (self:GetFocused() ~= nil) then
        -- TODO Find best player to send the trace, nearest player in range
        self.tracingAuthority = self.character:GetNetworkAuthority()
        -- Console.Log("Calling remote event")
        
        
        if (not self.tracingLaunched and self.tracingAuthority) then
            Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", self.tracingAuthority, self.character, self:GetFocused(), self:GetID(), NACT_PROVISORY_VISION_LOOKUP_BONES)
            self.tracingLaunched = true
        end
    end
end


--- This function attemps to change focused entity. If there is an enemy in the detection trigger of the NACT_NPC
--- and there the enemy is in the vision range of the player.
--- You can call this function like there is no tommorrow, it is throttled and will NOT trigger each time it is called
function NACT_NPC:LookForFocused()
    if (not self.launchedScanAround) then
        local enemiesInDetection = self:GetEnemiesInZone("detection")
        if (#enemiesInDetection > 0) then
            self.launchedScanAround = true
            local delegatedPlayer = self.character:GetNetworkAuthority()
            local enemiesInVisionAngle = {}
            if (delegatedPlayer) then
                for i, enemy in ipairs(enemiesInDetection) do
                    if (self:IsInVisionAngle(enemy)) then
                        enemiesInVisionAngle[#enemiesInVisionAngle + 1] = enemy
                    end
                end
                Events.CallRemote(
                    "NACT:TRACE:NPC_LOOK_AROUND:QUERY",
                    delegatedPlayer,
                    self.character,
                    enemiesInVisionAngle,
                    self:GetID(),
                    NACT_PROVISORY_VISION_LOOKUP_BONES
                )
            end
            
        end
    end
end
--- INTERNAL. Releases the scan lock of the "LookForFocused" query.
function NACT_NPC:ReleaseScanLock()
    self.launchedScanAround = false
end

--- Checks if the character in parameter is in the vision angle of the NPC
--- This function is not enough to check if the entity is really visible. You must use vision traces for that
---@param cEntity Character @The character to check for vision range
---@return boolean @Ff the character is in vision angle.
function NACT_NPC:IsInVisionAngle(cEntity)
    if (cEntity == nil) then
        -- Console.Error("N.A.C.T. Called IsInVisionAngle with Nil entity")
        return false
    end

    local tAnglePlayerNpc = (self.character:GetLocation() - cEntity:GetLocation()):Rotation()
    local angleVersion =  math.abs(self.character:GetRotation().Yaw - tAnglePlayerNpc.Yaw)
    -- Console.Log("Angle "..NanosTable.Dump(angleVersion))
    return angleVersion > self.visionAngle
end

--- Returns if the focused entity is currently visible.
--- Meaning if it is hit by the vision system and is in the vision angle of the NPC.
---@return boolean @Is the focused entity is currently visible.
function NACT_NPC:IsFocusedVisible()
    return self:GetFocused() ~= nil and self.cFocusedTraceHit and self:IsInVisionAngle(self:GetFocused())
end

-- TODO: Below should be moved to navigation

--- Turns the NPC towards the focused entity.
--- Remember to specify an innacuracyFactor if you intend to shoot right after, or your NPC will quickly kill opponents.
---@param nInaccuracyFactor number @Innacuracy to apply to the NPC when shooting
function NACT_NPC:TurnToFocused(nInaccuracyFactor)
    local vFocusedLocation = self:GetFocusedLocation()
    if vFocusedLocation == nil then
        return
    end
    self:TurnTo(vFocusedLocation, nInaccuracyFactor)
end

--- Makes the NPC turn towards a location
---@param vLocation Vector @Location to turn towards
---@param nInaccuracyFactor number @Innacuracy factor fo turn to
function NACT_NPC:TurnTo(vLocation, nInaccuracyFactor)
    local vInaccurayVector
    if (nInaccuracyFactor) then
        vInaccurayVector = Vector(
            math.random(-nInaccuracyFactor, nInaccuracyFactor),
            math.random(-nInaccuracyFactor, nInaccuracyFactor),
            math.random(-nInaccuracyFactor, nInaccuracyFactor)
        )
    else
        vInaccurayVector = Vector(0,0,0)
    end
    self.character:LookAt(vLocation + vInaccurayVector)
    self.character:RotateTo(Rotator(0, (vLocation - self.character:GetLocation()):Rotation().Yaw, 0), 0.5)
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
---@return Vector Focused location
function NACT_NPC:GetFocusedLocation()
    if (self:GetFocused()) then
        return self.cFocused:GetLocation()
    end
end

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", function(player, npcID, entityResult)
    local npcSubscribedToTraces = NACT_NPC.GetByID(npcID)
    if (npcSubscribedToTraces) then
        -- Console.Log("Cfocused hit "..NanosTable.Dump(entityResult))
        npcSubscribedToTraces.cFocusedTraceHit = entityResult
        local currentFocused = npcSubscribedToTraces:GetFocused()
        if (currentFocused) then
            npcSubscribedToTraces.cFocusedLastPosition = currentFocused:GetLocation()
        end
        if not entityResult then
            Timer.SetTimeout(function(npcSubscribedToTraces)
                if (not npcSubscribedToTraces.cFocusedTraceHit) then
                    npcSubscribedToTraces:Log("Player lost")
                    npcSubscribedToTraces:SetFocused(nil)
                end
            end, 1000, npcSubscribedToTraces) -- TODO: 1s to loose track seems like a lot
        else
            
        end
    end
end)

Events.SubscribeRemote("NACT:TRACE:NPC_LOOK_AROUND:RESULT", function(player, npcID, maybeNewCFocused)
    local npcForResult = NACT_NPC.GetByID(npcID)
    -- Console.Log("Attempt vision lookup result : "..NanosTable.Dump(maybeNewCFocused).." for npc : "..NanosTable.Dump(npcForResult))
    
    if (npcForResult) then
        if maybeNewCFocused then
            -- npcForResult:Log("Looked around, now focusing "..NanosTable.Dump(maybeNewCFocused))
            npcForResult:SetFocused(maybeNewCFocused)
        end

        Timer.SetTimeout(function(npcForResult)
            npcForResult.launchedScanAround = false
            npcForResult:Log("Looked around, found "..NanosTable.Dump(maybeNewCFocused).." Releasing scan")
        end, NACT_PROVISORY_LOOKAROUND_THROTTLE, npcForResult)
    end
end)
