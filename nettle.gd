extends Node2D

@onready var nettle_file = preload("res://nettle.tscn")
@onready var timer = $Timer

const SPAWN_RAD = 200.0
const MAX_CHILD = 3
const MAX_COUNT_NETTLE = 200

var spawned_child = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reproduction():
	if spawned_child >= MAX_CHILD:
		timer.stop()
		return
		
	var all_nettles = get_parent().get_children()
	
	if all_nettles.size() >= MAX_COUNT_NETTLE:
		return
	
	
	var nettle_child = nettle_file.instantiate()
	var random_angle = randf_range(0,2*PI)
	var random_distance = randf_range(50, SPAWN_RAD)
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	nettle_child.global_position = global_position + offset
	get_parent().add_child(nettle_child)
	spawned_child += 1



func _on_timer_timeout() -> void:
	reproduction()


func _on_dead_timer_timeout() -> void:
	print("я умер")
	queue_free()
	
