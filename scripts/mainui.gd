extends CanvasLayer
@export var label_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_inv()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$supplycount.text="supply: "+str(DeckManager.deck.size())
	$nodecount.text="node "+str(get_parent().node)+" of 6"

func _on_recipebook_pressed() -> void:
	$recipebookbutton.hide()
	get_parent().show_menu()
	
func show_inv():
	for thing in get_tree().get_nodes_in_group("labels"):
		thing.queue_free()
	var x=0
	for i in Global.ingredients.keys():
		var label=label_scene.instantiate()
		label.add_to_group("labels")
		label.get_node("TextureRect").texture=load("res://art/ingredients/"+i+".PNG")
		label.get_node("Label").text=str(Global.ingredients[i])
		add_child(label)
		label.position=Vector2(10+120*x,550)
		x=x+1
	for i in range(Global.decors.size()):
		var decor=get_parent().decor_scene.instantiate()
		decor.data=load("res://resources/decors/"+Global.decors[i]+"_decor.tres")
		decor.position=decor.data.menupos
		add_child(decor)
