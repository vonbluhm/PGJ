class_name ShadeSpawner
extends Enemy

@onready var anim_sprite = $AnimatedSprite2D
@onready var encaser = $Encaser
@onready var container = $Container
@onready var subenemies = $Subenemies
@onready var FSM = $FSM
@onready var spawn_timer = $Timer
@export var time_btw_spawns = 8
@export var max_subenemies = 5
var unaffected_time = time_btw_spawns
@onready var raycast = $RayCast2D
@onready var enemy_array = preload("res://scenes/melee_charger.tscn")


func _ready():
	threshold = 12


func _process(delta):
	var children_value = 0
	dazzled = false
	slow_downers = 0
	for child in container.get_children():
		match child.type:
			0:
				children_value += 1
			1:
				children_value += 3
			2:
				children_value += 1
				slow_downers += 1
			3:
				children_value += 1
				dazzled = true
			_:
				print("unusual child in ", self, "'s bullet container")
	if children_value >= threshold:
		defeated.emit()
	
	unaffected_time -= delta
	spawn_timer.paused = dazzled
	if slow_downers and unaffected_time + slow_downers * 1 > 0:
		spawn_timer.wait_time = unaffected_time + slow_downers * 1
	
	
func remove():
	anim_sprite.set_deferred("visible", false)
	encaser.play("pop")
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_defeated():
	for child in subenemies.get_children():
		child.reparent(get_node(".."))
	spawn_timer.stop()
	FSM.transition_to("Defeated")


func _on_timeout():
	if FSM.state.name != "Defeated"\
	and subenemies.get_child_count() < max_subenemies:
		unaffected_time = time_btw_spawns
		spawn_timer.start(time_btw_spawns + slow_downers * 1)
		raycast.target_position = \
			Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()\
			* 128 * randf()
		raycast.force_raycast_update()
		while raycast.get_collider():
			raycast.target_position = \
			Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()\
			* 128 * randf()
			raycast.force_raycast_update()
		var enemy = enemy_array.instantiate()
		enemy.global_position = global_position + raycast.target_position
		subenemies.add_child(enemy)
