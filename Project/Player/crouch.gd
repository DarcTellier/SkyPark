extends Node

var crouch = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		crouch = true
	if event.is_action_released("down"):
		crouch = false



func _process(delta: float) -> void:
	if crouch == true:
		#change image 
		get_parent().get_node("Sprite").visible =  false
		get_parent().get_node("SpriteCrouch").visible =  true
		get_parent().get_node("PlayerCollision").shape.size.y = 16
		get_parent().get_node("PlayerCollision").position.y = 8
		
		
		# change collision shape
	else:
		get_parent().get_node("Sprite").visible =  true
		get_parent().get_node("PlayerCollision").disabled = false
		get_parent().get_node("SpriteCrouch").visible =  false
		get_parent().get_node("PlayerCollision").shape.size.y = 25
		get_parent().get_node("PlayerCollision").position.y = 3.5
		
		
