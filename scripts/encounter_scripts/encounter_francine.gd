extends eventdata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func button1(main):
	if main.get_node("text/Button1").text in Global.ingredients.keys():
		Global.ingredients[main.get_node("text/Button1").text]*=2
	
func button2(main):
	if main.get_node("text/Button1").text in Global.ingredients.keys():
		Global.ingredients[main.get_node("text/Button2").text]*=2
	
func button3(main):
	Global.ingredients[main.get_node("text/Button3").text]*=2
	
func button4(main):
	Global.ingredients[main.get_node("text/Button4").text]*=2
