NACT_Seek = BaseClass.Inherit("NACT_Seek")

NACT_PROVISORY_HOLD_AT_POINT = 3000
NACt_PROVISORY_SEEK_RADIUS = 5000


-- TODO: Finish seek behavior
function NACT_Seek:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.moveCompleteCallback = nil
    self.movingToPoint = true
    self.timeLastPointAcquired = 0
    self.seekAttemps = 0

    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500)
end


function NACT_Seek:Main()
    self.npc:LookForFocused()
    -- Finish tomorrow and plug it in NACT_Combat
    if (self.npc:GetFocused()) then
        self.npc:SetBehavior(NACT_Combat)
    end

    Console.Log("Moving to focused ? "..NanosTable.Dump(self.movingToPoint))
    if (self.seekAttemps == 0) then
        self.seekAttemps = self.seekAttemps + 1
        self.movingToPoint = true
        self.seekAttemps = self.seekAttemps + 1
        self.npc:MoveToFocused()
    end

    if (self.npc.cFocusedLastPosition:IsZero()) then
        self.movingToPoint = true
        local allAlliesNpc = self.npc.territory:GetAlliesInZone("detection")
        if (#allAlliesNpc > 0) then
            local randomIndexOfAlly = math.random(1, #allAlliesNpc)
            Console.Log("Going to ally for help")
            local maybeFoundAlly = allAlliesNpc[randomIndexOfAlly]
            if (maybeFoundAlly) then
                self.npc:RandomPointToQuery(maybeFoundAlly.character:GetLocation())    
            end
        end
    end

    if (not self.movingToPoint) then
        self.movingToPoint = true
        self.npc:RandomPointToFocusedQuery(NACt_PROVISORY_SEEK_RADIUS)
    end
end

function NACT_Seek:OnMoveComplete()
    self.movingToPoint = false
end

function NACT_Seek:OnRandomPointResult(vTargetPoint)
    if (vTargetPoint:IsZero()) then
        self.npc:SetBehavior(NACT_Combat)
        return
    end
    Console.Log("Random point result : "..NanosTable.Dump(vTargetPoint))
    self.npc:MoveToPoint(vTargetPoint)
    self.timeLastPointAcquired = os.clock()
end

function NACT_Seek:OnTakeDamage(_, damage, bone, type, from_direction, instigator)
    self.npc:SetFocused(instigator)
    self.npc:SetBehavior(NACT_Combat)
end

function NACT_Seek:Destroy()
    Timer.ClearInterval(self.timerHandle)
end
