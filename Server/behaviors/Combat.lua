NACT_Combat = BaseClass.Inherit("NACT_Combat", false)

local DEFAULT_RNG_MAX = 30
local DEFAULT_RNG_COVER_VALUE = 10

function NACT_Combat:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance

    -- TODO: Combat should take all the NACT behavior that you want to give the NPC for combat

    self.rngMax = NACT.ValueOrDefault(tBehaviorConfig.rngMax, DEFAULT_RNG_MAX)
    self.rngCoverValue = NACT.ValueOrDefault(tBehaviorConfig.rngCoverValue, DEFAULT_RNG_COVER_VALUE)


    self.coverBehavior = NACT.ValueOrDefault(tBehaviorConfig.coverBehavior, NACT_Cover)
    self.idleBehavior = NACT.ValueOrDefault(tBehaviorConfig.idleBehavior, NACT_Idle)
    self.seekBehavior = NACT.ValueOrDefault(tBehaviorConfig.seekBehavior, NACT_Seek)
    self.attackBehavior = NACT.ValueOrDefault(tBehaviorConfig.attackBehavior, NACT_Engage)

    -- Should not need a timer
    Timer.SetTimeout(function()
        self:Main()
    end)
    
end

function NACT_Combat:Main()
    local rng = math.random(0, self.rngMax)
    self.npc:Log("Combat")

    if (self.npc:ShouldReload() or rng == self.rngCoverValue) then
        -- Console.Log("Combat: go to cover")
        self.npc:SetBehavior(self.coverBehavior)
    else
        if (#self.npc.territory:GetEnemiesInZone() == 0) then
             Console.Log("Setting back to idle")
             self.npc:SetBehavior(self.idleBehavior)
             return
        end
        if (self.npc:GetFocused() == nil) then
            self.npc:SetBehavior(self.seekBehavior)
            return
        end
        self.npc:SetBehavior(self.attackBehavior)
    end
end