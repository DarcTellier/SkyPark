extends Node2D
@export var donut_scene: PackedScene  # Drag your Donut scene here

@export var shake_speed := 6.0
@export var shake_amount := 1.0
@export var shake_time_limit := 0.5
@export var drop_delay := 0.75  # How long the player must stand before falling
@export var touch_to_drop := false  # If true, fall instantly on touch
@export var respawn_time := 5.0  # Time after falling to spawn new donut
@export var gravity := 1


func respawn():
	if donut_scene:
		var new_donut = donut_scene.instantiate()
		add_child(new_donut)
		new_donut.global_position = global_position
	
