extends eventdata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func button1():
	Global.ingredients["flower"]+=5
	
func button2():
	Global.ingredients["mushroom"]+=5
	
func button3():
	Global.ingredients["feather"]+=5
