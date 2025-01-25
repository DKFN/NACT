NACT_Seek = BaseClass.Inherit("NACT_Seek")

local DEFAULT_INTERVAL_TIME = 500
local DEFAULT_MAX_TIME_SEEKING = 5000
local DEFAULT_SEEK_RADIUS = 5000
local DEFAULT_MAX_TIME_HOLD = 3000

function NACT_Seek:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.moveCompleteCallback = nil
    self.movingToPoint = true
    self.timeLastPointAcquired = 0
    self.seekAttemps = 0
    self.maxTimeSeeking = NACT.ValueOrDefault(tBehaviorConfig.maxTimeSeeking, DEFAULT_MAX_TIME_SEEKING)
    self.seekRadius = NACT.ValueOrDefault(tBehaviorConfig.seekRadius, DEFAULT_SEEK_RADIUS)
    self.maxTimeHold = NACT.ValueOrDefault(tBehaviorConfig.maxTimeHold, DEFAULT_MAX_TIME_HOLD)

    -- TODO: Make Utility function to create them
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.intervalTime, DEFAULT_INTERVAL_TIME), self)
    Timer.Bind(self.timerHandle, self.npc.character)
end


function NACT_Seek:Main()
    -- Console.Log("Inside thing with timer handle : "..NanosTable.Dump(self.timerHandle))
    self.npc:LookForFocused()
    -- Finish tomorrow and plug it in NACT_Combat
    if (self.npc:GetFocused() or #self.npc.territory:GetEnemiesInZone("detection") == 0) then
        self.npc:SetBehavior(NACT_Alert)
    end

    -- Console.Log("Moving to focused ? "..NanosTable.Dump(self.movingToPoint))
    if (self.seekAttemps == 0) then
        self.movingToPoint = true
        self.seekAttemps = self.seekAttemps + 1
        self.npc:MoveToFocused()
    end

    if (self.npc.cFocusedLastPosition:IsZero()) then
        self.movingToPoint = true
        local allAlliesNpc = self.npc.territory:GetAlliesInZone("detection")
        if (#allAlliesNpc > 0) then
            local randomIndexOfAlly = math.random(1, #allAlliesNpc)
            self.npc:Log("Going to ally for help "..NanosTable.Dump(randomIndexOfAlly))
            local maybeFoundAlly = allAlliesNpc[randomIndexOfAlly]
            if (maybeFoundAlly and maybeFoundAlly.character) then
                self.npc:RandomPointToQuery(maybeFoundAlly.character:GetLocation())
            end
        end
    end

    if (not self.movingToPoint) then
        self.movingToPoint = true
        self.npc:RandomPointToFocusedQuery(self.seekRadius)
    end
end

function NACT_Seek:OnMoveComplete()
    self.movingToPoint = false
end

function NACT_Seek:OnRandomPointResult(vTargetPoint)
    -- TODO: This creates way too much instance creation and destruction when you noclip somewhere not reachable
    -- TODO: Should not happend in real life, but not ideal nonetheless
    if (vTargetPoint:IsZero()) then
        Console.Log("Zero result, returning to combat for decision")
        self.npc:SetBehavior(NACT_Combat)
        return
    end
    -- Console.Log("Random point result : "..NanosTable.Dump(vTargetPoint))
    self.npc:MoveToPoint(vTargetPoint)
    self.timeLastPointAcquired = os.clock()
end

-- TODO: This should be default in NACT_Behavior base
function NACT_Seek:OnTakeDamage(_, damage, bone, type, from_direction, instigator, causer)
    -- TODO: Check if Ally
    local causerCharacter = NACT.GetCharacterFromCauserEntity(causer)
    if (causerCharacter) then
        self.npc:SetFocused(causerCharacter)
        self.npc:SetBehavior(NACT_Combat)
    end
end

function NACT_Seek:Destructor()
    Console.Log("Destroying seek with "..NanosTable.Dump(self.timerHandle))
    Timer.ClearInterval(self.timerHandle)
end
