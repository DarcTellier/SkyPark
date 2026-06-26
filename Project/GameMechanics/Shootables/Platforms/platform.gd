extends AnimatableBody2D

@onready var gun_reactions: Node = $GunReactions


func shot(hit_position: Vector2, gun: GunData, gun_manager: Node = null) -> void:
	print("Platform shot with: ", gun.gun_name)

	for reaction in gun_reactions.get_children():
		print("Checking: ", reaction.name)

		if reaction.has_method("react_to_gun"):
			var worked = reaction.react_to_gun(hit_position, gun, gun_manager)
			print(reaction.name, " worked: ", worked)

			if worked:
				return
