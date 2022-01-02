extends Button

onready var Globals = get_node("/root/Globals")
onready var doubleJumpButton = get_node(".")

func _ready():
	if Globals.doubleJumpActive == true:
		doubleJumpButton.text = "Doppelsprung deaktivieren"
	else:
		doubleJumpButton.text = "Doppelsprung aktivieren"

func _on_DoubleJumpButton_pressed():
	if Globals.doubleJumpActive == true:
		Globals.doubleJumpActive = false
		doubleJumpButton.text = "Doppelsprung aktivieren"
	else:
		Globals.doubleJumpActive = true
		doubleJumpButton.text = "Doppelsprung deaktivieren"
