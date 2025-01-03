NACT_Patrol = NACT_Detection.Inherit("NACT_Patrol")

NACT_PROVISORY_WAITFOR_MIN = 0
NACT_PROVISORY_WAITFOR_MAX = 5000

function NACT_Patrol:Constructor(NpcInstance)
    self:Super().Constructor(self, NpcInstance)
    Console.Log("Instance a "..self.heat)

    self.patrolPath = "BigEnemyCamp"
    self.targetPatrolPointIndex = 1
    -- TODO: Make patrol point configurable
    self.patrolRoute = self.npc.territory.patrolRoutes["aroundCamp"]
    self.patrolPoints = self.patrolRoute.points
    self.maxPatrolPointIndex = #self.patrolRoute.points
    self.moveCompleteCallback = nil

    self:WalkToNextPoint()
end

function NACT_Patrol:WalkToNextPoint()
    self.npc:MoveToPoint(self.patrolPoints[self.targetPatrolPointIndex])
    self.moveCompleteCallback = self.npc.character:Subscribe("MoveComplete", function()
        Timer.SetTimeout(function()
            self:WalkToNextPoint()
        end, math.random(NACT_PROVISORY_WAITFOR_MIN, NACT_PROVISORY_WAITFOR_MAX))
        self.npc.character:Unsubscribe("MoveComplete", self.moveCompleteCallback)
    end)
    if (self.targetPatrolPointIndex == self.maxPatrolPointIndex) then
        -- TODO : Check if circling or not
        if (self.patrolRoute.walkMethod == "circle") then
            self.targetPatrolPointIndex = 1
        else
            Console.Log("Circling method not implemented")
        end
    else 
        self.targetPatrolPointIndex = self.targetPatrolPointIndex + 1
    end
    
end

-- function NACT_Patrol:Main()
--    Console.Log("wesh")
    -- Comes handy if you need to call the base behavior main too in your own main
    -- self:Super().Main(self)
-- end
