# N.A.C.T. : Nanos Advanced Combat Tactics

NACT is a serverside package that gives combat capabilities for NPCs.
By default, the NPCs will be able to detect, flank, engage, cover, patrol and take actions against enemy players or NPCs to create interesting PvE combat situations.

While NACT is primarly focused on simulating gunfights with millitary combat tactics, we want to provide all the tools for you to create orther scenarios 
(bandits, melee, magic, fauna, etc...)

Special thanks to olivato and voltaism for open sourcing Isolados and VZombies code wich implement bots and was an inspiration for this library

# TODO

## Alpha

### Features
- Rajouter une fonction pour trouver le plus proche (truc que je fais souvent dans les behaviors du coup) et remplacer par ca dans les behjaviors ou on fait souvent ca
- Rajouter dans l'event delegation les BeginOverlap / EndOverlap des differents triggers pour que les behavior
  puissent l'utiliser (nottament pour declencher le clako pour le behavior de mellee)
- Les zombies doivent avoir une notion de vision a 360 et qui detecte instantanement le joueur
  Pour eviter qu'ils sentent (voient) a travers les murs
- Finir de nettoyer le code des tests fourré dans la lib vers le gamemode de test
- Rajouter une fonction si un joueur est a proximité d'un NPC meme si il a un autre focused, qu'il puisse switch pour eviter de passer en ignorant le joueur (Ca devrait etre OK mais a test)
- Renomer les NACT_<BehaviorName> en NACT.<BehaviorName> dans l'export

- 1 aller classique (pv normaux, vitesse normaux), 1 sprinter (pv un peu bas mais il te trace et il te tatane), 1 tank (gros pv gros tatane mais lent)
- Les zombies devraient alerter leur potes qui sont très proches

- Make NPC configurable, some NACT_PROVISORY left there
- When no cover point found, reload on place
- Add events for focus changed etc
- Make the Functions with standard naming for nanos (ex: MoveToPoint should be renamed MoveToLocation)
- Cleanups en cas d'abandon du combat par le joueur
- Cleanups en cas de deconnexion du joueur en combat (Ca devrait etre ok a test)
- Faire en sorte que les NPCs ils sortent jamais du territoire
- Les cleanups de NPC dans le territoire sont incomplets (ca devrait etre ok ?)
- Documenter les configurations
- Faire la documentation sur gitbook avec les tutos etc
- Ajouter des fontions de setter pour des trucs qui seraient pas passés directement via la config


## Beta
- Changing a value/config of a behavior should also change the value of the current running behavior, not the next one instancied
- Behavior back qui est choisit dans le combat si le NPC est en insuffisance numerique dans sa zone de choix, cherchant de l'aide vers un NPC proche
- Behavior push qui est choisit dans le combat si le NPC est en superiorité
- Make vision based focusing change optionnal (for example, humans work like that, zombies don't)
- Make sure all character nanos function calls are wrapped in NACT_NPC so users can extend NACT_NPC and provide their own system
- Roaming NPC is just a NPC that carries the territory attached to the commander and regularly updates the cover point in range

# Bails du turfu mais faut y penser

-> Sync la position relative des bones face a l'actor qui les attachent pour pouvoir avoir une liste de bones interessantes (bras, tete, torse) puis ensuite faire un leger RNG sur la position pour pas hit tout le temps
-> Test le changement de dimensions en cours de route