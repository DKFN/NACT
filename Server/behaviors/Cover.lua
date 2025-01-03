NACT_Cover = BaseClass.Inherit("NACT_Cover")

-- Make sure your NPC has enough time to perform actions while in cover !
NACT_PROVISORY_COVER_HOLD_MIN = 2000
NACT_PROVISORY_COVER_HOLD_MAX = 3000

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
    elseif (not (self.inCover or self.movingToCover)) then
        self:MoveToNearestCoverPoint()
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
        local _self = self
        self.moveCompleteCallback = self.npc.character:Subscribe("MoveComplete", function()
            self.movingToCover = false
            self.inCover = true
            self.npc.character:SetGaitMode(GaitMode.Walking)
            local stanceOfCoverPoint =_self.nearestCoverPoint.stance
            if (stanceOfCoverPoint) then
                self.npc.character:SetStanceMode(stanceOfCoverPoint)
            end
            Timer.SetTimeout(function()
                self.shouldExitCover = true
            end, math.random(NACT_PROVISORY_COVER_HOLD_MIN, NACT_PROVISORY_COVER_HOLD_MAX))
            self.npc.character:Unsubscribe("MoveComplete", self.moveCompleteCallback)
        end)
    end
end

--- Gets to the nearest safe and not taken cover point
---@return nil | coverPoint
function NACT_Cover:FindNearestCoverPoint()
    -- Console.Log("All territory "..NanosTable.Dump(self.npc))
    local allTerritoryCoverPoints = self.npc.territory.coverPoints
    local currentNearestDistance = 99999999999
    local nearestCoverPoint = nil

    for i, coverPoint in ipairs(allTerritoryCoverPoints) do
        -- TODO: Also check if cover point is taker
        if (coverPoint.secure and not coverPoint.taken) then
            Console.Log("Scanning cover point : "..NanosTable.Dump(coverPoint))
            local distanceToCoverPoint = coverPoint.pos:Distance(self.npc.character:GetLocation())
            if (distanceToCoverPoint < currentNearestDistance) then
                currentNearestDistance = distanceToCoverPoint
                nearestCoverPoint = coverPoint
            end
        end
    end

    return nearestCoverPoint
end

function NACT_Cover:LeaveCover()
    Console.Log("Exiting cover")
    self.nearestCoverPoint.taken = false
    self.npc.character:SetStanceMode(StanceMode.Standing)
end

function NACT_Cover:Destructor()
    Timer.ClearInterval(self.timerMain)
end
