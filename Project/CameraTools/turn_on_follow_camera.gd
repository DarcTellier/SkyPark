extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("Camera2D").enabled = true
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("Camera2D").enabled = false
		
	pass # Replace with function body.
