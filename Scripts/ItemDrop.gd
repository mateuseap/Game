extends KinematicBody2D

var itemName
var speed = Vector2.ZERO
var player = null
var beingPickedUp

signal pickedUp

const MAX_SPEED = 225
const ACCELERATION = 460

func _ready():
	itemName = "Slime Potion"

func _physics_process(delta):
	if beingPickedUp:
		var direction = global_position.direction_to(player.global_position)
		speed = speed.move_toward(direction*MAX_SPEED,ACCELERATION*delta)
		var distance = global_position.distance_to(player.global_position)		
		if distance < 12:
			if PlayerInventory.addItem(itemName,1):
				#print("O item foi pego")
				queue_free()
				emit_signal("pickedUp")
			else:
				#print("Inventario Cheio")
				pass
			beingPickedUp = false

func pickUpItem(body):
	player = body
	beingPickedUp = true
