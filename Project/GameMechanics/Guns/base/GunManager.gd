extends Node2D

signal ammo_changed(new_ammo: int)
signal gun_changed(new_gun: GunData)

@export var guns: Array[GunData] = []
@export var current_gun_index := 0
@export var ammo := 20

@export_flags_2d_physics var shoot_collision_mask := 1
@export var point_query_size := 32

var can_shoot := true


func _ready() -> void:
	if not guns.is_empty():
		current_gun_index = clamp(current_gun_index, 0, guns.size() - 1)
		gun_changed.emit(get_current_gun())

	ammo_changed.emit(ammo)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			fire_current_gun()

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				switch_gun(0)
			KEY_2:
				switch_gun(1)
			KEY_3:
				switch_gun(2)
			KEY_4:
				switch_gun(3)


func fire_current_gun() -> void:
	print("FIRE")
	if not can_fire():
		return

	var current_gun := get_current_gun()

	spend_ammo(current_gun.ammo_cost)
	can_shoot = false

	var mouse_pos := get_global_mouse_position()
	var hits := get_hits_at_position(mouse_pos)
	print("Hits: ", hits.size())

	for hit in hits:
		
		var collider = hit.collider

		if collider.has_method("shot"):
			print("Hit: ", collider.name)
			collider.shot(mouse_pos, current_gun)
			break

	await get_tree().create_timer(current_gun.cooldown).timeout
	can_shoot = true


func can_fire() -> bool:
	if guns.is_empty():
		print("No guns assigned.")
		return false

	if current_gun_index < 0 or current_gun_index >= guns.size():
		print("Invalid gun index.")
		return false

	if not can_shoot:
		return false

	var current_gun := get_current_gun()

	if ammo < current_gun.ammo_cost:
		print("No ammo.")
		return false

	return true


func get_current_gun() -> GunData:
	return guns[current_gun_index]


func get_hits_at_position(world_position: Vector2) -> Array:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = world_position
	query.collision_mask = shoot_collision_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false

	return get_world_2d().direct_space_state.intersect_point(
		query,
		point_query_size
	)


func switch_gun(index: int) -> void:
	if index < 0 or index >= guns.size():
		return

	current_gun_index = index
	gun_changed.emit(get_current_gun())

	print("Switched to: ", get_current_gun().gun_name)


func spend_ammo(amount: int) -> void:
	ammo -= amount
	ammo = max(ammo, 0)
	ammo_changed.emit(ammo)


func add_ammo(amount: int) -> void:
	ammo += amount
	ammo_changed.emit(ammo)

	print("Ammo: ", ammo)
