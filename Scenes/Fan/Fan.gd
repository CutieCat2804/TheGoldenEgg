extends Node2D

signal playerEnteredFan

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


func _on_Area2D_body_entered(body):
	emit_signal("playerEnteredFan", true)

func _on_Area2D_body_exited(body):
	emit_signal("playerEnteredFan", false)
