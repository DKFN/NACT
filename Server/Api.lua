-- This is all the public functions exposed by the package

-- This functions handles registering a new NPC into the system. It will transform a Character in a NACT_NPC
-- Parameters:
--   cNpcTohandle : Npc to be delegated to N.A.C.T.
--   sTerritoryName    : The Territory this NPC will use to find it's cover and patrol points
function NACT_RegisterNpc(cNpcToHandle, sTerritoryName)

    if (cNpcToHandle == nil) then
        Console.Error("N.A.C.T. Invalid character provided to NACT_RegisterNpc")
        return
    end

    if (sTerritoryName == nil) then
        Console.Error("N.A.C.T. You must provide a zone for this NPC")
        return
    end

    local tTerritoryOfNpc = NACT_territories[sTerritoryName];

    if (tTerritoryOfNpc == nil) then
        Console.Error("N.A.C.T. Zone was not found for this NPC")
        return
    end

    -- TODO: This would definitly be better with Timmy classlib :D
    -- Type is NACT_NPC
    local NpcRegistred = NACT_NPC(cNpcToHandle, sTerritoryName)
    local iNpcRegID = NpcRegistred:GetID()
    NACT_handledNpcs[iNpcRegID] = NpcRegistred

    Console.Log("N.A.C.T. npc " .. iNpcRegID .. " registered")
    cNpcToHandle:SetValue("NACT_NPC_ID", iNpcRegID)

    return NpcRegistred

end



function NACT_RegisterTerritory(sTerritoryName, tZoneConfigTable)
    NACT_territories[sTerritoryName] = tZoneConfigTable;
end
