extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.time=$HSlider.value
	$Label.text="opening time: "+str(Global.time)+" sec"


func _on_button_pressed() -> void:
	for i in get_tree().get_nodes_in_group("event"):
		i.process_mode=Node.PROCESS_MODE_INHERIT
		if i.get_node_or_null("exit"): i.get_node_or_null("exit").show()
	hide()
