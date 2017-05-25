extends Area2D

# class member variables go here, for example:

var group
var polarity # 0 is red, 1 is blue
var bomb
var targets

const SPEED = 400
var life = 1
var exploded = false



func _ready():
	set_process(true)
	add_to_group("asteroids")
	add_to_group("asteroid"+str(group))
	if bomb:
		get_node("frames").set_frame(3)
		add_to_group("bombs")
		set_z(1)
	get_node("frames").set_hidden(false)


func _process(delta):
	translate(delta*SPEED*Vector2(0,1))
	if life <= 0 and not exploded:
		explode()
	if get_global_pos().y > get_node("../ship/get_hits").get_global_pos().y:
		show_color()


func _on_asteroid_area_enter( area ):
	if area.get_name() == "ship":
		var file = File.new()
		file.open("/Users/pietro/Documents/save_try.json", file.WRITE)
		file.store_line(get_node("../").data.to_json())
		file.close()
		get_tree().change_scene("res://game_over.tscn")


func show_color():
	for asteroid in get_tree().get_nodes_in_group("asteroid"+str(group)):
		asteroid.get_node("frames").set_frame(polarity)


func explode():
# Specify who explodes if asteroids explodes
	if bomb:
		targets = get_tree().get_nodes_in_group("asteroid"+str(group))
	else:
		targets = [get_node(".")]
# Perform the explosion
	for asteroid in targets:
			get_node("../ship").score += 10
			asteroid.get_node("frames").set_frame(asteroid.polarity)
			asteroid.get_node("timer").start()
			asteroid.exploded = true


func _on_visibility_exit_screen():
	queue_free()


func _on_timer_timeout():
	queue_free()
