extends Node2D

var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var integrating = false
var x_scale = 10
var h = 15
var frame = 10
var decreased_life = 0
var increased_life = 0
var max_decrease = [1,1,1,1,1,1]
var max_increase = [1,1,1,1,1,1]
var boundary = [0,1,25,50,75,100]
var Draw = preload("res://scripts//draw_arc.gd")


func _ready():
	set_process(true)
	for i in range(6):
		max_decrease[i] = get_node("../../enemy").lose_life(boundary[i], true)
		max_increase[i] = -get_node("../../enemy").lose_life(boundary[i], false)

func _process(delta):
	if get_node("../../ship").shooting:
		integrating = true
	decreased_life = get_node("../../enemy").lose_life(get_node("../").charge, true)
	increased_life = -get_node("../../enemy").lose_life(get_node("../").charge, false)
	update()

func _draw():
	var x_scale = 100/float(max_increase[5]+max_decrease[5]+frame)
	var color = colors[get_node("../").polarity]
	var begin1 = 40
	var end1 = begin1+x_scale*max_decrease[5]
	var begin2 = end1+frame*x_scale
	var end2 = begin2 + x_scale*max_increase[5]
	for i in range(5):
		var color_pale = color.linear_interpolate(Color(1,1,1),(i+1)/float(6))
		Draw.draw_arc(self,Vector2(0,0),100,120,begin1+x_scale*max_decrease[i],begin1+x_scale*max_decrease[i+1],
		color_pale)
		Draw.draw_arc(self,Vector2(0,0),100,120,begin2+x_scale*max_increase[i],begin2+x_scale*max_increase[i+1],
		color_pale)
	
	if get_node("../").charge > 0.1 :
		Draw.draw_arc(self,Vector2(0,0),100,120,begin1,begin1+x_scale*decreased_life,color)
		Draw.draw_arc(self,Vector2(0,0),100,120,begin2,begin2+x_scale*increased_life,color)