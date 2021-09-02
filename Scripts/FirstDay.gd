extends Node2D

export var numPotions:int = 2

signal dayEnded

func _on_ItemDrop_pickedUp():
	numPotions-=1
	if numPotions==0:
		emit_signal("dayEnded")
		
