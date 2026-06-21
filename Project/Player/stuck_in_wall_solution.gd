extends Node2D

var up_has_wall = false
var down_has_wall = false
var left_has_wall = false
var right_has_wall = false

func _on_up_unstuck_body_entered(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			up_has_wall = true
	

func _on_up_unstuck_body_exited(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			up_has_wall = false


func _on_down_unstuck_body_entered(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			down_has_wall = true


func _on_down_unstuck_body_exited(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			down_has_wall = false


func _on_left_unstuck_body_entered(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			left_has_wall = true


func _on_left_unstuck_body_exited(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			left_has_wall = false


func _on_right_unstuck_body_entered(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			right_has_wall = true


func _on_right_unstuck_body_exited(body: Node2D) -> void:
	if body.name != null:
		if body.name == "TileMapLayer":
			right_has_wall = false


func _process(delta: float) -> void:
	print("_________________")
	print(up_has_wall)
	print(down_has_wall)
	print(left_has_wall)
	print(right_has_wall) 
