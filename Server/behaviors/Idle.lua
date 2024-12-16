
NACT_Idle = BaseClass.Inherit("NACT_Idle", true)

function NACT_Idle:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.playersInRange = 0
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 1000, self)
end


function NACT_Idle:Main()
    Console.Log(NanosTable.Dump(self.npc.triggers))
    if (self.npc.triggers.detection.enemyCount > 0) then
        self.npc:GoNextBehavior()
    end
end


function NACT_Idle:Destroy()
    Timer.ClearInterval(self.timerHandle)
end
