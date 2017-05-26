extends TextureFrame

# class member variables go here, for example:
const SPEED = 200
var bg_pos

func _ready():
	bg_pos = get_pos()
	set_process(true)


func _process(delta):
	bg_pos = get_pos()
	bg_pos += delta*SPEED*Vector2(0,1)
	if bg_pos.y > 0:
		bg_pos -= Vector2(0,1280)
	set_pos(bg_pos)
