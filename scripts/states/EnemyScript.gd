class_name Enemy
extends CharacterBody2D

var target_node
var threshold = 10
var dazzled = false
var slow_downers = 0
var is_defeated = false

signal defeated


func _ready():
	defeated.connect(_on_defeated)


func _process(_delta):
	pass


func _on_defeated():
	is_defeated = true
