extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_sold(main):
	DeckManager.addtodeck("abundant gold potion")
	DeckManager.addtodeck("abundant gold potion")
	if hq:
		DeckManager.addtodeck("abundant gold potion")
