extends Button

func _on_MenuButton_pressed():
	if get_tree().change_scene("res://scenes/menu/titleMenu/titleMenu.tscn") != OK:
		print("An unexpected error occured when trying to switch to the Readme scene")
