extends Node

class_name TaskManager

var taskQueue = []

func RequestTask():
	if len(taskQueue) > 0:
		var task = taskQueue[0]
		taskQueue.erase(task)
		return task
	return null	

func RequestFindAndEatFoodTask():
	var task = Task.new()
	task.InitFindAndEatFoodTask()
	return task

func AddTask(taskType, targetItem):
	var newTask = Task.new()
	
	if taskType == Task.TaskType.Harvest:
		newTask.InitFindAndHarvestTask(targetItem)
		taskQueue.append(newTask)
		
