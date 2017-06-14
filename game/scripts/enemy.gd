extends Area2D

# class member variables go here, for example:
var polarity = 1*(rand_range(0,1) > 0.5)
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]

func _ready():
	add_to_group("enemies")

func _on_bullet_hit():
	get_node("timer").start()
	get_node("frames").set_modulate(colors[polarity])
	if rand_range(0,1) < get_node("../").gamma:
		polarity = 1-polarity


func reflect():
	_on_bullet_hit()

func explode():
	_on_bullet_hit()
	get_node("explosion").set_emitting(true)
	get_node("../ship").score += 10

func _on_visibility_exit_screen():
	queue_free()


func _on_timer_timeout():
	get_node("explosion").set_emitting(false)
	get_node("frames").set_modulate(Color(1,1,1))
