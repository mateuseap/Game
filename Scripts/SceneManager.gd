extends Node2D

var nextScene = null
var wasTrue

func transitionToScene(newScene: String):
	$UserInterface/Hotbar.visible = false
	if $UserInterface/Inventory.visible == true:
		$UserInterface/Inventory.visible = false
		wasTrue = true
	else:
		wasTrue = false
	nextScene = newScene
	$SceneTransition/AnimationPlayer.play("FadeToBlack")
	
func finishedFading():
	$UserInterface/Hotbar.visible = true
	if wasTrue:
		$UserInterface/Inventory.visible = true
		wasTrue = false
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(nextScene).instance())
	$SceneTransition/AnimationPlayer.play("FadeToNormal")

func _on_FirstDay_dayEnded():
	transitionToScene("res://Scenes/SecondDay.tscn")
