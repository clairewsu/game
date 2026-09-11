extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_sold(main):
	if hq:
		main.effects.append("hunthq")
	else:
		main.effects.append("hunt")
