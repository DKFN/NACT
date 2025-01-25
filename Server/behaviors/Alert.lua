NACT_Alert = NACT_Detection.Inherit("NACT_Alert")

function NACT_Alert:Constructor(NpcInstance)
    self.npc = NpcInstance

    Timer.SetTimeout(function()
        self:Main()
    end)
end

function NACT_Alert:Main()
    Chat.BroadcastMessage("NPC : "..self.npc:GetID().." alerting zone !!!")
    local territoryNpcs = self.npc.territory:GetAlliesInZone()
    for i, allyNpc in ipairs(territoryNpcs) do

        -- TODO: 
        local maybeNactNpcId = allyNpc:GetValue("NACT_NPC_ID")

        -- Console.Log("Ally npc #"..maybeNactNpcId.." : "..NanosTable.Dump(allyNpc))
        if maybeNactNpcId then
            local nactNpc = NACT_NPC.GetByID(maybeNactNpcId)

            -- TODO: The alerting mechanism should be smarter and only switch
            -- TODO: If the current NPC is not in Combat towards someone already
            -- TODO: So make a list of behavior that if it is the current behavior of the NPC they should not switch back
            -- TODO: To combat
            -- if (not nactNpc:GetFocused()) then
                nactNpc:SetBehavior(NACT_Combat)
                nactNpc:SetFocused(self.npc:GetFocused())
            -- end
        end
    end
end