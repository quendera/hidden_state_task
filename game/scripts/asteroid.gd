extends Area2D

# class member variables go here, for example:
const SPEED = 400
var group
var polarity # 0 is red, 1 is blue
var bomb = false
var exploded = false
var colors = ["red","blue"]

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

func _on_asteroid_area_enter( area ):
	if area.get_name() == "shield":
		for asteroid in get_tree().get_nodes_in_group("asteroid"+str(group)):
			asteroid.get_node("frames").set_frame(2- polarity)
	if area.get_name() == "ship":
		if area.get_node("shield").polarity != polarity:
			area.destroy()
		else:
			area.score += 10

func do_anim_finished():
	queue_free()