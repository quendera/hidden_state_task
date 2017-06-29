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
var exploding = false
var shooting = false
var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_instance
var ship_displace = Vector2(0,0)
var dirs = {"ui_left":Vector2(-1,0), "ui_right":Vector2(1,0), "ui_up":Vector2(0,-1), "ui_down":Vector2(0,1)}


func _ready():
	randomize()
	set_process(true)
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("flip_color") and not Input.is_action_pressed("shoot"):
		polarity = 1-polarity

func _process(delta):
	ship_pos = get_pos()
	var sum_dir = Vector2(0,0)
	for dir in dirs.keys():
		if Input.is_action_pressed(dir):
			sum_dir += dirs[dir]
	ship_displace = sum_dir*velocity
	ship_pos += delta*ship_displace
	if Input.is_action_pressed("shoot") and ready2shoot:
		if not shooting:
			shooting = true
			spawn_bullet(polarity)
		charge = clamp(charge+delta*charging_velocity, 0, 100)
		bullet_instance.steps = steps
	if not Input.is_action_pressed("shoot") and shooting:
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

func explode():
	if not exploding:
		get_node("sound").play("explosion")
		get_node("anim").play("explosion")
	hits += 1

func _on_anim_animation_started( name ):
	exploding = true


func _on_anim_finished():
	exploding = false
