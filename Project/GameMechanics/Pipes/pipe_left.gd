extends StaticBody2D

@export var pipe_name = ""
var pipe_direction = "LEFT"
@export var destination = ""

var player_reff
var player_reff_transion
var enter_pipe = false
var inpipetransit = false
var left_press = false
var area2d_toggle = false

func _ready() -> void:
	if pipe_name == "":
		print_debug("missing pipe name")
	GPipeNetwork.pipe_directory[pipe_name] = [$Location_pos.global_position,pipe_direction]
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.name == "Player":
		player_reff = body
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	player_reff = null
	enter_pipe = false
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		left_press = true
		
		

func _process(delta: float) -> void:
	
	if player_reff != null:
		enter_pipe = false
		if player_reff.name == "Player":
			if player_reff.left_press == true && enter_pipe == false:
				enter_pipe = true
				print(pipe_name)
				in_the_pipe()
				

		
				
func in_the_pipe():
	if player_reff.in_pipe_transit == true:
		
		return
	player_reff.in_pipe_transit = true
	player_reff.input_freeze = true
	

	player_reff.global_position.y = global_position.y
	player_reff.z_index = -2
	player_reff.get_node("AnimationPlayer").play("enter_the_left_pipe")
	
	$InThePipeTimer.start()
	


func _on_timer_timeout() -> void:
	if player_reff == null:
		print("its a living")
		player_reff= GPipeNetwork.emergency_player_reff
		
	player_reff.global_position = GPipeNetwork.pipe_directory[destination][0]
	select_pipe_exit_animation()
	
	player_reff_transion = player_reff
	$OuThePipeTimer.start()

func select_pipe_exit_animation():
	match GPipeNetwork.pipe_directory[destination][1]:
		"DOWN":player_reff.get_node("AnimationPlayer").play_backwards("exit_the_down_pipe")
		"UP":player_reff.get_node("AnimationPlayer").play_backwards("exit_the_up_pipe")
		"LEFT":player_reff.get_node("AnimationPlayer").play_backwards("exit_the_left_pipe")
		"RIGHT":player_reff.get_node("AnimationPlayer").play_backwards("exit_the_right_pipe")
		
	

func _on_ou_the_pipe_timer_timeout() -> void:
	player_reff_transion.in_pipe_transit = false
	player_reff_transion.input_freeze = false
	player_reff_transion.left_press = false
	player_reff_transion.z_index= 0
	player_reff_transion = null
	player_reff = null
	
