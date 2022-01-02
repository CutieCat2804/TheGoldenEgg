extends KinematicBody2D

signal playerGotHurt

var velocity = Vector2()
# export: Jeder Enemy hat einzeln! diese Variable im Inspector
# Enemies können sich nach belieben in die eine oder andere Richtung bewegen
export var direction = -1
const GRAVITY = 35
const SPEED = 140
const FLOORCHECKERPOSITION = 80

func _ready():
	# setzt die RayCast2D Position auf das linke oder rechte Ende des CollisionShapes2D
	$floor_checker.position.x = FLOORCHECKERPOSITION * direction

func _physics_process(_delta):
	# checkt ob Enemy eine Wand berührt
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		# ändert die Richtung des Enemies
		direction = direction * -1
		
		# spielt die richtige Animation abhängig von der Richtung ab
		if direction == 1:
			$AnimationPlayer.play("rollRight")
		else:
			# spielt die Animation rückwärts ab
			$AnimationPlayer.play_backwards("rollRight")
		
		$floor_checker.position.x = FLOORCHECKERPOSITION * direction
	
	velocity.y += GRAVITY
	
	velocity.x = SPEED * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)

# Signal kommt von der Area2D, die den Damage checkt
func _on_DamageChecker_body_entered(_body):
	print("_on_DamageChecker_body_entered")
	emit_signal("playerGotHurt")
