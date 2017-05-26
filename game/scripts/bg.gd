extends TextureFrame

# class member variables go here, for example:
const SPEED = 200
var m1 = preload("res://assets/Images/bganim/bg1.png")
var m2 = preload("res://assets/Images/bganim/bg2.png")
var m3 = preload("res://assets/Images/bganim/bg3.png")
var m4 = preload("res://assets/Images/bganim/bg4.png")
var mytextures = [m1,m2,m3,m4]
var chosen_texture = 0
var bg_pos

func _ready():
	set_texture(mytextures[chosen_texture])
	bg_pos = get_pos()
	set_process(true)


func _process(delta):
	bg_pos = get_pos()
	bg_pos -= delta*SPEED*Vector2(1,0)
	if bg_pos.x < -1000:
		bg_pos += Vector2(1000,0)
	set_pos(bg_pos)


func _on_timer_timeout():
	chosen_texture = (chosen_texture+1) % 4
	set_texture(mytextures[chosen_texture])
