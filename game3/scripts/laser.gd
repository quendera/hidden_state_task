extends AnimatedSprite

var hit = false


func ready():
	pass

func activate(polarity):
	hit = false
	get_material().set_shader_param("x", polarity)
	show()
	get_node("../anim").play("laser")
	get_node("../sound").play()

func explode():
	if get_node("area").overlaps_area(global.player.get_node("ship")):
		if not global.player.get_node("ship").active:
			global.player.explode_ship(20)
			hit = true
			global.player.get_node("ship").escaped = false
		else:
			global.player.get_node("ship").escaped = true

func retract():
	global.player.get_node("ship").active = false


