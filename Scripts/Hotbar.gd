extends Node2D

onready var hotbar = $HotbarSlots
onready var activeItemLabel = $ActiveItemLabel
onready var slots = hotbar.get_children()

const SlotClass = preload("res://Scripts/Slot.gd")

func _ready():
	var _value
	_value = PlayerInventory.connect("activeItemUpdated", self, "updateActiveItemLabel")
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slotGuiInput", [slots[i]])
		_value = PlayerInventory.connect("activeItemUpdated", slots[i], "slotStyle")
		slots[i].slotIndex = i
		slots[i].slotType = SlotClass.SlotType.HOTBAR
	initializeHotbar()
	updateActiveItemLabel()

func updateActiveItemLabel():
	if slots[PlayerInventory.activeItemSlot].item != null:
		activeItemLabel.text = slots[PlayerInventory.activeItemSlot].item.itemName
	else:
		activeItemLabel.text = ""

func initializeHotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initializeItem(PlayerInventory.hotbar[i][0],PlayerInventory.hotbar[i][1])

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
			updateActiveItemLabel()

func leftClickEmptySlot(slot: SlotClass):
	PlayerInventory.addItemToEmptySlot(find_parent("UserInterface").holdingItem,slot,true)
	slot.putIntoSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem = null

func leftClickDifferntItem(event: InputEvent, slot: SlotClass):
	PlayerInventory.removeItem(slot,true)
	PlayerInventory.addItemToEmptySlot(find_parent("UserInterface").holdingItem,slot,true)
	var temporaryItem = slot.item
	slot.pickFromSlot()
	temporaryItem.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holdingItem)
	find_parent("UserInterface").holdingItem = temporaryItem

func leftClickSameItem(slot: SlotClass):
	var stackSize = int(JsonData.itemsData[slot.item.itemName]["StackSize"])
	var ableToAdd = stackSize-slot.item.itemQuantity
	
	if ableToAdd >= find_parent("UserInterface").holdingItem.itemQuantity:
		PlayerInventory.addItemQuantity(slot,find_parent("UserInterface").holdingItem.itemQuantity,true)
		slot.item.addItemQuantity(find_parent("UserInterface").holdingItem.itemQuantity)
		find_parent("UserInterface").holdingItem.queue_free()
		find_parent("UserInterface").holdingItem = null
	else:
		PlayerInventory.addItemQuantity(slot,ableToAdd,true)
		slot.item.addItemQuantity(ableToAdd)
		find_parent("UserInterface").holdingItem.decreaseItemQuantity(ableToAdd)

func leftClickNotHolding(slot: SlotClass):
	PlayerInventory.removeItem(slot,true)
	find_parent("UserInterface").holdingItem = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holdingItem.global_position = get_global_mouse_position()
