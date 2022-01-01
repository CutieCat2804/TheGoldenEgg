extends Node2D

signal checkpointChecked

func _on_Area2D_body_entered(body):
	emit_signal("checkpointChecked")
	changeCheckpointSprite()
	$Area2D.collision_layer = 0

func changeCheckpointSprite():
	$CheckpointSpriteChecked.visible = !$CheckpointSpriteChecked.visible
	$CheckpointSprite.visible = !$CheckpointSprite.visible
