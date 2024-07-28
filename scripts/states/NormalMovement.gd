extends PlayerState

@export var speed = 300.0
@export var run_accel = 500


func enter(_msg = {}):
	pass


func update(_delta):
	if (Input.is_action_just_pressed("shoot") or player.aiming_vector)\
	and not player.shield_unusable:
		state_machine.transition_to("ShieldedMovement")


func physics_update(delta):
	var direction = player.movement_vector
	if direction:
		if direction.length() > 1:
			direction = direction.normalized()
		player.velocity.x = roundi(move_toward(player.get_real_velocity().x, \
		direction.x * speed, \
		run_accel * delta))
		player.velocity.y = roundi(move_toward(player.get_real_velocity().y, \
		direction.y * speed, \
		run_accel * delta))
	else:
		state_machine.transition_to("Idle")
