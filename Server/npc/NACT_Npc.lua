NACT_NPC = BaseClass.Inherit("NACT_NPC", false)

PROVISORY_NACT_ANGLE_DETECTION = 90
function NACT_NPC:Constructor(cNpcToHandle, sTerritoryName, tNpcConfig)
    self.character = cNpcToHandle
    self.territory = NACT.territories[sTerritoryName]
    self.afInrangeEntities = {}
    self.cFocused = nil -- When someone gets noticed by the NPC and it takes actions against it
    self.cFocusedTraceHit = false
    self.cFocusedLastPosition = Vector()

     -- IDLE | DETECT | COVER | PUSH | FLANK | ENGAGE | SUPRESS | HEAL etc... see Server/behaviors
    -- self.behaviorConfig = {NACT_Idle, NACT_Detection, NACT_Engage}
    -- self.behaviorConfig = {NACT_Idle, NACT_Detection, NACT_Cover}
    self.behaviorConfig = tNpcConfig.behaviors
    self.currentBehaviorIndex = 1
    self.behavior = self.behaviorConfig[self.currentBehaviorIndex](self)
    self:_registerTriggerBoxes()

    self.tracingLaunched = false
    self.launchedScanAround = false
    self.initialPosition = cNpcToHandle:GetLocation()

    -- DEBUG
    if (NACT_DEBUG_BEHAVIORS) then
        Timer.SetInterval(function()
            if (self.currentBehaviorIndex) then
                Chat.BroadcastMessage("Behavior index ".. self.currentBehaviorIndex)
            end
        end, 2000, self)
    end
end

---
--- Enemy functions
---

--- Firearm NPC functions, in the future it should be done by extending the
--- NACT_NPC base class
function NACT_NPC:GetWeapon()
    -- TODO: Should check if this is a weapon or not
    return self.character:GetPicked()
end

function NACT_NPC:ShouldReload()
    local weapon = self:GetWeapon()
    if (weapon --[[and weapon:GetAmmoBag() > 0]]) then
        return weapon:GetAmmoClip() <= 0
    end
    return false
end

function NACT_NPC:Reload()
    -- Console.Log("Called reload event")
    local weapon = self:GetWeapon()
    if (weapon --[[and weapon:GetAmmoBag() > 0]]) then
        weapon:Reload()
    end
end

----
--- Sets the currently focused charcter by the NPC
--- @param cEntity Character to be focused by the NPC  
function NACT_NPC:SetFocusedEntity(cEntity)
    if (cEntity ~= self.cFocused) then
        self:StopTracing()
        self.cFocused = cEntity
        if (cEntity) then
            self:StartTracing()
        end
    end
end

function NACT_NPC:MoveToFocused()
    local focusedEntity = self:GetFocused()
    if (focusedEntity) then
        local focusedLocation = self.cFocused:GetLocation()
        -- Console.Log("NPC : "..self:GetID().." Moving to location of cfocused ()")
        self:MoveToPoint(focusedLocation)
    else
        if (self.cFocusedLastPosition) then
            self:MoveToPoint(self.cFocusedLastPosition)
        end
    end
end

function NACT_NPC:GetFocused()
    if (self.cFocused and self.cFocused:IsValid()) then
        return self.cFocused
    else
        self.cFocused = nil
    end
end

function NACT_NPC:SetFocused(newFocused)
    self:Log("Now focusing : "..NanosTable.Dump(newFocused))
    self:SetFocusedEntity(newFocused)
end

--- Move but also look towards point
---@param vPoint Vector point to go
function NACT_NPC:MoveToPoint(vPoint)
    self.character:MoveTo(vPoint, 1)
    self.character:LookAt(vPoint)
end

function NACT_NPC:Destructor()
    self.behavior:Destroy()
    self.territory:RemoveNPC(self)
    for k, t in pairs(self.triggers) do
        t.trigger:Destroy()
    end
    self.triggers = nil
    self.cFocused = nil
    self:Log(" reporting death, bye :(")
end

function NACT_NPC:Log(sMessage)
    Console.Log("NACT_NPC #"..self:GetID().." : "..sMessage)
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
   -- Console.Log("RM bv "..NanosTable.Dump(entity).."  col : "..NanosTable.Dump(entity))
    table.remove(tCollection, table_findIndex_by_value(tCollection, entity))
end

Package.Require("./Behaviors.lua")
Package.Require("./Tracing.lua")
Package.Require("./Triggers.lua")
Package.Require("./Events.lua")
