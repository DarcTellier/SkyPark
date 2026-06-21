extends CanvasLayer

var display_toggle = false

func _ready():
	display_toggle = visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if display_toggle == false:
			display_toggle = true
			show()
		else:
			display_toggle = false
			hide()
				
