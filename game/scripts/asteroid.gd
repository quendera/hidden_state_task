extends Area2D

# class member variables go here, for example:
const SPEED = 200
var group

func _ready():
	set_process(true)


func _process(delta):
	translate(delta*SPEED*Vector2(0,1))

func _on_asteroid_area_enter( area ):
	if area.get_name() == "ship":
		for asteroid in get_tree().get_nodes_in_group("asteroid"+str(group)):
			asteroid.get_node("frames").set_frame(get_node("../").polarity+1)
