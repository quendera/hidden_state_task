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
const low_x = 800
const high_x = 1000
const low_y = 250
const high_y = 500
var explosions = ["explosion_red", "explosion_blue"]
var explosion
var num_rays = 5
var shooting = true
var shooting_dir
var shooting_offset
var life = 1000
var regenerate_vec = [10, 25, 48.33, 88.33, 178.33]
var lost_life = 0
var life_sign

func _ready():
	dir = Vector2(cos(rand_range(0,2*PI)),sin(rand_range(0,2*PI)))
	add_to_group("enemies")
	set_process(true)


func _process(delta):
	if life <= 0:
		get_node("../").save_data()
		get_tree().quit()
	life = clamp(life,0,1000)
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
	get_node("draw_life").integrating = false
	get_node("timer").start()
	get_node("frames").set_modulate(colors[polarity])
	if rand_range(0,1) < get_node("../").gamma:
		polarity = 1-polarity


func lose_life(power, correct):
	if power == 0 :
		return 0
	var steps = int(floor(power/25))
	if correct:
		return 10*(steps+1)
	else:
		return -regenerate_vec[steps]


func reflect(power):
	var vec = get_node("../ship").get_global_pos()-get_node("laser/position").get_global_pos()
	get_node("laser").set_scale(Vector2(1,0.5)) #power/float(100) if you want it dependent on attack
	get_node("laser").set_rot(vec.angle()+PI/2)
	get_node("laser").activate(polarity, 0.2, 0.6 )
	get_node("sound").play("laser")
	lost_life = lose_life(power, false)
	_on_bullet_hit()


func explode(power):
	explosion = explosions[int(polarity)]
	get_node(explosion).set_scale(Vector2(power/100, power/100))
	get_node("anim").play(explosion)
	get_node("sound").play("explosion")
	lost_life = lose_life(power, true)
	_on_bullet_hit()



func _on_timer_timeout():
	get_node("frames").set_modulate(Color(1,1,1))
	get_node("lost_life").set_text("")


func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir)
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)

func attack(num_rays):
	for i in range(num_rays):
		shooting_offset = sin(OS.get_ticks_msec()/float(1000))*0.5
		var angle = shooting_offset+PI+0.8*PI*(i-2)/num_rays
		shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)

func _on_shooting_timeout():
	if shooting:
		attack(num_rays)
	if rand_range(0,1) < 0.1:
		shooting = not shooting