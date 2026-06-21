extends Node

func movement_input():
	
	var direction = Input.get_axis("left", "right")
	if direction <0:
		get_parent().get_node("Sprite").flip_h = true
	elif direction >0 :
		get_parent().get_node("Sprite").flip_h = false
	if direction:
		get_parent().velocity.x = direction * get_parent().SPEED
	else:
		get_parent().velocity.x = move_toward(get_parent().velocity.x,get_parent().horizontal_velocity,get_parent(). SPEED) 

	get_parent().move_and_slide()
