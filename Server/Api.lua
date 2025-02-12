NACT = BaseClass.Inherit("_NACT")

NACT.territories = {}
NACT.handledNpcs = {}

NACT.mapCoverPoints = {}

function NACT:Constructor()
    
end

-- This is all the public functions exposed by the package

--- This functions handles registering a new NPC into the system. It will wrap a Character with a NACT_NPC.
--- 
--- NACT provies a few default configurations #LINK MISSING# for you to use, but it's funnier to tweak stuff!
--- 
--- It can take the following table as a configuration:
--- 
--- ```lua
--- {
---     -- List of all the behaviors. Pass it or use AddBehavior #LINK MISSING# or your NPC will be a static potato
---     behaviors= {
---       class = NACT_Idle,
---     }, {
---       class = NACT_Detection,
---       config = {
---           heatIncrement = 20
---        }
---     },
--- 
---     -- Does the NPC has a human like vision (auto vision) or behaves like an animal/flesh ?
---     -- Default to true
---     autoVision = false,
--- 
---     -- Vision "angle", the vision range... Huh kinda, I should make it better before alpha, it's simple to fix maybe I'll forgot let me know!
---     -- Right now, 0 means 360° vision angle. Defaults to 110 (wich means 90 :D)
---     visionAngle = 90,
--- 
---     look
--- }
--- ```
--- 
---@param cNpcToHandle Character @Npc to be controlled NACT
---@param sTerritoryName string @The Territory this NPC will use to find it's cover and patrol points
---@param tNpcConfig table @See above for tNpcConfig map
---@return NACT_NPC | nil @NACT_NPC created or nil if operation failed
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

--- Add a territory to NACT
---@param sTerritoryName string Name of the territory
---@param tZoneConfigTable table TO BE DOCUMENTED
function NACT.RegisterTerritory(sTerritoryName, tZoneConfigTable)
    NACT.territories[sTerritoryName] = NACT_Territory(tZoneConfigTable);
end

--- Get the character from the causer in some events of nanos
---@param causer Weapon | Character @causer sent by nanos world events
---@return Character @the real causer
function NACT.GetCharacterFromCauserEntity(causer)
    if (causer:IsA(Character)) then
        return causer
    end
    if (causer:IsA(Weapon) or causer:IsA(Melee)) then
        return causer:GetHandler()
    end
end

--- Utility function especially useful for configurations. Returns a value if defined or the default
---@param maybeValue any | nil The value to be used if not nil
---@param default any The default value if maybeValue is nil
---@return any maybeValue or defaultValue
function NACT.ValueOrDefault(maybeValue, default)
    if (maybeValue ~= nil) then
        return maybeValue
    else
        return default
    end
end

--- Set the map cover points that will be used when creating a territory
---@param tMapCoverPoints table @TO BE DOCUMENTED test doc update
function NACT.SetMapCoverPoints(tMapCoverPoints)
    NACT.mapCoverPoints = tMapCoverPoints
    for k, v in pairs(NACT.territories) do
        Console.Log("Refreshing cover points for "..k)
        v:RefreshCoverPoints(NACT.mapCoverPoints)
    end
end

--- Returns all the defined cover points of the territory
---@return table TO BE DOCUMENTED
function NACT.GetMapCoverPoints()
    return NACT.mapCoverPoints
end


Package.Require("./core/Triggers.lua")
