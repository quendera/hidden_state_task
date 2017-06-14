extends ProgressBar

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	set_value(get_node("../../ship").charge)
