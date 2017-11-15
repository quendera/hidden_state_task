extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	parse_bbcode("""
[center][b] Controls [/b][/center]

Arrows : move

X      : shoot (long press)

X      : polarity (short press)

Z      : shield

C      : combo

Space  : blue / red

P      : pause / unpause

F      : toggle fullscreen

Esc    : exit the game

Ctrl   : tutorial

Enter  : start the game 
""")


