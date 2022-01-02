extends Control
	
func _on_Level_pressed(number: int):
	if Globals.levelNumber:
		get_node("Level" + str(Globals.levelNumber)).disabled = false
	
	Globals.levelNumber = number
	Globals.setLevel()
	
	$PlayButton.visible = true
	$HighscoreLabel.visible = true
	$HighscoreTitle.visible = true
	$DoubleJumpLabel.visible = Globals.levelParameters[Globals.levelNumber - 1]["doubleJump"]
	$ParametersLabel.visible = true
	$ParametersLabel.text = Globals.levelParameters[Globals.levelNumber - 1]["parameters"]
	
	get_node("Level" + str(Globals.levelNumber)).disabled = true
		
func _on_PlayButton_pressed():
	if Globals.levelParameters[Globals.levelNumber - 1]["doubleJump"] && Globals.doubleJumpActive == true:
		if get_tree().change_scene(Globals.level) != OK:
			print("An unexpected error occured when trying to switch to the " + Globals.level + " scene")
	elif !Globals.levelParameters[Globals.levelNumber - 1]["doubleJump"]:
		if get_tree().change_scene(Globals.level) != OK:
			print("An unexpected error occured when trying to switch to the " + Globals.level + " scene")
			
func _on_MainMenuButton_pressed():
	if get_tree().change_scene(Globals.TITLE_MENU) != OK:
			print("An unexpected error occured when trying to switch to the titleMenu scene")
	

