extends Sprite2D


class_name Buff
enum Effect {FAST = 1, SLOW = 2}

@export var last_time : float
@export var effect : Effect

func _init():
	add_to_group("Buff")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
