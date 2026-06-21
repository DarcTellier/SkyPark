extends Area2D

var player_reff = null
var on_top_of_ladder = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == ("Player"):
		player_reff = body

func _on_body_exited(body: Node2D) -> void:
	if player_reff != null:
		player_reff.get_node("Ladder").exit_ladder()
		player_reff = null
	
	


func _input(event: InputEvent) -> void:
	if player_reff != null && player_reff.name == "Player":
		
		if event.is_action_pressed("up"):
			if on_top_of_ladder == true:
				return
			else:
				player_reff.get_node("Ladder").enter_ladder($center_of_lader.global_position)	
		
		
		if  event.is_action_pressed("down") :
			if on_top_of_ladder == true:
				player_reff.position.y +=1
				
			player_reff.get_node("Ladder").enter_ladder($center_of_lader.global_position)
			


func _on_top_of_ladder_area_body_entered(body: Node2D) -> void:
	
	if body.name == ("Player"):
		on_top_of_ladder = true
		


func _on_top_of_ladder_area_body_exited(body: Node2D) -> void:
	if body.name == ("Player"):
		on_top_of_ladder = false
