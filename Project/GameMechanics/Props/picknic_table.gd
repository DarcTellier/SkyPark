extends StaticBody2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.two_way_platform = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.two_way_platform = false
