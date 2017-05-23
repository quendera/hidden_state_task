extends Area2D

# class member variables go here, for example:
const SPEED = 500
var group
var life = 5
var polarity # 0 is red, 1 is blue
var bomb = false
var exploded = false
var colors = ["red","blue"]
var targets

func _ready():
	set_process(true)
	add_to_group("asteroids")
	if bomb:
		get_node("frames").set_frame(3)
		add_to_group("bombs")
	else:
		get_node("frames").set_frame(0)
	get_node("frames").set_hidden(false)
	get_node("anim").connect("finished", self, "do_anim_finished")



func _process(delta):
	translate(delta*SPEED*Vector2(0,1))
	if life <= 0:
		explode()
	if get_global_pos().y > get_node("../ship/get_hits").get_global_pos().y:
		show_color()

func _on_asteroid_area_enter( area ):
	if area.get_name() == "ship":
		show_color()
		area.destroy()

func show_color():
	for asteroid in get_tree().get_nodes_in_group("asteroid"+str(group)):
		asteroid.get_node("frames").set_frame(2- polarity)

func do_anim_finished():
	queue_free()

func explode():
	if not exploded:
# Specify who explodes if asteroids explodes
		if bomb:
			targets = get_tree().get_nodes_in_group("asteroid"+str(group))
		else:
			targets = [get_node(".")]
# Perform the explosion
		for asteroid in targets:
#				asteroid.get_node("sound").play("explosion")
				get_node("../ship/sound").play("explosion")
				get_node("../ship").score += 10
				asteroid.get_node("anim").play(asteroid.colors[asteroid.polarity])
				asteroid.exploded = true

func _on_visibility_exit_screen():
	queue_free()
