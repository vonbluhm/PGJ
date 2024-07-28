extends Area2D

@onready var regular_box = $RegularHitBox
@onready var round_box = $CircumBox

signal shield_hit
signal body_hit


func _ready():
	regular_box.set_deferred("disabled", false)
	round_box.set_deferred("disabled", true)


func _process(_delta):
	pass


func _on_body_entered(body):
	if body is Enemy and body.FSM.state.name != "Defeated":
		if regular_box.disabled:
			shield_hit.emit()
		else:
			body_hit.emit()
	if body is Enemy and body.FSM.state.name == "Defeated":
		body.remove()
