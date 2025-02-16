NACT_Follow = BaseClass.Inherit("NACT_Follow")


function NACT_Follow:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.followingEntity = tBehaviorConfig.following

    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.intervalTime, 250), self)
    Timer.Bind(self.timerHandle, self.npc.character)
end


function NACT_Follow:Main()
    if (#self.npc:GetEnemiesInZone("detection") > 0) then
        self.npc:GoNextBehavior()
    else
        if (self.followingEntity and self.followingEntity:IsValid()) then
            self.npc.character:Follow(self.followingEntity)
        end
    end
end

function NACT_Follow:Destructor()
    Timer.ClearInterval(self.timerHandle)
end