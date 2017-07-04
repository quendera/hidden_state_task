extends AnimatedSprite

var hit = false


func ready():
	pass

func activate(polarity):
	hit = false
	var ship = get_node("../../ship")
	ship.check_movement = true
	ship.start_time = OS.get_ticks_msec()
	get_material().set_shader_param("x", polarity)
	show()
	get_node("timer").start()
	get_node("../anim").play("laser")
	get_node("../sound").play("laser")

func _on_timer_timeout():
	if get_node("area").overlaps_area(get_node("../../ship")) and not get_node("../../ship").active:
		get_node("../../ship").explode()
		hit = true

