extends Area2D

var base_speed = 200
var base_direction = null
var velocity = Vector2.ZERO
var intact = true
var stuck = false
var type: int = 0
@onready var lifespan_timer = $LifespanTimer
@onready var anim_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
var enemy_container = null


func _ready():
	anim_sprite.stop()
	var anim_2b_played = ""
	match type:
		0:
			anim_2b_played = "default"
		1:
			anim_2b_played = "element_1"
		2:
			anim_2b_played = "element_2"
		3:
			anim_2b_played = "element_3"
		_:
			print(self, ": unknown type, using the fallback animation")
			anim_2b_played = "default"
	anim_sprite.play(anim_2b_played)
	var base_velocity = base_direction * base_speed
	var random_vector = Vector2(randfn(0.0, 0.25), randfn(0.0, 0.25))
	velocity = base_velocity + random_vector.normalized() * 0.25 * base_speed
	lifespan_timer.wait_time = 2.0 + randf() * 1
	lifespan_timer.start()
	

func _process(_delta):
	if stuck:
		assert(enemy_container)
		reparent(enemy_container)


func _physics_process(delta):
	if intact:
		if stuck:
			velocity = enemy_container.owner.velocity
		global_translate(velocity * delta)


func pop():
	intact = false
	anim_sprite.play("pop")
	collision_shape.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_body_entered(body):
	if body is Enemy and body.FSM.state.name != "Defeated":
		stuck = true
		enemy_container = body.container
	if body.is_in_group("obstacles"):
		pop()


func _on_lifespan_timer_timeout():
	pop()
