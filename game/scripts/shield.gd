extends Area2D


# class member variables go here, for example:
var polarity = 1*(rand_range(0,1) > 0.5)
var active = false
const time_on = 1
const time_off = 0.1
var timer = 0
const colors = ["red", "blue"]


func _ready():
	get_node("frames").set_frame(polarity)
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("polarity_change"):
		polarity = 1-polarity
		get_node("frames").set_frame(polarity)
