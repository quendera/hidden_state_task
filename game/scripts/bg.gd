extends TextureFrame

# class member variables go here, for example:
const SPEED = 1
var bg_pos

func _ready():
	bg_pos = get_pos()
	set_process(true)


func _process(delta):
	bg_pos = get_pos()
	bg_pos -= delta*SPEED*Vector2(1,0)
	if bg_pos.x < -1000:
		bg_pos += Vector2(1000,0)
	set_pos(bg_pos)
