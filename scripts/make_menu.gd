extends Panel
var objname:String
var amount=0
signal add

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text=str(amount)


func _on_upbutton_pressed() -> void:
	amount+=1


func _on_downbutton_pressed() -> void:
	amount=max(amount-1,0)
	
func _unhandled_input(event):
	if event.is_action_pressed("enter"):
		add.emit(objname,amount)
		amount=0


func _on_makebutton_pressed() -> void:
	add.emit(objname,amount)
	amount=0
