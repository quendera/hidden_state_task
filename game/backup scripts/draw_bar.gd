extends Node2D

var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var new_color
var new_color_bg

func _ready():
    set_process(true)


func _process(delta):
	new_color = colors[get_node("../").polarity]
	new_color_bg = new_color.linear_interpolate(Color(1,1,1),0.5)
	update()

func _draw():
	draw_arc(Vector2(0,0),100,120,130,230-get_node("../").hits*2,new_color)
#	draw_arc(Vector2(0,0),100,120,130,230,new_color_bg)
#	if get_node("../").charge > 0.1:
#		draw_arc(Vector2(0,0),100,120,130,130+get_node("../").charge,new_color)

func draw_arc(center, radius1, radius2, angle_from, angle_to, color):
	var arc1 = get_arc(center, radius1, angle_from, angle_to)
	var arc2 = get_arc(center, radius2, angle_from, angle_to)
	arc2.invert()
	for s in arc2:
		arc1.push_back(s)
	draw_polygon(arc1, ColorArray([color]))

func get_arc(center, radius, angle_from, angle_to):
	var nb_points = 32
	var points_arc = Vector2Array()
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
		points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
	return points_arc