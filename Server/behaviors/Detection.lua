-- This behavior aims to try to detect the player and then go to the next state on the behavior tree


NACT_Detection = BaseClass.Inherit("NACT_Detection", true)
function NACT_Detection:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.heat = 1
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500, self)
end

function NACT_Detection:Main()
    Console.Log("Detection main, heat".. self.heat)
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
    elseif (self.heat <= 0) then
        self.npc:GoPreviousBehavior()
    else
        -- TODO: Check if player is in range and visible
    end
end

