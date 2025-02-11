Package.Require("./NpcVision.lua")
Package.Require("./CoverViability.lua")
Package.Require("./EditorGhetto.lua")
Package.Require("./Navigation.lua")


-- TODO: Move to gamemode
local tKills = {}

Character.Subscribe("Death", function(self, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator, causer)
    if not instigator or not instigator:IsValid() then return end
    tKills[instigator] = (tKills[instigator] or 0) + 1

    local sMsg = ""
    for pPlayer, iKills in pairs(tKills) do
        sMsg = sMsg .. pPlayer:GetAccountName() .. ": " .. iKills .. "kills\n"
    end
    Chat.AddMessage(sMsg)
end)

local function possessOutline(char)
    char:SetOutlineEnabled(true, 0)
end
Player.Subscribe("Possess", function(self, character)
    possessOutline(character)
end)
for _, v in ipairs(Character.GetAll()) do
    if v:GetPlayer() then
        possessOutline(v)
    end
end