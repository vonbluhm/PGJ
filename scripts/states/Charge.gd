extends EnemyState

const BASE_SPEED = 600
var speed = BASE_SPEED
var motion: Vector2
var distance: float

func enter(_msg = {}):
	print(self.name)
	speed = BASE_SPEED * float(actor.threshold - actor.slow_downers)\
	  / actor.threshold
	motion = _msg.dir * speed
	distance = 0.0
	print(motion)


func update(_delta):
	if actor.dazzled:
		state_machine.transition_to("Idle")


func physics_update(delta):
	speed = BASE_SPEED * float(actor.threshold - actor.slow_downers)\
	  / actor.threshold
	actor.velocity = motion
	actor.move_and_slide()
	distance += speed * delta
	if distance >= 0.5 * BASE_SPEED:
		state_machine.transition_to("Pursue")


func exit():
	actor.velocity = Vector2.ZERO
	actor.anim_sprite.play()
