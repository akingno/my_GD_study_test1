extends Node

class_name Task


enum TaskType {BaseTask, FindItem, WalkTo, PickUp, Eat, Mnipulate, Harvest}

var taskName: String
var taskType : TaskType = TaskType.BaseTask

var subTasks = []
var currentSubTask : int = 0

var targetItem
var targetItemType

func IsFinished() -> bool:
	return currentSubTask == len(subTasks)
	
func Finish():
	currentSubTask = len(subTasks)
	
func GetCurrentSubTask():
	#通过序号获取当前subtask
	return subTasks[currentSubTask]
	
func OnFinishSubTask():
	#此subtask完成
	currentSubTask +=1
	
func OnFoundItem(item):
	#用在FindItem那个subtask中，果找到了物品则调用这个，设定物品
	OnFinishSubTask()
	GetCurrentSubTask().targetItem = item
	
func OnReachedDestination():
	OnFinishSubTask()
	GetCurrentSubTask().targetItem = subTasks[currentSubTask - 1].targetItem
	
func InitFindAndEatFoodTask():
	#创建一个找并且吃的task
	taskName = "Find some food and eat"
	
	var subTask = Task.new()
	subTask.taskType = TaskType.FindItem
	subTask.targetItemType = ItemManager.ItemCategory.FOOD
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.PickUp
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Eat
	subTasks.append(subTask)
	
	
