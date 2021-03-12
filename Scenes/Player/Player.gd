extends KinematicBody2D

signal looseLife

onready var deathTimer = get_node("DeathTimer")

# velocity bestimmt die Position des Players
var velocity = Vector2(0,0)
var coins = 0
const SPEED = 300
const GRAVITY = 35
const JUMPFORCE = -1100

var jump_count = 0
var on_ground = false

# beinhaltet alles, was sechzig Mal pro Sekunde ausgeführt werden soll (z.B Bewegung)
func _physics_process(delta):
	# right und left selbst erstellter Input
	# Input Tasten ändern: Project - Input Map - Add New Action - Press Plus - Bind Key
	# Sprite.play() setzt die Animation|Sprite.flip_h flippt die Animation
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite.flip_h = false
		if is_on_floor():
			$Sprite.play("walk")
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite.flip_h = true
		if is_on_floor():
			$Sprite.play("walk")
	else:
		if is_on_floor():
			$Sprite.play("idle")
		
	if not is_on_floor():
		$Sprite.play("jump")
		
	# Lässt den Player fallen|Je länger er fällt desto schneller fällt er
	velocity.y = velocity.y + GRAVITY
	
	# guckt ob Spieler auf dem Boden
	# setzt die Variablen, damit Player nicht beim fallen springen kann
	# setzt jump_count sinnvoll zurück
	if is_on_floor():
		if on_ground == false:
			on_ground = true
			jump_count = 0
	else:
		if on_ground == true:
			on_ground = false
			# auf 2 kann der Player nicht nochmal in der Luft beim Fallen springen| auf 1 einmal
			jump_count = 1
		
	# Lässt den Player springen|just verhindert gedrückt halten
	# is_on_floor() verhindert springen in der Luft
	if Input.is_action_just_pressed("jump"):
		if Globals.doubleJumpActive == true:
			# ermöglicht Doppelsprung
			if jump_count < 2:
				jump_count += 1
				velocity.y = JUMPFORCE
				on_ground = false
		elif is_on_floor():
			velocity.y = JUMPFORCE
			
	
	# Funktion des KinematicBody2D|Player bewegt sich durch diese Funktion
	# move_and_slide returned Vector2 also eine Velocity|Reseted Z. 17 gesetzte Velocity
	# Vector2.UP bestimmt die Richtung des Bodens (0,-1)
	velocity = move_and_slide(velocity,Vector2.UP)
		
	# lerp = linear interpolation|kleine Änderungen über Zeit zwischen zwei Zahlen
	# Spieler bleibt durch diese Funktion langsam wieder stehen
	velocity.x = lerp(velocity.x,0,0.1)

# Wenn die FallZone (Area2D) betreten wird, also man runterfällt, wird die Szene reseted
# get_tree() gibt den Szenenbaum, wo sich die Node drin befindet zurück
# mit change_scene wird dann die Szene zu der der Player wechseln soll ausgewählt
func _on_FallZone_body_entered(body):
	$DeathSound.play()
	deathTimer.set_wait_time(1)
	deathTimer.start() 
	yield(deathTimer, "timeout") 
	# checkt ob Leben = 1 ist| gleich 1, weil Leben erst danach durch das Signal auf null gesetzt wird
	if Globals.life == 1:		
		Globals.reset()
		get_tree().change_scene("res://Scenes/Menus/GameOver+Win/GameOver.tscn")
	else:
		# setzt die Player(self) Position auf die Position der Position2D Node zurück
		self.position = get_parent().get_node("Position2D").position
		# sendet Signal an das HUD, um dort das Leben richtig anzuzeigen
		emit_signal("looseLife")
