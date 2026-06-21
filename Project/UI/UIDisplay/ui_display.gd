extends Control

func _process(delta: float) -> void:
	update_display()


func update_display():
	update_coins()
	update_level()
	update_time()

func update_coins():
	$Coins.text =  str(GPlayer.coins)

func update_level():
	$Level.text = str(GPlayer.level)
	
func update_time():
	var hour = Time.get_datetime_dict_from_system().hour
	var min = Time.get_datetime_dict_from_system().minute
	var sec = Time.get_datetime_dict_from_system().second
	$Time.text = str( str(hour) + ":" + str(min) + ":" + str(sec))
