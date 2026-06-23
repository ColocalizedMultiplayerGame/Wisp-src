extends Label

var txtInit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	txtInit = self.text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_luma_round_changed(new_value: Variant) -> void:
	if not self.visible :
		self.visible = true
	self.text = txtInit + str(new_value)
