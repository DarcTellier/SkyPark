extends AnimatableBody2D
var speed = 4
var min_height
var max_height
var inside_elevator = false

func _ready() -> void:
	min_height = get_parent().get_node("MinHeight").position
	max_height =  get_parent().get_node("MaxHeight").position
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inside_elevator = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inside_elevator = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("up") && inside_elevator ==true :
		if position.y >= max_height.y:
			position.y -= speed
			if position.y < max_height.y:# evens out the platform 
				position.y = max_height.y

	if Input.is_action_pressed("down") && inside_elevator ==true :
		if position.y <= min_height.y:
			position.y += speed
			if position.y > min_height.y:# evens out the platform 
				position.y = min_height.y
