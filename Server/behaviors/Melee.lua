NACT_Melee = BaseClass.Inherit("NACT_Melee")

local NACT_PROVISORY_MIN_DISTANCE = 1000
function NACT_Melee:Constructor(NpcInstance)
    self.npc = NpcInstance

    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500)

end


function NACT_Melee:Destructor()
    Timer.ClearInterval(self.timerHandle)
end
