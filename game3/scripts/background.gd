extends Sprite

# class member variables go here, for example:
const SPEED = 15

func _ready():
	set_process(true)


func _process(delta):
	translate(-delta*SPEED*Vector2(1,0))
	if position.x +  5000*0.9 <= global.w:
		position.x += get_texture().get_size().x*0.9

