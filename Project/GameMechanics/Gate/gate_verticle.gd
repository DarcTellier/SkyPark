@tool
extends Node2D

@export_category("Gate Parts")
@export var gate_a_path: NodePath = "AGate"
@export var gate_b_path: NodePath = "BGate"

@export_category("Movement")
@export var gate_opening_size := 100.0
@export var open_time_in_sec := 1.0
@export var close_time_in_sec := 1.0
@export var auto_start := true
@export var start_open := false

@export_category("Pause")
@export var pause_when_fully_open := true
@export var fully_open_pause_time := 1.0
@export var pause_when_closed := true
@export var closed_pause_time := 1.0

@export_category("Tween")
@export var transition_type := Tween.TRANS_CUBIC
@export var ease_type := Tween.EASE_OUT

var gate_a: Node2D
var gate_b: Node2D

var gate_a_default_position: Vector2
var gate_b_default_position: Vector2

var is_open := false
var is_moving := false


func _ready() -> void:
	gate_a = get_node_or_null(gate_a_path)
	gate_b = get_node_or_null(gate_b_path)

	if gate_a == null or gate_b == null:
		print("Gate missing AGate or BGate.")
		return

	gate_a_default_position = gate_a.position
	gate_b_default_position = gate_b.position

	if start_open:
		set_open_position()
		is_open = true
	else:
		set_closed_position()
		is_open = false

	if auto_start and not Engine.is_editor_hint():
		run_gate_loop()


func run_gate_loop() -> void:
	while true:
		if is_open:
			if pause_when_fully_open:
				await get_tree().create_timer(fully_open_pause_time).timeout

			await close_gate()
		else:
			if pause_when_closed:
				await get_tree().create_timer(closed_pause_time).timeout

			await open_gate()


func open_gate() -> void:
	if gate_a == null or gate_b == null:
		return

	if is_moving or is_open:
		return

	is_moving = true

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)

	tween.tween_property(
		gate_a,
		"position:x",
		gate_a_default_position.x - gate_opening_size,
		open_time_in_sec
	)

	tween.tween_property(
		gate_b,
		"position:x",
		gate_b_default_position.x + gate_opening_size,
		open_time_in_sec
	)

	await tween.finished

	is_open = true
	is_moving = false


func close_gate() -> void:
	if gate_a == null or gate_b == null:
		return

	if is_moving or not is_open:
		return

	is_moving = true

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)

	tween.tween_property(
		gate_a,
		"position:x",
		gate_a_default_position.x,
		close_time_in_sec
	)

	tween.tween_property(
		gate_b,
		"position:x",
		gate_b_default_position.x,
		close_time_in_sec
	)

	await tween.finished

	is_open = false
	is_moving = false


func set_open_position() -> void:
	if gate_a == null or gate_b == null:
		return

	gate_a.position.x = gate_a_default_position.x - gate_opening_size
	gate_b.position.x = gate_b_default_position.x + gate_opening_size


func set_closed_position() -> void:
	if gate_a == null or gate_b == null:
		return

	gate_a.position = gate_a_default_position
	gate_b.position = gate_b_default_position
