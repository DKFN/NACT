local NACT_PROVISORY_VISION_LOOKUP_BONES = {
    "head", "lowerarm_l", "lowerarm_r", "foot_l", "foot_r"
}

local NACT_PROVISORY_LOOKAROUND_THROTTLE = 1000

---
--- Tracing and Vision
---
function NACT_NPC:StopTracing()
    if (self.tracingLaunched) then
        Console.Log("Calling stop event for traces")
        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", Player.GetByIndex(1), self:GetID()) --, self.npc.character, self.npc.cFocused)
        self.tracingLaunched = false
    end
end

function NACT_NPC:StartTracing()
    if (self:GetFocused() ~= nil) then
        -- TODO Find best player to send the trace, nearest player in range
        local delegatedPlayer = Player.GetByIndex(1) -- self.npc.cFocused:GetPlayer()
        -- Console.Log("Calling remote event")
        
        
        if (not self.tracingLaunched and delegatedPlayer) then
            Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", delegatedPlayer, self.character, self:GetFocused(), self:GetID(), NACT_PROVISORY_VISION_LOOKUP_BONES)
            self.tracingLaunched = true
        end
    end
end


--- This function attemps to change focused entity, if once is hit in the look range and 
---  
function NACT_NPC:LookForFocused()
    -- self:Log("Attempt "..NanosTable.Dump(#self:GetEnemiesInTrigger("detection") > 0).." scan launched ? "..NanosTable.Dump(self.launchedScanAround))
    if (not self.launchedScanAround) then
        self:Log2("Poll from me")
        local enemiesInDetection = self:GetEnemiesInTrigger("detection")
        if (#enemiesInDetection > 0) then
            -- self:Log("Looking around")
            self.launchedScanAround = true
            -- TODO Find best player to send the trace, nearest player in range
            local delegatedPlayer = Player.GetByIndex(1)
            local enemiesInVisionAngle = {}
            for i, enemy in ipairs(enemiesInDetection) do
                if (self:IsInVisionAngle(enemy)) then
                    table.insert(enemiesInVisionAngle, enemy)
                end
            end
            Events.CallRemote("NACT:TRACE:NPC_LOOK_AROUND:QUERY", delegatedPlayer, self.character, enemiesInVisionAngle, self:GetID(), NACT_PROVISORY_VISION_LOOKUP_BONES)
        end
    end
end

function NACT_NPC:ReleaseScanLock()
    self.launchedScanAround = false
end
function NACT_NPC:IsInVisionAngle(cEntity)
    if (cEntity == nil) then
        -- Console.Error("N.A.C.T. Called IsInVisionAngle with Nil entity")
        return false
    end

    local tAnglePlayerNpc = (self.character:GetLocation() - cEntity:GetLocation()):Rotation()
    local angleVersion =  math.abs(self.character:GetRotation().Yaw - tAnglePlayerNpc.Yaw)
    -- Console.Log("Angle "..NanosTable.Dump(angleVersion))
    return angleVersion > PROVISORY_NACT_ANGLE_DETECTION
end

function NACT_NPC:IsFocusedVisible()
    return self:GetFocused() ~= nil and self.cFocusedTraceHit and self:IsInVisionAngle(self:GetFocused())
end

function NACT_NPC:TurnToFocused(nInaccuracyFactor)
    local vFocusedLocation = self:GetFocusedLocation()
    if vFocusedLocation == nil then
        return
    end
    self:TurnTo(vFocusedLocation, nInaccuracyFactor)
end

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

function NACT_NPC:GetDistanceToFocused()
    local focusedLocation = self:GetFocusedLocation()
    if (focusedLocation) then
        return self.character:GetLocation():Distance(focusedLocation)
    else
        return 0
    end
end

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
            end, 1000, npcSubscribedToTraces)
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
