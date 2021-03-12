extends CanvasLayer

onready var pauseMenu = get_node(".")

func _ready():
	pauseMenu.pause_mode = Node.PAUSE_MODE_PROCESS
	$Overlay.visible = false

func _input(event):
	if get_tree().current_scene.name == "Level":
		if event.is_action_pressed("pause"):
			$Overlay.visible = !$Overlay.visible
			get_tree().paused = !get_tree().paused



func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Menus/TitleMenu.tscn")
	$Overlay.visible = false
