NACT_Engage = BaseClass.Inherit("NACT_Engage")
-- NACT_PROVISORY_INNACURACY = 200
NACT_PROVISORY_MAX_TIME_ENGAGED_SEC = 10
local MAX_TIME_ENGAGED_SEC_DEFAULT = 8
-- local DEFAULT_INNACURACY = 0
local DEFAULT_INNACURACY = 100
-- local DEFAULT_INNACURACY = 25000
local DEFAULT_MAIN_BEHAVIOR = NACT_Combat
local DEFAULT_INTERVAL_TIME = 25

-- TODO: This would be much better if controlled by a "Combat" main behavior
-- TODO: The main "combat" behavior is just a behavior that will switch to anorther behavior
-- TODO: Depending on various factors
function NACT_Engage:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.timerHandle = Timer.SetInterval(function(self)
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.intervalTime, DEFAULT_INTERVAL_TIME), self)
    Timer.Bind(self.timerHandle, self.npc.character)

    -- self.npc:StartTracing()
    self.npc.character:SetWeaponAimMode(AimMode.ADS)

    self.startedAt = NACT.GetTime()

    self.maxTimeEngaged = NACT.ValueOrDefault(tBehaviorConfig.maxTimeEngaged, MAX_TIME_ENGAGED_SEC_DEFAULT)
    self.innacuracy = NACT.ValueOrDefault(tBehaviorConfig.innacuracy, DEFAULT_INNACURACY)
    self.mainBehavior = NACT.ValueOrDefault(tBehaviorConfig.mainBehavior, DEFAULT_MAIN_BEHAVIOR)
end

function NACT_Engage:Main()
    local weapon = self.npc:GetWeapon()

    if (self.npc:ShouldReload()) then
        self.npc:SetBehavior(self.mainBehavior)
        return
    end

    self.npc:MoveToFocused()

    local bFocusedVisible = self.npc:IsFocusedVisible()
    if (bFocusedVisible) then
        local focusedChar =  self.npc:GetFocused()
        if (focusedChar:GetHealth() > 0) then
            self.npc:TurnToFocused(self.innacuracy)
            if (weapon) then
                weapon:PullUse(0)
            end
        end
    end

    if (not bFocusedVisible) then
        self.npc:SetBehavior(self.mainBehavior)
    end

    if (self:TimeElapsed() > self.maxTimeEngaged) then
        self.npc:SetBehavior(self.mainBehavior)
    end
end


function NACT_Engage:OnTakeDamage(_, damage, bone, type, from_direction, instigator, causer)
    local decision = math.random(0, 10)
    local causerCharacter = NACT.GetCharacterFromCauserEntity(causer)
    if (causerCharacter) then
        self.npc:SetFocused(causerCharacter)
    end
    if (decision > 5) then
        self.npc.character:SetStanceMode(StanceMode.Crouching)
        Timer.SetTimeout(function()
            self.npc.character:SetStanceMode(StanceMode.Standing)
        end, 500)
    end
    if (decision == 2) then
        self.npc:SetBehavior(self.mainBehavior)
    end
end

function NACT_Engage:TimeElapsed()
    return NACT.GetTime() - self.startedAt
end

function NACT_Engage:Destructor()
    Timer.ClearInterval(self.timerHandle)
    local weapon = self.npc:GetWeapon()
    if (weapon) then
        weapon:ReleaseUse()
    end
end
