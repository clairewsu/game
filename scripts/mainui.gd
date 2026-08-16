extends CanvasLayer
@export var label_scene:PackedScene
var object_scene=preload("res://scenes/object.tscn")
signal hideinv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_inv()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$supplycount.text="supply: "+str(DeckManager.deck.size())
	$nodecount.text="level "+str(Global.level)+" node "+str(get_parent().node)+" of 6"

func _on_recipebook_pressed() -> void:
	$recipebookbutton.hide()
	get_parent().show_menu()
	
func show_inv():
	if not is_inside_tree():
		return
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


func _on_supplycount_pressed() -> void:
	$supplyinv.show()
	var inv=[]
	for i in DeckManager.deck:
		var skip=false
		for j in inv:
			if i.name==j.data.name:
				j.get_node("invamt").text=str(int(j.get_node("invamt").text)+1)
				skip=true
				break
		if skip:
			continue
		var wrapper=Control.new()
		wrapper.custom_minimum_size=Vector2(200,200)
		var object=object_scene.instantiate()
		object.data=i
		object.sold=true
		object.menu_ver=true
		object.scale*=.5
		wrapper.add_child(object)
		inv.append(object)
		object.get_node("invamt").show()
		object.get_node("invamt").text="1"
		$supplyinv/ScrollContainer/GridContainer.add_child(wrapper)
		object.position=wrapper.custom_minimum_size/2
		object.objpos=object.position
		hideinv.connect(wrapper.queue_free)
		
func _input(event):
	if event.is_action("move") and $supplyinv.visible==true and not $supplyinv.get_global_rect().has_point(event.position):
		hide_menu()
		
func hide_menu():
	$supplyinv.hide()
	hideinv.emit()
