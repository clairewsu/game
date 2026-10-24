extends shop_node


# Called when the node enters the scene tree for the first time.
func load_stuff() -> void:
	for file in ResourceLoader.list_directory("res://resources/"):
		if file.ends_with(".tres"):
			var path=ResourceLoader.load("res://resources/"+file)
			stuff.append(path)
			if path.rarity=="uncommon":
				stuff.append(path)
			if path.rarity=="common":
				stuff.append(path)
				stuff.append(path)
	stuff=stuff.filter(func(file):return file not in DeckManager.excluded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
