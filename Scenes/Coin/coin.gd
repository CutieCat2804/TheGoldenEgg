extends Area2D

signal coin_collected

export var playAnimation = true

func _ready():
	if playAnimation:
		$AnimationPlayer.play("bounce")
	
# wird ausgeführt, wenn der Player den Coin berührt
# spielt die Collect Animation und Sound ab
# sendet ein Custom Signal an HUD, um mitzuteilen, dass ein Coin eingesammelt wurde
func _on_coin_body_entered(_body):
	if playAnimation:
		$AnimationPlayer.play("collect")
	$CoinSound.play()
	emit_signal("coin_collected")
	# verhindert, dass der Coin mehrmals eingesammelt werden kann
	# erste value bit --> kann im Inspector bei Mask hover gesehen werden
	set_collision_mask_bit(0, false)
	
# lässt den Coin verschwinden, wenn die ANimation fertig ist
func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
