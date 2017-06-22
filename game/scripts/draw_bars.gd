extends Node2D

var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var integrating = false
var x_scale = 40
var h = 15
var frame = 3
var decreased_life = 0
var increased_life = 0
var max_decrease = 0
var max_increase = 0
var top_left = Vector2(200,40)
var points

func _ready():
	set_process(true)
	max_decrease = get_node("../../enemy").lose_life(100, true)
	max_increase = -get_node("../../enemy").lose_life(100, false)

func _process(delta):
	if get_node("../../ship").shooting:
		integrating = true
	decreased_life = get_node("../../enemy").lose_life(get_node("../../ship").charge, true)
	increased_life = -get_node("../../enemy").lose_life(get_node("../../ship").charge, false)
	update()

func _draw():
	var size_tot = x_scale*(max_decrease+max_increase)+3*frame
#	top_left.x = (get_node("../../").w-size_tot)/2
	top_left = Vector2((get_node("../../").w-size_tot)/2, get_node("../..").h-2*frame-h-40)
	draw_rectangle(top_left-Vector2(frame,frame), Vector2(x_scale*(max_decrease+max_increase)+3*frame, h+2*frame), 
	colors[get_node("../../ship").polarity])
	draw_rectangle(top_left, Vector2(x_scale*max_decrease,h), Color(0.5,0.5,0.5))
	if decreased_life > 0.1:
		draw_rectangle(top_left, Vector2(x_scale*decreased_life,h), Color(1,1,1))
	var top_left2 = top_left+Vector2(x_scale*(max_increase+max_decrease)+frame,0)
	draw_rectangle(top_left2, Vector2(-x_scale*max_increase,h), Color(0.5,0.5,0.5))
	if increased_life > 0.1:
		draw_rectangle(top_left2, Vector2(-x_scale*increased_life,h), Color(1,1,1))

func draw_rectangle(pos, size, color):
	points = Vector2Array()
	points.push_back(pos)
	points.push_back(Vector2(pos.x+size.x,pos.y))
	points.push_back(Vector2(pos+size))
	points.push_back(Vector2(pos.x,pos.y+size.y))
	draw_polygon(points,  ColorArray([color]))