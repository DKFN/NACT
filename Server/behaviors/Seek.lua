NACT_Seek = BaseClass.Inherit("NACT_Seek")

NACT_PROVISORY_HOLD_AT_POINT = 3000
NACt_PROVISORY_SEEK_RADIUS = 5000


-- TODO: Finish seek behavior
function NACT_Seek:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.moveCompleteCallback = nil
    self.movingToPoint = true
    self.timeLastPointAcquired = 0

    Timer.SetTimeout(function()
        self:Main()
    end, 1)
end


function NACT_Seek:Main()
    -- Finish tomorrow and plug it in NACT_Combat
    if (not self.targetPoint or os.clock() - self.timeLastPointAcquired > NACT_PROVISORY_HOLD_AT_POINT) then
        self.npc:RandomPointToFocusedQuery(NACt_PROVISORY_SEEK_RADIUS)
    end
end

function NACT_Seek:OnRandomPointResult(vTargetPoint)
    self.npc:MoveTo(vTargetPoint)
    self.timeLastPointAcquired = os.clock()

    self.moveCompleteCallback = Events.Subscribe("MoveComplete", function(player, character)

    end)
end