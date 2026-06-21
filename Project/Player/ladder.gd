extends Node

		
func enter_ladder(center_of_ladder):
	get_parent().velocity.y = 0
	get_parent().gravity = 0
	get_parent().position.x = center_of_ladder.x
	get_parent().default_movevent = false
	get_parent().ladder_movement = true
	


func exit_ladder():
	if get_parent().ladder_movement == true:
		get_parent().default_movevent = true 
		get_parent(). ladder_movement = false
		get_parent(). gravity = get_parent().default_gravity
		



func movement_input():
	var direction = Input.get_axis("up", "down")
	if direction <0:
		get_parent().get_node("Sprite").flip_h = true
	elif direction >0 :
		get_parent().get_node("Sprite").flip_h = false
	if direction:
		get_parent().velocity.y = direction * get_parent().SPEED
	else:
		get_parent().velocity.y = move_toward(get_parent().velocity.x,get_parent().horizontal_velocity,get_parent(). SPEED) 

	get_parent().move_and_slide()
	
	if Input.is_action_pressed("jump"):
		exit_ladder()
		get_parent().jump()
