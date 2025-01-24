NACT = BaseClass.Inherit("_NACT")

NACT.territories = {}
NACT.handledNpcs = {}

function NACT:Constructor()
    
end

-- This is all the public functions exposed by the package

-- This functions handles registering a new NPC into the system. It will transform a Character in a NACT_NPC
-- Parameters:
--   cNpcTohandle : Npc to be delegated to N.A.C.T.
--   sTerritoryName    : The Territory this NPC will use to find it's cover and patrol points
function NACT.RegisterNpc(cNpcToHandle, sTerritoryName, tNpcConfig)

    if (cNpcToHandle == nil) then
        Console.Error("N.A.C.T. Invalid character provided to NACT_RegisterNpc")
        return
    end

    if (sTerritoryName == nil) then
        Console.Error("N.A.C.T. You must provide a zone for this NPC")
        return
    end

    local tTerritoryOfNpc = NACT.territories[sTerritoryName];

    if (tTerritoryOfNpc == nil) then
        Console.Error("N.A.C.T. Zone was not found for this NPC")
        return
    end


    -- TODO: This would definitly be better with Timmy classlib :D
    -- Type is NACT_NPC
    local NpcRegistred = NACT_NPC(cNpcToHandle, sTerritoryName, tNpcConfig)
    local iNpcRegID = NpcRegistred:GetID()
    NACT.handledNpcs[iNpcRegID] = NpcRegistred

    Console.Log("N.A.C.T. npc " .. iNpcRegID .. " registered")
    cNpcToHandle:SetValue("NACT_NPC_ID", iNpcRegID)

    tTerritoryOfNpc:AddNPC(NpcRegistred)

    return NpcRegistred

end



function NACT.RegisterTerritory(sTerritoryName, tZoneConfigTable)
    NACT.territories[sTerritoryName] = NACT_Territory(tZoneConfigTable);
end

function NACT.GetCharacterFromCauserEntity(causer)
    if (causer:IsA(Character)) then
        return causer
    end
    if (causer:IsA(Weapon) or causer:IsA(Melee)) then
        return causer:GetHandler()
    end
end

function NACT.ValueOrDefault(maybeValue, default)
    if (maybeValue ~= nil) then
        return maybeValue
    else
        return default
    end
end


Package.Require("./core/Triggers.lua")
