extends Node2D

var color = Color(196/float(255),84/float(255),196/float(255))
var integrating
var Draw = preload("res://scripts//draw_arc.gd")


func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
	var current_life = get_node("../").life
	var max_life = get_node("../").max_life
	Draw.draw_arc(self,Vector2(0,0),275,315,90,90-180*current_life/float(max_life), color)

