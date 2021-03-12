extends Node

var highscore
var m
var s
var ms

var doubleJumpActive
var life
var level
var coinCount

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
