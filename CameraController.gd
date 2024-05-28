extends Camera2D

@export var zoomSpeed : float = 50

var zoomTarget : Vector2

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	zoomTarget = zoom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag()
	
func Zoom(delta):
	# 如果不设置线性镜头缩放，则不需要zoomTarget，直接使用zoom *= 1.1 就行，也不需要slerp
	if Input.is_action_just_pressed("camera_zoom_in"):
		#防止过大
		if zoomTarget >= Vector2(8.14,8.14):
			zoomTarget = Vector2(8.14,8.14)
		else:	
			zoomTarget = zoom * 1.1
	if Input.is_action_just_pressed("camera_zoom_out"):
		#防止过小
		if zoomTarget <= Vector2(0.21,0.21):
			zoomTarget = Vector2(0.21,0.21)
		else:	
			zoomTarget = zoom * 0.9
		
	
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta) # 这个 50 * delta很好
	
	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x -= 10
	if Input.is_action_pressed("camera_move_right"):
		moveAmount.x += 10
	if Input.is_action_pressed("camera_move_up"):
		moveAmount.y -= 10
	if Input.is_action_pressed("camera_move_down"):
		moveAmount.y += 10
	
	# 归一化防止镜头缩放导致的过慢
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1 / zoom.x)
	

func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
	
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * (1 / zoom.x)
