extends Node
var inventory = []
var level = 0
var coins = 0


func current_elevation (player_pos):
	level= -(int((player_pos / 16)+1)) 
	
	
func inventory_insert(item):
	inventory.insert(inventory.size(),str(item))
	print(inventory)
