extends Node

var w = 1280
var h = 720

var player_path = NodePath("/root/game/player")
var enemy_path = NodePath("/root/game/enemy/enemy_ship")

var enemy setget , get_enemy
var player setget , get_player

func get_enemy():
	return get_node(enemy_path)

func get_player():
	return get_node(player_path)

# Task variable:

var bias_blue = 0.0
var bonus = "blue"
var lasers = true
var time_pressure = 0