extends Node2D

var player_reff = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != null:
		if body.name == "Player":
			player_reff = body
			$Label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != null:
		if body.name == "Player":
			player_reff = null
			$Label.hide()

func _input(event: InputEvent) -> void:
	if player_reff != null:
		if event.is_action_pressed("interact"):
			get_parent().get_node("LightsOut").visible = false
			get_parent().get_node("Player/EyeWhite").visible = false
			get_parent().get_node("Ladder/CollisionShape2D").disabled = false
			get_parent().get_node("Display").show()
			get_parent().get_node("Display").display_toggle = true
