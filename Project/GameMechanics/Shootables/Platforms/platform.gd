extends AnimatableBody2D

@onready var gun_reactions: Node = $GunReactions


func shot(hit_position: Vector2, gun: GunData) -> void:
	print("Platform got shot with: ", gun.gun_name)

	for reaction in gun_reactions.get_children():
		print("Checking reaction: ", reaction.name)

		if reaction.has_method("react_to_gun"):
			print("Reaction has method")

			if reaction.react_to_gun(hit_position, gun):
				print("Reaction worked")
				return
