extends Button

# Wenn Button gedrückt wird, ändert sich die Szene zur Level Szene
func _on_PlayButton_pressed():
	if get_tree().change_scene(Globals.LEVEL_SELECT) != OK:
		print("An unexpected error occured when trying to switch to the " + Globals.LEVEL_SELECT + " scene")
