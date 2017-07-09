extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	put_text(0)


func put_text(i):
	if i == 0:
		parse_bbcode("""
[center][b] A peaceful start [/b][/center]
Your ultimate goal is to defeat an enemy ship equipped with a quantum defense mechanism. However, oftentimes it is good to start small. Use the arrow keys to move in front of the enemy and change color pressing the key E.
""")
	elif i == 1:
		parse_bbcode("""
Well done! Now try and shoot at the enemy by pressing and releasing the W key. The longer you press, the more powerful the shot.
Be careful: if the enemy is of the opposite color, it will fight back with a laser. Press Space to shield. Shielding unnecessarily costs you a timeout.
""")
	elif i == 2:
		parse_bbcode("""
Nice dodge! 
""")