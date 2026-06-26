extends Node

func react_to_gun(_hit_position: Vector2, gun: GunData, gun_manager = null) -> bool:
	if gun.gun_name != "Copy":
		return false

	var parent = get_parent().get_parent()

	if parent.scene_file_path.is_empty():
		print("This object isn't an instanced scene.")
		return false

	var scene := load(parent.scene_file_path)

	gun_manager.set_copied_scene(scene)

	return true
