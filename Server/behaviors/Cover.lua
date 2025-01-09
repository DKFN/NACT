NACT_Cover = BaseClass.Inherit("NACT_Cover")

-- Make sure your NPC has enough time to perform actions while in cover !
NACT_PROVISORY_COVER_HOLD_MIN = 2000
NACT_PROVISORY_COVER_HOLD_MAX = 3000
NACT_PROVISORY_MIN_COVER_DISTANCE = 10

function NACT_Cover:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.nearestCoverPoint = nil
    self.movingToCover = false
    self.inCover = false
    self.moveCompleteCallback = nil
    self.doingAction = false
    self.shouldExitCover = false

    -- TODO: Does not really need a timer.
    -- TODO: It should work relying only on events instead of polling
    self.timerMain = Timer.SetInterval(function()
        self:Main()
    end, 250, self)
end

function NACT_Cover:Main()
    if (self.shouldExitCover) then
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
                    self.npc:SetBehavior(NACT_Combat)
                end
            end
        end
    end
end

--- Go to the nearest cover point
function NACT_Cover:MoveToNearestCoverPoint()
    self.nearestCoverPoint = self:FindNearestCoverPoint()
    if (self.nearestCoverPoint) then
        self.nearestCoverPoint.taken = true
        self.npc.character:SetGaitMode(GaitMode.Sprinting)
        self.movingToCover = true
        self.npc:MoveToPoint(self.nearestCoverPoint.pos)
        return true
    end
    return false
end

function NACT_Cover:OnMoveComplete()
    if (not self.nearestCoverPoint) then
        self.npc:SetBehavior(NACT_Combat)
        return
    end
    self.movingToCover = false
    self.inCover = true
    self.npc.character:SetGaitMode(GaitMode.Walking)
    local stanceOfCoverPoint = self.nearestCoverPoint.stance
    if (stanceOfCoverPoint) then
        self.npc.character:SetStanceMode(stanceOfCoverPoint)
    end
    Timer.SetTimeout(function()
        self.shouldExitCover = true
    end, math.random(NACT_PROVISORY_COVER_HOLD_MIN, NACT_PROVISORY_COVER_HOLD_MAX))
end

--- Gets to the nearest safe and not taken cover point
---@return nil | coverPoint
function NACT_Cover:FindNearestCoverPoint()
    -- Console.Log("All territory "..NanosTable.Dump(self.npc))
    local allTerritoryCoverPoints = self.npc.territory.coverPoints
    local currentNearestDistance = 99999999999
    local nearestCoverPoint = nil

    local startSearch = os.clock()
    local charLocation = self.npc.character:GetLocation()
    local focusedLocation = self.npc:GetFocusedLocation()
    for i, coverPoint in ipairs(allTerritoryCoverPoints) do
        -- TODO: Also check if cover point is taker
        if (coverPoint.secure and not coverPoint.taken) then
            --Console.Log("Scanning cover point : "..NanosTable.Dump(coverPoint))
            local distanceToCoverPoint = coverPoint.pos:Distance(charLocation)
            
            if (distanceToCoverPoint < currentNearestDistance) then
                if (focusedLocation) then
                    local distanceToFocused = coverPoint.pos:Distance(focusedLocation)
                    if (distanceToFocused > NACT_PROVISORY_MIN_COVER_DISTANCE) then
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

    local elapsedInSearch = math.floor((os.clock() - startSearch) * 1000)
    Console.Log("Time elapsed searching cover : "..elapsedInSearch.."ms")
    return nearestCoverPoint
end

function NACT_Cover:OnTakeDamage(_, damage, bone, type, from_direction, instigator)
    self.npc:SetFocused(instigator)
    self.npc:SetBehavior(NACT_Combat)
end

function NACT_Cover:LeaveCover()
    -- Console.Log("Exiting cover")
    self.nearestCoverPoint.taken = false
    self.npc.character:SetStanceMode(StanceMode.Standing)
end

function NACT_Cover:Destructor()
    Timer.ClearInterval(self.timerMain)
end
