extends Area2D
var can_interact = false 
const DIALOG = preload("res://Prefabs/DialogBox.tscn")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		can_interact = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
		can_interact = false

func _input(_event):
	if Input.is_key_pressed(KEY_T) and can_interact == true:
		$Label.visible = false
		can_interact = false
		var dialog = DIALOG.instance()
		get_parent().add_child(dialog)
