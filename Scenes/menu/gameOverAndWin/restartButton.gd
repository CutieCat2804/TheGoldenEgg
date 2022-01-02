extends Button

func _on_RestartButton_pressed():
	if get_tree().change_scene(Globals.level) != OK:
		print("An unexpected error occured when trying to switch to the Readme scene")
