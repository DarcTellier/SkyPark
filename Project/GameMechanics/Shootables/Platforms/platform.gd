extends AnimatableBody2D

@onready var gun_reactions: Node = $GunReactions


func shot(
	hit_position: Vector2,
	gun: GunData,
	gun_manager: Node = null,
	mouse_button: int = MOUSE_BUTTON_LEFT
) -> void:
	for reaction in gun_reactions.get_children():
		if reaction.has_method("react_to_gun"):
			if reaction.react_to_gun(hit_position, gun, gun_manager, mouse_button):
				return
