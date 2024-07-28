class_name Player
extends CharacterBody2D

enum States{IDLE, NORMAL_RUN, SHIELDED}
enum Elements{
	NONE = 0, MULTI = 1, SLOW = 2, SPARK = 3
	}

var _state = States.IDLE

@onready var FSM = $FSM
@onready var container
@onready var regular_shape = $RegularCollisionShape
@onready var circumshape = $Circumshape
@onready var hitbox = $HitBox
@onready var hit_timer = $HitTimer
@onready var aim_ring = $AimRing
@onready var anim_sprite = $AnimatedSprite2D
@onready var shield_back: AnimatedSprite2D = $ShieldBack
@onready var shield_front: AnimatedSprite2D = $ShieldFront
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@export var element = Elements.NONE
var max_health = 2
var health
var max_shield_strength = 3
var shield_strength
var hit_cd = false
var shield_unusable = false
var hit_sprites = []
var movement_vector = Vector2.ZERO
var aiming_vector = Vector2.ZERO

signal shot_fired
signal defeated

func _ready():
	health = max_health
	shield_strength = max_shield_strength


func _process(_delta):
	movement_vector = Vector2(Input.get_axis("move_left", "move_right"),\
	Input.get_axis("move_up", "move_down"))
	aiming_vector = Vector2(Input.get_axis("aim_left", "aim_right"),\
	Input.get_axis("aim_up", "aim_down"))
	
	if not hit_timer.is_stopped() and health > 0:
		var is_visible = bool(int(hit_timer.time_left * 30) % 2)
		for sprite in hit_sprites:
			sprite.set_deferred("visible", is_visible)


func _physics_process(delta):
	if move_and_collide(velocity * delta, true):
		velocity = get_real_velocity()
	move_and_slide()


func set_element(e):
	element = e


func recharge_shield():
	shield_unusable = false
	shield_strength = max_shield_strength
	shield_back.set_deferred("visible", true)
	shield_front.set_deferred("visible", true)


func _on_shot_fired(vector):
	var bullet = bullet_scene.instantiate()
	bullet.type = element
	if vector:
		#Shoot normally
		vector.normalized()
		bullet.global_position = aim_ring.get_child(0).global_position
		bullet.base_direction = vector
		bullet.base_speed += 0.5 * (velocity.dot(vector))
	else:
		#Shoot randomly
		aim_ring.global_rotation = 0.0
		var picked_point = randi() % aim_ring.children
		bullet.global_position = aim_ring.get_child(picked_point).global_position
		bullet.base_direction = Vector2(\
		cos(picked_point * 2 * PI / aim_ring.children), \
		sin(picked_point * 2 * PI / aim_ring.children)\
		)
		bullet.base_speed += 0.25 * (velocity.dot(bullet.base_direction))
	if container:
		container.add_child(bullet)
	else:
		get_tree().get_root().add_child(bullet)


func _on_body_hit():
	if hit_timer.is_stopped():
		hit_timer.start()
		health -= 1
		if health <= 0:
			defeated.emit()
		else:
			hit_sprites.append(anim_sprite)
			anim_sprite.material.set_deferred(\
			"shader_parameter/brightness", -0.5)


func _on_shield_hit():
	if hit_timer.is_stopped():
		hit_timer.start()
		shield_strength -= 1
		element = 0
		if shield_strength <= 0:
			shield_unusable = true
			hit_sprites.append(anim_sprite)
		else:
			hit_sprites.append(shield_back)
			hit_sprites.append(shield_front)


func _on_hit_timer_timeout():
	for sprite in hit_sprites:
		sprite.set_deferred("visible", true)
	hit_sprites = []


func _on_defeated():
	FSM.transition_to("PlayerDefeated")
