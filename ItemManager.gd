extends Node2D

class_name ItemManager

var foodPrototypes = []
var itemPrototypes = []

var itemsInWorld = []

enum ItemCategory { FOOD = 0, NATURE = 1, HANDY = 2, EQUIPMENT = 3}
var itemCategories = ["Food","Nature","Handy","Equipment"]


# Called when the node enters the scene tree for the first time.
func _ready():
	LoadFood()
	LoadItemPrototypes()
	#print(foodPrototypes)
	
	SpawnItem(foodPrototypes[0],Vector2i(40,20))
	SpawnItem(foodPrototypes[0],Vector2i(21,7))
	SpawnItem(foodPrototypes[0],Vector2i(33,13))
	SpawnItem(foodPrototypes[0],Vector2i(23,10))
	SpawnItemByName("res://Item/Plant/BerryBush.tscn",1,Vector2i(10,10))
	SpawnItemByName("res://Item/Plant/BerryBush.tscn",1,Vector2i(15,20))
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SpawnItem(item, pos):
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld.append(newItem)
	newItem.position = World2BlockPosition(pos)
	
func SpawnItemByName(itemName : String, amount : int, mapPosition : Vector2i):
	var newItem
	
	for item in itemPrototypes:
		if item.get_path() == itemName:
			newItem = item.instantiate()
			newItem.count = amount
		
	if newItem != null:
		add_child(newItem)
		itemsInWorld.append(newItem)
		newItem.position = World2BlockPosition(mapPosition)
			
	
#按格子(16像素坐标化)
func World2BlockPosition(pos) -> Vector2:
	return Vector2(pos.x * 16 + 8, pos.y * 16 + 8)
	
static func Block2WorldPosition(pos) -> Vector2i:
	return Vector2i(pos.x / 16, pos.y / 16 )
	
func FindNearestItem(itemCategory : ItemCategory, worldPosition: Vector2):
	if len(itemsInWorld) == 0:
		return null
	
	var nearestItem = null
	var nearestDistance = 99999999
	
	for item in itemsInWorld:
		if IsItemInCategory(item, itemCategory):
			var distance = worldPosition.distance_to(item.position)
			
			if nearestItem == null:
				nearestItem = item
				nearestDistance = distance
				continue
			
			if distance < nearestDistance:
				nearestItem = item
				nearestDistance = distance
				
	return nearestItem
	

func RemoveItemFromWorld(item):
	remove_child(item)
	itemsInWorld.erase(item)

func IsItemInCategory(item,itemCategory: ItemCategory) -> bool:
	return item.is_in_group(itemCategories[itemCategory])

func LoadFood():
	var path = "res://Item/Food"
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		# 此处排除一下food这个抽象类，且只导入tscn
		elif file_name.ends_with(".tscn") and !file_name.begins_with("Food"):
			foodPrototypes.append(load(path + "/" + file_name))
			print(file_name)

func LoadItemPrototypes():
	var allFileNames = _dir_contents("res://Item/",".tscn")
	for fileName in allFileNames:
		itemPrototypes.append(load(fileName))
		print(fileName)
		
static func _dir_contents(path, suffix) -> Array[String]:
	var dir = DirAccess.open(path)
	if !dir:
		print("An error occurred when trying to access path: %s" % [path])
		return []

	var files: Array[String]
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		file_name = file_name.replace('.remap', '') 
		if dir.current_is_dir():
			files.append_array(_dir_contents("%s/%s" % [path, file_name], suffix))
		elif file_name.ends_with(suffix):
			files.append("%s/%s" % [path, file_name])
		file_name = dir.get_next()
		
	return files
