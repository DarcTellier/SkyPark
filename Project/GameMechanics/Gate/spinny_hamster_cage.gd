@tool
extends Node2D

@export_category("Doors")
@export var top_left_closed := true:
	set(value):
		top_left_closed = value
		update_doors()

@export var top_right_closed := true:
	set(value):
		top_right_closed = value
		update_doors()

@export var bottom_left_closed := true:
	set(value):
		bottom_left_closed = value
		update_doors()

@export var bottom_right_closed := true:
	set(value):
		bottom_right_closed = value
		update_doors()


@export_category("Spin Mode")
@export var spin_enabled := true
@export var alternate_direction := false
@export var clockwise := true

@export_category("Constant Spin")
@export var rotation_speed := 45.0

@export_category("Alternating Spin")
@export var rotate_degrees_per_cycle := 180.0
@export var left_spin_time := 3.0
@export var right_spin_time := 3.0
@export var pause_between_switch := 0.25

@export_category("Tween")
@export var transition_type := Tween.TRANS_SINE
@export var ease_type := Tween.EASE_IN_OUT

var alternating_active := false


func _ready() -> void:
	update_doors()

	if not Engine.is_editor_hint():
		if spin_enabled and alternate_direction:
			start_alternating_spin()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_doors()
		return

	if not spin_enabled:
		return

	if alternate_direction:
		return

	var dir := 1.0

	if not clockwise:
		dir = -1.0

	rotation_degrees += rotation_speed * dir * delta


func update_doors() -> void:
	if not is_inside_tree():
		return

	set_door_enabled("SpinnyHamsterDoor", top_left_closed)
	set_door_enabled("SpinnyHamsterDoor2", top_right_closed)
	set_door_enabled("SpinnyHamsterDoor3", bottom_left_closed)
	set_door_enabled("SpinnyHamsterDoor4", bottom_right_closed)


func set_door_enabled(door_name: String, enabled: bool) -> void:
	var door := get_node_or_null(door_name)

	if door == null:
		return

	door.visible = enabled
	set_collision_enabled_recursive(door, enabled)


func set_collision_enabled_recursive(node: Node, enabled: bool) -> void:
	if node is CollisionShape2D:
		node.disabled = not enabled

	if node is CollisionPolygon2D:
		node.disabled = not enabled

	for child in node.get_children():
		set_collision_enabled_recursive(child, enabled)


func start_alternating_spin() -> void:
	if alternating_active:
		return

	alternating_active = true

	while spin_enabled and alternate_direction:
		await spin_by_degrees(-rotate_degrees_per_cycle, left_spin_time)
		await wait_pause()

		await spin_by_degrees(rotate_degrees_per_cycle, right_spin_time)
		await wait_pause()

	alternating_active = false


func spin_by_degrees(amount: float, time: float) -> void:
	var tween := create_tween()
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_property(
		self,
		"rotation_degrees",
		rotation_degrees + amount,
		time
	)

	await tween.finished


func wait_pause() -> void:
	if pause_between_switch <= 0.0:
		return

	await get_tree().create_timer(pause_between_switch).timeout


func stop_spin() -> void:
	spin_enabled = false


func resume_spin() -> void:
	spin_enabled = true

	if alternate_direction:
		start_alternating_spin()
