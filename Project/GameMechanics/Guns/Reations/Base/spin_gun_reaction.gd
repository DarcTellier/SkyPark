extends Node

@export var target_path: NodePath = "../.."

@export var use_tween := true
@export var tween_time := 0.35
@export var spin_degrees := 180.0

var tween: Tween


func react_to_gun(_hit_position: Vector2, gun: GunData) -> bool:
	if gun.gun_name != "Spin":
		return false

	var target := get_node_or_null(target_path)

	if target == null:
		print("SpinGunReaction has no target.")
		return false

	if tween:
		tween.kill()

	var target_rotation = target.rotation_degrees + spin_degrees

	if use_tween:
		tween = create_tween()
		tween.tween_property(
			target,
			"rotation_degrees",
			target_rotation,
			tween_time
		)
	else:
		target.rotation_degrees = target_rotation

	return true
