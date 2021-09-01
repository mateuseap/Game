extends Area2D

var itemsInRange = {}

func _ready():
	pass 

func _on_PickUpZone_body_entered(body):
	itemsInRange[body] = body
	
func _on_PickUpZone_body_exited(body):
	if itemsInRange.has(body):
		itemsInRange.erase(body)
