-- This behavior aims to try to detect the player and then go to the next state on the behavior tree
PROVISORY_NACT_HEAT_INCREMENT = 3
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
    -- Console.Log("Main self of parent : "..NanosTable.Dump(self:GetNpc()))
    local bHasEnemyDetectable = self.npc.triggers.detection.enemyCount > 0
    if (NACT_DEBUG_DETECTION) then
        Chat.BroadcastMessage("N.A.C.T. (#".. self.npc:GetID() ..") Detection heat".. self.heat)
    end

    -- Tracing functions should be in NACT_NPC or NACT_Behavior
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
    elseif (self.heat <= 0 and not bHasEnemyDetectable) then
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
        
        if (self.npc:IsFocusedVisible() and bHasEnemyDetectable) then
            self:IncrementLevel()
        else
            self:DecrementLevel()
        end
    end
end
-- TODO: Vary heat increment and decrement by distance (and possibly angle too)

--- Raises heat level depeing of increment and distance factosr
function NACT_Detection:IncrementLevel()
    local nValue = PROVISORY_NACT_HEAT_INCREMENT + (1 / (self.npc:GetDistanceToFocused() + 1) * 2000)
    self.heat = math.min(self.heat + nValue, 100)
end

--- Decrement heat level depending of distance factor and increment configured
function NACT_Detection:DecrementLevel()
    local nValue = PROVISORY_NACT_HEAT_INCREMENT + ((self.npc:GetDistanceToFocused() + 1) / 2000)
    self.heat = math.max(0, self.heat - nValue)
end

function NACT_Detection:Destructor()
    self.npc:StopTracing()
    Timer.ClearInterval(self.timerHandle)
end

