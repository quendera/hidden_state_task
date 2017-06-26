extends ProgressBar

func _ready():
	set_process(true)

func _process(delta):
	var current_life = get_node("../../enemy").life
	var max_life =  get_node("../../enemy").max_life
	set_value(100*current_life/float(max_life))
