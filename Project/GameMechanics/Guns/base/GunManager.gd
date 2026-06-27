extends Node2D

signal ammo_changed(new_ammo: int)
signal gun_changed(new_gun: GunData)

@export_category("Guns")
@export var guns: Array[GunData] = []
@export var current_gun_index := 0

@export_category("Ammo")
@export var ammo := 20

@export_category("Shooting")
@export_flags_2d_physics var shoot_collision_mask := 1
@export var point_query_size := 32

@export_category("Block Gun")
@export var block_scene: PackedScene
@export var block_parent_path: NodePath
@export var snap_blocks_to_grid := true
@export var block_grid_size := 16.0

@export_category("Copy Gun")
@export var copy_parent_path: NodePath
@export var snap_copies_to_grid := true
@export var copy_grid_size := 16.0

@export_category("Ghost Preview")
@export var ghost_alpha := 0.45
@export var ghost_z_index := 999


var can_shoot := true
var copied_scene: PackedScene

var ghost_instance: Node2D


func _ready() -> void:
	add_to_group("gun_manager")

	if not guns.is_empty():
		current_gun_index = clamp(current_gun_index, 0, guns.size() - 1)
		gun_changed.emit(get_current_gun())
		print("Current Gun: ", get_current_gun().gun_name)

	ammo_changed.emit(ammo)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		fire_current_gun(MOUSE_BUTTON_LEFT)
		return

	if event.is_action_pressed("alt_shoot"):
		fire_current_gun(MOUSE_BUTTON_RIGHT)
		return

	if event.is_action_pressed("gun_1"):
		switch_gun(0)

	if event.is_action_pressed("gun_2"):
		switch_gun(1)

	if event.is_action_pressed("gun_3"):
		switch_gun(2)

	if event.is_action_pressed("gun_4"):
		switch_gun(3)

	if event.is_action_pressed("next_gun"):
		next_gun()

	if event.is_action_pressed("previous_gun"):
		previous_gun()




func _process(_delta: float) -> void:
	update_ghost_preview()


func update_ghost_preview() -> void:
	var preview_scene := get_preview_scene()

	if preview_scene == null:
		clear_ghost()
		return

	if ghost_instance == null:
		create_ghost(preview_scene)

	var mouse_pos := get_global_mouse_position()
	var current_gun := get_current_gun()

	match current_gun.gun_name:
		"Block":
			ghost_instance.global_position = get_snapped_position(
				mouse_pos,
				snap_blocks_to_grid,
				block_grid_size
			)

		"Copy":
			ghost_instance.global_position = get_snapped_position(
				mouse_pos,
				snap_copies_to_grid,
				copy_grid_size
			)


func get_preview_scene() -> PackedScene:
	if guns.is_empty():
		return null

	var current_gun := get_current_gun()

	match current_gun.gun_name:
		"Block":
			return block_scene

		"Copy":
			return copied_scene

	return null


func create_ghost(scene: PackedScene) -> void:
	clear_ghost()

	ghost_instance = scene.instantiate()

	if not ghost_instance is Node2D:
		ghost_instance.queue_free()
		ghost_instance = null
		return

	get_tree().current_scene.add_child(ghost_instance)

	ghost_instance.modulate.a = ghost_alpha
	ghost_instance.z_index = ghost_z_index

	disable_ghost_collision(ghost_instance)


func clear_ghost() -> void:
	if ghost_instance:
		ghost_instance.queue_free()
		ghost_instance = null


func disable_ghost_collision(node: Node) -> void:
	if node is CollisionObject2D:
		node.collision_layer = 0
		node.collision_mask = 0

	for child in node.get_children():
		disable_ghost_collision(child)



