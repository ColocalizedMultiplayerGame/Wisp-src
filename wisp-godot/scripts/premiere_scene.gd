extends Node2D

@onready var darkLayer = $DarknessCanvasLayer
@onready var ecranFin = $EcranFin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fin_jeu() -> void :
	darkLayer.visible = false
	ecranFin.visible = true
	$"EcranFin/BtnRestart".visible = true
	$CountDownLabel.visible = false
	$NumTourLabel.visible = false
	

func _on_luma_gagner() -> void:
	fin_jeu()
	$"EcranFin/Gagner".visible = true
	


func _on_luma_perdu() -> void:
	fin_jeu()
	$"EcranFin/Perdu".visible = true
