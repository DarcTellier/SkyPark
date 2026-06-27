extends Node

@export var spin_reaction_path: NodePath = "../SpinGunReaction"


func react_to_gun(
	_hit_position: Vector2,
	gun: GunData,
	_gun_manager: Node = null,
	_mouse_button: int = MOUSE_BUTTON_LEFT
) -> bool:
	if gun.gun_name != "Stop":
		return false

	var spin_reaction := get_node_or_null(spin_reaction_path)

	if spin_reaction == null:
		return false

	if spin_reaction.has_method("stop_spinning"):
		spin_reaction.stop_spinning()
		return true

	return false
