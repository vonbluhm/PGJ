extends EnemyState


func enter(_msg = {}):
	print(self.name)
	actor.is_defeated = true
	for child in actor.container.get_children():
		child.queue_free()
	actor.anim_sprite.stop()
	actor.encaser.set_deferred("visible", true)
	await get_tree().create_timer(5).timeout
	actor.remove()


func update(_delta):
	pass


func physics_update(delta):
	actor.velocity.x = move_toward(actor.velocity.x, 0.0, 20 * delta)
	actor.velocity.y = move_toward(actor.velocity.y, -20.0, 20 * delta)
	actor.move_and_slide()
