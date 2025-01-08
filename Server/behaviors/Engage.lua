NACT_Engage = BaseClass.Inherit("NACT_Engage")
-- NACT_PROVISORY_INNACURACY = 1000
NACT_PROVISORY_INNACURACY = 500
NACT_PROVISORY_MAX_TIME_ENGAGED_SEC = 30
-- TODO: This would be much better if controlled by a "Combat" main behavior
-- TODO: The main "combat" behavior is just a behavior that will switch to anorther behavior
-- TODO: Depending on various factors
function NACT_Engage:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 25, self)

    -- self.npc:StartTracing()
    self.npc.character:SetWeaponAimMode(AimMode.ADS)

    self.startedAt = os.clock()
end

function NACT_Engage:Main()
    local weapon = self.npc:GetWeapon()

    if (self.npc:ShouldReload()) then
        self.npc:SetBehavior(NACT_Combat)
    end

    if (self.npc:GetFocused() == nil) then
        self.npc:LookForFocused()
    end

    self.npc:MoveToFocused()

    local bFocusedVisible = self.npc:IsFocusedVisible()
    if (bFocusedVisible) then
        self.npc:TurnToFocused(NACT_PROVISORY_INNACURACY)
        if (weapon) then
            weapon:PullUse(0)
        end
    else
        
    end

    if (self:TimeElapsed() > NACT_PROVISORY_MAX_TIME_ENGAGED_SEC) then
        self.npc:SetBehavior(NACT_Combat)
    end
end

function NACT_Engage:TimeElapsed()
    return os.clock() - self.startedAt
end

function NACT_Engage:Destructor()
    Timer.ClearInterval(self.timerHandle)
    local weapon = self.npc:GetWeapon()
    if (weapon) then
        weapon:ReleaseUse()
    end
    -- self.npc:StopTracing()
end
