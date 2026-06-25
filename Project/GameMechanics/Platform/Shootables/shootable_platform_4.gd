extends AnimatableBody2D

@export_category("Movement")
@export var move_distance := 128.0
@export var move_time := 0.35
@export var launch_strength := 1.4

@export_category("Tween")
@export_enum("TRANS_LINEAR", "TRANS_SINE", "TRANS_QUAD", "TRANS_CUBIC", "TRANS_BACK", "TRANS_BOUNCE")
var transition_type := 1

@export_enum("EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN")
var ease_type := 2

var start_position := Vector2.ZERO
var target_position := Vector2.ZERO
var previous_position := Vector2.ZERO
var platform_velocity := Vector2.ZERO
var moving := false
var tween: Tween
var riders: Array[Node] = []


func _ready() -> void:
	start_position = global_position
	target_position = global_position
	previous_position = global_position

	$RiderArea.body_entered.connect(_on_rider_area_body_entered)
	$RiderArea.body_exited.connect(_on_rider_area_body_exited)


func _physics_process(delta: float) -> void:
	platform_velocity = (global_position - previous_position) / delta
	previous_position = global_position


func shot(hit_position: Vector2) -> void:
	if moving:
		return

	var local_hit := to_local(hit_position)

	if local_hit.x < 0:
		move_and_launch(-1)
	else:
		move_and_launch(1)


func move_and_launch(direction: int) -> void:
	moving = true
	target_position = global_position + Vector2(move_distance * direction, 0)

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(
		self,
		"global_position",
		target_position,
		move_time
	).set_trans(get_transition()).set_ease(get_ease())

	tween.finished.connect(_on_move_finished)


func _on_move_finished() -> void:
	global_position = target_position
	launch_riders()
	moving = false
	tween = null


func launch_riders() -> void:
	for body in riders:
		if body and body.has_method("launch_from_platform"):
			body.launch_from_platform(platform_velocity, launch_strength)


func _on_rider_area_body_entered(body: Node) -> void:
	if body not in riders:
		riders.append(body)


func _on_rider_area_body_exited(body: Node) -> void:
	riders.erase(body)


func get_transition() -> Tween.TransitionType:
	match transition_type:
		0: return Tween.TRANS_LINEAR
		1: return Tween.TRANS_SINE
		2: return Tween.TRANS_QUAD
		3: return Tween.TRANS_CUBIC
		4: return Tween.TRANS_BACK
		5: return Tween.TRANS_BOUNCE
		_: return Tween.TRANS_SINE


func get_ease() -> Tween.EaseType:
	match ease_type:
		0: return Tween.EASE_IN
		1: return Tween.EASE_OUT
		2: return Tween.EASE_IN_OUT
		3: return Tween.EASE_OUT_IN
		_: return Tween.EASE_IN_OUT
