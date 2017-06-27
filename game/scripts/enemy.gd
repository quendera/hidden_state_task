extends Area2D

export var exploding = 0
export var frame = 0
# class member variables go here, for example:
var polarity = 1*(rand_range(0,1) > 0.5)
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var enemy_bullet_scene = preload("res://scenes/enemy_bullet.tscn")
const SPEED = 30
var enemy_bullet_instance
var dir
var pos
const low_x = 900
const high_x = 1100
const low_y = 250
const high_y = 500
var explosions = ["explosion_red", "explosion_blue"]
var explosion
var shooting = false
var max_life = 4000
var life = max_life
var regenerate_vec = [0, 10, 25, 48.33, 88.33, 178.33]
var lost_life = 0
var life_sign
var offset = 45
var attack_amount = 3
var attacks_effectuated = 0
var next_attack
var attack_durations = [4, 2, 1]
var attack_frequency = [0.3, 0.03, 0.1]

func _ready():
	randomize()
	dir = Vector2(cos(rand_range(0,2*PI)),sin(rand_range(0,2*PI)))
	add_to_group("enemies")
	set_process(true)


func _process(delta):
	if life <= 0:
		get_node("../").save_data()
		get_tree().quit()
	life = clamp(life,0,max_life)
	pos = get_node("centroid").get_global_pos()
	translate(SPEED*delta*dir)
	
	if (dir.x)*(pos.x-clamp(pos.x, low_x, high_x)) > 0.001:
		dir.x = -dir.x
	if (dir.y)*(pos.y-clamp(pos.y, low_y, high_y)) > 0.001:
		dir.y = -dir.y


func _on_bullet_hit():
	life -= lost_life
	if - lost_life > 0:
		life_sign = "+"
	else:
		life_sign = ""
	get_node("lost_life").set_text(life_sign+str(int(-lost_life)))
	get_node("timer").start()
	get_node("frames").set_modulate(colors[polarity])
	if rand_range(0,1) < get_node("../").gamma:
		polarity = 1-polarity


func lose_life(steps, correct):
	if correct:
		return 10*steps
	else:
		return -regenerate_vec[steps]


func reflect(steps):
	get_node("laser").activate(polarity)
	lost_life = lose_life(steps, false)
	_on_bullet_hit()


func explode(steps):
	explosion = explosions[int(polarity)]
	get_node(explosion).set_scale(Vector2(steps/float(5), steps/float(5)))
	get_node("anim").play(explosion)
	get_node("sound").play("explosion")
	lost_life = lose_life(steps, true)
	_on_bullet_hit()

func _on_timer_timeout():
	get_node("frames").set_modulate(Color(1,1,1))
	get_node("lost_life").set_text("")


func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir)
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)

func _on_shooting_timeout():
	if shooting:
		attack(next_attack)

func _on_toggle_shooting_timeout():
	shooting = not shooting
	if not shooting:
		get_node("toggle_shooting").set_wait_time(4+4*(attacks_effectuated % 3 == 0))
	else:
		if attacks_effectuated % 3 == 0:
			next_attack = randi() % 3
		attacks_effectuated += 1
		get_node("shooting").set_wait_time(attack_frequency[next_attack])
		get_node("toggle_shooting").set_wait_time(attack_durations[next_attack])
	get_node("toggle_shooting").start()

func attack(attack_number):
	if attack_number == 0:
		attack0()
	elif attack_number == 1:
		attack1()
	elif attack_number == 2:
		attack2()

func attack0():
	for i in range(5):
		var shooting_offset = sin(OS.get_ticks_msec()/float(1000))*0.5
		var angle = shooting_offset+PI+PI*(i-2)/float(5)
		var shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)

func get_num_rays(t):
	if t > 0.78:
		return 3
	elif t > 0.61:
		return 0
	elif t > 0.39:
		return 2
	elif t > 0.22:
		return 0
	else:
		return 1 

func attack1():
	offset = -offset
	var num_rays = get_num_rays(get_node("toggle_shooting").get_time_left()/get_node("toggle_shooting").get_wait_time())
	for i in range(num_rays):
		var angle = PI+0.2*PI*(i-0.5*(num_rays-1))+rand_range(-0.2,0.2)
		var shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)
#		enemy_bullet_instance.translate(Vector2(0, rand_range(-100,100)))


func attack2():
	offset = -offset
	for i in range(5):
		spawn_enemy_bullet(Vector2(-1,0))
		enemy_bullet_instance.translate(Vector2(0,180*(i-2)+offset))
		var vec = (get_node("../ship/get_hits").get_global_pos() -
		enemy_bullet_instance.get_global_pos())
		vec.x *= 0.8
		enemy_bullet_instance.dir = vec.normalized()


