extends Node2D

var color = Color(217/float(255),76/float(255),158/float(255))
var color1 = color.linear_interpolate(Color(1,1,1),0.5)
var color2 = color.linear_interpolate(Color(0,0,0),0.5)
var integrating


func _ready():
    set_process(true)

func _process(delta):
	if get_node("../../ship").shooting:
		integrating = true
	update()

func _draw():
	var current_life = get_node("../").life
	var decreased_life = current_life - get_node("../").lose_life(get_node("../../ship").charge, true)
	var increased_life = current_life - get_node("../").lose_life(get_node("../../ship").charge, false)
	draw_arc(Vector2(0,0),275,325,100,100-2*current_life, color)
	if integrating and get_node("../../ship").charge > 0.01:
		draw_arc(Vector2(0,0),275,325,100-2*current_life,100-2*increased_life, color1)
		draw_arc(Vector2(0,0),275,325,100-2*current_life,100-2*decreased_life, color2)

func draw_arc(center, radius1, radius2, angle_from, angle_to, color):
	var arc1 = get_arc(center, radius1, angle_from, angle_to)
	var arc2 = get_arc(center, radius2, angle_from, angle_to)
	arc2.invert()
	for s in arc2:
		arc1.push_back(s)
	draw_polygon(arc1, ColorArray([color]))

func get_arc(center, radius, angle_from, angle_to):
	var nb_points = 100
	var points_arc = Vector2Array()
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
	return points_arc