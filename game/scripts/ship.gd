extends Area2D

# class member variables go here, for example:
var polarity = int(rand_range(0,1) > 0.5)
var charge = 0
var steps = 0
var hits = 0
var ship_pos
var velocity = 400
var ready2shoot = true
var charging_velocity = 100
var shooting = false
var active = false
var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_instance
var dirs = {"ui_left":Vector2(-1,0), "ui_right":Vector2(1,0), "ui_up":Vector2(0,-1), "ui_down":Vector2(0,1)}


func _ready():
	set_process(true)
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("flip_color") and not Input.is_action_pressed("shoot"):
		polarity = 1-polarity
	for dir in dirs.keys():
		if event.is_action_pressed(dir):
			active = true

func _process(delta):
	ship_pos = get_pos()
	for dir in dirs.keys():
		if Input.is_action_pressed(dir):
			ship_pos += delta*velocity*dirs[dir]
	if Input.is_action_pressed("shoot") and ready2shoot:
		if not shooting:
			shooting = true
			spawn_bullet(polarity)
		charge = clamp(charge+delta*charging_velocity, 0, 100)
		steps = int(floor(charge/25))+(charge > 0 )
		bullet_instance.steps = steps
	if not Input.is_action_pressed("shoot") and shooting:
		bullet_instance.detached = true
		shooting = false
		ready2shoot = false
	ship_pos.x = clamp(ship_pos.x, 100, get_node("..").w*0.4)
	ship_pos.y = clamp(ship_pos.y, 0, get_node("..").h)
	set_pos(ship_pos)


func spawn_bullet(polarity):
	bullet_instance = bullet_scene.instance()
	bullet_instance.init(polarity)
	bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(bullet_instance)

func explode():
	get_node("sound").play("explosion")
	get_node("anim").play("explosion")
	hits += 1