extends shop_node


# Called when the node enters the scene tree for the first time.
func load_stuff() -> void:
	for file in DirAccess.get_files_at("res://resources/"):
		if file.ends_with(".tres") and not DeckManager.book.any(func(r): return r.resource_path == str("res://resources/"+file)):
			stuff.append(file)
			if load("res://resources/"+file).rarity=="uncommon":
				stuff.append(file)
			if load("res://resources/"+file).rarity=="common":
				stuff.append(file)
				stuff.append(file)
	stuff=stuff.filter(func(file):return file not in DeckManager.excluded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
