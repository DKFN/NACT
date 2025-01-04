# N.A.C.T. : Nanos Advanced Combat Tactics

NACT is a serverside package that gives combat capabilities for NPCs.
By default, the NPCs will be able to detect, flank, engage, cover, patrol and take actions against enemy players or NPCs to create interesting PvE combat situations.

While NACT is primarly focused on simulating gunfights with millitary combat tactics, we want to provide all the tools for you to create orther scenarios 
(bandits, melee, magic, fauna, etc...)

Special thanks to olivato and voltaism for open sourcing Isolados and VZombies code wich implement bots and was an inspiration for this library

# TODO

- Behavior back qui est choisit dans le combat si le NPC est en insuffisance numerique dans sa zone de choix, cherchant de l'aide vers un NPC proche
- Behavior push qui est choisit dans le combat si le NPC est en superiorité
- Engage ne devrait etre actif que lorsque l'ennemi est dans la ligne de mire
- Reaction aux evenements de hit d'un NPC (Engage, Cover, Detection)
- Le detection range du NPC devrait etre remplacé par un detection range de zone
- Cleanups en cas de mort du NPC
- Cleanups en cas d'abandon du combat par le joueur
- Cleanups en cas de deconnexion du joueur en combat
- Make sure all character nanos function calls are wrapped in NACT_NPC so users can extend NACT_NPC and provide their own system
- Store all cover points of map globally and get all the cover points in range when creating the territory or updating the territory in case of roaming npc
- Roaming NPC is just a NPC that carries the territory attached to the commander
and regularly updates the cover point in range

# Bails du turfu mais faut y penser

-> Sync la position relative des bones face a l'actor qui les attachent pour pouvoir avoir une liste de bones interessantes (bras, tete, torse) puis ensuite faire un leger RNG sur la position pour pas hit tout le temps
-> Test le changement de dimensions en cours de route