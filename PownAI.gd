extends Node

@onready var taskManager = $"../../TaskManager"
@onready var itemManeger = $"../../ItemManager"
@onready var charController = $".."

@onready var hungerBar = $"../hungerBar"

@export var nutrition_variable : int
@export var hungery_line : float

enum PawnAction {Idle, DoingSubTask}

var currentActtion : PawnAction = PawnAction.Idle

var currentTask : Task = null
var inHand

var foodNeed : float = 0.4
var eatSpeed : float = 0.5
var foodNeedDepleteSpeed : float = 0.05


func _process(delta):
	
	foodNeed -= foodNeedDepleteSpeed * delta
	hungerBar.value = foodNeed * 100 #用来显示百分比
	
	#如果当前任务未完成，就做当前任务
	if currentTask != null:
		DoCurrentTask(delta)
	else:
		if foodNeed < hungery_line:
		#如果当前任务完成过了，就通过taskManager要求新任务
			currentTask = taskManager.RequestTask()

func OnPickUpItem(item):
	inHand = item
	itemManeger.RemoveItemFromWorld(item)
	
		
func OnFinishedSubTask():
	# 当前subtask完成，改为空闲状态
	currentActtion = PawnAction.Idle
	#如果当前任务完成，设为null
	if currentTask.IsFinished():
		currentTask = null

# 如果有任务未完成，则开始做此任务:
func DoCurrentTask(delta):
	var subTask = currentTask.GetCurrentSubTask()
	# 如果当前task是idle(空闲)，则切换到下一个动作
	if currentActtion == PawnAction.Idle:
		StartCurrentSubTask(subTask)
	else:
		# 此时currentAction = PawnAction.DoingSubTask
		# 此时的情况未：在做非瞬时性的工作，所以分离出StartCurrentSubTask
		match subTask.taskType:
			Task.TaskType.WalkTo:
				if charController.HasReachedDestination():
					currentTask.OnReachedDestination()
					OnFinishedSubTask()
			Task.TaskType.Eat:
				if itemManeger.IsItemInCategory(inHand, itemManeger.ItemCategory.FOOD):
					if inHand.nutrition > 0 and foodNeed < 1:
						inHand.nutrition -= eatSpeed * delta
						foodNeed += eatSpeed * delta * nutrition_variable #(这里×了个100来调整吃一次回复的营养值)
					else:
						print("finished eating food")
						inHand = null
				else:
					print("this is not food")
				
				currentTask.OnFinishSubTask()
				OnFinishedSubTask()
	
func StartCurrentSubTask(subTask):
	print("Starting subtask: " + Task.TaskType.keys()[subTask.taskType])
	
	match subTask.taskType:
		Task.TaskType.FindItem:
			var targetItem = itemManeger.FindNearestItem(subTask.targetItemType, charController.position)
			if targetItem == null:
				print("no item, force task to finish")
				currentTask.Finish()
			else:
				currentTask.OnFoundItem(targetItem)
				
			OnFinishedSubTask()
		
		Task.TaskType.WalkTo:
			charController.SetMoveTarget(subTask.targetItem.position)
			#如果动作需要超过一帧
			currentActtion = PawnAction.DoingSubTask
			# OnFinishedSubTask()
			
		Task.TaskType.PickUp:
			OnPickUpItem(subTask.targetItem)
			currentTask.OnFinishSubTask()
			OnFinishedSubTask()
		
		Task.TaskType.Eat:
			currentActtion = PawnAction.DoingSubTask
