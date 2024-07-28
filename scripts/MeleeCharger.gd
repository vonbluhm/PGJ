extends Enemy

@onready var anim_sprite = $AnimatedSprite2D
@onready var encaser = $Encaser
@onready var FSM = $FSM
@onready var container = $Container
@onready var raycast = $RayCast2D
@onready var origin_point = global_position


func _ready():
	add_to_group("enemies")
	print(origin_point)
	threshold = 8


func _process(_delta):
	if is_defeated:
		FSM.transition_to("Defeated")
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


func _physics_process(delta):
	if move_and_collide(velocity * delta, true):
		velocity = get_real_velocity()
		

func remove():
	anim_sprite.set_deferred("visible", false)
	encaser.play("pop")
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_defeated():
	FSM.transition_to("Defeated")
