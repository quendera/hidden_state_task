extends Light2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	var angle2laser = get_angle_to(get_node("../../../enemy/laser/position").get_global_pos())
	rotate(angle2laser-PI/2)
