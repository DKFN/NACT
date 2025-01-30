NACT_Combat = BaseClass.Inherit("NACT_Combat", false)

local DEFAULT_RNG_MAX = 3
local DEFAULT_RNG_COVER_VALUE = 2

function NACT_Combat:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.timeoutHandle = nil

    -- TODO: Combat should take all the NACT behavior that you want to give the NPC for combat

    self.rngMax = NACT.ValueOrDefault(tBehaviorConfig.rngMax, DEFAULT_RNG_MAX)
    self.rngCoverValue = NACT.ValueOrDefault(tBehaviorConfig.rngCoverValue, DEFAULT_RNG_COVER_VALUE)


    self.coverBehavior = NACT.ValueOrDefault(tBehaviorConfig.coverBehavior, NACT_Cover)
    self.idleBehavior = NACT.ValueOrDefault(tBehaviorConfig.idleBehavior, NACT_Idle)
    self.seekBehavior = NACT.ValueOrDefault(tBehaviorConfig.seekBehavior, NACT_Seek)
    self.attackBehavior = NACT.ValueOrDefault(tBehaviorConfig.attackBehavior, NACT_Engage)

    -- Should not need a timer
    self.timeoutHandle = Timer.SetTimeout(function()
        self:Main()
    end)
    
end

function NACT_Combat:Main()
    local rng = math.random(0, self.rngMax)
    Console.Log(self.npc:GetID().."Combat RNG "..rng.."From id : "..self:GetID())
    self.npc:Log("Combat")

    if (self.npc:ShouldReload() or rng == self.rngCoverValue) then
        self.npc:SetBehavior(self.coverBehavior)
        return
    else
        if (#self.npc.territory:GetEnemiesInZone() == 0) then
             Console.Log("Setting back to idle")
             self.npc:SetBehavior(self.idleBehavior)
             return
        end
        if (self.npc:IsFocusedVisible() == false) then
            self.npc:SetBehavior(self.seekBehavior)
            return
        else
            self.npc:TurnToFocused()
            self.npc:SetBehavior(self.attackBehavior)
            return
        end
    end
end

function NACT_Combat:Destructor()
    Console.Log("Destructing combat")
    Timer.ClearTimeout(self.timeoutHandle)
end