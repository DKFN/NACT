NACT_Alert = NACT_Detection.Inherit("NACT_Alert")

function NACT_Alert:Constructor(NpcInstance)
    self.npc = NpcInstance

    self.timerHandle = Timer.SetTimeout(function()
        self:Main()
    end)
end

function NACT_Alert:Main()
    local territoryNpcs = self.npc.territory:GetAlliesInZone()
    local timeElapsedSinceLastAlert = os.clock() - self.npc.territory.lastAlertRaisedAt

     if (timeElapsedSinceLastAlert > 10) then
        Console.Log("Time elapsed since last alert "..timeElapsedSinceLastAlert)
        Console.Log("NPC : "..self.npc:GetID().." alerting zone !!!")
        self.npc.territory.lastAlertRaisedAt = os.clock()
        for i, allyNpc in ipairs(territoryNpcs) do
            local maybeNactNpcId = allyNpc:GetValue("NACT_NPC_ID")

            -- Console.Log("Ally npc #"..maybeNactNpcId.." : "..NanosTable.Dump(allyNpc))
            if maybeNactNpcId then
                local nactNpc = NACT_NPC.GetByID(maybeNactNpcId)

                -- TODO: The alerting mechanism should be smarter and only switch
                -- TODO: If the current NPC is not in Combat towards someone already
                -- TODO: So make a list of behavior that if it is the current behavior of the NPC they should not switch back
                -- TODO: To combat
                -- if (not nactNpc:GetFocused()) then
                if (nactNpc.behavior:GetClass() ~= NACT_Combat and nactNpc.behavior:GetClass() ~= NACT_Engage and nactNpc.behavior:GetClass() ~= NACT_Alert) then
                    Console.Log("Setting combat for : "..nactNpc.behavior:GetClassName())
                    nactNpc:SetBehavior(NACT_Combat)
                    nactNpc:SetFocused(self.npc:GetFocused())
                end
                -- end
            end
        end
    end

    self.npc:SetBehavior(NACT_Combat)
end

function NACT_Alert:Destructor()
    Timer.ClearTimeout(self.timerHandle)
end
