extends KinematicBody2D

signal looseLife
signal respawnJetpack

onready var deathTimer = get_node("DeathTimer")

const SPEED = 300
const GRAVITY = 35
const JUMPFORCE = -1100
const JUMPFORCE_JETPACK = -2300

const FAN_SPEED = 200
const TOWARDS_FAN_SPEED = 75
const AWAY_FAN_SPEED = 275

var velocity = Vector2(0,0)
var coins = 0
var jumpCount = 0
var onGround = false
var gotHurt = false
var item = "none"
var usedJetpack = true
var playDeadAnimation = false
var playerEnteredFan = false
var fanDirection = 1

onready var playerSpawnpoint = get_parent().get_node("StartPosition").position
onready var lavaSplash = get_parent().get_parent().get_node_or_null("LavaSplash")
onready var playerSprite = get_node(Globals.levelParameters[Globals.levelNumber - 1]["sprite"])

func _ready():
	playerSprite.visible = true

func _physics_process(_delta):
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
				velocity.y = JUMPFORCE_JETPACK	
		else:
			# setzt das Movement während Player im Fan ist
			velocity.x = FAN_SPEED * fanDirection
			velocity.y = -GRAVITY
			
			if Input.is_action_pressed("right"):
				velocity.x = AWAY_FAN_SPEED	if fanDirection == 1 else TOWARDS_FAN_SPEED	
			elif Input.is_action_pressed("left"):
				velocity.x = -TOWARDS_FAN_SPEED if fanDirection == 1 else -AWAY_FAN_SPEED
		
		# Animationen
	if item == "none":		
		if Input.is_action_pressed("right"):
			playerSprite.flip_h = false
			if is_on_floor():
				playerSprite.play("walk")
		elif Input.is_action_pressed("left"):
			playerSprite.flip_h = true
			if is_on_floor():
				playerSprite.play("walk")
		else:
			if is_on_floor():
				playerSprite.play("idle")
			
		if not is_on_floor() :
			if playDeadAnimation:
				playerSprite.play("dead")
			else:
				playerSprite.play("jump")

	elif item == "Jetpack":
		if Input.is_action_pressed("right"):
			playerSprite.flip_h = false
			if is_on_floor():
				playerSprite.play("walkJetpack")
		elif Input.is_action_pressed("left"):
			playerSprite.flip_h = true
			if is_on_floor():
				playerSprite.play("walkJetpack")
		else:
			if is_on_floor():
				playerSprite.play("idleJetpack")
			
		if not is_on_floor() and not usedJetpack:
			playerSprite.play("jumpJetpack")
			
		if Input.is_action_just_pressed("fly") and is_on_floor():
			playerSprite.play("flyJetpack")
			usedJetpack = true
			
	# Lässt den Player fallen|Je länger er fällt desto schneller fällt er
	velocity.y += GRAVITY
	
	# guckt ob Spieler auf dem Boden
	# setzt die Variablen, damit Player nicht beim fallen springen kann
	# setzt jump_count sinnvoll zurück
	if is_on_floor():
		if onGround == false:
			onGround = true
			jumpCount = 0
	else:
		if onGround == true:
			onGround = false
			# auf 2 kann der Player nicht nochmal in der Luft beim Fallen springen| auf 1 einmal
			jumpCount = 1
		
	# Lässt den Player springen|just verhindert gedrückt halten
	# is_on_floor() verhindert springen in der Luft
	if Input.is_action_just_pressed("jump"):
		if Globals.doubleJumpActive == true:
			# ermöglicht Doppelsprung
			if jumpCount < 2:
				jumpCount += 1
				velocity.y = JUMPFORCE
				onGround = false
		elif is_on_floor():
			velocity.y = JUMPFORCE
			
	
	# Funktion des KinematicBody2D|Player bewegt sich durch diese Funktion
	# move_and_slide returned Vector2 also eine Velocity|Reseted Z. 17 gesetzte Velocity
	# Vector2.UP bestimmt die Richtung des Bodens (0,-1)
	velocity = move_and_slide(velocity,Vector2.UP)
	
	# lerp = linear interpolation|kleine Änderungen über Zeit zwischen zwei Zahlen
	# Spieler bleibt durch diese Funktion langsam wieder stehen
	velocity.x = lerp(velocity.x,0,0.1)
	
	# checkt mit was der Player gerade kollidiert
	# wenn er mit lava kollidiert stirbt er
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Lava":
			lavaSplash.visible = true
			lavaSplash.play("splash")
			lavaSplash.position = $PlayerPosition.global_position
			$CollisionShape2D.set_deferred("disabled", true)
			velocity.y = -700
			velocity.x = 0
			self.set_process_input(false)	
			self.collision_mask = 0
			self.collision_layer = 0
			playerDeath()
			break;	

func _on_LavaSplash_animation_finished():
	lavaSplash.stop()
	lavaSplash.visible = false
				
# Signal vom Enemy aus
func _on_Enemy_playerGotHurt():
	velocity.y = -700
	$CollisionShape2D.set_deferred("disabled", true)
	playerSprite.play("idle")
	self.collision_mask = 0
	self.collision_layer = 0
	playerDeath()

# Signal von der FallZone  aus
# Wenn die FallZone (Area2D) betreten wird, also man runterfällt, wird die Szene reseted
func _on_FallZone_body_entered(_body):
	playerDeath()
	
# get_tree() gibt den Szenenbaum, wo sich die Node drin befindet zurück
# mit change_scene wird dann die Szene zu der der Player wechseln soll ausgewählt
func playerDeath():
	gotHurt = true
	$DeathSound.play()
	playDeadAnimation = true;
	deathTimer.set_wait_time(1)
	deathTimer.start() 
	yield(deathTimer, "timeout") 
	# checkt ob Leben = 1 ist| gleich 1, weil Leben erst danach durch das Signal auf null gesetzt wird
	if Globals.life == 1:		
		Globals.reset()
		if get_tree().change_scene(Globals.GAME_OVER) != OK:
			print("An unexpected error occured when trying to switch to the " + Globals.GAME_OVER + " scene")
	else:
		# setzt die Player(self) Position auf die Position der Position2D Node zurück
		self.position = playerSpawnpoint
		$CollisionShape2D.set_deferred("disabled", false)
		self.collision_mask = 127
		self.collision_layer = 1
		gotHurt = false
		# sendet Signal an das HUD, um dort das Leben richtig anzuzeigen
		emit_signal("looseLife")
		
		playDeadAnimation = false;
		
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

# setzt den Spawnpoint auf die jetzige Position beim Checkpoint
func _on_Checkpoint_checkpointChecked():
	playerSpawnpoint = self.position

# Signal des Fans, was angibt, ob Player in der Area2D ist oder nicht
func _on_Fan_playerEnteredFan(_playerEnteredFan, _fanDirection):
	playerEnteredFan = _playerEnteredFan
	fanDirection = _fanDirection



