NACT_Cover = BaseClass.Inherit("NACT_Cover")

function NACT_Cover:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.nearestCoverPoint = nil
    self.movingToCover = false
    self.inCover = false

    self.timerMain = Timer.SetInterval(function()
        self:Main()
    end, 250, self)
end

function NACT_Cover:Main()
    if (self.inCover) then
        local ammoValue = self.npc.character
    elseif (not (self.inCover or self.movingToCover)) then
        self:MoveToNearestCoverPoint()
    end
end

function NACT_Cover:MoveToNearestCoverPoint()
    self.nearestCoverPoint = self:FindNearestCoverPoint()
    if (self.nearestCoverPoint) then
        self.npc.character:SetGaitMode(GaitMode.Sprinting)
        self.movingToCover = true
        self.npc.character:MoveTo(self.nearestCoverPoint.pos)
        local _self = self
        self.npc.character:Subscribe("MoveComplete", function()
            _self.movingToCover = false
            _self.inCover = true
            _self.npc.character:SetGaitMode(GaitMode.Walking)
            local stanceOfCoverPoint =_self.nearestCoverPoint.stance
            if (stanceOfCoverPoint) then
                _self.npc.character:SetStanceMode(stanceOfCoverPoint)
            end
        end)
    end
end

function NACT_Cover:FindNearestCoverPoint()
    Console.Log("All territory "..NanosTable.Dump(self.npc))
    local allTerritoryCoverPoints = self.npc.territory.coverPoints
    local currentNearestDistance = 99999999999
    local nearestCoverPoint = nil

    for i, coverPoint in ipairs(allTerritoryCoverPoints) do
        -- TODO: Also check if cover point is taker
        -- if (coverPoint.coversFromAllFocused) then
        local distanceToCoverPoint = coverPoint.pos:Distance(self.npc.character:GetLocation())
            if (distanceToCoverPoint < currentNearestDistance) then
                currentNearestDistance = distanceToCoverPoint
                nearestCoverPoint = coverPoint
                Console.Log("Scanning cover point : "..NanosTable.Dump(coverPoint))
            end
            
        -- end
    end

    return nearestCoverPoint
end

