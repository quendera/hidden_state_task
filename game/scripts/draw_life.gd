extends Node2D

var color = Color(217/float(255),76/float(255),158/float(255))

func _ready():
    set_process(true)

func _process(delta):
	update()

func _draw():
	draw_arc(Vector2(0,0),275,325,100,100-2*get_node("../").life, color)

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
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
	return points_arc