extends Node2D


var polarity = 1*(rand_range(0,1) > 0.5)
var asteroid_scene = preload("res://asteroid.tscn")
var enemy_scene = preload("res://enemy.tscn")
var gamma = 0.5
var accuracy = [0.4, 0.6]
var counter = 0
var data = {"time":[], "polarity_shot":[], "polarity_asteroid":[]}
var w = Globals.get("display/width")
var h = Globals.get("display/height")
const space = 10
var upper_lim
var lower_lim


func _ready():
	pass


func save_data():
	var file = File.new()
	file.open("/Users/pietro/Documents/save_try.json", file.WRITE)
	file.store_line(get_node("../").data.to_json())
	file.close()
