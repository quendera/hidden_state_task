extends Node2D

var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var integrating = false
var x_scale = 10
var frame = 10
var h = 10
var y = 10
var l = 500
var decreased_life = 0
var increased_life = 0
var max_decrease = [1,1,1,1,1,1]
var max_increase = [1,1,1,1,1,1]
var points


func _ready():
	set_process(true)
	for i in range(6):
		max_decrease[i] = get_node("../../enemy").lose_life(i, true)
		max_increase[i] = -get_node("../../enemy").lose_life(i, false)

func _process(delta):
	if get_node("../../ship").shooting:
		integrating = true
	decreased_life = get_node("../../enemy").lose_life(get_node("../../ship").steps, true)
	increased_life = -get_node("../../enemy").lose_life(get_node("../../ship").steps, false)
	update()

func _draw():
	pass
#	h = get_node("../boss_life").get_size().y
#	l = get_node("../boss_life").get_size().x
#	y = get_node("../boss_life").get_global_pos().y-h
#	var x_scale = (l-frame)/float(max_increase[5]+max_decrease[5])
#	var color = colors[get_node("../../ship").polarity]
#	var begin1 = get_node("../../").w-get_node("../boss_life").get_global_pos().x
#	var end1 = begin1+x_scale*max_decrease[5]
#	var begin2 = end1+frame
#	var end2 = begin2 + x_scale*max_increase[5]
#	for i in range(5):
#		var color_pale = color.linear_interpolate(Color(1,1,1),(i+2)/float(7))
#		draw_rectangle(Vector2(begin1+x_scale*max_decrease[i],y),Vector2(x_scale*(max_decrease[i+1]-max_decrease[i]),h),color_pale)
#		draw_rectangle(Vector2(begin2+x_scale*max_increase[i],y),Vector2(x_scale*(max_increase[i+1]-max_increase[i]),h),color_pale)
#	
#	if get_node("../../ship").steps > 0 :
#		draw_rectangle(Vector2(begin1,y),Vector2(x_scale*decreased_life,h),color)
#		draw_rectangle(Vector2(begin2,y),Vector2(x_scale*increased_life,h),color)

func draw_rectangle(pos, size, color):
	points = Vector2Array()
	points.push_back(pos)
	points.push_back(Vector2(pos.x+size.x,pos.y))
	points.push_back(Vector2(pos+size))
	points.push_back(Vector2(pos.x,pos.y+size.y))
	draw_polygon(points,  ColorArray([color]))