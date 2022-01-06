extends Node

var highscore
var m
var s
var ms

var doubleJumpActive
var life
var level
var coinCount
var levelNumber

func _ready():
	highscore = "-------"
	m = 100
	s = 100
	ms = 100
	doubleJumpActive = false
	reset()

func reset():
	life = 3
	coinCount = 0

const WIN_SCREEN = "res://scenes/menu/gameOverAndWin/winScreen.tscn"
const TITLE_MENU = "res://scenes/menu/titleMenu/titleMenu.tscn"
const LEVEL_SELECT = "res://scenes/menu/levelSelect/levelSelect.tscn"
const GAME_OVER = "res://scenes/menu/gameOverAndWin/gameOver.tscn"

func setLevel():
	level = "res://scenes/level/level"+ str(levelNumber) +".tscn"

var levelParameters = [
		{ "doubleJump": false, "highscore": "-------", "parameters": "Jetpack", "sprite": "Beige" }, 
		{ "doubleJump": true, "highscore": "-------", "parameters": "Gegnersteine", "sprite": "Beige" },
		{ "doubleJump": false, "highscore": "-------", "parameters": "Ventilatoren + Schalter", "sprite": "Beige" },
		{ "doubleJump": false, "highscore": "-------", "parameters": "Feuerbälle","sprite": "Brown" }
	]
