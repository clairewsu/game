extends Node
var open_scene = preload("res://scenes/main.tscn")
@export var object_scene:PackedScene
@export var menu_scene:PackedScene
var recipeslots=[Vector2(300,170),Vector2(450,170),Vector2(300,370),Vector2(450,370),Vector2(650,170),Vector2(800,170),Vector2(650,370),Vector2(800,370)]
var slot_occupied=[false,false,false,false,false,false,false,false]
var cards={}
signal hiderecipes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ui/open.pressed.connect(_on_open)
	$recipebook.hide()
	cards=DeckManager.cards


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_open():
	var open=open_scene.instantiate()
	add_child(open)
	$ui.hide()
	
func show_menu():
	var x=1
	$recipebook.show()
	$ui/open.hide()
	for name in cards.keys():
		var object=object_scene.instantiate()
		var menu=menu_scene.instantiate()
		var slot=get_free_slot()
		if slot == -1:
			return
		object.data=cards[name]
		add_child(object)
		add_child(menu)
		object.position=recipeslots[slot]
		object.scale*=.5
		menu.scale*=.7
		object.z_index=100
		object.sold=true
		object.menu_ver=true
		object._show_desc(name,object.data.color,object.data.basevalue,object.data.desc,object.position)
		menu.position=object.position+Vector2(-50,-100)
		menu.objname=name
		menu.add.connect(addtodeck)
		x+=1
		hiderecipes.connect(object.queue_free)
		hiderecipes.connect(menu.queue_free)
	x=1
		
func addtodeck(name,amount):
	for i in range(amount):
		DeckManager.addtodeck(name)
		
func get_free_slot():
	for i in range(slot_occupied.size()):
		if not slot_occupied[i]:
			slot_occupied[i] = true
			return i
	return -1
	
func _input(event):
	if event.is_action("move") and not $recipebook.get_global_rect().has_point(event.position):
		$recipebook.hide()
		hiderecipes.emit()
		$ui/recipebookbutton.show()
		$ui/open.show()
		slot_occupied=[false,false,false,false,false,false,false,false]
