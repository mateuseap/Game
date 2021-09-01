extends Panel

var defaultTexture = preload("res://Assets/Inventory/item_slot_default_background.png")
var emptyTexture = preload("res://Assets/Inventory/item_slot_empty_background.png")
var selectedTexture = preload("res://Assets/Hotbar/item_slot_selected_background.png")

var defaultStyle: StyleBoxTexture = null
var emptyStyle: StyleBoxTexture = null
var selectedStyle: StyleBoxTexture = null

var ItemClass = preload("res://Prefabs/Item.tscn")
var item = null
var slotIndex
var slotType

enum SlotType {
	HOTBAR = 0,
	INVENTORY
}

func _ready():
	defaultStyle = StyleBoxTexture.new()
	defaultStyle.texture = defaultTexture
	emptyStyle = StyleBoxTexture.new()
	emptyStyle.texture = emptyTexture
	selectedStyle = StyleBoxTexture.new()
	selectedStyle.texture = selectedTexture
	
	#if randi()%2 == 0:
		#item = ItemClass.instance()
		#add_child(item)
	slotStyle()

func initializeItem(itemName, itemQuantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.setItem(itemName,itemQuantity)
	else:
		item.setItem(itemName,itemQuantity)
	slotStyle()

func slotStyle():
	if SlotType.HOTBAR == slotType && PlayerInventory.activeItemSlot == slotIndex:
		set('custom_styles/panel',selectedStyle)
	elif item == null:
		set('custom_styles/panel',emptyStyle)
	else:
		set('custom_styles/panel',defaultStyle)

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.add_child(item)
	item = null
	slotStyle()
	
func putIntoSlot(selectedItem):
	item = selectedItem
	item.position = Vector2.ZERO
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.remove_child(item)
	add_child(item)
	slotStyle()
