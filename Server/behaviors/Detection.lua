-- This behavior aims to try to detect the player and then go to the next state on the behavior tree
PROVISORY_NACT_HEAT_INCREMENT = 1
PROVISORY_NACT_HEAT_TURN_TO = 50 -- Heat necessary for the NPC to turn towards the player

NACT_Detection = BaseClass.Inherit("NACT_Detection")
function NACT_Detection:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.heat = PROVISORY_NACT_HEAT_INCREMENT
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500, self)
end

-- TODO: cFocused should change to closest player in vision range
-- If the player 
function NACT_Detection:Main()
    Chat.BroadcastMessage("N.A.C.T. (#".. self.npc:GetID() ..") Detection heat".. self.heat)

    -- Tracing functions should be in NACT_NPC or NACT_Behavior
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
    elseif (self.heat <= 0 and self.npc.triggers.detection.enemyCount <= 0) then
        self.npc:GoPreviousBehavior()
    else
        if (self.heat >= PROVISORY_NACT_HEAT_TURN_TO) then
            self.npc:TurnToFocused()
        end

        if (self.npc:IsInVisionAngle(self.npc.cFocused)) then
            self.npc:StartTracing()
        else
            self.npc:StopTracing()
        end
        
        if (self.npc:IsFocusedVisible()) then
            self:IncrementLevel()
        else
            self:DecrementLevel()
        end
    end
end

-- TODO: Vary heat increment and decrement by distance (and possibly angle too)
function NACT_Detection:IncrementLevel()
    self.heat = math.min(self.heat + PROVISORY_NACT_HEAT_INCREMENT, 100)
end

function NACT_Detection:DecrementLevel()
    self.heat = math.max(0, self.heat - PROVISORY_NACT_HEAT_INCREMENT)
end

function NACT_Detection:Destroy()
    Timer.ClearInterval(self.timerHandle)
end

