extends Label

# holt sich das HighscoreLabel
onready var highscoreLabel = get_node(".")

func _process(delta):
	# setzt den Label Text auf den Globals Highscore
	highscoreLabel.text = Globals.levelParameters[Globals.levelNumber - 1]["highscore"] if Globals.levelNumber else "-------"
