extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func on_dismiss():
	if hq:
		return 1.6
	else:
		return 1.3
