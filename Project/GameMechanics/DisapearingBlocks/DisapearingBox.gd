extends Node2D

@export var appear = true
@export var speed = 1
@export var time = 60
@export var count = 0 


func _ready():
	if appear == false:
		$StaticBody2D/CollisionShape2D.disabled = true
		visible = false
		

func _process(delta):
	
	count += speed
	if count >= time:
		if appear == true:
			count = 0
			$StaticBody2D/CollisionShape2D.disabled = true
			visible = false
			appear = false
		else:
			count = 0
			$StaticBody2D/CollisionShape2D.disabled = false
			visible = true
			appear = true
			
	
	
	pass
