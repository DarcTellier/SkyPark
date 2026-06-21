extends Sprite2D

@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")
	
	
func on_interact():
	unlock_door()


func unlock_door():
	if GPlayer.inventory.has("key"):
		GPlayer.inventory.erase("key")
		get_parent().locked = false
		
		queue_free()
