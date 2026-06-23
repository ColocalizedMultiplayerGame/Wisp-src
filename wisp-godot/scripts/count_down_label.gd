extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_luma_time_changed(new_value: Variant) -> void:
	if not self.visible :
		self.visible = true
		
	if typeof(new_value) == Variant.Type.TYPE_INT :
		self.text = "0" + str(new_value)
	else :
		self.text = new_value
