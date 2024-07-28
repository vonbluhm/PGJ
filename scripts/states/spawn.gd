extends EnemyState

const BASE_SPEED = 600
var speed: float
var motion: Vector2
var distance: float

func enter(_msg = {}):
	print(self.name)
	actor.apply_scale(Vector2.ONE * 0.1)


func update(_delta):
	pass


func physics_update(delta):
	actor.scale += Vector2(delta, delta)
	if actor.scale >= Vector2.ONE:
		actor.apply_scale(Vector2.ONE)
		state_machine.transition_to("Idle")


func exit():
	actor.anim_sprite.play()
