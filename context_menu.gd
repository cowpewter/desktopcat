extends PopupMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item('Quit')
	index_pressed.connect(_on_index_pressed)

func _on_index_pressed(index: int):
	if index == 0:
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
