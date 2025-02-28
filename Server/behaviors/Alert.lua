NACT_Alert = NACT_Detection.Inherit("NACT_Alert")

function NACT_Alert:Constructor(NpcInstance)
    self.npc = NpcInstance

    self.timerHandle = Timer.SetTimeout(function()
        self:Main()
    end)

    if (not self.npc.territory.lastAlertRaisedAt) then
        self.npc.territory.lastAlertRaisedAt = 99999
    end

end

function NACT_Alert:Main()
    local territoryNpcs = self.npc.territory:GetAlliesInZone()
    local timeElapsedSinceLastAlert = NACT.GetTime() - self.npc.territory.lastAlertRaisedAt

    -- Console.Log("Time elapsed since last alert "..timeElapsedSinceLastAlert)

     if (timeElapsedSinceLastAlert > 5) then
        self.npc.territory.lastAlertRaisedAt = NACT.GetTime()
        for i, allyNpc in ipairs(territoryNpcs) do
            local nactNpc = NACT_NPC.GetFromCharacter(allyNpc)
            if (nactNpc) then
                if (nactNpc.behavior:GetClass() ~= NACT_Combat and nactNpc.behavior:GetClass() ~= NACT_Engage and nactNpc.behavior:GetClass() ~= NACT_Alert) then
                    -- Console.Log("Setting combat for : "..nactNpc.behavior:GetClassName())
                    nactNpc:SetBehavior(NACT_Combat)
                    nactNpc:SetFocused(self.npc:GetFocused())
                end
            end
        end
    end

    self.npc:SetBehavior(NACT_Combat)
end

function NACT_Alert:Destructor()
    Timer.ClearTimeout(self.timerHandle)
end
