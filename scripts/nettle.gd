extends Node2D

@onready var nettle_file: PackedScene = preload("res://nettle.tscn")
@onready var timer: Timer = $Timer
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

const SPAWN_RAD := 150.0
const MAX_CHILD := 3
const MAX_COUNT_NETTLE := 400

var spawned_child: int = 0
var baby: bool = true


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func reproduction() -> void:
	if baby == true:
		return
	
	if spawned_child >= MAX_CHILD:
		timer.stop()
		return
	
	var all_nettles = get_parent().get_children()
	if all_nettles.size() >= MAX_COUNT_NETTLE:
		return
	
	var nettle_child = nettle_file.instantiate()
	
	var random_angle = randf_range(0, 2 * PI)
	var random_distance = randf_range(100, SPAWN_RAD)
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	
	nettle_child.global_position = global_position + offset
	
	get_parent().add_child(nettle_child)
	spawned_child += 1
	
	ScoreManager.add_points(ScoreManager.NEW_NETTLE_POINTS)


func _on_timer_timeout() -> void:
	reproduction()


func _on_dead_timer_timeout() -> void:
	print("я умер")
	queue_free()


func _on_timer_gen_timeout() -> void:
	animate.play("default")
	baby = false
