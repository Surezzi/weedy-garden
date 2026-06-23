extends Camera2D

const MAX_ZOOM := Vector2(3.0, 3.0)
const MIN_ZOOM := Vector2(0.8, 0.8)
const MOVE_SPEED := 300.0
const ZOOM_STEP := 0.15


const LIMIT_LEFT := -172.0
const LIMIT_TOP := -185.0
const LIMIT_RIGHT := 1296.0
const LIMIT_BOTTOM := 809.0


func _ready() -> void:
	make_current()
	position_smoothing_enabled = false
	drag_horizontal_enabled = false
	drag_vertical_enabled = false
	offset = Vector2.ZERO
	_clamp_camera()


func _process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("w"):
		direction.y -= 1
	if Input.is_action_pressed("a"):
		direction.x -= 1
	if Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("d"):
		direction.x += 1

	if direction != Vector2.ZERO:
		global_position += direction.normalized() * MOVE_SPEED * delta
		_clamp_camera()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(ZOOM_STEP, ZOOM_STEP)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(ZOOM_STEP, ZOOM_STEP)

		zoom = zoom.clamp(MIN_ZOOM, MAX_ZOOM)
		_clamp_camera()


func _clamp_camera() -> void:
	var viewport_size := get_viewport_rect().size
	
	var visible_world_size := Vector2(
		viewport_size.x / zoom.x,
		viewport_size.y / zoom.y
	)
	
	var half_visible_size := visible_world_size * 0.5

	var min_x := LIMIT_LEFT + half_visible_size.x
	var max_x := LIMIT_RIGHT - half_visible_size.x
	var min_y := LIMIT_TOP + half_visible_size.y
	var max_y := LIMIT_BOTTOM - half_visible_size.y

	if min_x > max_x:
		global_position.x = (LIMIT_LEFT + LIMIT_RIGHT) * 0.5
	else:
		global_position.x = clamp(global_position.x, min_x, max_x)

	if min_y > max_y:
		global_position.y = (LIMIT_TOP + LIMIT_BOTTOM) * 0.5
	else:
		global_position.y = clamp(global_position.y, min_y, max_y)
