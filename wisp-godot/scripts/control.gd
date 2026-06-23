extends Control

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F11:
			_toggle_fullscreen()

func _toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/control-qr.tscn")

func _on_btn_tuto_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control-tuto.tscn")
