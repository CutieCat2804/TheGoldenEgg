extends Control

func _ready():
	$DoubleJumpLabel.text = ""
	
func _on_Level_pressed(name: String, doubleJumpRequired: bool):
	if doubleJumpRequired == true && Globals.doubleJumpActive == true:
		Globals.level = "res://Scenes/Level/"+ name +".tscn"
		get_tree().change_scene(Globals.level)
	elif doubleJumpRequired == true && Globals.doubleJumpActive == false:
		$DoubleJumpLabel.text = "Das Level benötigt einen Doppelsprung!"
	else:
		Globals.level = "res://Scenes/Level/"+ name +".tscn"
		get_tree().change_scene(Globals.level)
		
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/Menus/TitleMenu/TitleMenu.tscn")
