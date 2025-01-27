NACT_NPC = BaseClass.Inherit("NACT_NPC", false)

NACT_PROVISORY_REGISTERED_EVENTS = {
    "TakeDamage",
    "MoveComplete"
}

-- PROVISORY_NACT_ANGLE_DETECTION = 90
PROVISORY_NACT_ANGLE_DETECTION = 110

--- /!\ INTERNAL /!\
--- NACT_NPC constructor. You should call NACT.RegisterNPC instead of this function directly
---@param cNpcToHandle Character Nanos world character to be controlled
---@param sTerritoryName string Territory to tie this NPC
---@param tNpcConfig table To be defined, quite unused for now
function NACT_NPC:Constructor(cNpcToHandle, sTerritoryName, tNpcConfig)
    self.character = cNpcToHandle
    self.territory = NACT.territories[sTerritoryName]
    self.afInrangeEntities = {}
    self.cFocused = nil -- When someone gets noticed by the NPC and it takes actions against it
    self.cFocusedTraceHit = false
    self.cFocusedLastPosition = Vector()
    self.tracingAuthority = nil

     -- IDLE | DETECT | COVER | PUSH | FLANK | ENGAGE | SUPRESS | HEAL etc... see Server/behaviors
    self.behaviorConfig = tNpcConfig.behaviors

    -- TODO: Add 
    self.currentBehaviorIndex = 1
    
    if (false) then
        self.debugTextBehavior = TextRender(
            Vector(0, 300, 0),
            Rotator(),
            "Initializing",
            Vector(0.5, 0.5, 0.5), -- Scale
            Color(1, 0, 0), -- Red Color
            FontType.OpenSans,
            TextRenderAlignCamera.FaceCamera
        )
    end
    -- self.debugTextBehavior:AttachTo(cNpcToHandle, AttachmentRule.KeepRelative, "head")

    if (#self.behaviorConfig > 0) then
        self:SetBehaviorIndex(1)
    end
    self:_registerTriggerBoxes()

    self.tracingLaunched = false
    self.launchedScanAround = false
    self.initialPosition = cNpcToHandle:GetLocation()


    self.takenDamageCallback = nil

    for i, sEventToRegister in ipairs(NACT_PROVISORY_REGISTERED_EVENTS) do
        Console.Log("Registered "..sEventToRegister)
        self:RegisterEvent(cNpcToHandle, sEventToRegister)
    end

    cNpcToHandle:Subscribe("Death", function()
        self:Log("Death called")
        self:Destroy()
    end)

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

--- Checks if the NPC has no more ammo left to fire
--- @return boolean If the npc should reload
function NACT_NPC:ShouldReload()
    local weapon = self:GetWeapon()
    if (weapon --[[and weapon:GetAmmoBag() > 0]]) then
        return weapon:GetAmmoClip() <= 0
    end
    return false
end

--- Makes the NPC reload its weapon
--- If the NPC has no weapon it will be a no op
function NACT_NPC:Reload()
    -- Console.Log("Called reload event")
    local weapon = self:GetWeapon()
    if (weapon --[[and weapon:GetAmmoBag() > 0]]) then
        weapon:Reload()
    end
end

--- Sets the currently focused charcter by the NPC
--- @param cEntity Character | nil Character or nil to be focused by the NPC  
function NACT_NPC:SetFocusedEntity(cEntity)
    if (cEntity ~= self.cFocused) then
        self:StopTracing()
        self.cFocused = cEntity
        if (cEntity) then
            self:StartTracing()
        end
        -- If no authority at the territory level and npc has focused. Start calculations on the territory
        if (not self.territory.authorityPlayer and cEntity and cEntity:GetPlayer()) then
            self.territory:SwitchNetworkAuthority()
        end
    end
    if (cEntity == nil) then
        self:StopTracing()
    end
end

--- Will make the NPC move to the location of the focused character or it's last known position
function NACT_NPC:MoveToFocused()
    local focusedEntity = self:GetFocused()
    if (focusedEntity ~= nil) then
        -- Console.Log("NPC : "..self:GetID().." Moving to location of cfocused "..NanosTable.Dump(focusedEntity))
        local focusedLocation = focusedEntity:GetLocation()
        
        self:MoveToPoint(focusedLocation)
    else
        if (self.cFocusedLastPosition) then
            self:MoveToPoint(self.cFocusedLastPosition)
        end
    end
end

--- Get the currently focused character if the NPC has one
--- @return Character|nil
function NACT_NPC:GetFocused()
    if not self or not self:IsValid() then
        return nil
    end
    if (self.cFocused and self.cFocused:IsValid()) then
        return self.cFocused
    else
        self.cFocused = nil
        return nil
    end
end

--- Sets the character the NPC will focus
--- @param newFocused Character the character to focus
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
    -- self:Log2("Destroying behavior is : "..NanosTable.Dump(self.behavior))
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
    if NACT_DEBUG_NPC_CHIT_CHAT then
        Console.Log("NACT_NPC #"..self:GetID().." : "..sMessage)
    end
end


function NACT_NPC:Log2(sMessage)
    if true then
        Console.Log("NACT_NPC #"..self:GetID().." : "..sMessage)
    end
end
function NACT_NPC:Error(sMessage)
    Console.Error("NACT NPC #"..self:GetID().. " : "..sMessage)
end

--- Gets the NACT_NPC instance tied to this character
--- Will return nil if this Character is not controlled by NACT
---@param character Character the nanos world character
---@return NACT_NPC | nil NACT_NPC that is controlled by NACT or nil
function NACT_NPC.GetFromCharacter(character)
    local iMaybeNactNpcId = character:GetValue("NACT_NPC_ID")
    if (iMaybeNactNpcId) then
        local nactNpc = NACT_NPC.GetByID(iMaybeNactNpcId)
        return nactNpc
    end
    return nil
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
Package.Require("./Navigation.lua")
