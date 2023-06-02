extends Button


func _ready():
	# warning-ignore:return_value_discarded
	connect("pressed", get_node("/root/Game"), "_on_PlayButton_pressed")
