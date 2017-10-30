extends Node

var w = 1280
var h = 720

var enemy setget , get_enemy
var player setget , get_player

func get_enemy():
	return get_node("/root/game/enemy/enemy_ship")

func get_player():
	return get_node("/root/game/player")

# Task variable:

var bias_blue = 0.1
var lasers = true