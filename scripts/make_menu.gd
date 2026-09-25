extends Area2D
var objname:String
var object:Area2D
var amount=0
var maxamt=100
var shop_ver=false
var confirm=false
var select=false
signal tempadd
signal add
signal selected(String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("recipes")
	$TextureRect.material=$TextureRect.material.duplicate()
	for i in object.data.ingredient.keys():
		if object.data.ingredient[i]>0:
			$ingredientcost.text+="[img=64]res://art/ingredients/"+i+".PNG[/img]"
			$ingredientcost.text+=str(object.data.ingredient[i])
	match object.data.rarity:
		"common": $TextureRect.texture=load("res://art/scorecounter_paper.PNG")
		"uncommon": $TextureRect.texture=load("res://art/uncommonrecipe.PNG")
		"rare": $TextureRect.texture=load("res://art/rarerecipe.PNG")
	objname=object.data.name


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shop_ver:
		$upbutton.hide()
		$downbutton.hide()
		$Label.hide()
		$makebutton.hide()
		$remove.hide()
	amount=int($Label.text)
	if $upbutton.is_pressed() and $Timer.is_stopped():
		_on_upbutton_pressed()
		$Timer.start()
	if $downbutton.is_pressed() and $Timer.is_stopped():
		_on_downbutton_pressed()
		$Timer.start()
	if $remove.is_pressed() and $Timer.is_stopped():
		_on_remove_pressed()
		$Timer.start()
	if confirm:
		$remove.text="remove?"
	else:
		$remove.text="x"

func _on_upbutton_pressed() -> void:
	get_parent().get_parent().tempadd(self)
	$Label.text=str(min(maxamt,int($Label.text)+1))

func _on_downbutton_pressed() -> void:
	$Label.text=str(max(int($Label.text)-1,0))
	
func _unhandled_input(event):
	if event.is_action_pressed("enter"):
		add.emit(object,objname,amount)
		$Label.text="0"
	if event.is_action_pressed("move") and confirm:
		confirm=false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and select:
		$TextureRect.material.set_shader_parameter("strength", abs($TextureRect.material.get_shader_parameter("strength")-1))
		selected.emit(objname)

func _on_makebutton_pressed() -> void:
	add.emit(object,objname,amount)
	for i in DeckManager.book:
		if i.name==objname:
			i.amt+=amount
	$Label.text="0"

func setamt(amt:int):
	$Label.text=str(amt)

func _on_label_text_changed(new_text: String) -> void:
	var caret=$Label.caret_column
	var text=""
	for c in new_text:
		if c in "1234567890":
			text+=c
	get_parent().get_parent().tempadd(self)
	text=str(min(maxamt,int(text)))
	if text != new_text:
		$Label.text=text
		$Label.caret_column=clamp(caret-1,0,text.length())
	
func _on_remove_pressed() -> void:
	if confirm:
		object.queue_free()
		self.queue_free()
		for i in DeckManager.book:
			if i.name==objname:
				DeckManager.book.erase(i)
	else:
		confirm=true
		
func _show_desc():
	$title.text=object.data.name
	$price.text="price: "+str(object.data.basevalue)
	$desc.text=object.data.desc
