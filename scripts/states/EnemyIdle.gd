extends EnemyState

const BASE_SPEED = 50
var speed = BASE_SPEED
var waypoint: Vector2
var raycast: RayCast2D
@onready var travel_timer = $Timer

func enter(_msg = {}):
	print(self.name)
	actor.anim_sprite.play()
	raycast = actor.raycast
	travel_timer.start()


func update(_delta):
	speed = BASE_SPEED * float(actor.threshold - actor.slow_downers)\
	  / actor.threshold


func physics_update(_delta):
	if actor.target_node:
		raycast.target_position = actor.target_node.global_position - actor.global_position
		raycast.force_raycast_update()
		if raycast.get_collider() is Player and not actor.dazzled\
		and raycast.target_position.length() <= 256 :
			state_machine.transition_to("Pursue")
	
	if (waypoint - actor.global_position).length() <= 8:
		actor.velocity = Vector2.ZERO
	actor.move_and_slide()


func _on_vision_area_body_entered(body):
	if body is Player and not actor.dazzled and actor.FSM.state.name == "Idle":
		actor.target_node = body
		raycast.target_position = body.global_position - actor.global_position
		print(raycast.target_position)
		raycast.force_raycast_update()
		print(raycast.get_collider())
		if raycast.get_collider() is Player:
			state_machine.transition_to("Pursue")


func _on_timeout():
	if actor.FSM.state.name != "Defeated":
		waypoint = actor.origin_point\
		 + Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 64
		actor.velocity = (waypoint - actor.global_position).normalized() * speed
