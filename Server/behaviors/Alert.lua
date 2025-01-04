NACT_Alert = NACT_Detection.Inherit("NACT_Alert")

function NACT_Alert:Constructor(NpcInstance)
    self.npc = NpcInstance

    Timer.SetTimeout(function()
        self:Main()
    end)
end

function NACT_Alert:Main()
    Chat.BroadcastMessage("NPC : "..self.npc:GetID().." alerting zone !!!")
    local territoryNpcs = self.npc.territory.npcs
    for i, allyNpc in ipairs(territoryNpcs) do
        allyNpc:SetBehavior(NACT_Combat)
    end
end