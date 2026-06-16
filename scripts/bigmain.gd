extends Node
var open_scene = preload("res://scenes/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ui/open.pressed.connect(_on_open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_open():
	var open=open_scene.instantiate()
	add_child(open)
	$ui/open.hide()
