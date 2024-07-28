extends Node2D

var input_vector
@export var children = 16
@export var radius = 36
signal aim_changed


func _ready():
	global_rotation = 0
	for idx in children:
		var child = Marker2D.new()
		child.position.x = radius * cos(idx * 2 * PI / children)
		child.position.y = radius * sin(idx * 2 * PI / children)
		add_child(child)


func _process(_delta):
	input_vector = Vector2(Input.get_axis("aim_left", "aim_right"),\
	Input.get_axis("aim_up", "aim_down"))
	if input_vector:
		aim_changed.emit(input_vector)
	else:
		input_vector = Vector2(Input.get_axis("move_left", "move_right"),\
		Input.get_axis("move_up", "move_down"))
		if input_vector:
			aim_changed.emit(input_vector)


func _on_aim_changed(vector):
	vector.normalized()
	global_rotation = vector.angle()
