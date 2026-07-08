extends shop_node

func load_stuff():
	for i in range(Global.ingredients.size()):
		stuff.append(Global.ingredients.keys()[i])
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
