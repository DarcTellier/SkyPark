extends Node

@export var target_path: NodePath = "../.."
@export var use_delay := false
@export var delay := 0.2


func react_to_gun(
	_hit_position: Vector2,
	gun: GunData,
	_gun_manager: Node = null,
	_mouse_button: int = MOUSE_BUTTON_LEFT
) -> bool:
	if gun.gun_name != "Break":
		return false

	var target := get_node_or_null(target_path)

	if target == null:
		return false

	if use_delay:
		await get_tree().create_timer(delay).timeout

	target.queue_free()
	return true
