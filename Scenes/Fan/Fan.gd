extends Node2D

signal playerEnteredFan

# Wenn Lever gedrückt wird | schickt isActive mit
func _on_Lever_leverIsPressed(isActive):
	if(isActive):
		$AnimationPlayer.play("spin")
		$Wind.play()
		$Wind.visible = true
		$Area2D.collision_mask = 32
		$Area2D.collision_layer = 32
	else:
		$AnimationPlayer.stop()
		$Wind.stop()
		$Wind.frame = 0
		$Wind.visible = false
		$Area2D.collision_mask = 0
		$Area2D.collision_layer = 0

# Signal zum Player, um dort das Movement anzupassen
func _on_Area2D_body_entered(_body):
	emit_signal("playerEnteredFan", true)

func _on_Area2D_body_exited(_body):
	emit_signal("playerEnteredFan", false)
