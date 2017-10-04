extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _process(delta):
	pass
#	get_node("absorb").set_global_position(global.player.get_node("ship/get_hits").get_global_position())


func _ready():
	set_process_input(true)
	set_process(true)


func _input(event):
	if event.is_action_pressed("steal"):
#		get_node("absorb").set_enabled(true)
#		set_time_scale(1)
		set_lifetime(0.7+(get_node("hide").get_wait_time()-get_node("hide").get_time_left())*3)
		get_node("hide").stop()

func start():
#	get_node("absorb").set_enabled(false)
#	set_time_scale(3)
	set_lifetime(3)
	set_visible(true)
	set_emitting(true)
	get_node("hide").start()

func _on_hide_timeout():
	set_visible(false)