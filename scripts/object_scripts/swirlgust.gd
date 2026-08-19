extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_dismiss(guy1):
	if guy1.slot_occupied.all(func(i):return i==3 or i==-1):
		if hq:
			guy1.multiplier*=2
		else:
			guy1.multiplier*=1.5
