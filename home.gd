extends Node
var game_scene=preload("res://scenes/bigmain.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	var game=game_scene.instantiate()
	add_child(game)
	$start.hide()
	$Label.hide()
	game.tree_exited.connect(_on_end)
	
func _on_end():
	$start.show()
	$Label.show()
