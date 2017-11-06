extends RichTextLabel


func _ready():
	put_text(0)


func put_text(i):
	if i == 0:
		parse_bbcode("""
[center][b] A peaceful start [/b][/center]
Your ultimate goal is to defeat an enemy ship equipped with a quantum defense mechanism. However, oftentimes it is good to start small. Use the [color=#e02727]arrow[/color] keys to move in front of the enemy and change color pressing [color=#e02727]Space[/color].
""")
	elif i == 1:
		parse_bbcode("""
Well done! Now try and shoot at the enemy by pressing and releasing the
[color=#e02727]W[/color] key. The longer you press, the more powerful the shot.
Be careful: if the enemy is of the opposite color, it will fight back with a laser. Press [color=#e02727]Q[/color] to shield. Shielding unnecessarily costs you a timeout.
""")
	elif i == 2:
		parse_bbcode("""
Nice dodge! Be careful: you must also dodge enemy bullets. Only bullets of the opposite color can hurt you.
Use the color of the bullets to figure out the color of the enemy: the more blue bullets it shoots the more likely it is to be blue, and viceversa.
""")
	elif i == 3:
		parse_bbcode("""
A final tip: choose wisely the power of your shot. If your attack is of the same polarity as the enemy, the corresponding damage is inflicted, Otherwise, the enemy can use the energy of the attack to gain back health points.
Practice your strategy and press [color=#e02727]Enter[/color] when you are ready.
""")