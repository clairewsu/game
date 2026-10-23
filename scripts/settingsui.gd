extends CanvasLayer
@onready var sfx_bus=AudioServer.get_bus_index("sfx")
var delay=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.time=$HSlider.value
	$HSlider/Label.text="opening time: "+str(Global.time)+" sec"


func _on_button_pressed() -> void:
	for i in get_tree().get_nodes_in_group("event"):
		i.process_mode=Node.PROCESS_MODE_INHERIT
		if i.get_node_or_null("exit"): i.get_node_or_null("exit").show()
	hide()


func _on_sfxvol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus,linear_to_db($sfxvol.value))
	if not delay:
		$AudioStreamPlayer2D.play()
		delay=true
		await get_tree().create_timer(.1).timeout
		delay=false
	else:
		return

func _on_h_slider_value_changed(value: float) -> void:
	if not delay:
		$AudioStreamPlayer2D.play()
		delay=true
		await get_tree().create_timer(.1).timeout
		delay=false
	else:
		return
