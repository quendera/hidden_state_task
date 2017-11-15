extends AnimatedSprite


func ready():
	pass

func activate(polarity):
	get_material().set_shader_param("x", polarity)
	show()
	get_node("../anim").play("laser")
	get_node("sound_laser").play()

func explode():
	if not global.player.get_node("ship").active:
		global.player.explode_ship(0)
		global.enemy.take_life_points(-30)
		get_node("sound_laser_hit").play()

func retract():
	global.player.get_node("ship").active = false