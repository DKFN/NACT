---
--- Behaviors
---

--- Goes to the next behavior if there is one
function NACT_NPC:GoNextBehavior()
    if (not self.currentBehaviorIndex) then
        self:Log("Cannot switch behavior, no index defined")
        return
    end
    local nextBehavior = self.currentBehaviorIndex + 1
    self:SetBehaviorIndex(nextBehavior)
end

--- Goes to the next previous if there is one
function NACT_NPC:GoPreviousBehavior()
    if (not self.currentBehaviorIndex) then
        self:Log("Cannot switch behavior, no index defined")
        return
    end
    local previousBehavior = self.currentBehaviorIndex - 1
    self:SetBehaviorIndex(previousBehavior)
end

--- Jumps to the behavior at the specified index
---@param iBehaviorIndex number Index of the behavior to switch to
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

--- Sets the behavior by the class
---@param cBehaviorClass Class Class of the behavior to set (eg: NACT_Detection, NACT_Combat)
function NACT_NPC:SetBehavior(cBehaviorClass)
    local maybeBehaviorIndex = nil
    for i, v in ipairs(self.behaviorConfig) do
        if (v.class == cBehaviorClass) then
            maybeBehaviorIndex = i
            break;
        end
    end

    if (maybeBehaviorIndex) then
        if (self.behavior) then
            Console.Log(self:GetID().." Previous behavior :"..self.behavior:GetClassName().."Next behavior : "..cBehaviorClass:GetClassName())    
        end
        self:SetBehaviorIndex(maybeBehaviorIndex)
    else
        Console.Warn("Behavior index was not found !")
    end
end

--- Add a behavior
--- @param cBehaviorClass Class Class of the behavior to add in the list
---@param tMaybeBehaviorConfig BehaviorConfigTable (optional) The config of the behavior
function NACT_NPC:AddBehavior(cBehaviorClass, tMaybeBehaviorConfig)
    self.behaviorConfig[#self.behaviorConfig+1] = {
        class = cBehaviorClass,
        config = NACT.ValueOrDefault(tMaybeBehaviorConfig, {})
    }
end

--- Set behavior config. Currently, this will not change the config if the behavior is running, but only on the next
--- time it is spawned, this a limitation for now
---@param cBehaviorClass Class Class of the behavior to change the configuration
---@param tBehaviorConfigTable BehaviorConfigTable The behavior config to be set
function NACT_NPC:SetBehaviorConfig(cBehaviorClass, tBehaviorConfigTable)
    local nBehaviorIndex = table_findIndex_by_value(self.behavior, cBehaviorClass)
    if (nBehaviorIndex) then
        self.behavior[nBehaviorIndex].config = tBehaviorConfigTable
    else
        Console.Error("Unable to find index of behavior "..cBehaviorClass:GetClassName())
    end
end

--- Set a behavior config value instead of replacing the whole config.
--- This currently has the same limitations as the SetBehaviorConfig function
---@param cBehaviorClass Class Class of the behavior to change the configuration
---@param sBehaviorKey string the config key to change (example: minCoverDistance)
---@param aBehaviorConfigValue any the value to set (example: 350)
function NACT_NPC:SetBehaviorValue(cBehaviorClass, sBehaviorKey, aBehaviorConfigValue)
    local nBehaviorIndex = table_findIndex_by_value(self.behavior, cBehaviorClass)
    if (nBehaviorIndex) then
        self.behavior[nBehaviorIndex].config[sBehaviorKey] = aBehaviorConfigValue
    else
        Console.Error("Unable to find index of behavior "..cBehaviorClass:GetClassName())
    end
end
