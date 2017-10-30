#Functionality:
#	move, shield and explode.
#	Emit exploded signal when hit by an enemy bullet


extends Area2D

signal exploded(enemy_polarity)

const LAG = 0.1
var escaped = false

var active = false setget set_active

func set_active(new_active):
	active = new_active
	get_node("shader").set_visible(new_active)
	set_z(1+2*int(new_active))


var velocity = 400


var exploding = false
var combo = false

var ship_displace = Vector2(0,0)
var dirs = {"ui_left":Vector2(-1,0), "ui_right":Vector2(1,0), "ui_up":Vector2(0,-1), "ui_down":Vector2(0,1)}
var pos_touch = Vector2(0,0)
var move_touch = false
var dir_touch = Vector2(0,0)
var pressed = false


func _ready():
	randomize()
	set_process(true)
	set_process_input(true)


func _input(event):
	if (event is InputEventScreenDrag) or (event is InputEventScreenDrag):
		pos_touch = event.pos
		pressed = (InputEventScreenDrag) or event.is_pressed()


func _process(delta):
# move the ship:
	var sum_dir = Vector2(0,0)
	for dir in dirs.keys():
		if Input.is_action_pressed(dir):
			sum_dir += dirs[dir]
		#	if not $sound_ship_engine.playing:
		#		$sound_ship_engine.play()
	ship_displace += (sum_dir*velocity-ship_displace)*delta/LAG
	position += delta*ship_displace
	dir_touch = pos_touch-get_node("joystick").get_global_position()
	move_touch = pressed and dir_touch.length()<get_node("joystick").ray
	if move_touch:
		position += min(dir_touch.length(),2*velocity*delta)*dir_touch.normalized()
	position.x = clamp(position.x, 80, global.w*0.35)
	position.y = clamp(position.y, global.h*0.22, global.h*0.92)



func explode():
	if not exploding:
		$anim.play("explosion")


func _on_anim_started( name ):
	if name == "explosion":
		exploding = true


func _on_anim_finished( name ):
	if name == "explosion":
		exploding = true
	if name == "laser" and combo:
		$anim.play("combo")
		get_parent().set_hits(get_parent().hits - 10)
		combo = false






