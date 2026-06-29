extends Node

@export var target_path: NodePath = "../.."
@export var spin_speed := 180.0

var target: Node2D

var spinning := false
var stopped := false
var direction := 1


func _ready() -> void:
	target = get_node_or_null(target_path)


func _process(delta: float) -> void:
	if target == null:
		return

	if not spinning:
		return

	if stopped:
		return

	target.rotation_degrees += spin_speed * direction * delta


func react_to_gun(
	_hit_position: Vector2,
	gun: GunData,
	_gun_manager: Node = null,
	mouse_button: int = MOUSE_BUTTON_LEFT
) -> bool:
	if gun.gun_name != "Spin":
		return false

	if mouse_button == MOUSE_BUTTON_LEFT:
		start_spinning(-1)

	if mouse_button == MOUSE_BUTTON_RIGHT:
		start_spinning(1)

	return true


func start_spinning(new_direction: int) -> void:
	spinning = true
	stopped = false
	direction = new_direction


func stop_spinning() -> void:
	stopped = true


func resume_spinning() -> void:
	if spinning:
		stopped = false
