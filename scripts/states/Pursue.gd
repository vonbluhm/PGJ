extends EnemyState

@onready var raycast: RayCast2D
const BASE_SPEED = 100
var speed = BASE_SPEED
var last_known_pos: Vector2


func enter(_msg = {}):
	print(self.name)
	raycast = actor.raycast


func physics_update(_delta):
	speed = BASE_SPEED * float(actor.threshold - actor.slow_downers)\
	  / actor.threshold
	if actor.dazzled:
		state_machine.transition_to("Idle")
	else:
		raycast.target_position = actor.target_node.global_position\
		- actor.global_position
		raycast.force_raycast_update()
		if raycast.get_collider() is Player\
		and raycast.target_position.length() < 300:
			last_known_pos = actor.target_node.global_position
		if last_known_pos != null \
		and (last_known_pos - actor.global_position).length() > 5:
			actor.velocity = (last_known_pos\
			- actor.global_position).normalized() * speed
			actor.move_and_slide()
		else:
			state_machine.transition_to("Idle")
	

func exit():
	actor.velocity = Vector2.ZERO


func _on_attack_area_body_entered(body):
	if body is Player and actor.FSM.state.name == "Pursue":
		state_machine.transition_to("Poise")
