NACT_NPC = BaseClass.Inherit("NACT_NPC", false)

PROVISORY_NACT_ANGLE_DETECTION = 90
function NACT_NPC:Constructor(cNpcToHandle, sTerritoryName)
    self.character = cNpcToHandle
    self.territory = NACT_territories[sTerritoryName]
    self.afInrangeEntities = {}
    self.cFocused = nil -- When someone gets noticed by the NPC and it takes actions against it
    self.cFocusedTraceHit = false
     -- IDLE | DETECT | COVER | PUSH | FLANK | ENGAGE | SUPRESS | HEAL etc... see Server/behaviors
    -- self.behaviorConfig = {NACT_Idle, NACT_Detection, NACT_Engage}
    self.behaviorConfig = {NACT_Idle, NACT_Detection, NACT_Cover}
    self.currentBehaviorIndex = 1
    self.behavior = self.behaviorConfig[self.currentBehaviorIndex](self)
    self:_registerTriggerBoxes()

    self.tracingLaunched = false

    -- DEBUG
    if (NACT_DEBUG_BEHAVIORS) then
        Timer.SetInterval(function()
            Chat.BroadcastMessage("Behavior index ".. self.currentBehaviorIndex)
        end, 2000, self)
    end
end

---
--- Enemy functions
---

function NACT_NPC:SetFocusedEntity(cEntity)
    self.cFocused = cEntity
end



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

Package.Require("./Behaviors.lua")
Package.Require("./Tracing.lua")
Package.Require("./Triggers.lua")
