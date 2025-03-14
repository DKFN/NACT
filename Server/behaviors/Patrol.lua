NACT_Patrol = NACT_Detection.Inherit("NACT_Patrol")

-- NACT_PROVISORY_WAITFOR_MIN = 0
-- NACT_PROVISORY_WAITFOR_MAX = 5000

local DEFAULT_WAITFOR_MIN = 0
local DEFAULT_WAITFOR_MAX = 5000

function NACT_Patrol:Constructor(NpcInstance, tBehaviorConfig)
    self:Super().Constructor(self, NpcInstance, tBehaviorConfig)

    if (not tBehaviorConfig.patrolPath) then
        Console.Error("No patrol point was defined !")
    end
    self.patrolPath = tBehaviorConfig.patrolPath
    self.targetPatrolPointIndex = 1
    -- TODO: Make patrol point configurable
    -- Console.Log("for "..self.patrolPath.. "Dump routes : "..NanosTable.Dump(self.npc.territory.patrolRoutes))
    self.patrolRoute = self.npc.territory.patrolRoutes[self.patrolPath]
    self.patrolPoints = self.patrolRoute.points
    self.maxPatrolPointIndex = #self.patrolRoute.points
    self.moveCompleteCallback = nil

    self.preventReturnToInitialPos = true

    self.waitForMin = NACT.ValueOrDefault(tBehaviorConfig.waitForMin, DEFAULT_WAITFOR_MIN)
    self.waitForMax = NACT.ValueOrDefault(tBehaviorConfig.waitForMax, DEFAULT_WAITFOR_MAX)

    self:WalkToNextPoint()
end

function NACT_Patrol:WalkToNextPoint()
    self.npc:MoveToPoint(self.patrolPoints[self.targetPatrolPointIndex].pos)
    if (self.targetPatrolPointIndex == self.maxPatrolPointIndex) then
        if (self.patrolRoute.walkMethod == "circle") then
            self.targetPatrolPointIndex = 1
        else
            Console.Warn ("Circling method not implemented")
        end
    else 
        self.targetPatrolPointIndex = self.targetPatrolPointIndex + 1
    end
end

function NACT_Patrol:OnMoveComplete()
    Timer.SetTimeout(function()
        self:WalkToNextPoint()
    end, math.random(self.waitForMin, self.waitForMax))
end

function NACT_Patrol:Destructor()
    self:Super().Destructor(self)
end
