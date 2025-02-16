NACT.Defaults = {}
NACT.Defaults.Millitary = {
    Soldier = {
        behaviors = {
            { class = NACT_Idle },
            { class = NACT_Detection},
            { class = NACT_Alert},
            { class = NACT_Combat},
            { class = NACT_Engage},
            { class = NACT_Seek},
            { class = NACT_Cover},
    }}
}

NACT.Defaults.Zombies = {
    Basic = {
        behaviors = {
            { class = NACT_Idle },
            { class = NACT_Detection, config = {
                heatIncrement = 99
            }},
            { class = NACT_ZombieMelee }
        },
        triggers = { melee = true, closeProximity = true, detection = true },
        lookAroundThrottle = 100,
        autoVison = false,
        visionAngle = 0 -- TODO: C'est pas ouf du tout eh !
    }
}

NACT.Defaults.Allies = {
    FollowerSoldier = function(cFollwed) return {
        behaviors = {
            { class = NACT_Follow, config = {
                following = cFollwed
            }},
            { class = NACT_Alert},
            { class = NACT_Combat, config = {
                idleBehavior = NACT_Follow
            }},
            { class = NACT_Engage},
            { class = NACT_Seek},
            { class = NACT_Cover},
    }} end
}