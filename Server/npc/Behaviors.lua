---
--- Behaviors
---

function NACT_NPC:GoNextBehavior()
    local nextBehavior = self.currentBehaviorIndex + 1
    self:SetBehavior(nextBehavior)
end

function NACT_NPC:GoPreviousBehavior()
    local previousBehavior = self.currentBehaviorIndex - 1
    self:SetBehavior(previousBehavior)
end

function NACT_NPC:SetBehavior(iBehaviorIndex)
    if (NACT_DEBUG_BEHAVIORS) then
        Console.Log("Switching to Behavior index ".. iBehaviorIndex)
    end
    
    local cBehaviorToSpawn = self.behaviorConfig[iBehaviorIndex]

    if (cBehaviorToSpawn == nil) then
        Console.Error("N.A.C.T. Behavior change was not possible, trying index ".. iBehaviorIndex)
        return
    end
    self.behavior:Destroy()
    self.behavior = cBehaviorToSpawn(self)
    self.currentBehaviorIndex = iBehaviorIndex
end
