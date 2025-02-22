
NACT_Idle = BaseClass.Inherit("NACT_Idle")

function NACT_Idle:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.intervalTime, 1000), self)
    Timer.Bind(self.timerHandle, self.npc.character)
end


function NACT_Idle:Main()
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
