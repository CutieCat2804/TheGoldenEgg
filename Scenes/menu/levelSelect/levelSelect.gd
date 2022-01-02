extends Control

func _ready():
	$DoubleJumpLabel.text = ""
	
func _on_Level_pressed(name: String, doubleJumpRequired: bool):
	Globals.levelName = name
	if doubleJumpRequired == true && Globals.doubleJumpActive == true:
		Globals.level = "res://scenes/level/"+ name +".tscn"
		if get_tree().change_scene(Globals.level) != OK:
			print("An unexpected error occured when trying to switch to the " + name + " scene")
	elif doubleJumpRequired == true && Globals.doubleJumpActive == false:
		$DoubleJumpLabel.text = "Das Level benötigt einen Doppelsprung!"
	else:
		Globals.level = "res://scenes/level/"+ name +".tscn"
		if get_tree().change_scene(Globals.level) != OK:
			print("An unexpected error occured when trying to switch to the " + name + " scene")
		
func _on_MainMenuButton_pressed():
	if get_tree().change_scene("res://scenes/menu/titleMenu/titleMenu.tscn") != OK:
			print("An unexpected error occured when trying to switch to the titleMenu scene")
	
