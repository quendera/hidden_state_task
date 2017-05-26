extends Area2D

# class member variables go here, for example:

var group
var polarity # 0 is red, 1 is blue
var bomb
var targets

const SPEED = 400
var life = 1
var exploded = false
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]


func _ready():
	set_process(true)
	add_to_group("asteroids")
	add_to_group("asteroid"+str(group))
	if bomb:
		get_node("bomb").set_hidden(false)
		get_node("sprite").set_hidden(true)
		add_to_group("bombs")
		set_z(1)


func _process(delta):
	translate(delta*SPEED*Vector2(-1,0))
	if life <= 0 and not exploded:
		explode()
	if get_global_pos().x < get_node("../ship/get_hits").get_global_pos().x:
		show_color()


func _on_asteroid_area_enter( area ):
	if area.get_name() == "ship":
		get_node("../ship").score -= 100


func show_color():
	for asteroid in get_tree().get_nodes_in_group("asteroid"+str(group)):
		asteroid.get_node("sprite").set_modulate(colors[polarity])
		asteroid.get_node("bomb").set_hidden(true)


func explode():
# Specify who explodes if asteroids explodes
	if bomb:
		targets = get_tree().get_nodes_in_group("asteroid"+str(group))
	else:
		targets = [get_node(".")]
# Perform the explosion
	for asteroid in targets:
			get_node("../ship").score += 10
			asteroid.get_node("sprite").set_modulate(colors[polarity])
			asteroid.get_node("bomb").set_hidden(true)
			asteroid.get_node("timer").start()
			asteroid.exploded = true


func _on_visibility_exit_screen():
	queue_free()


func _on_timer_timeout():
	queue_free()
