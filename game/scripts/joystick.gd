extends Position2D

# class member variables go here, for example:
# var a = 2
onready var ray = (get_node("left").get_global_pos()-get_global_pos()).length()