-- This behavior aims to try to detect the player and then go to the next state on the behavior tree
PROVISORY_NACT_HEAT_INCREMENT = 1
PROVISORY_NACT_ANGLE_DETECTION = 90
PROVISORY_NACT_HEAT_TURN_TO = 50 -- Heat necessary for the NPC to turn towards the player

NACT_Detection = BaseClass.Inherit("NACT_Detection")
function NACT_Detection:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.heat = PROVISORY_NACT_HEAT_INCREMENT
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500, self)
end

-- If the player 
function NACT_Detection:Main()
    Chat.BroadcastMessage("N.A.C.T. (#".. self.npc:GetID() ..") Detection heat".. self.heat)

    -- Tracing functions should be in NACT_NPC or NACT_Behavior
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
    elseif (self.heat <= 0 and self.npc.triggers.detection.enemyCount <= 0) then
        self.npc:GoPreviousBehavior()
        self:DecrementLevel()
    else
        if (self.npc.triggers.closeProximity.enemyCount > 0 and self.heat >= PROVISORY_NACT_HEAT_TURN_TO) then
            -- Ambigu, c'est un player ou un npc etc, closestChar
            local closestPlayerInRange = self.npc.triggers.closeProximity.enemies[1]
            self.npc.character:LookAt(closestPlayerInRange:GetLocation())
            self.npc.character:RotateTo(Rotator(0, (closestPlayerInRange:GetLocation() - self.npc.character:GetLocation()):Rotation().Yaw, 0), 0.5)
        end
        
        --Console.Log("Angle played npc : "..NanosTable.Dump(tAnglePlayerNpc) .. " yaw version " .. angleVersion)
        if (self.npc:IsInVisionAngle(self.npc.cFocused)) then 
            self.npc:StartTracing()
        else
            self.npc:StopTracing()
            self:DecrementLevel()
        end
    end
end

-- Tracing functions should be in NACT_NPC or NACT_Behavior
-- It is not really good in base class, tried it. Better in NPC instance

function NACT_Detection:OnVisionChanged(bNewState)
    if (bNewState) then
        self:IncrementLevel()
    else
        self:DecrementLevel()
    end
end


function NACT_Detection:IncrementLevel()
    self.heat = math.min(self.heat + PROVISORY_NACT_HEAT_INCREMENT, 100)
end

function NACT_Detection:DecrementLevel()
    self.heat = math.max(0, self.heat - PROVISORY_NACT_HEAT_INCREMENT)
end

function NACT_Detection:Destroy()
    self:StopTracing()
    Timer.ClearInterval(self.timerHandle)
end

