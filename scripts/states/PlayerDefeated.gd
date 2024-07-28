extends PlayerState


func enter(_msg = {}):
	player.anim_sprite.material.set_deferred(\
	"shader_parameter/brightness", -1.0)
	player.velocity = Vector2.ZERO
