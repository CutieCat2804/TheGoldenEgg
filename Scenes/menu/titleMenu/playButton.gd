extends Button

# Wenn Button gedrückt wird, ändert sich die Szene zur Level Szene
func _on_PlayButton_pressed():
	if get_tree().change_scene("res://scenes/menu/levelSelect/levelSelect.tscn") != OK:
		print("An unexpected error occured when trying to switch to the levelSelect scene")
