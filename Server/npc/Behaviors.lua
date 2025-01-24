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
    if (self:IsValid() and not self:IsBeingDestroyed()) then
        if (NACT_DEBUG_BEHAVIORS) then
            Console.Log("Behavior configs : "..NanosTable.Dump(self.behaviorConfig))
            Console.Log("Switching to Behavior index ".. iBehaviorIndex)
        end

        if (self.behavior and self.behavior:IsValid()) then
            self.behavior:Destroy()
        end

        local cBehaviorToSpawn = self.behaviorConfig[iBehaviorIndex]

        if (cBehaviorToSpawn == nil) then
            Console.Error("N.A.C.T. Behavior set was not possible, trying index ".. iBehaviorIndex)
            return
        end
        -- self:SetBehavior(cBehaviorToSpawn)
        self.behavior = cBehaviorToSpawn.class(self, NACT.ValueOrDefault(cBehaviorToSpawn.config, {}))
        self.currentBehaviorIndex = iBehaviorIndex
    end
end

function NACT_NPC:SetBehavior(cBehaviorClass)
    local maybeBehaviorIndex = nil
    for i, v in ipairs(self.behaviorConfig) do
        if (v.class == cBehaviorClass) then
            maybeBehaviorIndex = i
            break;
        end
    end
    self:Log(" Going to "..cBehaviorClass:GetClassName())
    if (maybeBehaviorIndex) then
        self:SetBehaviorIndex(maybeBehaviorIndex)
    else
        Console.Warn("Behavior index was not found !")
    end
    
end

function NACT_NPC:SetBehaviorConfig(cBehaviorClass, tBehaviorConfigTable)

end
