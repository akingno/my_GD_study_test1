extends Node

class_name TaskManager


func RequestTask():
	var task = Task.new()
	task.InitFindAndEatFoodTask()
	return task
