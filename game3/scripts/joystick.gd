extends Position2D

# class member variables go here, for example:
# var a = 2
onready var ray = (get_node("right").get_global_position()-get_global_position()).length()


func _within_ray(pos):
	var diff = pos-get_global_position()
	return sqr(diff.x*diff.x+0.5*diff.y*diff.y)<ray
