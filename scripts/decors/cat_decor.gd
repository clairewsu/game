extends decordata


func obtained():
	Global.decors.append("cat")
	for recipe in DeckManager.book:
		recipe.hq_chance+=.2
