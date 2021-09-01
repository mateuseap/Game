extends KinematicBody2D

onready var playerAnimation = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var speed = Vector2.ZERO

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

func _physics_process(delta):
	move(delta)
	speed = move_and_slide(speed)
		
func move(delta):
	var movement = Vector2.ZERO
	
	movement.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	movement.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")	
	movement = movement.normalized()
	
	if movement != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position",movement)
		animationTree.set("parameters/Run/blend_position",movement)
		animationState.travel("Run")
		speed = speed.move_toward(movement*MAX_SPEED,ACCELERATION*delta)
	else:
		animationState.travel("Idle")
		speed = speed.move_toward(Vector2.ZERO,FRICTION*delta)

func _input(event):
	if event.is_action_pressed("pick_up"):
		if $PickUpZone.itemsInRange.size() > 0:
			var pickUpItem = $PickUpZone.itemsInRange.values()[0]
			pickUpItem.pickUpItem(self)
			$PickUpZone.itemsInRange.erase(pickUpItem)
