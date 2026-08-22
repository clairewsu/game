extends shop_node


# Called when the node enters the scene tree for the first time.
func load_stuff() -> void:
	for file in DirAccess.get_files_at("res://resources/"):
		if file.ends_with(".tres") and not DeckManager.book.any(func(r): return r.resource_path == str("res://resources/"+file)):
			stuff.append(file)
	for i in stuff.size()-1:
		if stuff[i].name in DeckManager.excluded:
			stuff.remove_at(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
