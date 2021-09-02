extends Node2D

var nextScene = null


func transitionToScene(newScene: String):
	nextScene = newScene
	$SceneTransition/AnimationPlayer.play("FadeToBlack")
	
func finishedFading():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(nextScene).instance())
	$SceneTransition/AnimationPlayer.play("FadeToNormal")


func _on_FirstDay_dayEnded():
	transitionToScene("res://Scenes/SecondDay.tscn")
