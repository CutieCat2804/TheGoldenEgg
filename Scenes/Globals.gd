extends Node

var highscore
var m
var s
var ms

var doubleJumpActive

var life

func _ready():
	highscore = "-------"
	m = 100
	s = 100
	ms = 100
	doubleJumpActive = false
	life = 3

func resetLife():
	life = 3
