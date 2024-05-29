@tool
extends Node2D

@onready var terrain = $"../Terrain"

var astar_grid = AStarGrid2D.new()
var path = []

@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

func _ready():
	InitPathFinding()
	pass
	
	
func _process(delta):
	if calculate:
		calculate = false
		InitPathFinding()
		RequestPath(start,end)
		

# 这个函数调用A*找路径，作微调，并绘制路径
func RequestPath(start : Vector2i, end : Vector2i):
	path = astar_grid.get_point_path(start,end)
	
	#下面这两行代码使得小人走在格子中间。但好像我不需要
	for i in range(len(path)):
		path[i] += Vector2(terrain.CELL_SIZE_HALF,0)
	
	queue_redraw()
	return path


# 绘制路径
func _draw():
	if len(path) > 0:
		for i in range(len(path)-1):
			draw_line(path[i],path[i+1],Color.GRAY)

			
func InitPathFinding():
	#A*算法的范围
	astar_grid.region = Rect2i(0,0,terrain.mapWidth,terrain.mapHeight)
	astar_grid.cell_size = Vector2(terrain.CELL_SIZE, terrain.CELL_SIZE) #CELL_SIZE : 16
	astar_grid.update()
	
	#设置每个格子A*速度乘法
	for x in range(terrain.mapWidth):
		for y in range(terrain.mapHeight):
			if GetSpeedPenalty(Vector2i(x,y)) == -1:
				astar_grid.set_point_solid(Vector2i(x,y))
			else:
				#print(GetSpeedPenalty(Vector2i(x,y)))
				astar_grid.set_point_weight_scale(Vector2i(x,y),GetSpeedPenalty(Vector2i(x,y))) 
			
			
			

func GetSpeedPenalty(coords: Vector2i):
	var layer = 0
	# 找第layer层坐标coords的源ID
	var source_id = terrain.get_cell_source_id(layer,coords,false)
	# 找source_id关联的源对象
	var source: TileSetAtlasSource = terrain.tile_set.get_source(source_id)
	# 在layer找coords所在的那个瓦片在瓦片集的坐标(如草(1,0))
	var atlas_coords = terrain.get_cell_atlas_coords(layer,coords,false)
	# 得到其瓦片数据
	var tile_data = source.get_tile_data(atlas_coords,0)
	
	return tile_data.get_custom_data("speed_penalty")
	
	
