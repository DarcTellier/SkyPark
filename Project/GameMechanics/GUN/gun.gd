extends Node2D

@export_flags_2d_physics var shoot_collision_mask := 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot_at_mouse()


func shoot_at_mouse() -> void:
	var mouse_pos := get_global_mouse_position()

	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collision_mask = shoot_collision_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var hits := get_world_2d().direct_space_state.intersect_point(query, 32)

	for hit in hits:
		var collider = hit.collider

		if collider.has_method("shot"):
			collider.shot(mouse_pos)
			return
