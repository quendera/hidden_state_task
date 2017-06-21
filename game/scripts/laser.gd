extends AnimatedSprite

var active

func activate(polarity, delay1, delay2):
	set_hidden(false)
	set_frame(2*polarity)
	get_node("timer").set_wait_time(delay1)
	get_node("timer").start()
	get_node("timer_off").set_wait_time(delay2)
	get_node("timer_off").start()

func _on_timer_timeout():
	set_frame(get_frame()+1)
	active = true
	if get_node("area").overlaps_area(get_node("../../ship")):
		get_node("../../ship").explode()


func _on_timer_off_timeout():
	set_hidden(true)
	active = false
