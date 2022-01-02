extends CanvasLayer

onready var pauseMenu = get_node(".")

func _ready():
	# Der Modus des PauseMenus wird auf process gesetzt
	# Bug: Kann nicht vorher gemacht werden, muss im laufenden Spiel gemacht werden
	# Process verhindert, dass diese Szene auch pausiert wird
	pauseMenu.pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	# Pause Menu öffnet sich nur in der Level Szene
	if Globals.levelNumber && get_tree().current_scene.name == "Level" + str(Globals.levelNumber):
		# checkt ob Escape gedrückt wurde
		if event.is_action_pressed("pause"):
			$Overlay.visible = !$Overlay.visible
			# pausiert das gesamte Spiel
			get_tree().paused = !get_tree().paused			

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	if get_tree().change_scene(Globals.TITLE_MENU) != OK:
		print("An unexpected error occured when trying to switch to the titleMenu scene")
	$Overlay.visible = false 
	Globals.reset()

func _on_ResumeButton_pressed():
	get_tree().paused = false
	$Overlay.visible = false
