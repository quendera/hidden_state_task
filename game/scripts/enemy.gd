extends Area2D

# class member variables go here, for example:
var polarity = 1*(rand_range(0,1) > 0.5)
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var enemy_bullet_scene = preload("res://enemy_bullet.tscn")
const SPEED = 30
var enemy_bullet_instance
var dir
var pos
const low_x = 850
const high_x = 1050
const low_y = 200
const high_y = 500
var explosions = ["explosion_red", "explosion_blue"]
var explosion
var num_rays = 5
var shooting = true
var shooting_dir
var shooting_offset


func _ready():
	dir = Vector2(cos(rand_range(0,2*PI)),sin(rand_range(0,2*PI)))
	add_to_group("enemies")
	set_process(true)


func _process(delta):
	pos = get_node("centroid").get_global_pos()
	translate(SPEED*delta*dir)
	if (dir.x)*(pos.x-clamp(pos.x, low_x, high_x)) > 0.001:
		dir.x = -dir.x
	if (dir.y)*(pos.y-clamp(pos.y, low_y, high_y)) > 0.001:
		dir.y = -dir.y

func _on_bullet_hit():
	shooting = false
	get_node("timer").start()
	get_node("frames").set_modulate(colors[polarity])
	if rand_range(0,1) < get_node("../").gamma:
		polarity = 1-polarity


func reflect(power):
	var vec = get_node("../ship").get_global_pos()-get_node("laser/position").get_global_pos()
	get_node("laser").set_scale(Vector2(1,power/float(50)))
	get_node("laser").set_rot(vec.angle()+PI/2)
	get_node("laser").set_frame(polarity)
	get_node("laser").set_hidden(false)
	get_node("sound").play("laser")
	get_node("../ship").score -= pow(power,2)/float(30)
	_on_bullet_hit()


func explode(power):
	explosion = explosions[int(polarity)]
	get_node(explosion).set_scale(Vector2(power/100, power/100))
	get_node("anim").play(explosion)
	get_node("sound").play("explosion")
	get_node("../ship").score += power
	_on_bullet_hit()



func _on_timer_timeout():
	get_node("laser").set_hidden(true)
	get_node("frames").set_modulate(Color(1,1,1))
	get_node("../ship").ready2shoot = true
	get_node("../ship").charge = 0
	shooting = true


func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir)
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)

func attack(num_rays):
	for i in range(num_rays):
		shooting_offset = sin(OS.get_ticks_msec()/float(1000))*0.5
		var angle = shooting_offset+PI/2+PI*(i+0.5)/num_rays
		shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)

func _on_shooting_timeout():
	if shooting:
		attack(num_rays)