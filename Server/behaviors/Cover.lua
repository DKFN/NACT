NACT_Cover = BaseClass.Inherit("NACT_Cover")

local DEFAULT_TIMER_TIME = 500
-- Make sure your NPC has enough time to perform actions while in cover !
local DEFAULT_COVER_HOLD_MIN = 2000
local DEFAULT_COVER_HOLD_MAX = 3000
local DEFAULT_MIN_COVER_DISTANCE = 200

--- Behavior that makes the NPC go to cover. Will find the closest secure and non taken cover point to reload or chill
---@param NpcInstance NACT_NPC @npc that is tied to this behacior
---@param tBehaviorConfig {coverHoldMin: number, coverHoldMax: number, minCoverDistance: number} @Optional behavior config
function NACT_Cover:Constructor(NpcInstance, tBehaviorConfig)
    self.npc = NpcInstance
    self.nearestCoverPoint = nil
    self.movingToCover = false
    self.inCover = false
    self.moveCompleteCallback = nil
    self.doingAction = false
    self.shouldExitCover = false
    self.attempts = 0

    self.coverHoldMin = NACT.ValueOrDefault(tBehaviorConfig.coverHoldMin, DEFAULT_COVER_HOLD_MIN)
    self.coverHoldMax = NACT.ValueOrDefault(tBehaviorConfig.coverHoldMax, DEFAULT_COVER_HOLD_MAX)
    self.minCoverDistance = NACT.ValueOrDefault(tBehaviorConfig.minCoverDistance, DEFAULT_MIN_COVER_DISTANCE)

    -- TODO: Does not really need a timer.
    -- TODO: It should work relying only on events instead of polling
    self.timerMain = Timer.SetInterval(function(self)
        self:Main()
    end, NACT.ValueOrDefault(tBehaviorConfig.timerTime, DEFAULT_TIMER_TIME), self)
    Timer.Bind(self.timerMain, self.npc.character)

    self.timerHold = nil
end

function NACT_Cover:Main()
    if (self.shouldExitCover or #self.npc.territory:GetEnemiesInZone() == 0) then
        self:LeaveCover()
        self.npc:SetBehavior(NACT_Combat)
        return
    end

    if (self.inCover and not self.doingAction) then
        if (self.npc:ShouldReload()) then
            self.doingAction = true
            self.npc:Reload()
            self.doingAction = false
        end
    else
        if (not self.doingAction) then
            if (not (self.inCover or self.movingToCover) or (self.nearestCoverPoint and not self.nearestCoverPoint.secure)) then
                local success = self:MoveToNearestCoverPoint()
                if (not success) then
                    Console.Warn("Nearest cover point search was not successful. Switching back to combat")
                    self.npc:SetBehavior(NACT_Combat)
                end
            end
        end
    end
end

--- Move to the nearest cover point if one is available
---@return boolean If the operation was successful
function NACT_Cover:MoveToNearestCoverPoint()
    self.nearestCoverPoint = self:FindNearestCoverPoint()
    if (self.nearestCoverPoint) then
        self.nearestCoverPoint.taken = true
        self.npc.character:SetGaitMode(GaitMode.Sprinting)
        self.movingToCover = true
        self.npc:MoveToPoint(self.nearestCoverPoint.pos)
        return true
    end
    Console.Warn("No cover point safe and available was found")
    return false
end

--- Callback for the "MoveComplete" event
function NACT_Cover:OnMoveComplete(_, succeeded)
    if (not self.nearestCoverPoint or not self.movingToCover) then
        return
    end

    if (not succeeded) then
        self:LeaveCover()
        self:MoveToNearestCoverPoint()
        return;
    end


    self.movingToCover = false
    self.inCover = true
    local stanceOfCoverPoint = self.nearestCoverPoint.stance
    if (stanceOfCoverPoint) then
        self.npc.character:SetStanceMode(stanceOfCoverPoint)
    end
    self.timerHold = Timer.SetTimeout(function()
        self.shouldExitCover = true
        self.nearestCoverPoint.taken = false
    end, math.random(self.coverHoldMin, self.coverHoldMax))
end

--- Attempt to find the nearest safe and not taken cover point
---@return nil | coverPoint Nearest cover point or nil if not found
function NACT_Cover:FindNearestCoverPoint()
    -- Console.Log("All territory "..NanosTable.Dump(self.npc))
    local allTerritoryCoverPoints = self.npc.territory.coverPoints
    local currentNearestDistance = 99999999999
    local nearestCoverPoint = nil

    local charLocation = self.npc.character:GetLocation()
    local focusedLocation = self.npc:GetFocusedLocation() or self.npc.cFocusedLastPosition
    for i, coverPoint in ipairs(allTerritoryCoverPoints) do
        -- TODO: Also check if cover point is taker
        if (coverPoint.secure and not coverPoint.taken) then
            --Console.Log("Scanning cover point : "..NanosTable.Dump(coverPoint))
            local distanceToCoverPoint = coverPoint.pos:Distance(charLocation)
            
            if (distanceToCoverPoint < currentNearestDistance) then
                if (focusedLocation) then
                    local distanceToFocused = coverPoint.pos:Distance(focusedLocation)
                    if (distanceToFocused > self.minCoverDistance) then
                        currentNearestDistance = distanceToCoverPoint
                        nearestCoverPoint = coverPoint
                    end
                else
                    currentNearestDistance = distanceToCoverPoint
                    nearestCoverPoint = coverPoint
                end
            end
        end
    end
    return nearestCoverPoint
end

function NACT_Cover:OnTakeDamage(_, damage, bone, type, from_direction, instigator, causer)
    local causerCharacter = NACT.GetCharacterFromCauserEntity(causer)
    if (causerCharacter) then
        self:LeaveCover()
        self.npc:SetFocused(causerCharacter)
        self.npc:SetBehavior(NACT_Combat)
    end
end

function NACT_Cover:LeaveCover()
    if (self.nearestCoverPoint) then
        self.nearestCoverPoint.taken = false
        self.npc.character:SetStanceMode(StanceMode.Standing)
    end
end

function NACT_Cover:Destructor()
    self.npc.character:SetGaitMode(GaitMode.Walking)
    Timer.ClearInterval(self.timerMain)
    if (self.nearestCoverPoint) then
        self:LeaveCover()
    end
    if (self.timerHold) then
        Timer.ClearTimeout(self.timerHold)
    end
end
