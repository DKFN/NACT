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
    if (self.cFocused ~= nil) then
        -- TODO Find best player to send the trace, nearest player in range
        local delegatedPlayer = Player.GetByIndex(1) -- self.npc.cFocused:GetPlayer()
        -- Console.Log("Calling remote event")
        
        
        if (not self.tracingLaunched) then
            Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", delegatedPlayer, self.character, self.cFocused, self:GetID(), {
                "head", "lowerarm_l", "lowerarm_r", "foot_l", "foot_r"
            })
            self.tracingLaunched = true
        end
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
    return self.cFocusedTraceHit and self:IsInVisionAngle(self.cFocused)
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

    self.character:LookAt(self.cFocused:GetLocation() + vInaccurayVector)
    self.character:RotateTo(Rotator(0, (self.cFocused:GetLocation() - self.character:GetLocation()):Rotation().Yaw, 0), 0.5)
end

function NACT_NPC:GetDistanceToFocused()
    return self.character:GetLocation():Distance(self.cFocused:GetLocation())
end

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", function(player, npcID, entityResult)
    local npcSubscribedToTraces = NACT_NPC.GetByID(npcID)
    if (npcSubscribedToTraces) then
        npcSubscribedToTraces.cFocusedTraceHit = entityResult
    end
end)
