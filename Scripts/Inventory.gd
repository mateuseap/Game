extends Node2D

onready var inventorySlots = $GridContainer

const SlotClass = preload("res://Scripts/Slot.gd")

func _ready():
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slotGuiInput", [slots[i]])
		slots[i].slotIndex = i
		slots[i].slotType = SlotClass.SlotType.INVENTORY
	initializeInventory()
	
func initializeInventory():
	var slots = inventorySlots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initializeItem(PlayerInventory.inventory[i][0],PlayerInventory.inventory[i][1])

func slotGuiInput(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").holdingItem != null:
				if !slot.item:
					leftClickEmptySlot(slot) #Se clicamos num slot vazio com o botão esquerdo do mouse enquanto seguramos um item, nós chamamos essa função
				else:
					if find_parent("UserInterface").holdingItem.itemName != slot.item.itemName:
						leftClickDifferntItem(event,slot) #Se estamos segurando um item e clicamos num slot que possue um item diferente do que estamos segurando, chamamos essa função
					else:
						leftClickSameItem(slot) #Se estamos segurando um item e clicamos num slot que possue um item igual ao que estamos segurando, chamamos essa função
			elif slot.item:
				leftClickNotHolding(slot) #Quando não estamos segurando um item, nós chamamos essa função

func _input(_event):
	if find_parent("UserInterface").holdingItem:
		find_parent("UserInterface").holdingItem.global_position = get_global_mouse_position()

func leftClickEmptySlot(slot: SlotClass):
	PlayerInventory.addItemToEmptySlot(find_parent("UserInterface").holdingItem,slot)
	slot.putIntoSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem = null

func leftClickDifferntItem(event: InputEvent, slot: SlotClass):
	PlayerInventory.removeItem(slot)
	PlayerInventory.addItemToEmptySlot(find_parent("UserInterface").holdingItem,slot)
	var temporaryItem = slot.item
	slot.pickFromSlot()
	temporaryItem.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem = temporaryItem

func leftClickSameItem(slot: SlotClass):
	var stackSize = int(JsonData.itemsData[slot.item.itemName]["StackSize"])
	var ableToAdd = stackSize-slot.item.itemQuantity
	
	if ableToAdd >= find_parent("UserInterface").holdingItem.itemQuantity:
		PlayerInventory.addItemQuantity(slot,find_parent("UserInterface").holdingItem.itemQuantity)
		slot.item.addItemQuantity(find_parent("UserInterface").holdingItem.itemQuantity)
		find_parent("UserInterface").holdingItem.queue_free()
		find_parent("UserInterface").holdingItem = null
	else:
		PlayerInventory.addItemQuantity(slot,ableToAdd)
		slot.item.addItemQuantity(ableToAdd)
		find_parent("UserInterface").holdingItem.decreaseItemQuantity(ableToAdd)

func leftClickNotHolding(slot: SlotClass):
	PlayerInventory.removeItem(slot)
	find_parent("UserInterface").holdingItem = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holdingItem.global_position = get_global_mouse_position()
