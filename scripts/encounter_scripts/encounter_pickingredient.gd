extends eventdata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func button1(main):
	Global.ingredients["flower"]+=5
	
func button2(main):
	Global.ingredients["mushroom"]+=5
	
func button3(main):
	Global.ingredients["feather"]+=5
