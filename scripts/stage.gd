extends Node

@onready var bullet_container = $PlayerBulletContainer
@onready var enemy_container = $EnemyContainer
@onready var player = $PlayerChar
@onready var tilemap = $TileMap
var enemies_max: int = 0
var enemies_left: int = 0

signal stage_clear

func _ready():
	player.container = bullet_container
	for child in enemy_container.get_children():
		if child is ShadeSpawner:
			enemies_max += child.max_subenemies + 1
			enemies_left += child.subenemies.get_child_count() + 1
		elif child is Enemy:
			enemies_max += 1
			enemies_left += 1
	adjust_saturation()
	


func _process(_delta):
	var enemies_this_frame = 0
	for child in enemy_container.get_children():
		if child is ShadeSpawner and not child.is_defeated:
			enemies_this_frame += child.subenemies.get_child_count() + 1
		elif child is Enemy and not child.is_defeated:
			enemies_this_frame += 1
	if enemies_this_frame != enemies_left and enemies_left > 0:
		enemies_left = enemies_this_frame
		adjust_saturation()
	if not enemies_left:
		stage_clear.emit()


func adjust_saturation():
	var fraction_of_defeated = float(enemies_max - enemies_left) / enemies_max
	tilemap.material.set_deferred("shader_parameter/saturation",\
	0.2 + 0.8 * fraction_of_defeated)
	tilemap.queue_redraw()
		
		
func _on_stage_clear():
	enemies_left = -1
	print("You're winner!!! :rofl:")
