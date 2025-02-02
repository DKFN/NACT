NACT_Melee = BaseClass.Inherit("NACT_Melee")

-- TODO: It's more of an "animal" melee than human melee.
-- TODO: Once your ass is targeted, it will not be loosed
local NACT_PROVISORY_MIN_DISTANCE = 1000
function NACT_Melee:Constructor(NpcInstance)
    self.npc = NpcInstance

    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 100)

end

function NACT_Melee:Main()
    local cFocused = self.npc:GetFocused()
    if (cFocused) then
        self.npc.character:SetGaitMode(GaitMode.Sprinting)
        self.npc:MoveToFocused()
        if (#self.npc:GetEnemiesInTrigger("melee") > 0) then
            local weapon = self.npc:GetWeapon()
            -- Console.Log("wpn"..NanosTable.Dump(weapon))
            if (weapon) then
                weapon:PullUse(0)
            end
        end
    else
        local allEnemiesNearNpc = self.npc.territory:GetEnemiesInZone()
        local closestEnemy = nil
        if (#allEnemiesNearNpc > 0) then
            local nearestDistance = 99999999
            for i, enemy in ipairs(allEnemiesNearNpc) do
                local distanceToEnemy = self.npc.character:GetLocation():Distance(enemy:GetLocation())
                if (distanceToEnemy < nearestDistance) then
                    closestEnemy = enemy
                end
            end
            self.npc:SetFocusedEntity(closestEnemy)
        else
            self.npc:SetBehavior(NACT_Idle)
        end
    end
end


function NACT_Melee:Destructor()
    Timer.ClearInterval(self.timerHandle)
end
