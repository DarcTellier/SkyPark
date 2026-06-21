@tool
extends Node2D
@export var open_time_in_sec = 1.0
@export var close_time_in_sec = 1.0

@export var gate_opening_size = 100 
var gate_A_default_position 
var gate_B_default_position 

# === CONFIG ===
@export var sunday_enabled := true
@export var monday_enabled := true
@export var tuesday_enabled := true
@export var wednesday_enabled := true
@export var thursday_enabled := true
@export var friday_enabled := true
@export var saturday_enabled := true
#happens twice per day 
@export var use_12_hour_cycle := true 
@export var show_debug := false

# Open/Close switch
var open_gate_switch = false
var close_gate_switch = false

# Each window is a dictionary with 'open' and 'close' keys containing time dictionaries
@export var schedule_windows: Array[Dictionary] = [
	{
		"open": {"hour": 23, "minute": 50, "second": 0},
		"close": {"hour": 0, "minute": 10, "second": 0}
	},
	{
		"open": {"hour": 23, "minute": 50, "second": 0},
		"close": {"hour": 0, "minute": 10, "second": 0}
	}
]

@export var override_enabled := false
@export var override_open := false

# === INTERNAL ===
var is_open := false


func _ready() -> void:
	gate_A_default_position = $AGate.position
	gate_B_default_position = $BGate.position


func _process(_delta):
	var now = Time.get_time_dict_from_system()
	var weekday = Time.get_date_dict_from_system().weekday

	if override_enabled:
		is_open = override_open
		if show_debug:
			print("🔧 Manual override: is_open =", is_open)
	else:
		if is_day_enabled(weekday):
			is_open = is_within_any_window(now)
		else:
			is_open = false
			if show_debug:
				print("🛑 Day not enabled:", weekday)

	update_gate()


func is_day_enabled(day: int) -> bool:
	match day:
		0: return sunday_enabled
		1: return monday_enabled
		2: return tuesday_enabled
		3: return wednesday_enabled
		4: return thursday_enabled
		5: return friday_enabled
		6: return saturday_enabled
	return false


func is_within_any_window(current_time: Dictionary) -> bool:
	var now_seconds = time_to_seconds(current_time)

	for window in schedule_windows:
		var open_time = time_to_seconds(window["open"])
		var close_time = time_to_seconds(window["close"])

		var is_in_range = false

		if open_time <= close_time:
			is_in_range = now_seconds >= open_time and now_seconds <= close_time
		else:
			# Handles wrap-around window (e.g., 23:50 -> 00:10)
			is_in_range = now_seconds >= open_time or now_seconds <= close_time

		if is_in_range:
			if show_debug:
				print("✅ Inside active window:", window, "now_seconds =", now_seconds)
			return true

	if show_debug:
		print("❌ Not inside any window. Now:", now_seconds)
	return false


func time_to_seconds(t: Dictionary) -> int:
	var hour = t.hour
	if use_12_hour_cycle:
		hour = hour % 12
	return hour * 3600 + t.minute * 60 + t.second


func update_gate():
	if is_open:
		open_gate()
	else:
		close_gate()


func open_gate():
	
	if open_gate_switch == false:
		open_gate_switch = true
		close_gate_switch= false

		var tweenA := create_tween()
		var tweenB := create_tween()
		tweenA.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tweenB.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
		tweenA.tween_property($AGate, "position:x", gate_A_default_position.x - gate_opening_size, open_time_in_sec)
		tweenB.tween_property($BGate, "position:x", gate_B_default_position.x + gate_opening_size, open_time_in_sec)




func close_gate():
	if close_gate_switch == false:
		close_gate_switch = true
		open_gate_switch = false
		
		var tweenA := create_tween()
		var tweenB := create_tween()
		tweenA.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tweenB.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
		tweenA.tween_property($AGate, "position:x", gate_A_default_position.x , close_time_in_sec)
		tweenB.tween_property($BGate, "position:x", gate_B_default_position.x, close_time_in_sec)
		print("🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮🌮")
		

	
