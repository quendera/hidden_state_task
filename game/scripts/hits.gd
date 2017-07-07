extends Label

func _ready():
	set_process(true)

func _process(delta):
	set_text("HITS "+str(get_node("../../ship").hits))