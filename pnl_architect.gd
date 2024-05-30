@tool
extends Panel
@export var reset : bool = false

@onready var UI = $".."

var buttons = []
var current_buildable : String
var column_count = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	LoadButtons()
	for button in buttons:
		button.connect("pressed",OnButtonPressed.bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reset:
		reset = false
		LoadButtons()
		ArrangeSelf()
		ArrangeButtons()

func OnButtonPressed(button : Button):
	OpenSubmenu(button.text)

func OpenSubmenu(menu: String):
	if menu == current_buildable:
		find_child("pnl_buildable").set_visible(false)
		current_buildable = ""
	else:
		current_buildable = menu
		find_child("pnl_buildable").set_visible(true)
		match menu:
			"Structure":
				LoadArchitectBuildableMenu()
				
func LoadArchitectBuildableMenu():
	var pnl_buildable = find_child("pnl_buildable")
	
	# 遍历 pnl_buildable 的所有子节点，并将其移除。
	# queue_free() 方法会在下一帧删除节点，确保界面清理干净以便添加新的按钮。
	for i in range(pnl_buildable.get_child_count()):
		pnl_buildable.get_child(i).queue_free()
		
	var buildables = ["Cancel", "Wall", "Door", "Fence"]
		
	for i in range(len(buildables)):
		# 创建一个新的按钮对象 button。
		var button = Button.new()
		# 将创建的按钮添加为 pnl_buildable 的子节点。
		pnl_buildable.add_child(button)
		# 设置按钮的文本为 buildables 数组中当前索引 i 的值。
		button.text = buildables[i]
		var buttonSize = pnl_buildable.size.x / 20
		button.position = Vector2(buttonSize * i, pnl_buildable.size.y - buttonSize)
		button.size = Vector2(buttonSize, buttonSize)
		button.add_theme_font_size_override("font_size",10)


func LoadButtons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
			
			
func ArrangeSelf():
	anchor_left = 0;
	anchor_right = 0.2
	anchor_bottom = 1 - UI.buttonHeight
	
	var rows = (len(buttons)+1)/column_count
	
	anchor_top = anchor_bottom - UI.buttonHeight * rows
	
	offset_bottom = 0
	offset_top = 0
	offset_left = 0
	offset_right = 0

func ArrangeButtons():
	var rows = (len(buttons)+1)/column_count
	for i in range(len(buttons)):
		var column = i % column_count
		var row = i / column_count
		buttons[i].anchor_top = row * 1/float(rows)
		buttons[i].anchor_bottom = 1/float(rows) + row * 1/float(rows)
		buttons[i].anchor_left = column * 1/float(column_count)
		buttons[i].anchor_right = 1/float(column_count) + column * 1/float(column_count)
		
		buttons[i].offset_bottom = 0
		buttons[i].offset_top = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
		
		
