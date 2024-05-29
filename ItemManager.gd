extends Node2D

var foodPrototypes = []
var itemsInWorld = []

enum ItemCategory { FOOD = 0, NATURE = 1, HANDY = 2, EQUIPMENT = 3}
var itemCategories = ["Food","Nature","Handy","Equipment"]


# Called when the node enters the scene tree for the first time.
func _ready():
	LoadFood()
	print(foodPrototypes)
	
	SpawnItem(foodPrototypes[0],Vector2i(10,10))
	SpawnItem(foodPrototypes[0],Vector2i(13,20))
	SpawnItem(foodPrototypes[1],Vector2i(12,30))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SpawnItem(item, pos):
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld.append(newItem)
	newItem.position = World2BlockPosition(pos)
	
#按格子(16像素坐标化)
func World2BlockPosition(pos) -> Vector2:
	return Vector2(pos.x * 16 + 8, pos.y * 16 + 8)
	
func FindNearstItem(itemCategory : ItemCategory, worldPosition: Vector2):
	if len(itemsInWorld) == 0:
		return false
	
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
