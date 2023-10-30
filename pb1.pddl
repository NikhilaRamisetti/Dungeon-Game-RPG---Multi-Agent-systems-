(define (problem pb1) (:domain rpg)
(:objects 
    room1_1 room1_2 room1_3 room2_1 room2_2 room2_3  - room
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (adjacent room1_1 room1_2) 
    (adjacent room1_1 room2_1)
    (adjacent room1_2 room1_1) 
    (adjacent room1_2 room1_3) 
    (adjacent room1_2 room2_2)
    (adjacent room1_3 room1_2) 
    (adjacent room1_3 room2_3)
    (adjacent room2_1 room1_1) 
    (adjacent room2_1 room2_2) 
    (adjacent room2_2 room1_2) 
    (adjacent room2_2 room2_3) 
    (adjacent room2_2 room2_1)
    (adjacent room2_3 room1_3) 
    (adjacent room2_3 room2_2) 
    (hero-at room1_1)
    (monster-at room1_3)
    (monster-at room2_1)
    (not (armed))
)

(:goal (and
    ;todo: put the goal condition here
    (hero-at room2_3)
))
;un-comment the following line if metric is needed
;(:metric minimize (???))
)