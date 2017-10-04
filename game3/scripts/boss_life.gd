extends TextureProgress

func _ready():
	set_process(true)

func _process(delta):
	var current_life = global.enemy.life
	var max_life =  global.enemy.max_life
	set_value(100*current_life/float(max_life))
