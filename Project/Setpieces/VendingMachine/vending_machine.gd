extends StaticBody2D

var player_reff = null
var shop_toggle = false
var shop_is_open = false

	
func on_interact():
	vend_shop()
	
func vend_shop():
	$VendingMachineUI.show()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != null:
		if body.name == "Player":
			player_reff = body
			$InteractLabel.show()
			shop_toggle = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != null:
		if body.name == "Player":
			player_reff = null
			$InteractLabel.hide()
			shop_toggle = false





func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if shop_toggle == true && shop_is_open == false:
			$VendingMachineUI.show()
			shop_is_open = true
			player_reff.input_freeze = true
		elif shop_is_open == true:
			$VendingMachineUI.hide()
			shop_is_open = false
			player_reff.input_freeze = false
			
	if event.is_action_pressed("ui_accept"):
		if shop_is_open == true:
			if GPlayer.coins >= 15:
				GPlayer.coins -= 15
				player_reff.cayote_Time = 20
				print("THANKS FOR YOUR PURCHASE")
			else:
				print("not enough cash")	
		
	
