extends Button

func _on_MenuButton_pressed():
	if get_tree().change_scene(Globals.TITLE_MENU) != OK:
		print("An unexpected error occured when trying to switch to the " + Globals.TITLE_MENU +" scene")
