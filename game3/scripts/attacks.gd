func attack(attack_number):
	if attack_number == 0:
		attack0()
	elif attack_number == 1:
		attack1()

static func get_num_rays(t):
	if t > 0.78:
		return 3
	elif t > 0.61:
		return 0
	elif t > 0.39:
		return 2
	elif t > 0.22:
		return 0
	else:
		return 1

static func attack0():
	var num_rays = get_num_rays(get_node("end_attack").get_time_left()/
	get_node("end_attack").get_wait_time())
	for i in range(num_rays):
		var angle = PI+0.2*PI*(i-0.5*(num_rays-1))+rand_range(-0.2,0.2)
		var shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)


static func attack1(offset ):
	offset = -offset
	for i in range(5):
		spawn_enemy_bullet(Vector2(-1,0))
		enemy_bullet_instance.translate(Vector2(0,180*(i-2)+offset))
		var vec = (get_node("../ship/get_hits").get_global_pos() -
		enemy_bullet_instance.get_global_pos())
		vec.x *= 0.8
		enemy_bullet_instance.dir = vec.normalized()