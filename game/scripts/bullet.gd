extends Area2D

const SPEED = 600
var dir
var friendly
var polarity

func _process(delta):
	translate(delta*SPEED*dir)

func _ready():
	get_node("blue").set_hidden(polarity == 0)
	get_node("red").set_hidden(polarity == 1)
	set_process(true)

func _on_bullet_area_enter(area):
	if not friendly:
		if area.has_method("destroy"):
			area.destroy()
			get_node("../ship").score -=15
			queue_free()
		if area.get_name() == "shield" and polarity == area.polarity:
			queue_free()
	if friendly:
		if area.is_in_group("enemies"):
			area.get_node("anim").play("explosion")
			get_node("../ship").score += 10 +40*(area.life == 1)
			area.life -= 1

func _on_visibility_exit_screen():
	queue_free()