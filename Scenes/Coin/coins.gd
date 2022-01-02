extends Node2D

var count = 0
var children

func _on_HUD_coinCount():
	children = get_node(".").get_children()
	for i in children:
		count += 1
	Globals.coinCount = count

