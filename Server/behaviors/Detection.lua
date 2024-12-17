-- This behavior aims to try to detect the player and then go to the next state on the behavior tree
PROVISORY_NACT_HEAT_INCREMENT = 1

NACT_Detection = BaseClass.Inherit("NACT_Detection")
function NACT_Detection:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.heat = PROVISORY_NACT_HEAT_INCREMENT
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500, self)
    self.tracingLaunched = false
end

-- If the player 
function NACT_Detection:Main()
    Console.Log("Detection main, heat".. self.heat .. " npc : ".. NanosTable.Dump(self.npc.cFocused))

    -- Tracing functions should be in NACT_NPC or NACT_Behavior
    local fStopTracing = function()
        if (self.tracingLaunched) then
            Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", Player.GetByIndex(1)) --, self.npc.character, self.npc.cFocused)
            self.tracingLaunched = false
        end
    end
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
        fStopTracing()
    elseif (self.heat <= 0) then
        self.npc:GoPreviousBehavior()
        fStopTracing()
    else
        if (self.npc.cFocused ~= nil) then
            -- TODO Find best player to send the trace, nearest player in range
            local delegatedPlayer = Player.GetByIndex(1) -- self.npc.cFocused:GetPlayer()
            Console.Log("Calling remote event")
            if (not self.tracingLaunched) then
                Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", delegatedPlayer, self.npc.character, self.npc.cFocused, self:GetID())
                self.tracingLaunched = true
            end
        else
            self.heat = 0
            fStopTracing()
        end
        -- TODO: Check if player is in range and visible
    end
end

function NACT_Detection:IncrementLevel()
    self.heat = self.heat + PROVISORY_NACT_HEAT_INCREMENT
end

function NACT_Detection:DecrementLevel()
    self.heat = self.heat - PROVISORY_NACT_HEAT_INCREMENT
end

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", function(player, behaviorID, entityResult)
    local behaviorSubscribedToTraces = NACT_Detection.GetByID(behaviorID)

    if (behaviorSubscribedToTraces) then
        if (entityResult) then
            behaviorSubscribedToTraces:IncrementLevel()
        else
            behaviorSubscribedToTraces:DecrementLevel()
        end
    end

    -- Console.Log("Entity poll result : ".. NanosTable.Dump(entityResult))
end)

function NACT_Detection:Destroy()
    Timer.ClearInterval(self.timerHandle)
end

