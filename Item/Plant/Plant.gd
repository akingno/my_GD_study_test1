extends Item

class_name Plant
enum FoodType {Normal = 0, Vege = 1, Meat = 2}

var harvestProgress : float = 0
var harvestDifficulty : float

var harvestItem : String
var harvestAmount : Vector2i

func _init():
	add_to_group("Plant")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func TryHarvest(amount : float) -> bool:
	harvestProgress += amount * 1 / harvestDifficulty
	
	if harvestProgress >= 1:
		itemManager.RemoveItemFromWorld(self)
		var rng = RandomNumberGenerator.new()
		itemManager.SpawnItemByName(harvestItem, randi_range(harvestAmount.x, harvestAmount.y), ItemManager.Block2WorldPosition(position))
		print(ItemManager.Block2WorldPosition(position))
		return true
	else:
		return false
		
