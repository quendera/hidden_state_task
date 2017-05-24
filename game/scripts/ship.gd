extends Area2D

# class member variables go here, for example:
var score = 0
var ship_pos
var velocity = 800
var reload = 0
var reload_time = 0.1
var active = true
var bullet_scene = preload("res://bullet.tscn")
var bullet_instance
var dirs = {"ui_left":Vector2(-1,0), "ui_right":Vector2(1,0), "ui_up":Vector2(0,-1), "ui_down":Vector2(0,1)}

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	pass

func _process(delta):
	get_node("../score").set_text("Score :"+str(score))
	reload += delta
	ship_pos = get_pos()
	draw_circle(ship_pos, 20, Color(1,0,0))
	if active:
		for dir in dirs.keys():
			if Input.is_action_pressed(dir):
				ship_pos += delta*velocity*dirs[dir]
		if Input.is_action_pressed("shoot") and reload >= reload_time:
			spawn_bullet(get_node("shield").polarity, false)
			reload = 0
		if Input.is_action_pressed("super_shoot"):
			spawn_bullet(get_node("shield").polarity, true)
			active = false
			get_node("timer").start()
	ship_pos.x = clamp(ship_pos.x, 0, 720)
	ship_pos.y = clamp(ship_pos.y, 200, 1150)
	set_pos(ship_pos)

func destroy():
	get_node("anim").play("explosion")
	get_node("sound").play("explosion")
	score -= 50

func spawn_bullet(polarity, super):
	bullet_instance = bullet_scene.instance()
	bullet_instance.init(polarity, super)
	bullet_instance.set_global_pos(get_global_pos())
	get_node("../").add_child(bullet_instance)


func _on_timer_timeout():
	active = true