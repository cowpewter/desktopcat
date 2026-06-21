extends Node2D

var speed = 100
var direction = Vector2(1, 0)
var is_dragging = false
var drag_offset = Vector2()
var idle_timer = 0.0
var is_idling = false
var is_menu_open = false;
var last_idle = 0;
var min_idle_cooldown = 5000; # 5 sec min between idles
var currentSprite = null;
var allSprites = null;

@onready var orangeSprite = get_node('CatSpriteOrange')
@onready var whiteSprite = get_node('CatSpriteWhite')
@onready var blackSprite = get_node('CatSpriteBlack')
@onready var area = get_node('CatArea')
@onready var menu = get_node('ContextMenu')
@onready var debug = get_node('Label')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allSprites = [orangeSprite, whiteSprite, blackSprite]
	_set_cat(orangeSprite);
	area.input_event.connect(_on_area_input)
	menu.connect('popup_hide', _on_menu_hide)
	_pick_new_direction()

func _physics_process(delta):
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		currentSprite.play("pick_up")
		return

	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			last_idle = Time.get_ticks_msec()
			_pick_new_direction()
		return
		
	if (is_menu_open):
		currentSprite.play('idle')
		return

	var win_pos = Vector2(DisplayServer.window_get_position())
	win_pos += direction * speed * delta
	DisplayServer.window_set_position(Vector2i(win_pos))
	_update_animation(win_pos)
	
	var usable = DisplayServer.screen_get_usable_rect()
	var real_size = Vector2(DisplayServer.window_get_size())

	var min_x = usable.position.x
	var min_y = usable.position.y
	var max_x = usable.position.x + usable.size.x - real_size.x
	var max_y = usable.position.y + usable.size.y - real_size.y

	# debug.text = str(last_idle) + '/' + str(Time.get_ticks_msec() - last_idle)

	if (win_pos.x <= min_x and direction.x < 0) or (win_pos.x >= max_x and direction.x > 0):
		direction.x = -direction.x
	if (win_pos.y <= min_y and direction.y < 0) or (win_pos.y >= max_y and direction.y > 0):
		direction.y = -direction.y
		
	if (not is_idling):
		_maybe_idle()

func _update_animation(_win_pos):
	if abs(direction.x) >= abs(direction.y):
		if direction.x <= 0:
			currentSprite.play("walk_left")
		else:
			currentSprite.play("walk_right")
	else:
		if direction.y <= 0:
			currentSprite.play("walk_up")
		else:
			currentSprite.play("walk_down")

func _maybe_idle():
	if (Time.get_ticks_msec() - last_idle) > min_idle_cooldown and randf() < 0.01:
		is_idling = true
		idle_timer = randf_range(1.0, 3.0)
		currentSprite.play("idle")

func _pick_new_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()
	
func _set_cat(newCat):
	for sprite in allSprites:
		sprite.visible = false
	currentSprite = newCat
	currentSprite.visible = true

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			is_dragging = false
			_pick_new_direction()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		menu.popup(Rect2(get_global_mouse_position(), Vector2(0, 0)))
		speed = 0
		is_menu_open = true;
		
func _on_menu_hide():
	speed = 100
	is_menu_open = false;