func fire_current_gun(mouse_button: int = MOUSE_BUTTON_LEFT) -> void:
	if not can_fire():
		return

	var current_gun := get_current_gun()
	var mouse_pos := get_global_mouse_position()

	# Copy Gun special controls
	if current_gun.gun_name == "Copy":
		if mouse_button == MOUSE_BUTTON_RIGHT:
			copy_object_at_mouse()
			return

		if mouse_button == MOUSE_BUTTON_LEFT:
			if current_gun.consumes_ammo:
				spend_ammo(current_gun.ammo_cost)

			can_shoot = false
			fire_copy_gun(mouse_pos)
			await start_cooldown(current_gun)
			return

	if current_gun.consumes_ammo:
		spend_ammo(current_gun.ammo_cost)

	can_shoot = false

	match current_gun.gun_name:
		"Block":
			fire_block_gun(mouse_pos)

		_:
			fire_reaction_gun(mouse_pos, current_gun, mouse_button)

	await start_cooldown(current_gun)


func copy_object_at_mouse() -> void:
	if guns.is_empty():
		return

	var current_gun := get_current_gun()

	if current_gun.gun_name != "Copy":
		return

	var mouse_pos := get_global_mouse_position()
	fire_reaction_gun(mouse_pos, current_gun, MOUSE_BUTTON_RIGHT)


func fire_reaction_gun(mouse_pos: Vector2, current_gun: GunData, mouse_button: int = MOUSE_BUTTON_LEFT) -> void:
	var hits := get_hits_at_position(mouse_pos)

	for hit in hits:
		var collider = hit.collider

		if collider.has_method("shot"):
			collider.shot(mouse_pos, current_gun, self, mouse_button)
			return

func fire_block_gun(mouse_pos: Vector2) -> void:
	if block_scene == null:
		return

	var spawn_pos := get_snapped_position(
		mouse_pos,
		snap_blocks_to_grid,
		block_grid_size
	)

	var parent := get_spawn_parent(block_parent_path)

	var block := block_scene.instantiate()
	parent.add_child(block)
	block.global_position = spawn_pos


func fire_copy_gun(mouse_pos: Vector2) -> void:
	if copied_scene == null:
		return

	var spawn_pos := get_snapped_position(
		mouse_pos,
		snap_copies_to_grid,
		copy_grid_size
	)

	var parent := get_spawn_parent(copy_parent_path)

	var copy := copied_scene.instantiate()
	parent.add_child(copy)
	copy.global_position = spawn_pos


func set_copied_scene(scene: PackedScene) -> void:
	copied_scene = scene
	clear_ghost()

	if copied_scene != null:
		print("Copied Scene: ", copied_scene.resource_path)

func can_fire() -> bool:
	if guns.is_empty():
		return false

	if current_gun_index < 0 or current_gun_index >= guns.size():
		return false

	if not can_shoot:
		return false

	var current_gun := get_current_gun()

	if current_gun.consumes_ammo and ammo < current_gun.ammo_cost:
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


func get_snapped_position(
	world_position: Vector2,
	should_snap: bool,
	grid_size: float
) -> Vector2:
	if not should_snap:
		return world_position

	return Vector2(
		round(world_position.x / grid_size) * grid_size,
		round(world_position.y / grid_size) * grid_size
	)


func get_spawn_parent(parent_path: NodePath) -> Node:
	var parent := get_node_or_null(parent_path)

	if parent == null:
		parent = get_tree().current_scene

	return parent


func switch_gun(index: int) -> void:
	if index < 0 or index >= guns.size():
		return

	current_gun_index = index
	clear_ghost()

	gun_changed.emit(get_current_gun())

	print("Current Gun: ", get_current_gun().gun_name)


func next_gun() -> void:
	if guns.is_empty():
		return

	var new_index := current_gun_index + 1

	if new_index >= guns.size():
		new_index = 0

	switch_gun(new_index)


func previous_gun() -> void:
	if guns.is_empty():
		return

	var new_index := current_gun_index - 1

	if new_index < 0:
		new_index = guns.size() - 1

	switch_gun(new_index)


func start_cooldown(gun: GunData) -> void:
	await get_tree().create_timer(gun.cooldown).timeout
	can_shoot = true


func spend_ammo(amount: int) -> void:
	ammo -= amount
	ammo = max(ammo, 0)
	ammo_changed.emit(ammo)


func add_ammo(amount: int) -> void:
	ammo += amount
	ammo_changed.emit(ammo)
