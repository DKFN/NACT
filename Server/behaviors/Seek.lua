NACT_Seek = BaseClass.Inherit("NACT_Seek")

local DEFAULT_INTERVAL_TIME = 500
local DEFAULT_MAX_TIME_SEEKING = 30000
local DEFAULT_SEEK_RADIUS = 5000
local DEFAULT_MAX_TIME_HOLD = 3000
local DEFAULT_GAIT_SEEKING = GaitMode.Sprinting
local DEFAULT_GAIT_INITIAL = GaitMode.Walking
local DEFAULT_MAIN_BEHAVIOR = NACT_Combat
local DEFAULT_ALERT_BEHAVIOR = NACT_Alert -- TODO: Maybe by default the NPC should not have an alert behavior ?

function NACT_Seek:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.moveCompleteCallback = nil
    self.movingToPoint = true
    self.timeLastPointAcquired = 0
    self.seekAttemps = 0
    self.maxTimeSeeking = NACT.ValueOrDefault(tBehaviorConfig.maxTimeSeeking, DEFAULT_MAX_TIME_SEEKING)
    self.seekRadius = NACT.ValueOrDefault(tBehaviorConfig.seekRadius, DEFAULT_SEEK_RADIUS)
    self.maxTimeHold = NACT.ValueOrDefault(tBehaviorConfig.maxTimeHold, DEFAULT_MAX_TIME_HOLD)
    self.gaitSeeking = NACT.ValueOrDefault(tBehaviorConfig.gaitSeeking, DEFAULT_GAIT_SEEKING)
    self.gaitInitial = NACT.ValueOrDefault(tBehaviorConfig.gaitInitial, DEFAULT_GAIT_INITIAL)
    self.mainBehavior = NACT.ValueOrDefault(tBehaviorConfig.mainBehavior, DEFAULT_MAIN_BEHAVIOR)
    self.alertBehavior = NACT.ValueOrDefault(tBehaviorConfig.alertBehavior, DEFAULT_ALERT_BEHAVIOR)

    -- TODO: Make Utility function to create them
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.intervalTime, DEFAULT_INTERVAL_TIME), self)
    Timer.Bind(self.timerHandle, self.npc.character)
end


function NACT_Seek:Main()
    -- Console.Log("Inside thing with timer handle : "..NanosTable.Dump(self.timerHandle))
    self.npc:LookForFocused()

    if (#self.npc.territory:GetEnemiesInZone() == 0) then
        self.npc:SetBehavior(self.mainBehavior)
    end

    -- Finish tomorrow and plug it in NACT_Combat
    if (self.npc:IsFocusedVisible()) then
        if (self.alertBehavior) then
            self.npc:SetBehavior(self.alertBehavior)
        else
            self.npc:SetBehavior(self.mainBehavior)
        end
    end

    -- Console.Log("Moving to focused ? "..NanosTable.Dump(self.movingToPoint))
    if (self.seekAttemps == 0) then
        self.movingToPoint = true
        self.seekAttemps = self.seekAttemps + 1
        self.npc.character:SetGaitMode(self.gaitSeeking)
        self.npc:MoveToFocused()
    end

    if (not self.npc.cFocusedLastPosition) then
        self.movingToPoint = true
        local allAlliesNpc = self.npc.territory:GetAlliesInZone("detection")
        if (#allAlliesNpc > 0) then
            local randomIndexOfAlly = math.random(1, #allAlliesNpc)
            -- self.npc:Log("Going to ally for help "..NanosTable.Dump(randomIndexOfAlly))
            local maybeFoundAlly = allAlliesNpc[randomIndexOfAlly]
            if (maybeFoundAlly and maybeFoundAlly.character) then
                self.npc:RandomPointToQuery(maybeFoundAlly.character:GetLocation(), 200) -- TODO: Add config key for ally search ?
            end
        end
    end

    if (not self.movingToPoint) then
        self.movingToPoint = true
        self.npc.character:SetGaitMode(self.gaitSeeking)
        self.npc:RandomPointToFocusedQuery(self.seekRadius)
    end
end

function NACT_Seek:OnMoveComplete()
    self.npc.character:SetGaitMode(self.gaitInitial)
    self.movingToPoint = false
end

function NACT_Seek:OnRandomPointResult(vTargetPoint)
    -- Console.Log("Random pt result : "..NanosTable.Dump(vTargetPoint))
    if (vTargetPoint:IsZero()) then
        Console.Log("Zero result, returning to combat for decision")
        Timer.SetTimeout(function()
            self.npc:SetBehavior(self.mainBehavior)
        end, 2000)
        return
    end
    -- Console.Log("Random point result : "..NanosTable.Dump(vTargetPoint))
    self.npc:MoveToPoint(vTargetPoint)
    self.timeLastPointAcquired = NACT.GetTime()
end

-- TODO: This should be default in NACT_Behavior base
function NACT_Seek:OnTakeDamage(_, damage, bone, type, from_direction, instigator, causer)
    -- TODO: Check if Ally
    local causerCharacter = NACT.GetCharacterFromCauserEntity(causer)
    if (causerCharacter) then
        self.npc:SetFocused(causerCharacter)
        self.npc:SetBehavior(self.mainBehavior)
    end
end

function NACT_Seek:Destructor()
    -- Console.Log("Destroying seek with "..NanosTable.Dump(self.timerHandle))
    self.npc.character:SetGaitMode(self.gaitInitial)
    Timer.ClearInterval(self.timerHandle)
end
