extends Node

signal activeItemUpdated

const SlotClass = preload("res://Scripts/Slot.gd")
const ItemClass = preload("res://Scripts/Item.gd")
const INVENTORY_SLOTS = 20
const HOTBAR_SLOTS = 8

var inventory = {
	0: ["Slime Potion", 0], #Índice do inventário, item e quantidade desejada
	1: ["Tree Branch", 98],
	2: ["Slime Potion", 0]
}

var hotbar = {
	0: ["Iron Sword", 1], #Índice do inventário, item e quantidade desejada
	1: ["Slime Potion", 0]
}

var activeItemSlot = 0

func addItem(itemName, itemQuantity):
	for item in inventory:
		if inventory[item][0] == itemName:
			var stackSize = int(JsonData.itemsData[itemName]["StackSize"])
			var ableToAdd = stackSize-inventory[item][1]
			if ableToAdd >= itemQuantity:
				inventory[item][1] += itemQuantity
				updateSlotVisual(item, inventory[item][0], inventory[item][1])
				return true
			else:
				inventory[item][1] += ableToAdd
				updateSlotVisual(item, inventory[item][0], inventory[item][1])
				itemQuantity = itemQuantity-ableToAdd
	for i in range(INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [itemName,itemQuantity]
			updateSlotVisual(i, inventory[i][0], inventory[i][1])
			return true
	return false

func updateSlotVisual(slotIndex, itemName, newItemQuantity):
	var currentDay = get_path_to(get_node("/root/SceneManager/CurrentScene").get_child(0)).get_name(3)
	var slot = get_node("/root/SceneManager/CurrentScene/"+currentDay+"/UserInterface/Inventory/GridContainer/Slot"+str(slotIndex+1))
	if slot.item != null:
		slot.item.setItem(itemName,newItemQuantity)
	else:
		slot.initializeItem(itemName,newItemQuantity)

func removeItem(slot: SlotClass, isHotbar: bool = false):
	if isHotbar:
		hotbar.erase(slot.slotIndex)
	else:
		inventory.erase(slot.slotIndex)

func addItemToEmptySlot(item: ItemClass, slot: SlotClass, isHotbar: bool = false):
	if isHotbar:
		hotbar[slot.slotIndex] = [item.itemName,item.itemQuantity]
	else:
		inventory[slot.slotIndex] = [item.itemName,item.itemQuantity]

func addItemQuantity(slot: SlotClass, quantityToAdd: int, isHotbar: bool = false):
	if isHotbar:
		hotbar[slot.slotIndex][1] += quantityToAdd
	else:
		inventory[slot.slotIndex][1] += quantityToAdd
	
func activeItemScrollUp():
	activeItemSlot = (activeItemSlot+1)%HOTBAR_SLOTS
	emit_signal("activeItemUpdated")

func activeItemScrollDown():
	if activeItemSlot == 0:
		activeItemSlot = HOTBAR_SLOTS-1
	else:
		activeItemSlot -= 1
	emit_signal("activeItemUpdated")

