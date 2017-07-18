extends Node

var w = Globals.get("display/width")
var h = Globals.get("display/height")

var enemy setget , get_enemy
var player setget , get_player

func get_enemy():
	return get_node("/root/game/enemy/enemy_ship")

func get_player():
	return get_node("/root/game/player")