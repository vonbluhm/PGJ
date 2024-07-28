extends EnemyState

@onready var raycast: RayCast2D
@onready var timer = $Timer
var direction: Vector2 = Vector2.ZERO


func enter(_msg = {}):
	print(self.name)
	raycast = actor.raycast
	direction = raycast.target_position.normalized()
	actor.anim_sprite.stop()
	timer.start(0.2)


func update(_delta):
	pass


func physics_update(_delta):
	if actor.dazzled:
		state_machine.transition_to("Idle")
	else:
		actor.anim_sprite.offset = \
		Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()\
		* 4


func _on_timer_timeout():
	actor.anim_sprite.offset = Vector2.ZERO
	timer.stop()
	state_machine.transition_to("Charge", {"dir": direction.normalized()})
