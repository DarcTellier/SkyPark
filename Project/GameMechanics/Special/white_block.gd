extends StaticBody2D

var player_reff
var behind_block = false
var white_platform = false
var white_block_time_start = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_reff = body
		white_platform = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		white_platform = false


func _process(delta: float) -> void:
	white_block()
	if Input.is_action_just_pressed("jump")&& behind_block == true :  
		$ZReturnTimer.start()


func white_block():
	if Input.is_action_pressed("down") && white_platform == true:
		if white_block_time_start == false:
			$White_Block_Timer.start()
			white_block_time_start = true
	else:
		$White_Block_Timer.stop()
		white_block_time_start = false 


func _on_white_block_timer_timeout() -> void:
	if player_reff != null:
		player_reff.position.y+=1
		player_reff.z_index = -1
		behind_block = true


func _on_z_return_timer_timeout() -> void:
	behind_block = false
	player_reff = GPipeNetwork.emergency_player_reff #gets player reff needs to be modified for multiplayer
	player_reff.z_index = 0
	player_reff = null
	
