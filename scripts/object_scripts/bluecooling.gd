extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_sold(main):
	if randf()<=.2:
		if hq:
			main.roundmult=2
		else:
			main.roundmult=1.5
