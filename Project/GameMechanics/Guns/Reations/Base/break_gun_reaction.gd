extends Node

@export var destroy_parent := true
@export var use_delay := false
@export var delay := 0.2


func react_to_gun(_hit_position: Vector2, gun: GunData, _gun_manager: Node = null) -> bool:
	if gun.gun_name != "Break":
		return false

	var target := get_parent().get_parent()

	if use_delay:
		await get_tree().create_timer(delay).timeout

	if destroy_parent and target:
		target.queue_free()

	return true
