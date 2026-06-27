extends Node


func react_to_gun(
	_hit_position: Vector2,
	gun: GunData,
	gun_manager: Node = null,
	_mouse_button: int = MOUSE_BUTTON_LEFT
) -> bool:
	if gun.gun_name != "Copy":
		return false

	if gun_manager == null:
		return false

	var target := get_parent().get_parent()

	if target == null:
		return false

	if target.scene_file_path.is_empty():
		print("Cannot copy: target has no scene file path.")
		return false

	var scene := load(target.scene_file_path)

	if scene == null:
		print("Cannot load copied scene.")
		return false

	gun_manager.set_copied_scene(scene)
	return true
