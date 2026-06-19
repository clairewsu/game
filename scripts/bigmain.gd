extends Node
var open_scene = preload("res://scenes/main.tscn")
@export var object_scene:PackedScene
@export var menu_scene:PackedScene
var cards={}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ui/open.pressed.connect(_on_open)
	cards=DeckManager.cards
	show_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_open():
	var open=open_scene.instantiate()
	add_child(open)
	$ui/open.hide()
	
func show_menu():
	var x=1
	for name in cards.keys():
		var object=object_scene.instantiate()
		var menu=menu_scene.instantiate()
		object.data=cards[name]
		add_child(object)
		add_child(menu)
		object.scale*=.5
		menu.scale*=.7
		object.sold=true
		object.menu_ver=true
		object.position=Vector2(-100,200)+Vector2(200*x,0)
		object._show_desc(name,object.data.color,object.data.basevalue,object.data.desc,object.position)
		menu.position=object.position+Vector2(-100,-50)
		menu.objname=name
		menu.add.connect(addtodeck)
		x+=1
		$ui/open.pressed.connect(object.queue_free)
		$ui/open.pressed.connect(menu.queue_free)
	x=1
		
func addtodeck(name,amount):
	for i in range(amount):
		DeckManager.addtodeck(name)
