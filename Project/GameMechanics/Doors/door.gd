extends Node2D

@export var door_name = ""
@export var destination = ""
@export var locked = false
var player_reff 
var release_up_button = false


func _ready() -> void:
	if locked == false:
		$LockedDoor.queue_free()

	if door_name == "":
		print_debug("missing door name")
	if destination == "":
		print_debug("missing destination name")	
	
	GDoorNetwork.door_directory[door_name] = $Location_pos.global_position
	

func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.name == "Player":
		player_reff = body
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		#player_reff.get_node("Camera2D").position_smoothing_enabled = true
		player_reff = null
		
		
		
func _process(delta: float) -> void:
	if player_reff != null:
		if Input.is_action_just_pressed("up") && locked == false:
			player_reff.get_node("Camera2D").position_smoothing_enabled = false
			player_reff.global_position = GDoorNetwork.door_directory[destination]
			
		
		
