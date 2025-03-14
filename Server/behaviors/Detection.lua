-- This behavior aims to try to detect the player and then go to the next state on the behavior tree
-- PROVISORY_NACT_HEAT_INCREMENT = 5
-- PROVISORY_NACT_HEAT_TURN_TO = 50 -- Heat necessary for the NPC to turn towards the player

local DEFAULT_INTERVAL_TIME = 500
local DEFAULT_HEAT_INCREMENT = 10
local DEFAULT_HEAT_TURN_TO = 70
-- local DEFAULT_HEAT_INCREMENT = 0.000000001
-- TODO: Add max distance to start spotting

NACT_Detection = BaseClass.Inherit("NACT_Detection")
function NACT_Detection:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.heatIncrement = NACT.ValueOrDefault(tBehaviorConfig.heatIncrement, DEFAULT_HEAT_INCREMENT)
    self.heatTurnTo = NACT.ValueOrDefault(tBehaviorConfig.heatTurnTo, DEFAULT_HEAT_TURN_TO)
    self.heat = self.heatIncrement
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.timerHandle, DEFAULT_INTERVAL_TIME), self)
    Timer.Bind(self.timerHandle, self.npc.character)
end

-- If the player 
function NACT_Detection:Main()
    -- Console.Log("Main self of parent : "..NanosTable.Dump(self:GetNpc()))
    local enemiesInZone = self.npc.territory:GetEnemiesInZone()
    -- Console.Log("Enemies in Zone deteciton : "..NanosTable.Dump(enemiesInZone))
    local bHasEnemyDetectable = #enemiesInZone > 0
    -- Console.Log(self.npc:GetID().." enemy detectable "..NanosTable.Dump(bHasEnemyDetectable))
    if (NACT_DEBUG_DETECTION) then
        Chat.BroadcastMessage("N.A.C.T. (#".. self.npc:GetID() ..") Detection heat".. self.heat)
    end

    -- Allows the behavior to be compatible with animal like behaviors
    if (not self.npc.autoVision and not self.npc.tracingLaunched) then
        -- Console.Log(self.npc:GetID().." Starting tracing")
        self.npc:StartTracing()
    end

    -- Console.Log("Detection focused : "..NanosTable.Dump(self.npc:GetFocused()))
    if (self.npc:GetFocused() == nil) then
        self.npc:LookForFocused()
    end

    -- Tracing functions should be in NACT_NPC or NACT_Behavior
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
    elseif (self.heat <= 0 and not bHasEnemyDetectable) then
            self.npc:GoPreviousBehavior()
    else
        if (self.heat >= self.heatTurnTo) then
            self.npc:TurnToFocused()
        end

        if (not self.npc:IsInVisionAngle(self.npc.cFocused)) then
            self.npc:LookForFocused()
        end

        if (self.npc:IsFocusedVisible() and bHasEnemyDetectable) then
            self:IncrementLevel()
            Events.Call("NACT_Detection:HEAT_CHANGED", self.npc:GetID(), self.heat)
        else
            self:DecrementLevel()
            self.npc:LookForFocused()
            Events.Call("NACT_Detection:HEAT_CHANGED", self.npc:GetID(), self.heat)
        end
    end
end

--- Raises heat level depeing of increment and distance factosr
function NACT_Detection:IncrementLevel()
    local nValue = self.heatIncrement + (1 / (self.npc:GetDistanceToFocused() + 1) * 10000)
    self.heat = math.min(self.heat + nValue, 100)
end

--- Decrement heat level depending of distance factor and increment configured
function NACT_Detection:DecrementLevel()
    local nValue = self.heatIncrement + ((self.npc:GetDistanceToFocused() + 1) / 10000)
    self.heat = math.max(0, self.heat - nValue)
end

function NACT_Detection:OnTakeDamage(_, damage, bone, type, from_direction, instigator, causer)
    local causerCharacter = NACT.GetCharacterFromCauserEntity(causer)
    if (causerCharacter) then
        -- Console.Log("Causer is character")
        self.npc:TurnTo(causerCharacter:GetLocation())
        self.heat = self.heat + self.heatTurnTo
    end
end

function NACT_Detection:Destructor()
    -- Allows the behavior to be compatible with animal like behaviors
    if (not self.npc.autoVision) then
        self.npc:StopTracing()
    end 
    Timer.ClearInterval(self.timerHandle)
end

