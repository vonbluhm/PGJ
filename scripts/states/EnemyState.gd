class_name EnemyState
extends State

var actor: Enemy


func _ready():
	await owner.ready
	actor = owner as Enemy
	assert(actor != null)
