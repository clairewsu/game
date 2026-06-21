extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$supplycount.text="supply: "+str(DeckManager.deck.size())

func _on_recipebook_pressed() -> void:
	$recipebookbutton.hide()
	get_parent().show_menu()
