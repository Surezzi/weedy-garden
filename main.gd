extends Node2D

@onready var nettle_file: PackedScene = preload("res://nettle.tscn")
@onready var accessible_area = $"accessible area"
@onready var shader_blink = $ColorRect
@onready var text_massage = $Label

var mouse_is_inside: bool = false
var nettle_spawned_start: bool = false


func _ready() -> void:
	ScoreManager.reset_score()


func _process(_delta: float) -> void:
	if nettle_spawned_start == false:
		if Input.is_action_just_pressed("left_pressing_mouse"):
			if mouse_is_inside:
				spawn_nettle()
				nettle_spawned_start = true
				shader_blink.material.set_shader_parameter("shader_enable", false)
				text_massage.visible = false


func spawn_nettle() -> void:
	var new_nettle = nettle_file.instantiate()
	new_nettle.global_position = get_global_mouse_position()
	add_child(new_nettle)
	
	ScoreManager.add_points(ScoreManager.FIRST_NETTLE_POINTS)
	
	print("я первый куст")


func _on_accessible_area_mouse_entered() -> void:
	mouse_is_inside = true


func _on_accessible_area_mouse_exited() -> void:
	mouse_is_inside = false
