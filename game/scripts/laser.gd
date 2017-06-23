extends AnimatedSprite

var active

func activate(polarity):
	set_hidden(false)
	set_frame(polarity)
	set_modulate(Color(1, 1, 1, 0.1))
	get_node("../../ship").active = false
	get_node("timer").start()
	get_node("timer_off").start()

func _on_timer_timeout():
	set_modulate(Color(1, 1, 1, 1))
	active = true
	if get_node("area").overlaps_area(get_node("../../ship")):
		get_node("../../ship").explode()


func _on_timer_off_timeout():
	set_hidden(true)
	active = false
