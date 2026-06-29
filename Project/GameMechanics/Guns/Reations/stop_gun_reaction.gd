extends Node

@export var spin_reaction_path: NodePath = "../SpinGunReaction"


func react_to_gun(
	_hit_position: Vector2,
	gun: GunData,
	_gun_manager: Node = null,
	mouse_button: int = MOUSE_BUTTON_LEFT
) -> bool:

	if gun.gun_name != "Stop":
		return false

	var spin := get_node_or_null(spin_reaction_path)

	if spin == null:
		return false

	if mouse_button == MOUSE_BUTTON_LEFT:
		spin.stop_spinning()

	if mouse_button == MOUSE_BUTTON_RIGHT:
		spin.resume_spinning()

	return true
