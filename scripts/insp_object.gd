class_name InspirationObject
extends Area2D

enum Elements{MULTI = 1, SLOW = 2, SPARK = 3}
@export var element = Elements.MULTI
@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	match element:
		1:
			anim_sprite.play("multi")
		2:
			anim_sprite.play("slow")
		3:
			anim_sprite.play("spark")


func _on_body_entered(body):
	if body is Player:
		body.set_element(element)
		body.recharge_shield()
