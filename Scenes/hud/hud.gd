extends CanvasLayer

signal coinCount

var coins = 0

# holt sich den Timer aus dem NodeTree
onready var winningTimer = get_node("WinningTimer")
onready var timerLabel = get_node("TimerLabel")

var ms = 0
var s = 0
var m = 0
var score = 0

# wird ausgeführt, wenn die Node geladen wird
# setzt den Text des Labels am Anfang auf 0|Konvertiert Number zu String
func _ready():
	if Globals.coinCount == 0:
		emit_signal("coinCount")
	$Coins.text = ("0" + str(coins) if str(coins).length() == 1 else str(coins)) + "/" + str(Globals.coinCount)
	$Life.text = str(Globals.life)
	

func _physics_process(_delta):	
	# Erstellt einen Timer, der in dem Label angezeigt wird
	# Innerhalb von Timer muss Wait Time auf 0.1 gestellt sein und das timeout Signal muss verwendet werden 
	# auto start muss an sein und one shot aus
	if ms > 9 :
		s += 1
		ms = 0
		
	if s > 59 :
		m += 1
		s = 0
		
	timerLabel.text = ("0" + str(m) if str(m).length() == 1  else str(s)) + ":" + ("0" + str(s) if str(s).length() == 1  else str(s)) + ":0" + str(ms)
	
	# reseted das Spiel, wenn der Player genug Coins eingesammelt
	if coins == Globals.coinCount - 1:
		# setzt Timer damit Winning Screen erst nach kurzem kommt
		winningTimer.set_wait_time(0.5)
		winningTimer.start() # startet den Timer
		yield(winningTimer, "timeout") # wartet bis Timer ausläuft
		# wird erst ausgeführt, wenn timer abgelaufen ist
		Globals.reset()
		if get_tree().change_scene(Globals.WIN_SCREEN) != OK:
			print("An unexpected error occured when trying to switch to the " + Globals.WIN_SCREEN + " scene")
		
		# checkt, ob jetziger score besser ist als der vorherige Highscore
		score = timerLabel.text
		if Globals.m > m :
			Globals.highscore = score
			setGlobals()
		elif Globals.m == m:
			if Globals.s > s :
				Globals.highscore = score
				setGlobals()
			elif Globals.s == s :
				if Globals.ms > ms :
					Globals.highscore = score
					setGlobals()

# Wenn Player einen Coin aufsammelt, sendet coin.gd ein Signal, was diese Methode ausführt
# erhöht coins um 1
func _on_coin_collected():
	coins = coins + 1
	_ready()

# gehört zum Timer, setzt die Millisekunden hoch
func _on_Timer_timeout():
	ms += 1

# um Code Dopplungen zu verhindern
func setGlobals(): 
	Globals.m = m
	Globals.s = s
	Globals.ms = ms

# wird ausgeführt, wenn Player in die FallZone fällt (Player Script)
func _on_Player_looseLife():
	# setzt das Leben im HUD
	Globals.life -= 1
	$Life.text = String(Globals.life)
