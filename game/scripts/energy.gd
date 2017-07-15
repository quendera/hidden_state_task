extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("steal"):
		get_node("absorb").set_enabled(true)
		get_node("hide").stop()

func start():
	get_node("absorb").set_enabled(false)
	set_hidden(false)
	set_emitting(true)
	get_node("hide").start()

func _on_hide_timeout():
	set_hidden(true)