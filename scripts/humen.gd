extends Node2D

enum State {
	PATROL,
	CHASE
}

@export var patrol_speed: float = 90.0
@export var chase_speed: float = 140.0
@export var detection_radius: float = 220.0
@export var detection_threshold: float = 0.5
@export var destroy_distance: float = 28.0
@export var scan_interval: float = 0.25
@export var show_detection_radius: bool = true

# Временный маршрут патруля.
# Подстрой точки под вашу карту.
@export var patrol_points: Array[Vector2] = [
	Vector2(220, 180),
	Vector2(1050, 180),
	Vector2(1050, 650),
	Vector2(220, 650)
]

var state: State = State.PATROL
var patrol_index: int = 0
var target_nettle: Node2D = null
var scan_timer: float = 0.0


func _ready() -> void:
	if patrol_points.is_empty():
		patrol_points.append(global_position)
	
	queue_redraw()


func _process(delta: float) -> void:
	scan_timer -= delta
	
	if scan_timer <= 0.0:
		scan_timer = scan_interval
		
		if target_nettle == null or not is_instance_valid(target_nettle):
			target_nettle = _find_visible_nettle()
			
			if target_nettle != null:
				state = State.CHASE
			else:
				state = State.PATROL
	
	match state:
		State.PATROL:
			_patrol(delta)
		State.CHASE:
			_chase_target(delta)


func _patrol(delta: float) -> void:
	if patrol_points.is_empty():
		return
	
	var target_position := patrol_points[patrol_index]
	var distance := global_position.distance_to(target_position)
	
	if distance <= 12.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()
		target_position = patrol_points[patrol_index]
	
	_move_to(target_position, patrol_speed, delta)


func _chase_target(delta: float) -> void:
	if target_nettle == null or not is_instance_valid(target_nettle):
		target_nettle = null
		state = State.PATROL
		return
	
	var distance := global_position.distance_to(target_nettle.global_position)
	
	if distance > detection_radius * 1.4:
		target_nettle = null
		state = State.PATROL
		return
	
	if distance <= destroy_distance:
		if target_nettle.has_method("destroy_by_gardener"):
			target_nettle.destroy_by_gardener()
		else:
			target_nettle.queue_free()
		
		target_nettle = null
		state = State.PATROL
		return
	
	_move_to(target_nettle.global_position, chase_speed, delta)


func _move_to(target_position: Vector2, speed: float, delta: float) -> void:
	var direction := global_position.direction_to(target_position)
	global_position += direction * speed * delta


func _find_visible_nettle() -> Node2D:
	var best_nettle: Node2D = null
	var best_distance := INF
	
	var nettles = get_tree().get_nodes_in_group("nettles")
	
	for nettle in nettles:
		if not is_instance_valid(nettle):
			continue
		
		if not nettle is Node2D:
			continue
		
		var distance := global_position.distance_to(nettle.global_position)
		
		if distance > detection_radius:
			continue
		
		if nettle.has_method("is_detectable_by"):
			if not nettle.is_detectable_by(detection_threshold):
				continue
		
		if distance < best_distance:
			best_distance = distance
			best_nettle = nettle
	
	return best_nettle


func _draw() -> void:
	if show_detection_radius:
		draw_arc(
			Vector2.ZERO,
			detection_radius,
			0.0,
			TAU,
			64,
			Color(1.0, 0.0, 0.0, 0.35),
			2.0
		)
