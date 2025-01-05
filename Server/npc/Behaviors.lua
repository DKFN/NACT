---
--- Behaviors
---

function NACT_NPC:GoNextBehavior()
    if (not self.currentBehaviorIndex) then
        self:Log("Cannot switch behavior, no index defined")
        return
    end
    local nextBehavior = self.currentBehaviorIndex + 1
    self:SetBehaviorIndex(nextBehavior)
end

function NACT_NPC:GoPreviousBehavior()
    if (not self.currentBehaviorIndex) then
        self:Log("Cannot switch behavior, no index defined")
        return
    end
    local previousBehavior = self.currentBehaviorIndex - 1
    self:SetBehaviorIndex(previousBehavior)
end

function NACT_NPC:SetBehaviorIndex(iBehaviorIndex)
    if (NACT_DEBUG_BEHAVIORS) then
        Console.Log("Behavior configs : "..NanosTable.Dump(self.behaviorConfig))
        Console.Log("Switching to Behavior index ".. iBehaviorIndex)
    end
    
    local cBehaviorToSpawn = self.behaviorConfig[iBehaviorIndex]

    if (cBehaviorToSpawn == nil) then
        Console.Error("N.A.C.T. Behavior change was not possible, trying index ".. iBehaviorIndex)
        return
    end
    self:SetBehavior(cBehaviorToSpawn)
    self.currentBehaviorIndex = iBehaviorIndex
end

function NACT_NPC:SetBehavior(cBehaviorClass)
    if (self.behavior and self.behavior:IsValid()) then
        self.behavior:Destroy()
    end
    local maybeBehaviorIndex = table_findIndex_by_value(self.behaviorConfig, cBehaviorClass)
    self.behavior = cBehaviorClass(self)
    self.currentBehaviorIndex = maybeBehaviorIndex
end
