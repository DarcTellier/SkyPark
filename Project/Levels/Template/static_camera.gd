extends Camera2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#body.get_node("Camera2D").enabled = false
		enabled = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
	#	body.get_node("Camera2D").enabled = true 
		enabled = false
#TODO fix issue with pause switching back forth between each camera real fast
