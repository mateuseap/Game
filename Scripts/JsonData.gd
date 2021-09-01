extends Node

var itemsData: Dictionary

func _ready():
	itemsData = loadData("res://Scripts/Data/ItemsData.json")
	
func loadData(filePath):
	var jsonData
	var fileData = File.new()
	
	fileData.open(filePath,File.READ)
	jsonData = JSON.parse(fileData.get_as_text())
	fileData.close()
	return jsonData.result
