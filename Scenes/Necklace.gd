extends Area2D

func _on_Necklace_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		
		
