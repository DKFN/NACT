-- This behavior aims to try to detect the player and then go to the next state on the behavior tree
PROVISORY_NACT_HEAT_INCREMENT = 5

NACT_Detection = BaseClass.Inherit("NACT_Detection")
function NACT_Detection:Constructor(NpcInstance)
    self.npc = NpcInstance
    self.heat = PROVISORY_NACT_HEAT_INCREMENT
    self.timerHandle = Timer.SetInterval(function()
        self:Main()
    end, 500, self)
    self.tracingLaunched = false
end

function NACT_Detection:Main()
    Console.Log("Detection main, heat".. self.heat .. " npc : ".. NanosTable.Dump(self.npc.cFocused))
    if (self.heat >= 100) then
        self.npc:GoNextBehavior()
    elseif (self.heat <= 0) then
        self.npc:GoPreviousBehavior()
    else
        if (self.npc.cFocused ~= nil) then
            -- TODO Find best player to send the trace, nearest player in range
            local delegatedPlayer = Player.GetByIndex(1) -- self.npc.cFocused:GetPlayer()
            Console.Log("Calling remote event")
            if (not self.tracingLaunched) then
                Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:START", delegatedPlayer, self.npc.character, self.npc.cFocused, self:GetID())
                self.tracingLaunched = true
            end

            -- Console.Log("Npc location : ".. NanosTable.Dump(npcLocation) .." Char location : ".. NanosTable.Dump(charLocation))

            -- TODO: Check if the player is in front or not of the NPC to not trigger detect
            -- TODO: Faire une fonction bogoss pour wrap ca
            --[[ SVTrace.LineSingle(
                self.npc.character:GetLocation(),
                self.npc.cFocused:GetLocation(),
                CollisionChannel.Mesh | CollisionChannel.WorldStatic | CollisionChannel.WorldDynamic | CollisionChannel.PhysicsBody | CollisionChannel.Vehicle,
                TraceMode.DrawDebug | TraceMode.ReturnEntity,
                {self.npc.character},
                function(traceToFocused)
                    -- Console.Log("Trace result in detection" .. NanosTable.Dump(traceToFocused))
                    -- Console.Log("Cfocused in trace ".. NanosTable.Dump(self.npc.cFocused))
                    if (traceToFocused.Success and traceToFocused.Entity == self.npc.cFocused) then
                        self.heat = self.heat + PROVISORY_NACT_HEAT_INCREMENT;
                    else
                        self.heat = self.heat - PROVISORY_NACT_HEAT_INCREMENT;
                    end
                end,
                 -- TODO: Get focused played instead
            ) ]]--
        else
            if (self.tracingLaunched) then
                Events.CallRemote("NCAT:TRACE:NPC_TO_ENTITY:STOP", Player.GetByIndex(1)) --, self.npc.character, self.npc.cFocused)
                self.tracingLaunched = false
            end
        end
        -- TODO: Check if player is in range and visible
    end
end

function NACT_Detection:IncrementLevel()
    self.heat = self.heat + PROVISORY_NACT_HEAT_INCREMENT
end

Events.SubscribeRemote("NCAT:TRACE:NPC_TO_ENTITY_RESULT", function(player, behaviorID, entityResult)
    local behaviorSubscribedToTraces = NACT_Detection.GetByID(behaviorID)

    if (behaviorSubscribedToTraces) then
        behaviorSubscribedToTraces:IncrementLevel()
    end

    -- Console.Log("Entity poll result : ".. NanosTable.Dump(entityResult))
end)

function NACT_Detection:Destroy()
    Timer.ClearInterval(self.timerHandle)
end

