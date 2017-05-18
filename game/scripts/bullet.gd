extends Area2D

const SPEED = 600
var dir
var friendly
var polarity

func _process(delta):
	translate(delta*SPEED*dir)

func _ready():
	if friendly:
		get_node("sound").play("laser")
	get_node("blue").set_hidden(polarity == 0)
	get_node("red").set_hidden(polarity == 1)
	set_process(true)

func _on_bullet_area_enter(area):
	if not friendly:
		if area.get_name() == "ship" and polarity != area.get_node("shield").polarity:
			area.destroy()
			get_node("../ship").score -=15
			get_node("sound").play("explosion")
			set_hidden(true)
		if area.get_name() == "shield" and polarity == area.polarity:
			set_hidden(true)
	if friendly:
		if area.is_in_group("enemies"):
			area.get_node("anim").play("explosion")
			get_node("../ship").score += 10 + 40*(area.life == 1)
			area.life -= 1
			set_hidden(true)

func _on_visibility_exit_screen():
	queue_free()