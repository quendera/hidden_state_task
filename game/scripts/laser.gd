extends AnimatedSprite

func ready():
	pass


func activate(polarity):
	get_material().set_shader_param("x", polarity)
	show()
	get_node("timer").start()

func _on_timer_timeout():
	if get_node("area").overlaps_area(get_node("../../ship")):
		get_node("../../ship").explode()

