extends Node2D

var itemName
var itemQuantity

func _ready():
	var randValue = randi()%3
	
	if randValue == 0:
		itemName = "Iron Sword"
	elif randValue == 1:
		itemName = "Tree Branch"
	else:
		itemName = "Slime Potion"
		
	$TextureRect.texture = load("res://Assets/Items/"+itemName+".png")
	var stackSize = int(JsonData.itemsData[itemName]["StackSize"])
	itemQuantity = randi()%stackSize+1
	
	if stackSize == 1:
		$Label.visible = false
	else:
		$Label.text = String(itemQuantity)

func addItemQuantity(amountToAdd):
	itemQuantity += amountToAdd
	$Label.text = String(itemQuantity)

func decreaseItemQuantity(amountToRemove):
	itemQuantity -= amountToRemove
	$Label.text = String(itemQuantity)

func setItem(name, quantity):
	itemName = name
	itemQuantity = quantity
	$TextureRect.texture = load("res://Assets/Items/"+itemName+".png")
	
	var stackSize = int(JsonData.itemsData[itemName]["StackSize"])
	if stackSize == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(itemQuantity)
	
