extends shop_node

func load_stuff():
	for i in range(Global.ingredients.size()):
		stuff.append(Global.ingredients.keys()[i])
	var ingredient={"leaf":0,"flower":0,"fish":0,"feather":0,"mushroom":0,"bone":0,"crystal":0,"rock":0,"clay":0}
	for j in DeckManager.book:
		for ing in j.ingredient.keys():
			if j.ingredient[ing]!=0:
				ingredient[ing]+=1
	for j in ingredient.keys():
		if ingredient[j]>2:
			stuff.append(j)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
