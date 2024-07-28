extends PlayerState

@export var deceleration = 2000


func enter(_msg = {}):
	pass


func update(_delta):
	if player.movement_vector:
		state_machine.transition_to("NormalMovement")
	
	if (Input.is_action_just_pressed("shoot") or player.aiming_vector)\
	and not player.shield_unusable:
		state_machine.transition_to("ShieldedMovement")


func physics_update(delta):
	player.velocity.x = roundi(move_toward(player.get_real_velocity().x, 0, \
		deceleration * delta))
	player.velocity.y = roundi(move_toward(player.get_real_velocity().y, 0, \
		deceleration * delta))
