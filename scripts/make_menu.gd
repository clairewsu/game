extends Panel
var objname:String
var object:Area2D
var amount=0
var maxamt=100
signal tempadd
signal add

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("recipes")
	for i in object.data.ingredient.keys():
		if object.data.ingredient[i]>0:
			$ingredientcost.text+=i
			$ingredientcost.text+=str(object.data.ingredient[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	amount=int($Label.text)
	if $upbutton.is_pressed() and $Timer.is_stopped():
		_on_upbutton_pressed()
		$Timer.start()
	if $downbutton.is_pressed() and $Timer.is_stopped():
		_on_downbutton_pressed()
		$Timer.start()

func _on_upbutton_pressed() -> void:
	get_parent().tempadd(self)
	$Label.text=str(min(maxamt,int($Label.text)+1))

func _on_downbutton_pressed() -> void:
	$Label.text=str(max(int($Label.text)-1,0))
	
func _unhandled_input(event):
	if event.is_action_pressed("enter"):
		add.emit(object,objname,amount)
		$Label.text="0"


func _on_makebutton_pressed() -> void:
	add.emit(object,objname,amount)
	$Label.text="0"

func setamt(amt:int):
	$Label.text=str(amt)

func _on_label_text_changed(new_text: String) -> void:
	var caret=$Label.caret_column
	var text=""
	for c in new_text:
		if c in "1234567890":
			text+=c
	get_parent().tempadd(self)
	text=str(min(maxamt,int(text)))
	if text != new_text:
		$Label.text=text
		$Label.caret_column=clamp(caret-1,0,text.length())
	
		
	
