extends Sprite


# class member variables go here, for example:
const SPEED = 15
var pos

func _ready():
	pos = get_pos()
	set_process(true)


func _process(delta):
	translate(-delta*SPEED*Vector2(1,0))
	pos = get_pos()
	if pos.x < -1000:
		pos += Vector2(1000,0)
		set_pos(pos)
