extends Area2D

const SPEED = 450
var dir
var polarity
var harmless = false


func _process(delta):
	translate(delta*SPEED*dir)
	if global.player.shooting and not harmless:
		harmless = true
		$anim.play("disappear")

func _ready():
	set_process(true)

func _on_enemy_bullet_area_enter(area):
	if area.get_name() == "ship" and not area.active and not harmless:
		area.emit_signal("exploded", polarity)
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func init(_dir, _polarity):
	dir = _dir
	polarity = _polarity
	get_node("frames"+str(1-int(polarity))).set_visible(false)


func _on_anim_animation_finished( name ):
	set_visible(false)
