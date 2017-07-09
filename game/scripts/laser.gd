extends AnimatedSprite

var hit = false

func ready():
	pass

func activate(polarity):
	hit = false
	get_material().set_shader_param("x", polarity)
	show()
	get_node("../anim").play("laser")
	get_node("../sound").play("laser")

func explode():
	if get_node("area").overlaps_area(get_node("../../ship")):
		if not get_node("../../ship").active:
			get_node("../../ship").explode(20)
			hit = true
			get_node("../../ship").escaped = false
		else:
			get_node("../../ship").escaped = true

func retract():
	get_node("../../ship").active = false


