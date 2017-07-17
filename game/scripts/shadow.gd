extends Light2D


func _ready():
	set_process(true)

func _process(delta):
	rotate(get_angle_to(global.enemy.laser_pos)-PI/2)

