@tool
extends TileMap

@export var generateTerrain : bool
@export var clearTerrain : bool

@export var mapWidth : int
@export var mapHeight : int

@export var shallowSeaLine : float
@export var beachLine : float
@export var grassLine : float
@export var dryGrassLine : float
@export var highestLine : float

@export var rockWidth : int
@export var rockHeight : int

@export var randomMapSeed : int

var CELL_SIZE = 16
var CELL_SIZE_HALF = 8
var CELL_SIZE_QUATER = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if generateTerrain:
		generateTerrain = false
		GenerateTerrain()
	
	if clearTerrain:
		clearTerrain = false
		clear()
	
	
func GenerateTerrain():
	#通过噪声；来生成地图
	var noise = FastNoiseLite.new()
	#使用库自带的细胞噪声
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	
	var rng = RandomNumberGenerator.new()
	
	# 通过输入来改变noise seed
	if randomMapSeed == 0:
		noise.seed = rng.randi()
	else:
		noise.seed = randomMapSeed
	
	#noise_num : 用于判断地形
	var noise_num
	
	for x in range(mapWidth):
		for y in range(mapHeight):
			noise_num = noise.get_noise_2d(x,y)
			if noise_num < shallowSeaLine :
			#(layer号，cell坐标，tileset的id，tile在tileset的坐标，备选tileset)
				set_cell(0,Vector2i(x,y),0,Vector2i(3,1))
			elif noise_num < beachLine :
				set_cell(0,Vector2i(x,y),0,Vector2i(2,1))
			elif noise_num < grassLine :
				set_cell(0,Vector2i(x,y),0,Vector2i(3,2))
			elif noise_num < dryGrassLine :
				set_cell(0,Vector2i(x,y),0,Vector2i(0,0))
			elif noise_num < highestLine :
				set_cell(0,Vector2i(x,y),0,Vector2i(1,0))
	
	#随机添加几块长方形的石头
	var rock_num = randi_range(1,4)
	
	#随机生成这些石头的位置并向右填充rockWidth,向下填充rockHeight格
	for num in range(rock_num):
		var rock_x = randi_range(1,mapWidth - rockWidth)
		var rock_y = randi_range(1,mapHeight - rockHeight)
		#print(str(rock_x) + "," + str(rock_y))
		for x in range(rock_x,rock_x + rockWidth):
			for y in range(rock_y,rock_y + rockHeight):
				if get_cell_atlas_coords(0,Vector2i(x,y),false) == Vector2i(0,0): #(0,0):草地图案
					#print("rock on:" + str(x) + "," + str(y) )
					set_cell(0,Vector2i(x,y),0,Vector2i(2,2))
	
		
