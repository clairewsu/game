extends shop_node


# Called when the node enters the scene tree for the first time.
func load_stuff() -> void:
	for file in DirAccess.get_files_at("res://resources/"):
		if file.ends_with(".tres"):
			stuff.append(file)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
