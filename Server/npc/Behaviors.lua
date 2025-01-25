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
        if (self.debugTextBehavior) then
            self.debugTextBehavior:SetText(cBehaviorToSpawn.class:GetClassName())
        end
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

    if (maybeBehaviorIndex) then
        self:SetBehaviorIndex(maybeBehaviorIndex)
    else
        Console.Warn("Behavior index was not found !")
    end
end

function NACT_NPC:AddBehavior(cBehaviorClass, tMaybeBehaviorConfig)
    self.behaviorConfig[#self.behaviorConfig+1] = {
        class = cBehaviorClass,
        config = NACT.ValueOrDefault(tMaybeBehaviorConfig, {})
    }
end

function NACT_NPC:SetBehaviorConfig(cBehaviorClass, tBehaviorConfigTable)
    local nBehaviorIndex = table_findIndex_by_value(self.behavior, cBehaviorClass)
    if (nBehaviorIndex) then
        self.behavior[nBehaviorIndex].config = tBehaviorConfigTable
    else
        Console.Error("Unable to find index of behavior "..cBehaviorClass:GetClassName())
    end
end

function NACT_NPC:SetBehaviorValue(cBehaviorClass, sBehaviorKey, aBehaviorConfigValue)
    local nBehaviorIndex = table_findIndex_by_value(self.behavior, cBehaviorClass)
    if (nBehaviorIndex) then
        self.behavior[nBehaviorIndex].config[sBehaviorKey] = aBehaviorConfigValue
    else
        Console.Error("Unable to find index of behavior "..cBehaviorClass:GetClassName())
    end
end
