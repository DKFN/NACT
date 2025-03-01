
NACT_Idle = BaseClass.Inherit("NACT_Idle")

function NACT_Idle:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.intervalTime, 1000), self)
    self.moveToCalled = false
    Timer.Bind(self.timerHandle, self.npc.character)
end


function NACT_Idle:Main()
    if (#self.npc.territory:GetEnemiesInZone() > 0) then
        self.npc:GoNextBehavior()
    else
        if (not self.preventReturnToInitialPos and not self.moveToCalled) then
            self.moveToCalled = true
            self.npc:MoveTo(self.npc.initialPosition)
            self.npc.character:SetRotation(self.npc.initialRotation)
        end
    end
end

function NACT_Idle:OnMoveComplete(character, succeeded)
    self.moveToCalled = succeeded
end


function NACT_Idle:Destructor()
    Timer.ClearInterval(self.timerHandle)
end
