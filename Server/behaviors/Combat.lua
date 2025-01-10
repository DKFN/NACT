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
    local rng = math.random(0, 10)
    self.npc:Log("Combat")
    if (self.npc:ShouldReload() or rng == 10) then
        Console.Log("Combat: go to cover")
        self.npc:SetBehavior(NACT_Cover)
    else
        if (#self.npc.territory:GetEnemiesInZone() == 0) then
             Console.Log("Setting back to idle")
             self.npc:SetBehavior(NACT_Idle)
             return
        end
        if (self.npc:GetFocused() == nil) then
            self.npc:SetBehavior(NACT_Seek)
            return
        end
        self.npc:SetBehavior(NACT_Engage)
    end
end