extends Item

class_name Food
enum FoodType {Normal = 0, Vege = 1, Meat = 2}

@export var nutrition : float
@export var foodType : FoodType


func _init():
	add_to_group("Food")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
