extends Area2D

const SPEED = 600
var dir
var friendly
var polarity
var masked
var visible_color

func _process(delta):
	if masked:
		visible_color = "masked"
	elif polarity == 0:
		visible_color = "red"
	else:
		visible_color = "blue"
	set_color(visible_color)
	translate(delta*SPEED*dir)

func _ready():
	if friendly:
		get_node("sound").play("laser")
	set_process(true)

func _on_bullet_area_enter(area):
	if not friendly:
		if area.get_name() == "ship":
			if polarity != area.get_node("shield").polarity:
				area.destroy()
				get_node("../ship").score -=15
				get_node("sound").play("explosion")
			set_hidden(true)
		if area.get_name() == "shield":
			masked = false
	if friendly:
		if area.is_in_group("enemies"):
			area.get_node("anim").play("explosion")
			get_node("../ship").score += 10 + 40*(area.life == 1)
			area.life -= 1
			set_hidden(true)
		if area.is_in_group("bombs"):
			if not area.exploded:
				for asteroid in get_tree().get_nodes_in_group("asteroid"+str(area.group)):
					asteroid.get_node("anim").play(asteroid.colors[asteroid.polarity])
					asteroid.exploded = true
		if area.is_in_group("asteroids"):
			queue_free()

func _on_visibility_exit_screen():
	queue_free()

func set_color(chosen_color):
	for color in ["red","blue", "masked"]:
		get_node(color).set_hidden(color != chosen_color)