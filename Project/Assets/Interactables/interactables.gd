extends Node2D

var interact = false
var reading = false


func _ready():
	$pressY.visible = false
	
func _on_area_2d_body_entered(body):
	interact = true
	$pressY.visible = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	interact = false
	$pressY.visible = false
	get_node("/root/Main/Camera2D/TextBox").visible = false
	pass # Replace with function body.
	
	

func _input(event):
	
		
	if event.is_action_pressed("intreraction") && interact == true && reading == false:
		get_node("/root/Main/Camera2D/TextBox").visible = true
		reading = true
		
	elif event.is_action_pressed("intreraction") && interact == true && reading == true:
		get_node("/root/Main/Camera2D/TextBox").visible = false
		reading = false
		
		
		
