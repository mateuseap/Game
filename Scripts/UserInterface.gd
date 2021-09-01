extends CanvasLayer

var holdingItem = null

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initializeInventory()
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.activeItemScrollUp()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.activeItemScrollDown()

func _ready():
	pass
