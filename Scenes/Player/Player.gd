extends KinematicBody2D

signal looseLife
signal respawnJetpack
signal changeCheckpointSprite

onready var deathTimer = get_node("DeathTimer")

const SPEED = 300
const GRAVITY = 35
const JUMPFORCE = -1100
const JUMPFORCEJETPACK = -2300

const FANSPEED = 200
const TOWARDSFANSPEED = 75
const AWAYFANSPEED = 275

var velocity = Vector2(0,0)
var coins = 0
var jump_count = 0
var on_ground = false
var gotHurt = false
var item = "none"
var usedJetpack = true

onready var playerSpawnpoint = get_parent().get_node("Position2D").position

var playerEnteredFan = false

func _physics_process(delta):
	if gotHurt == false:
		# right und left selbst erstellter Input
		# Input Tasten ändern: Project - Input Map - Add New Action - Press Plus - Bind Key
		# Sprite.play() setzt die Animation|Sprite.flip_h flippt die Animation
		respawnJetpack()
		
		if !playerEnteredFan:		
			if Input.is_action_pressed("right"):
				velocity.x = SPEED		
			elif Input.is_action_pressed("left"):
				velocity.x = -SPEED
				
			if Input.is_action_just_pressed("fly") and is_on_floor() and item == "Jetpack" and usedJetpack == false:
				velocity.y = JUMPFORCEJETPACK	
		else:
			velocity.x = FANSPEED
			velocity.y = -GRAVITY
			if Input.is_action_pressed("right"):
				velocity.x = AWAYFANSPEED		
			elif Input.is_action_pressed("left"):
				velocity.x = -TOWARDSFANSPEED
		
		# Animationen
	if item == "none":		
		if Input.is_action_pressed("right"):
			$Sprite.flip_h = false
			if is_on_floor():
				$Sprite.play("walk")
		elif Input.is_action_pressed("left"):
			$Sprite.flip_h = true
			if is_on_floor():
				$Sprite.play("walk")
		else:
			if is_on_floor():
				$Sprite.play("idle")
			
		if not is_on_floor() :
			$Sprite.play("jump")

	elif item == "Jetpack":
		if Input.is_action_pressed("right"):
			$Sprite.flip_h = false
			if is_on_floor():
				$Sprite.play("walkJetpack")
		elif Input.is_action_pressed("left"):
			$Sprite.flip_h = true
			if is_on_floor():
				$Sprite.play("walkJetpack")
		else:
			if is_on_floor():
				$Sprite.play("idleJetpack")
			
		if not is_on_floor() and not usedJetpack:
			$Sprite.play("jumpJetpack")
			
		if Input.is_action_just_pressed("fly") and is_on_floor():
			$Sprite.play("flyJetpack")
			usedJetpack = true
			
	# Lässt den Player fallen|Je länger er fällt desto schneller fällt er
	velocity.y += GRAVITY
	
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

	
				
# Signal vom Enemy aus
func _on_Enemy_playerGotHurt():
	velocity.y = -700
	$CollisionShape2D.disabled = true
	$Sprite.play("idle")
	self.collision_mask = 0
	self.collision_layer = 0
	playerDeath()

# Signal von der FallZone  aus
# Wenn die FallZone (Area2D) betreten wird, also man runterfällt, wird die Szene reseted
func _on_FallZone_body_entered(body):
	playerDeath()
	
# get_tree() gibt den Szenenbaum, wo sich die Node drin befindet zurück
# mit change_scene wird dann die Szene zu der der Player wechseln soll ausgewählt
func playerDeath():
	gotHurt = true
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
		self.position = playerSpawnpoint
		$CollisionShape2D.disabled = false
		self.collision_mask = 62
		self.collision_layer = 1
		gotHurt = false
		# sendet Signal an das HUD, um dort das Leben richtig anzuzeigen
		emit_signal("looseLife")
		
		usedJetpack = true
		respawnJetpack()
		
		


func _on_Jetpack_jetpack_collected():
	usedJetpack = false
	item = "Jetpack"
	
func respawnJetpack():
	if item == "Jetpack" and usedJetpack == true:
		if is_on_floor():
			item = "none"
			emit_signal("respawnJetpack")


func _on_Checkpoint_checkpointChecked():
	playerSpawnpoint = self.position


func _on_Fan_playerEnteredFan(_playerEnteredFan):
	playerEnteredFan = _playerEnteredFan
