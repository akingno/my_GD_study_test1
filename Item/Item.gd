extends Sprite2D
class_name Item

enum Modifier {None = -2, Trash = -1, Normal = 0, Good = 1, Matser = 2}

@export var id : int
@export var count : int
@export var weight : float
@export var value : float
@export var modifier : Modifier


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
