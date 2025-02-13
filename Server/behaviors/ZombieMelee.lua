NACT_ZombieMelee = BaseClass.Inherit("NACT_ZombieMelee")

-- TODO: It's more of an "animal" melee than human melee.
-- TODO: Once your ass is targeted, it will not be loosed
-- TODO: It's the zombie behavior maybe only ?
function NACT_ZombieMelee:Constructor(NpcInstance)
    self.npc = NpcInstance

    self.tick = 1
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 100)

    self.alertTimerHandle = Timer.SetInterval(function()
        self:AlertAlliesInRange()
    end, 1000)

end

function NACT_ZombieMelee:Main()
    local cFocused = self.npc:GetFocused()
    self.tick = self.tick + 1

    if (not self.npc:IsValid() or not self.npc.character:IsValid()) then
        -- Console.Log(self.npc:GetID().."I am dead I should not be called !")
        return
    end
    if (cFocused and cFocused:GetHealth() > 0 and self.tick < 20) then
        -- Console.Log("Focus tick "..self.tick)
        self.npc.character:SetGaitMode(GaitMode.Sprinting)
        self.npc:MoveToFocused()
        if (#self.npc:GetEnemiesInZone("melee") > 0) then
            local weapon = self.npc:GetWeapon()
            -- Console.Log("wpn"..NanosTable.Dump(weapon))
            if (weapon) then
                weapon:PullUse(0)
            end
        end
    else
        -- Console.Log("Search tick "..self.tick)
        self.tick = 1
        local allEnemiesNearNpc = self.npc.territory:GetEnemiesInZone()
        local closestEnemy = nil
        -- Console.Log("Enemies result : "..NanosTable.Dump(allEnemiesNearNpc))
        if (#allEnemiesNearNpc > 0) then
            local nearestDistance = 99999999
            for i, enemy in ipairs(allEnemiesNearNpc) do 
                local distanceToEnemy = self.npc.character:GetLocation():Distance(enemy:GetLocation())
                if (distanceToEnemy < nearestDistance) then
                    nearestDistance = distanceToEnemy
                    closestEnemy = enemy
                    -- Console.Log("Closest enemy result !")
                end
            end
            self.npc:SetFocusedEntity(closestEnemy)
        else
            self.npc:SetBehavior(NACT_Idle)
        end
    end
end

function NACT_ZombieMelee:AlertAlliesInRange()
    if (not self.npc:GetFocused()) then
        return
    end
    local alliesInRange = self.npc:GetAlliesInZone("closeProximity")
    -- Console.Log("Alerting in : "..NanosTable.Dump(alliesInRange))
    for k, v in ipairs(alliesInRange) do
        local nactNpcOfAlly = NACT_NPC.GetFromCharacter(v)
        -- Console.Log("NACT NPC OF ALly "..NanosTable.Dump(nactNpcOfAlly.behavior:GetClass()))
        if (nactNpcOfAlly and nactNpcOfAlly.behavior:GetClass() == NACT_Detection) then
            nactNpcOfAlly:SetFocusedEntity(self.npc:GetFocused())
            nactNpcOfAlly:SetBehavior(NACT_ZombieMelee)
        end
    end
end


function NACT_ZombieMelee:Destructor()
    Timer.ClearInterval(self.timerHandle)
    Timer.ClearInterval(self.alertTimerHandle)
end
