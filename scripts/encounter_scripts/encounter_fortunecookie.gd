extends eventdata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func button1(main):
	if randf()>.5:
		main.get_node("text")._on_button_3_pressed()
	else:
		Global.moneys+=6000
		
func button3(main):
	Global.ingredients[Global.ingredients.keys().pick_random()]=0
