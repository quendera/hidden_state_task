extends AnimatedSprite

func ready():
	pass


func activate(polarity):
	var ship = get_node("../../ship")
	var vec = ship.get_global_pos()+ship.ship_displace*get_node("timer").get_wait_time()-get_node("position").get_global_pos()
	set_rot(vec.angle()+PI/2)
	get_material().set_shader_param("x", polarity)
	show()
	get_node("timer").start()
	get_node("../anim").play("laser")
#	get_node("sound").play("laser")

func _on_timer_timeout():
	if get_node("area").overlaps_area(get_node("../../ship")):
		get_node("../../ship").explode()

