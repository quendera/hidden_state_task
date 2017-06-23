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
	Draw.draw_arc(self,Vector2(0,0),275,300,50,50-current_life, color)

