extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func on_sold(main):
	await main.get_tree().create_timer(.1).timeout
	main.spawn_object()
	if hq:
		main.spawn_object()
