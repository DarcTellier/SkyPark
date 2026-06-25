extends AnimatableBody2D

@export_category("Flip Settings")
@export var flip_degrees := 180.0
@export var flip_speed := 0.35
@export var ignore_shots_while_flipping := true

@export_enum("Clockwise", "CounterClockwise")
var left_half_direction := 0

@export_enum("Clockwise", "CounterClockwise")
var right_half_direction := 1

@export_category("Tween")
@export_enum("TRANS_LINEAR", "TRANS_SINE", "TRANS_QUAD", "TRANS_CUBIC", "TRANS_QUART", "TRANS_QUINT", "TRANS_EXPO", "TRANS_BACK", "TRANS_BOUNCE", "TRANS_ELASTIC")
var transition_type := 1

@export_enum("EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN")
var ease_type := 2

var tween: Tween
var is_flipping := false
var target_rotation := 0.0


func _ready() -> void:
	rotation_degrees = round(rotation_degrees / flip_degrees) * flip_degrees
	target_rotation = rotation_degrees


func shot(hit_position: Vector2) -> void:
	if is_flipping and ignore_shots_while_flipping:
		return

	var local_hit := to_local(hit_position)

	if local_hit.x < 0.0:
		start_flip(left_half_direction)
	else:
		start_flip(right_half_direction)


func start_flip(direction: int) -> void:
	if is_flipping:
		return

	is_flipping = true

	var spin_dir := 1.0
	if direction == 1:
		spin_dir = -1.0

	target_rotation = rotation_degrees + flip_degrees * spin_dir
	target_rotation = round(target_rotation / flip_degrees) * flip_degrees

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(
		self,
		"rotation_degrees",
		target_rotation,
		flip_speed
	).set_trans(get_transition()).set_ease(get_ease())

	tween.finished.connect(_on_flip_finished)


func _on_flip_finished() -> void:
	rotation_degrees = target_rotation
	is_flipping = false
	tween = null


func get_transition() -> Tween.TransitionType:
	match transition_type:
		0: return Tween.TRANS_LINEAR
		1: return Tween.TRANS_SINE
		2: return Tween.TRANS_QUAD
		3: return Tween.TRANS_CUBIC
		4: return Tween.TRANS_QUART
		5: return Tween.TRANS_QUINT
		6: return Tween.TRANS_EXPO
		7: return Tween.TRANS_BACK
		8: return Tween.TRANS_BOUNCE
		9: return Tween.TRANS_ELASTIC
		_: return Tween.TRANS_SINE


func get_ease() -> Tween.EaseType:
	match ease_type:
		0: return Tween.EASE_IN
		1: return Tween.EASE_OUT
		2: return Tween.EASE_IN_OUT
		3: return Tween.EASE_OUT_IN
		_: return Tween.EASE_IN_OUT
