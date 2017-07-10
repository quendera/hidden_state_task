extends Area2D

# class member variables go here, for example:
const lag = 0.1
var escaped = false
var active = false
var movement_time = 0
var start_time = 0
var polarity = int(rand_range(0,1) > 0.5)
var charge = 0
var steps = 0
var hits = 0
var ship_pos
var velocity = 400
var ready2shoot = true
var ready2shield = false
var charging_velocity = 100
var exploding = false
var shooting = false
var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_instance
var ship_displace = Vector2(0,0)
var dirs = {"ui_left":Vector2(-1,0), "ui_right":Vector2(1,0), "ui_up":Vector2(0,-1), "ui_down":Vector2(0,1)}
var pos_touch = Vector2(0,0)
var move_touch = false
var dir_touch = Vector2(0,0)
var pressed = false
var shooting_pressed = false

func _ready():
	randomize()
	set_process(true)
	set_process_input(true)
	get_node("frames").get_material().set_shader_param("x", polarity)

func _input(event):
	if event.is_action_pressed("flip_color"):
		change_polarity()
	if event.is_action_pressed("shield"):
		shield()
	
	if (event.type == InputEvent.SCREEN_TOUCH) or (event.type == InputEvent.SCREEN_DRAG):
		pos_touch = event.pos
		pressed = (event.type == InputEvent.SCREEN_DRAG) or event.is_pressed()




func _process(delta):
	if ready2shoot:
		ready2shield = false
	set_z(1+2*int(active))
	ship_pos = get_pos()
	var sum_dir = Vector2(0,0)
	for dir in dirs.keys():
		if Input.is_action_pressed(dir):
			sum_dir += dirs[dir]
	ship_displace += (sum_dir*velocity-ship_displace)*delta/lag
	ship_pos += delta*ship_displace
	dir_touch = pos_touch-get_node("joystick").get_global_pos()
	move_touch = pressed and dir_touch.length()<get_node("joystick").ray*1.2
	if move_touch:
		ship_pos += min(dir_touch.length(),2*velocity*delta)*dir_touch.normalized()

	if (Input.is_action_pressed("shoot") or shooting_pressed) and ready2shoot and not active:
		if not shooting:
			shooting = true
			spawn_bullet(polarity)
		charge = clamp(charge+delta*charging_velocity, 0, 100)
		bullet_instance.steps = steps
	if not (Input.is_action_pressed("shoot") or shooting_pressed) and shooting:
		bullet_instance.detached = true
		shooting = false
		ready2shoot = false
	steps = int(floor(charge/25))+(charge > 0 )
	ship_pos.x = clamp(ship_pos.x, 80, get_node("..").w*0.35)
	ship_pos.y = clamp(ship_pos.y, get_node("..").h*0.22, get_node("..").h*0.92)
	set_pos(ship_pos)


func spawn_bullet(polarity):
	bullet_instance = bullet_scene.instance()
	bullet_instance.init(polarity)
	bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(bullet_instance)

func explode(damage = 1):
	if not exploding:
		get_node("sound").play("explosion")
		get_node("anim").play("explosion")
	hits += damage

func _on_anim_animation_started( name ):
	exploding = true


func _on_anim_finished():
	exploding = false


func _on_shield_off_timeout():
	active = false

func change_polarity():
	if not Input.is_action_pressed("shoot"):
		polarity = 1-polarity
		get_node("frames").get_material().set_shader_param("x", polarity)

func shield():
	if not active:
		if movement_time == 0:
			movement_time = OS.get_ticks_msec()-start_time
		if ready2shield:
			active = true
			get_node("shield_off").start()

func _on_polarity_button_pressed():
	change_polarity()



func _on_shield_pressed():
	shield()
	print("shield")
