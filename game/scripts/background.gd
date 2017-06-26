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
	if pos.x +  5000*0.9 <= get_node("..").w:
		pos.x += get_texture().get_size().x*0.9
		set_pos(pos)
