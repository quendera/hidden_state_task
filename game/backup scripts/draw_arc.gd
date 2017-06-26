static func draw_arc(drawer, center, radius1, radius2, angle_from, angle_to, color):
	var arc1 = get_arc(center, radius1, angle_from, angle_to)
	var arc2 = get_arc(center, radius2, angle_from, angle_to)
	arc2.invert()
	for s in arc2:
		arc1.push_back(s)
	drawer.draw_polygon(arc1, ColorArray([color]))

static func get_arc(center, radius, angle_from, angle_to):
	var nb_points = 100
	var points_arc = Vector2Array()
	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/float(nb_points)
		points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
	return points_arc