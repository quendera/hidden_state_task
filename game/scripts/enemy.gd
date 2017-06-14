extends Area2D

# class member variables go here, for example:
var polarity = 1*(rand_range(0,1) > 0.5)
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var enemy_bullet_scene = preload("res://enemy_bullet.tscn")
var enemy_bullet_instance
var shooting = false

func _ready():
	add_to_group("enemies")
	set_process(true)

func _process(delta):
	if shooting:
		pass

func _on_bullet_hit():
	get_node("timer").start()
	get_node("frames").set_modulate(colors[polarity])
	if rand_range(0,1) < get_node("../").gamma:
		polarity = 1-polarity


func reflect(power):
	_on_bullet_hit()
	for i in range(int(power/3)):
		var dir = Vector2(rand_range(-1,0),rand_range(-0.5,0.5))
		spawn_enemy_bullet(dir.normalized())

func explode(power):
	_on_bullet_hit()
	get_node("explosion").set_amount(power)
	get_node("explosion").set_emitting(true)
	get_node("../ship").score += power

func _on_visibility_exit_screen():
	queue_free()


func _on_timer_timeout():
	get_node("frames").set_modulate(Color(1,1,1))

func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir)
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)