extends CharacterBody2D

@onready var terrain = $"../Terrain"
@onready var pathfinding = $"../PathFinding"

const SPEED = 300.0

var path = []

func _physics_process(delta):
	#delta:帧间隔时间
	
	if Input.is_action_just_pressed("right_click"):
		var pos = position / terrain.CELL_SIZE
		
		var target_pos = get_global_mouse_position() / terrain.CELL_SIZE
		
		path = pathfinding.RequstPath(pos,target_pos)
	
		
	if(len(path) > 0):
		# 计算其到路径上第一个节点的方向向量direction
		var direction = global_position.direction_to(path[0])
		# 方向向量 * SPEED 计算出速度
		velocity = direction * SPEED * ( 1 / pathfinding.GetSpeedPenalty(position / terrain.CELL_SIZE))
		
		# 如果角色到第一个路径节点距离小于v*delta,就移除第一个节点（表示角色已经到达该节点
		if position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
	
	else: 
		#角色停止移动
		velocity = Vector2(0,0)


	move_and_slide()
