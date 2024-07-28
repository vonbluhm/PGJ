extends PlayerState


@export var speed = 200.0
@export var run_accel = 500
@export var deceleration = 1000
@export var time_btw_shots = 0.125
@onready var timer: Timer = null
@onready var shot_cd = false
@export var time_to_revert = 2.0


func enter(_msg = {}):
	player.shield_back.play("expand")
	player.shield_front.play("expand")
	player.regular_shape.set_deferred("disabled", true)
	player.circumshape.set_deferred("disabled", false)
	player.hitbox.regular_box.set_deferred("disabled", true)
	player.hitbox.round_box.set_deferred("disabled", false)
	if timer == null:
		timer = Timer.new()
		timer.timeout.connect(_on_timeout)
		timer.wait_time = time_to_revert
		add_child(timer)
	timer.start()


func update(_delta):
	if Input.is_action_pressed("shoot") or player.aiming_vector:
		timer.start()
		if not shot_cd:
			shot_cd = true
			shoot()
			await get_tree().create_timer(time_btw_shots).timeout
			shot_cd = false
	if player.shield_unusable:
		if player.movement_vector:
			state_machine.transition_to("NormalMovement")
		else:
			state_machine.transition_to("Idle")


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
		player.velocity.x = roundi(move_toward(player.get_real_velocity().x, 0, \
		deceleration * delta))
		player.velocity.y = roundi(move_toward(player.get_real_velocity().y, 0, \
		deceleration * delta))
	
	
func shoot():
	player.shot_fired.emit(player.aiming_vector.normalized())
	
	
func exit():
	if not player.shield_unusable:
		player.shield_back.play_backwards("expand")
		player.shield_front.play_backwards("expand")
	else:
		player.shield_back.set_deferred("visible", false)
		player.shield_front.set_deferred("visible", false)
	player.regular_shape.set_deferred("disabled", false)
	player.circumshape.set_deferred("disabled", true)
	player.hitbox.regular_box.set_deferred("disabled", false)
	player.hitbox.round_box.set_deferred("disabled", true)


func _on_timeout():
	if player.movement_vector:
		state_machine.transition_to("NormalMovement")
	else:
		state_machine.transition_to("Idle")
