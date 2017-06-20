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
var baseline_charge = 5
var charge = baseline_charge
var shooting = 1
var shooting_delay
var shooting_dir
var shooting_offset


func _ready():
	shooting_delay = get_node("shooting").get_wait_time()
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
	get_node("timer").start()
	get_node("frames").set_modulate(colors[polarity])
	if rand_range(0,1) < get_node("../").gamma:
		polarity = 1-polarity


func reflect(power):
	charge = 0 #baseline_charge+power/5
	get_node("laser").set_frame(polarity)
	get_node("anim").play("laser")
	get_node("shooting").set_wait_time(shooting_delay/2)
	_on_bullet_hit()


func explode(power):
	charge = 0
	explosion = explosions[int(polarity)]
	get_node(explosion).set_scale(Vector2(power/100, power/100))
	get_node("anim").play(explosion)
	get_node("sound").play("explosion")
	get_node("../ship").score += power
	_on_bullet_hit()


func _on_visibility_exit_screen():
	queue_free()


func _on_timer_timeout():
	charge = 0
	get_node("waiting").start()
	get_node("shooting").set_wait_time(shooting_delay)


func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir)
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)

func attack(charge):
	for i in range(charge):
		shooting_offset = sin(OS.get_ticks_msec()/float(1000))*0.5
		var angle = shooting_offset+PI/2+PI*(i+0.5)/charge
		shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)

func targeted_attack(charge):
	var pos_start = get_node("shoot_from").get_global_pos()
	var pos_end = get_node("../ship/get_hits").get_global_pos()


func _on_shooting_timeout():
	attack(int(charge))


func _on_waiting_timeout():
	get_node("frames").set_modulate(Color(1,1,1))
	get_node("../ship").ready2shoot = true
	get_node("../ship").charge = 0
	charge = baseline_charge