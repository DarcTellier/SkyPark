extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("Mouse button detected: ", event.button_index, " pressed: ", event.pressed)

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("LEFT CLICK - shooting")
			shoot_at_mouse()


func shoot_at_mouse() -> void:
	var mouse_pos := get_global_mouse_position()
	print("Mouse world position: ", mouse_pos)

	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var hits := get_world_2d().direct_space_state.intersect_point(query, 32)

	print("Hits found: ", hits.size())

	for hit in hits:
		var collider = hit.collider
		print("Hit collider: ", collider.name)

		if collider.has_method("toggle_spin"):
			print("Toggling platform")
			collider.toggle_spin()
			return
