extends CanvasLayer

var player_reff
var pause = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if pause == false:
			#get_tree().paused = true
			player_reff.process_mode = Node.PROCESS_MODE_DISABLED
			$PauseScreen.show()
			$PauseSound.play()
			pause = true
		else:
			pause = false
			$PauseScreen.hide()
			#get_tree().paused = false
			$PauseSound.play() #TODO cahnge sound to be reverse or something
			player_reff.process_mode = Node.PROCESS_MODE_INHERIT
	
