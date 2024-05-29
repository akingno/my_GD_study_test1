extends Plant

class_name BerryBush




func _init():
	super._init()
	harvestDifficulty = 1 
	harvestItem  = "res://Item/Food/Berry.tscn"
	harvestAmount = Vector2i(5,15)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func OnClick():
	taskManager.AddTask(Task.TaskType.Harvest,self)
