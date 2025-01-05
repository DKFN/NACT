NACT_Combat = BaseClass.Inherit("NACT_Combat", false)

function NACT_Combat:Constructor(NpcInstance)
    self.npc = NpcInstance

    -- TODO: Combat should take all the NACT behavior that you want to give the NPC for combat

    -- Should not need a timer
    Timer.SetTimeout(function()
        self:Main()
    end)
    
end

function NACT_Combat:Main()
    if (self.npc:ShouldReload()) then
        Console.Log("Combat: go to cover")
        self.npc:SetBehavior(NACT_Cover)
    else
        if (#self.npc.territory:GetEnemiesInZone() == 0) then
             Console.Log("Setting back to idle")
             self.npc:SetBehavior(NACT_Idle)
        else
            Console.Log("Combat: Engage")
            self.npc:SetBehavior(NACT_Engage)
        end
    end
end