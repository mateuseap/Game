extends Control

var dialog = [ 'oi coisinha esquisita', ' poderia me ajudar com umas coisas?', ' DAYLOLLLLLLLLLLLL']
var dialog2 = ['coisinha esquisita, você conseguiu....']
var dialog_index = 0
var finished = false
var inventory
var quest = false

func _ready():
	inventory = PlayerInventory.inventory
	for item in inventory:
		if inventory[item][0] == "Slime Potion" and inventory[item][1] != 0:
			quest = true
			print(quest)
	load_dialog()

func _physics_process(_delta):
	$"Ind".visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()
		
func load_dialog():
	if quest == true:
		if dialog_index < dialog2.size():
			finished = false 
			$Text.bbcode_text = dialog2[dialog_index]
			$Text.percent_visible = 0
			$Tween.interpolate_property(
				$Text, "percent_visible", 0, 1, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			$Tween.start()
		else:
			queue_free()
		dialog_index += 1
	else:
		if dialog_index < dialog.size():
			finished = false 
			$Text.bbcode_text = dialog[dialog_index]
			$Text.percent_visible = 0
			$Tween.interpolate_property(
				$Text, "percent_visible", 0, 1, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			$Tween.start()
		else:
			queue_free()
		dialog_index += 1

func _on_Tween_tween_completed(_object, _key):
	finished = true
