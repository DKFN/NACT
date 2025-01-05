NACT_Engage = BaseClass.Inherit("NACT_Engage")
NACT_PROVISORY_INNACURACY = 1000

-- TODO: This would be much better if controlled by a "Combat" main behavior
-- TODO: The main "combat" behavior is just a behavior that will switch to anorther behavior
-- TODO: Depending on various factors
function NACT_Engage:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 25, self)

    self.npc:StartTracing()
    self.npc.character:SetWeaponAimMode(AimMode.ADS)
end

function NACT_Engage:Main()
    local weapon = self.npc:GetWeapon()

    if (self.npc:ShouldReload()) then
        weapon:ReleaseUse()
        self.npc:SetBehavior(NACT_Combat)
    end

    local bFocusedVisible = self.npc:IsFocusedVisible()
    if (bFocusedVisible) then
        self.npc:TurnToFocused(NACT_PROVISORY_INNACURACY)
        if (weapon) then
            weapon:PullUse(0)
        end
    else
        -- TODO: Might be the culprit for the memory leak?
        self.npc:MoveToFocused()
    end
end

function NACT_Engage:Destructor()
    Timer.ClearInterval(self.timerHandle)
    self.npc:StopTracing()
end
