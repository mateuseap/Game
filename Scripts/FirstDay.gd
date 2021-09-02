extends Node2D

export var numPotions:int = 2

signal dayEnded

func _on_ItemDrop_pickedUp():
	numPotions-=1

func _process(_delta):
	if numPotions==0:
		emit_signal("dayEnded")
		
func _on_ItemDrop2_pickedUp():
	numPotions-=1
