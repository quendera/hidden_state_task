extends Area2D

# class member variables go here, for example:
var polarity = 1*(rand_range(0,1) > 0.5)
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var enemy_bullet_scene = preload("res://enemy_bullet.tscn")
const SPEED = 30
var enemy_bullet_instance
var dir
var pos
const low_x = 800
const high_x = 1000
const low_y = 300
const high_y = 600
var explosions = ["explosion_red", "explosion_blue"]
var explosion
var charge = 1


func _ready():
	dir = Vector2(cos(rand_range(0,2*PI)),sin(rand_range(0,2*PI)))
	add_to_group("enemies")
	set_process(true)


func _process(delta):
	pos = get_node("shoot_from").get_global_pos()
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
	charge = 1+power/20
	_on_bullet_hit()


func explode(power):
	charge = 1
	explosion = explosions[int(polarity)]
	get_node(explosion).set_scale(Vector2(power/100, power/100))
	get_node("anim").play(explosion)
	get_node("sound").play("explosion")
	get_node("../ship").score += power
	_on_bullet_hit()


func _on_visibility_exit_screen():
	queue_free()


func _on_timer_timeout():
	get_node("frames").set_modulate(Color(1,1,1))
	get_node("../ship").ready2shoot = true

func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir)
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)

func attack(charge):
	for i in range(charge):
		var dir = Vector2(cos(PI/2+PI*(i+0.5)/charge),sin(PI/2+PI*(i+0.5)/charge))
		spawn_enemy_bullet(dir.normalized())


func _on_shooting_timeout():
	attack(int(4*charge))
