extends Node2D

signal leverIsPressed

var playerHasEntered
var isActive = false

func _physics_process(delta):
	if(playerHasEntered && Input.is_action_just_pressed("action")):
		isActive = !isActive
		emit_signal("leverIsPressed", isActive)
		changeLeverSprite()
	
func changeLeverSprite():
	$LeverSpriteDeactive.visible = !$LeverSpriteDeactive.visible
	$LeverSpriteActive.visible = !$LeverSpriteActive.visible

func _on_Area2D_body_entered(body):
	playerHasEntered = true	
	$KeySprite.visible = true
	
func _on_Area2D_body_exited(body):
	playerHasEntered = false	
	$KeySprite.visible = false
