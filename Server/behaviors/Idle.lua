
NACT_Idle = BaseClass.Inherit("NACT_Idle", false)

function NACT_Idle:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.playersInRange = 0
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 1000, self)
    Timer.Bind(self.timerHandle, self.npc)
end


function NACT_Idle:Main()
    -- Console.Log(NanosTable.Dump(self.npc.triggers))
    local enemiesInTerritory = self.npc.territory:GetEnemiesInZone()
    -- Console.Log("enemiesInTerritory"..NanosTable.Dump(enemiesInTerritory))
    if (#self.npc.territory:GetEnemiesInZone() > 0) then
        self.npc:GoNextBehavior()
    else
        if (not self.preventReturnToInitialPos) then
            self.npc:MoveToPoint(self.npc.initialPosition)
        end
    end
end


function NACT_Idle:Destructor()
    Timer.ClearInterval(self.timerHandle)
end
