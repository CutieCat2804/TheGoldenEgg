extends Label

# holt sich die GLobals
onready var Globals = get_node("/root/Globals")
# holt sich das HighscoreLabel
onready var highscoreLabel = get_node(".")

func _ready():
	# setzt den Label Text auf den Globals Highscore
	highscoreLabel.text = Globals.highscore
