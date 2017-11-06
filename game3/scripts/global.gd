extends Node

var w = 1280
var h = 720

var player_path
var enemy_path

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