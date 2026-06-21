extends Camera2D

const MAX_ZOOM = Vector2(3.0, 3.0)
const MIN_ZOOM = Vector2(0.8, 0.8)

const MOVE_SPEED = 200.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_zoom_plus"):
		zoom += Vector2(0.05, 0.05)
	if Input.is_action_just_pressed("mouse_zoom_minus"):
		zoom -= Vector2(0.05, 0.05)
	zoom = zoom.clamp(MIN_ZOOM, MAX_ZOOM)
	
	if Input.is_action_pressed("w"):
		position.y -= MOVE_SPEED * delta
	if Input.is_action_pressed("a"):
		position.x -= MOVE_SPEED * delta
	if Input.is_action_pressed("s"):
		position.y += MOVE_SPEED * delta
	if Input.is_action_pressed("d"):
		position.x += MOVE_SPEED * delta
		
	position.x = clamp(position.x, limit_left, limit_right)
	position.y = clamp(position.y, limit_top, limit_bottom)
	
