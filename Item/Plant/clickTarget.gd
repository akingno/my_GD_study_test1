extends Area2D


# 下面这个函数当点击时会自动调用
func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("camera_pan"):
		get_parent().OnClick()
