NACT_Engage = BaseClass.Inherit("NACT_Engage")

function NACT_Engage:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 25, self)
end

function NACT_Engage:Main()
    local bFocusedVisible = self.npc:IsFocusedVisible()
    if (bFocusedVisible) then
        self.npc:TurnToFocused()
    end
end
