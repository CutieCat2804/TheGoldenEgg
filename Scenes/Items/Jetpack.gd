extends Node2D

signal jetpack_collected

func _on_Area2D_body_entered(_body):
	$AnimationPlayer.play("collect")
	$JetpackSound.play()
	$Area2D.set_collision_layer_bit(3, false)

# Animation wird erst zu Ende gespielt, dann passiert das folgende
func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("jetpack_collected")
	self.visible = false

func _on_Player_respawnJetpack():
	$Area2D.set_collision_layer_bit(3, true)
	self.visible = true
	$AnimationPlayer.play("bounce")
