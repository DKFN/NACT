local NACT_PROVISORY_VISION_LOOKUP_BONES = {
    "head", "lowerarm_l", "lowerarm_r", "foot_l", "foot_r"
}

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
        
        
        if (not self.tracingLaunched) then
            Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", delegatedPlayer, self.character, self:GetFocused(), self:GetID(), NACT_PROVISORY_VISION_LOOKUP_BONES)
            self.tracingLaunched = true
        end
    end
end


--- This function attemps to change focused entity, if once is hit in the look range and 
---  
function NACT_NPC:LookForFocused()
    if (self.triggers.detection.enemyCount > 0 and not self.launchedScanAround) then
        Console.Log("Launching trace results")
        self.launchedScanAround = true
        -- TODO Find best player to send the trace, nearest player in range
        local delegatedPlayer = Player.GetByIndex(1)
        -- Events.CallRemote("NACT:TRACE:NPC_LOOK_AROUND:QUERY", delegatedPlayer, self.character, self.triggers.detection.enemies, self:GetID(), NACT_PROVISORY_VISION_LOOKUP_BONES)
    end
end

function NACT_NPC:IsInVisionAngle(cEntity)
    if (cEntity == nil) then
        Console.Error("N.A.C.T. Called IsInVisionAngle with Nil entity")
        return false
    end

    local tAnglePlayerNpc = (self.character:GetLocation() - cEntity:GetLocation()):Rotation()
    local angleVersion =  math.abs(self.character:GetRotation().Yaw - tAnglePlayerNpc.Yaw)
    return angleVersion > PROVISORY_NACT_ANGLE_DETECTION
end

function NACT_NPC:IsFocusedVisible()
    return self.cFocusedTraceHit and self:IsInVisionAngle(self:GetFocused())
end

function NACT_NPC:TurnToFocused(nInaccuracyFactor)
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

    self.character:LookAt(self:GetFocused():GetLocation() + vInaccurayVector)
    self.character:RotateTo(Rotator(0, (self:GetFocused():GetLocation() - self.character:GetLocation()):Rotation().Yaw, 0), 0.5)
end

function NACT_NPC:GetDistanceToFocused()
    if (self:GetFocused()) then
        return self.character:GetLocation():Distance(self.cFocused:GetLocation())
    else
        -- TODO: Heu ? Vazy je clean plus tard :D
        return 99999999999
    end
end

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", function(player, npcID, entityResult)
    local npcSubscribedToTraces = NACT_NPC.GetByID(npcID)
    if (npcSubscribedToTraces) then
        Console.Log("Cfocused hit "..NanosTable.Dump(entityResult))
        npcSubscribedToTraces.cFocusedTraceHit = entityResult
    end
end)

Events.SubscribeRemote("NACT:TRACE:NPC_LOOK_AROUND:RESULT", function(player, npcID, maybeNewCFocused)
    local npcForResult = NACT_NPC.GetByID(npcID)
    Console.Log("Attempt vision lookup result : "..NanosTable.Dump(maybeNewCFocused).." for npc : "..NanosTable.Dump(npcForResult))
    if (npcForResult and maybeNewCFocused) then
        
        npcForResult.cFocused = maybeNewCFocused
    end
end)
