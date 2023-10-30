(define (domain rpg)
    (:requirements :typing)
    (:types 
       room 
    )
    (:predicates
        (hero-at ?room - room)
        (armed)
        (monster-at  ?room - room)
        (trap-at ?room - room)
        (sword-at ?room)
        (adjacent ?room1 ?room2 - room)
        (room_destroyed ?room - room)
    )
  ; hero moves without sword 
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
  ;hero moves armed with sword 
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
  ; hero disarms trap 
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
  ; hero collects sword
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
  ; hero destroys sword in an empty room (no monster or no trap)
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

)