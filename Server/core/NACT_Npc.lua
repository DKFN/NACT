NACT_NPC = BaseClass.Inherit("NACT_NPC", false)

PROVISORY_NACT_ANGLE_DETECTION = 90
function NACT_NPC:Constructor(cNpcToHandle, sTerritoryName)
    self.character = cNpcToHandle
    self.territory = tTerritoryOfNpc
    self.afInrangeEntities = {}
    self.cFocused = nil -- When someone gets noticed by the NPC and it takes actions against it
    self.cFocusedTraceHit = false
     -- IDLE | DETECT | COVER | PUSH | FLANK | ENGAGE | SUPRESS | HEAL etc... see Server/behaviors
    self.behaviorConfig = {NACT_Idle, NACT_Detection}
    self.currentBehaviorIndex = 1
    self.behavior = self.behaviorConfig[self.currentBehaviorIndex](self)
    self:_registerTriggerBoxes()

    self.tracingLaunched = false

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
        enemies = {},
        allyCount = 0,
        allies = {}
    }
    tTriggerData.trigger:AttachTo(self.character)
    tTriggerData.trigger:SetOverlapOnlyClasses({ "Character", "CharacterSimple" })

    local _self = self

    tTriggerData.trigger:Subscribe("BeginOverlap", function(self, entity)
        -- TODO add more checks (in the same team for example)
        if (self == tTriggerData.trigger and _self.character:GetID() ~= entity:GetID()) then
            if (_self.character:GetTeam() == entity:GetTeam()) then
                tTriggerData.allyCount = tTriggerData.allyCount + 1
                table.insert(tTriggerData.allies, entity)
            else 
                tTriggerData.enemyCount = tTriggerData.enemyCount + 1
                table.insert(tTriggerData.enemies, entity)
            end
            _self:Debug_PrintTriggerStates()
        end
    end)


    tTriggerData.trigger:Subscribe("EndOverlap", function(self, entity)
        if (self == tTriggerData.trigger and _self.character:GetID() ~= entity:GetID()) then
            if (_self.character:GetTeam() == entity:GetTeam()) then
                table.remove(tTriggerData.allies, entity)
                tTriggerData.allyCount = tTriggerData.allyCount + 1
            else
                tTriggerData.enemyCount = tTriggerData.enemyCount - 1
                table_remove_by_value(tTriggerData.enemies, entity)
            end
        end
        _self:Debug_PrintTriggerStates()
    end)
    return tTriggerData
end

function NACT_NPC:Debug_PrintTriggerStates()
    Console.Log("N.A.C.T. Npc ".. self:GetID() .. " Trigger states : ".. NanosTable.Dump(self.triggers))
end

---
--- Tracing and Vision
---
function NACT_NPC:StopTracing()
    if (self.tracingLaunched) then
        Console.Log("Calling stop event for traces")
        Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", Player.GetByIndex(1), self:GetID()) --, self.npc.character, self.npc.cFocused)
        self.tracingLaunched = false
    end
end

function NACT_NPC:StartTracing()
    if (self.cFocused ~= nil) then
        -- TODO Find best player to send the trace, nearest player in range
        local delegatedPlayer = Player.GetByIndex(1) -- self.npc.cFocused:GetPlayer()
        -- Console.Log("Calling remote event")
        
        
        if (not self.tracingLaunched) then
            Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", delegatedPlayer, self.character, self.cFocused, self:GetID(), {
                "head", "lowerarm_l", "lowerarm_r", "foot_l", "foot_r"
            })
            self.tracingLaunched = true
        end
    end
end

function NACT_NPC:IsInVisionAngle(cEntity)
    if (cEntity == nil) then
        Console.Error("N.A.C.T. Called IsInVisionAngle with Nil entity")
        return false
    end

    local tAnglePlayerNpc = (self.character:GetLocation() - cEntity:GetLocation()):Rotation()
    local angleVersion =  math.abs(self.character:GetRotation().Yaw - tAnglePlayerNpc.Yaw)
    return angleVersion > PROVISORY_NACT_ANGLE_DETECTION
end

function NACT_NPC:IsFocusedVisible()
    return self.cFocusedTraceHit and self:IsInVisionAngle(self.cFocused)
end

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", function(player, npcID, entityResult)
    local npcSubscribedToTraces = NACT_NPC.GetByID(npcID)
    if (npcSubscribedToTraces) then
        npcSubscribedToTraces.cFocusedTraceHit = entityResult
    end
end)

-- Extend native library of Lua or atleast pu in table utils file
function table_findIndex_by_value(tCollection, entity)
    for i,e in ipairs(tCollection) do
        if (entity == e) then
            return i
        end
    end
end

function table_remove_by_value(tCollection, entity)
    table.remove(tCollection, table_findIndex_by_value(tCollection, entity))
end
