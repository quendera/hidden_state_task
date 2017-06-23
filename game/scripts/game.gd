extends Node2D


var enemy_scene = preload("res://enemy.tscn")
var gamma = 0.2
var counter = 0
var data = {"time":[], "polarity_shot":[], "polarity_asteroid":[]}
var w = Globals.get("display/width")
var h = Globals.get("display/height")

func _ready():
	pass


func save_data():
	var file = File.new()
	file.open("/Users/pietro/Documents/save_try.json", file.WRITE)
	file.store_line(data.to_json())
	file.close()
