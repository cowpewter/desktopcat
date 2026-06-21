extends PopupMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite_menu = PopupMenu.new()
	sprite_menu.name = 'spriteMenu'
	sprite_menu.add_item('Orange')
	sprite_menu.add_item('White')
	sprite_menu.add_item('Black')
	add_submenu_node_item('Change Color', sprite_menu)
	add_item('Quit')
	index_pressed.connect(_on_index_pressed)
	sprite_menu.index_pressed.connect(_on_sprite_pressed)

func _on_index_pressed(index: int):
	if index == 0:
		get_tree().quit()
		
func _on_sprite_pressed(index: int):
	var main = get_node('..')
	match index:
		0:
			main._set_cat(main.get_node('CatSpriteOrange'))
		1:
			main._set_cat(main.get_node('CatSpriteWhite'))
		2:
			main._set_cat(main.get_node('CatSpriteBlack'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
