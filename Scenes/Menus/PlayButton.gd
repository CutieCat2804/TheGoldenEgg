extends Button

# Wenn Button gedrückt wird, ändert sich die Szene zur Level Szene
func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Level/Level.tscn")
