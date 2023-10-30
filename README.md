# Dungeon Game - Role Playing Games(RPG) Domain 
Formalising Dungeon Game(a RPG) domain using pddl

## Overview
This submission is an RPG formalisation to help a hero get out of a dungeon via one exit marked as the goal. The dungeon is a pathway of empty rooms and rooms with monsters, traps and swords that are connected by corridors. The hero starts unarmed(without a sword).
Here are the following actions, the hero can perform:
*	Move to an adjacent room that has not been destroyed (once a room is visited, it is destroyed)
*	Picking up a sword in a room if the hero is in the same room and he is not armed.
*	Destroy a sword if there are traps and no monsters in the following rooms.
*	Disarm a trap if the hero is empty-handed.
Here are the important constraints we need to consider:
*	The hero needs a sword to enter a room with a monster, or else he will be killed. Also, he cannot kill a monster
*	The hero needs to destroy his sword in an empty room
*	The hero needs to step empty-handed into a room with a trap, so he can disarm it else he will be killed
*	Every room visited is destroyed, once the hero moves to the next room
Considering the above actions and constraints, he needs to reach the room marked as goal. We need to design a transition system with automated planning.
## Implementation
We are implementing the classic planning transition system in domain and problem pddl files

### Domain
We are defining the constant parts of the transition 
**Domain Name:** rpg
(domain rpg)
**Requirements:**
    (:requirements :typing)
	:typing - able to type objects and variables, ?room – room(type)

**Object types:** 
(:types 
       room)
**Predicates:**
```
(:predicates
        (hero-at ?room - room)
        (armed)
        (monster-at  ?room - room)
        (trap-at ?room - room)
        (sword-at ?room)
        (adjacent ?room1 ?room2 - room)
        (room_destroyed ?room - room)
    )
```   

**Actions**:
*	Action to move without a sword –
Conditions – No monster or no trap, has no sword(unarmed) and hero in the room, rooms are connected
Output – Hero moves from room1 to room2, room is destroyed
``` 
(:action move
    :parameters (?room1 ?room2 - room)
    :precondition (and
      (adjacent ?room1 ?room2)
      (hero-at ?room1)
      (not (room_destroyed ?room2))
      (not (trap-at ?room1))
      (not (monster-at ?room2))
      (not (armed))
    )
    :effect (and
      (not (hero-at ?room1))
      (hero-at ?room2)
      (room_destroyed ?room1)
    )
  )
```
*	Action to move with a sword –
Conditions – No monster or no trap, has no sword(unarmed) and hero in the room, rooms are connected
Output – Hero moves from room1 to room2, room is destroyed
```
(:action move-armed-with-sword
    :parameters (?room1 ?room2 - room)
    :precondition (and
      (adjacent ?room1 ?room2)
      (hero-at ?room1)
      (not (room_destroyed ?room2))
      (not (trap-at ?room2))
      (armed))  
    :effect (and
      (room_destroyed ?room1)
      (not (hero-at ?room1))
      (hero-at ?room2)
    )
  )
```
*	Action to pick up a sword
Conditions –has no sword(unarmed), sword in the room and hero in the room
Output – Sword picked
```
(:action pickup_sword
    :parameters (?room - room)
    :precondition (and
      (not (armed))
      (sword-at ?room)
      (hero-at ?room)
    )
    :effect (and
      (not (sword-at ?room))
      (armed))
    )
```

*	Action to disarm a trap
Conditions – has no sword(unarmed), trapin the room and hero in the room
Output – trap disarmed
```
(:action disarm_trap
    :parameters (?room - room)
    :precondition (and
      (not (armed))
      (hero-at ?room)
      (trap-at ?room)
    )
    :effect (and
      (not (trap-at ?room))
    )
  )
```
*	Action to destroy a sword in empty room - 
Conditions – No monster or no trap, has sword(armed) and hero in the room
Output – Sword destroyed
```
  (:action destroy_sword
    :parameters (?room - room)
    :precondition (and
      (armed)
      (hero-at ?room)
      (not (trap-at ?room))
      (not (monster-at ?room))
    )
    :effect (and
      (not (armed))
    )
  )
```
  
## Problem # – 
For all the problem files, we are declaring the rooms as objects in the following notation - (:object)
(:objects 
    room1_1 room1_2 room1_3 room2_1 room2_2 room2_3  - room )
And the adjacent room connection and placement of hero, monsters, traps, swords in Initialization - (:init)
And goal in (:goal)
### Problem1:
![Problem 1](../../Pb1.png "Problem 1")
#### Problem1 Input:
Problem file name – pb1.pddl
```
(:init
    ;todo: put the initial state's facts and numeric values here
    (adjacent room1_1 room1_2) 
    ;…(all the connected rooms info)
    (adjacent room2_3 room2_2) 
    (hero-at room1_1)
    (monster-at room1_3)
    (monster-at room2_1)
    (not (armed)) ;denoting emptyhanded hero
)
(:goal (and
    ;todo: put the goal condition here
    (hero-at room2_3)
))
```

#### Plan output:
(move room1_1 room1_2)
(move room1_2 room2_2)
(move room2_2 room2_3)
; cost = 3 (unit cost)

### Problem2 - 
![Problem 2](../../Pb2.png "Problem 2")
```
(:init
    ;…(all the connected rooms info)
    (hero-at room1_2)
    (monster-at room1_1)
    (monster-at room2_2)
    (sword-at room2_3)
    (not (armed))
)
(:goal (and
    ;todo: put the goal condition here
    (hero-at room2_1)
))
```

#### Plan output:
(move room1_2 room1_3)
(move room1_3 room2_3)
(pickup_sword room2_3)
(move-armed-with-sword room2_3 room2_2)
(move-armed-with-sword room2_2 room2_1)
; cost = 5 (unit cost)

### Problem3 –
![Problem 3](../../Pb3.png "Problem 3")
```
(:init
    ;…(all the connected rooms info)
    (hero-at room1_1)
    (monster-at room1_2)
    (monster-at room2_2)
    (sword-at room2_1)
    (trap-at room2_3)
    (not (armed))
)
(:goal (and
    ;todo: put the goal condition here
    (hero-at room2_4)
))
```

#### Plan output: 
(move room1_1 room2_1)
(pickup_sword room2_1)
(move-armed-with-sword room2_1 room2_2)
(move-armed-with-sword room2_2 room1_2)
(move-armed-with-sword room1_2 room1_3)
(destroy_sword room1_3)
(move room1_3 room2_3)
(disarm_trap room2_3)
(move room2_3 room2_4)
; cost = 9 (unit cost)

## Execution
The above mentioned code was executed with the following dependencies
•	Local System Implementation
VSCode, PDDL plugin and Fast downward
### **./fast_downward.py <domain.pddl> <problem.pddl> <heuristics>**

Eg. For Problem1
1.	Command for Greedy search:  ../fast-downward.py rpg.pddl pb1.pddl --evaluator "hff=ff()" --search "lazy_greedy([hff], preferred=[hff])"
Solution found.
Peak memory: 407994624 KB
..
INFO     Planner time: 0.06s

2.	Command for landmark cut heuristic : ../fast-downward.py rpg.pddl pb1.pddl --search "astar(lmcut())"  
•	Online Planning Domain editor

## Conclusion

Thus we have implemented a planning transition system for hero to get out of the dungeon to reach goals via different problem models


