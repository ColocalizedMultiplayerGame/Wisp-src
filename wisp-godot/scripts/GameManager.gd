extends Node

var current_level_number = 1
var max_levels = 3

func get_level_path():
	return "res://levels/niveau" + str(current_level_number) + ".tscn"

func get_level_number():
	return current_level_number

func next_level():
	current_level_number += 1
	if current_level_number > max_levels:
		current_level_number = 1 # Recommence au début ou va vers un écran de fin
