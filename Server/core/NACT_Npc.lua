NACT_NPC = BaseClass.Inherit("NACT_NPC", false)


function NACT_NPC:Constructor(cNpcToHandle, sTerritoryName)
    self.character = cNpcToHandle
    self.territory = tTerritoryOfNpc
    self.afInrangeEntities = {}
    self.cFocused = nil -- When someone gets noticed by the NPC and it takes actions against it
     -- IDLE | DETECT | COVER | PUSH | FLANK | ENGAGE | SUPRESS | HEAL etc... see Server/behaviors
    self.behaviorConfig = {NACT_Idle, NACT_Detection}
    self.currentBehaviorIndex = 1
    self.behavior = self.behaviorConfig[self.currentBehaviorIndex](self)
    self:_registerTriggerBoxes()

    -- DEBUG
    Timer.SetInterval(function()
        Chat.BroadcastMessage("Behavior index ".. self.currentBehaviorIndex)
    end, 2000, self)
end

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
    Console.Log("Switching to Behavior index ".. iBehaviorIndex)
    local cBehaviorToSpawn = self.behaviorConfig[iBehaviorIndex]

    if (cBehaviorToSpawn == nil) then
        Console.Error("N.A.C.T. Behavior change was not possible, trying index ".. iBehaviorIndex)
        return
    end
    self.behavior:Destroy()
    self.behavior = cBehaviorToSpawn(self)
    self.currentBehaviorIndex = iBehaviorIndex
end

---
--- Enemy functions
---

function NACT_NPC:SetFocusedEntity(cEntity)
    self.cFocused = cEntity
end


---
--- Triggers
---

function NACT_NPC:_registerTriggerBoxes()
    self.triggers = {
        detection = self:createTriggerBox(TriggerType.Sphere, 5000, Color.RED),
        midProximity = self:createTriggerBox(TriggerType.Sphere, 2000, TriggerType.Sphere, Color.ORANGE),
        closeProximity = self:createTriggerBox(TriggerType.Sphere, 1000, Color.BLUE),
        melee = self:createTriggerBox(TriggerType.Box, 70, Color.YELLOW)
    }

end

function NACT_NPC:createTriggerBox(eTriggerType, nRadius, eDebugColor)
    local tTriggerData = {
        trigger = Trigger(Vector(self.character:GetLocation()), Rotator(), Vector(nRadius), eTriggerType, NACT_DEBUG_TRIGGERS, eDebugColor),
        enemyCount = 0,
        allyCount = 0
    }
    tTriggerData.trigger:AttachTo(self.character)
    tTriggerData.trigger:SetOverlapOnlyClasses({ "Character", "CharacterSimple" })

    local _self = self

    tTriggerData.trigger:Subscribe("BeginOverlap", function(self, entity)
        -- TODO add more checks (in the same team for example)
        if (self == tTriggerData.trigger and _self.character:GetID() ~= entity:GetID()) then
            if (_self.character:GetTeam() == entity:GetTeam()) then
                tTriggerData.allyCount = tTriggerData.allyCount + 1
            else 
                tTriggerData.enemyCount = tTriggerData.enemyCount + 1
                -- TODO: This causes a bug when entering or exiting any triggers changes the focus wich sucks
                -- TODO: We must keep an array of entities focused it would be much much better
                if (_self.cFocused == nil) then
                    --table.insert(entity)
                    _self:SetFocusedEntity(entity)
                end
            end
        end
    end)


    tTriggerData.trigger:Subscribe("EndOverlap", function(self, entity)
        if (self == tTriggerData.trigger and _self.character:GetID() ~= entity:GetID()) then
            if (_self.character:GetTeam() == entity:GetTeam()) then
                tTriggerData.allyCount = tTriggerData.allyCount + 1
            else
                tTriggerData.enemyCount = tTriggerData.enemyCount - 1
                -- TODO: This causes a bug when entering or exiting any triggers changes the focus wich sucks
                -- TODO: We must keep an array of entities focused it would be much much better
                if (_self.cFocused ~= nil) then
                    --table.remove(entity)
                    _self:SetFocusedEntity(nil)
                end
            end
        end
    end)
    return tTriggerData
end
