extends Node
var open_scene = preload("res://scenes/main.tscn")
var gather_scene=preload("res://scenes/gather.tscn")
var shop_ingredient_scene=preload("res://scenes/shop_ingredient.tscn")
var shop_potion_scene=preload("res://scenes/shop_potion.tscn")
var shop_recipe_scene=preload("res://scenes/shop_recipe.tscn")
var encounter_scene=preload("res://scenes/encounter.tscn")
var decor_scene=preload("res://scenes/decor.tscn")
@export var object_scene:PackedScene
@export var menu_scene:PackedScene
var recipeslots=[Vector2(300,190),Vector2(460,190),Vector2(300,390),Vector2(460,390),Vector2(640,190),Vector2(790,190),Vector2(640,390),Vector2(790,390)]
var slot_occupied=[false,false,false,false,false,false,false,false]
var tempingredients={}
var cards={}
var popping_up=false
var tempmoneys=Global.moneys
var visible=true
signal hiderecipes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ui/open.pressed.connect(_on_open)
	$ui/gather.pressed.connect(_on_gather)
	$ui/ingredientshop.pressed.connect(_on_ingredientshop)
	$ui/potionshop.pressed.connect(_on_potionshop)
	$ui/recipeshop.pressed.connect(_on_recipeshop)
	$ui/encounter.pressed.connect(_on_encounter)
	$moneycount/Label.text=str(Global.default_moneys)
	$recipebook.hide()
	cards=DeckManager.cards

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.moneys!=tempmoneys and not popping_up:
		tempmoneys=Global.moneys
		money_changed()
	
func _on_open():
	var open=open_scene.instantiate()
	add_child(open)
	$ui.hide()
	$moneycount.hide()
	visible=false
	open.tree_exited.connect(_on_close)
	
func _on_gather():
	var gather=gather_scene.instantiate()
	add_child(gather)
	$ui.hide()
	$moneycount.hide()
	visible=false
	gather.tree_exited.connect(_on_close)
	
func _on_ingredientshop():
	var ingredientshop=shop_ingredient_scene.instantiate()
	add_child(ingredientshop)
	$ui.hide()
	$moneycount.hide()
	visible=false
	ingredientshop.tree_exited.connect(_on_close)

func _on_potionshop():
	var potionshop=shop_potion_scene.instantiate()
	add_child(potionshop)
	$ui.hide()
	$moneycount.hide()
	visible=false
	potionshop.tree_exited.connect(_on_close)
	
func _on_recipeshop():
	var recipeshop=shop_recipe_scene.instantiate()
	add_child(recipeshop)
	$ui.hide()
	$moneycount.hide()
	visible=false
	recipeshop.tree_exited.connect(_on_close)
	
func _on_encounter():
	var encounter=encounter_scene.instantiate()
	var encounters=[]
	for file in DirAccess.get_files_at("res://resources/encounters/"):
		if file.ends_with(".tres"):
			encounters.append(file)
	encounter.data=load("res://resources/encounters/"+encounters.pick_random())
	add_child(encounter)
	$ui.hide()
	$moneycount.hide()
	visible=false
	encounter.tree_exited.connect(_on_close)
		
func show_menu():
	var x=1
	$recipebook.show()
	$ui/open.hide()
	for name in DeckManager.book:
		var object=object_scene.instantiate()
		var menu=menu_scene.instantiate()
		var slot=get_free_slot()
		if slot == -1:
			return
		object.data=name
		menu.object=object
		add_child(object)
		add_child(menu)
		object.position=recipeslots[slot]
		object.objpos=object.position
		object.scale*=.5
		menu.scale*=.7
		object.z_index=100
		object.sold=true
		object.menu_ver=true
		object._show_desc(object.data.name,object.data.color,object.data.basevalue,object.data.desc,object.position)
		menu.position=object.position+Vector2(-50,-100)
		menu.objname=object.data.name
		menu.get_node("TextureRect").z_index=object.get_node("liquid").z_index-1
		menu.add.connect(addtodeck)
		x+=1
		hiderecipes.connect(object.queue_free)
		hiderecipes.connect(menu.queue_free)
	x=1
		
func addtodeck(object,name,amount):
	for i in range(amount):
		DeckManager.addtodeck(name)
		for key in Global.ingredients.keys():
			Global.ingredients[key]-=object.data.ingredient[key]
	$ui.show_inv()
		
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

func tempadd(tempobj):
	tempingredients.clear()
	var maxamt=[]
	for recipe in get_tree().get_nodes_in_group("recipes"):
		if recipe!=tempobj:
			for ingredient in recipe.object.data.ingredient.keys():
				var amt=recipe.amount*recipe.object.data.ingredient[ingredient]
				tempingredients[ingredient]=tempingredients.get(ingredient,0)+amt
	for i in tempobj.object.data.ingredient.keys():
		if tempobj.object.data.ingredient[i]>0:
			maxamt.append(int(floor((Global.ingredients[i]-tempingredients[i])/tempobj.object.data.ingredient[i])))
			tempobj.maxamt=maxamt.min()

func money_changed():
	$moneycount/Timer.start()
	
func update_moneys_popup():
	popping_up=true
	var tween=create_tween()
	$moneycount.show()
	$moneycount.position+=Vector2(0,-100)
	tween.tween_property($moneycount,"position",$moneycount.position+Vector2(0,100),1)
	tween.tween_method(update_moneys,int($moneycount/Label.text),Global.moneys,1)
	await tween.finished
	if not visible:
		tween=create_tween()
		tween.tween_interval(.3)
		tween.tween_property($moneycount,"position",$moneycount.position+Vector2(0,-100),1)
		await tween.finished
		$moneycount.hide()
	$moneycount.position=Vector2(0,0)
	popping_up=false
	
func update_moneys(amt):
	$moneycount/Label.text=str(amt)
	
func _on_close():
	visible=true
	$ui.show()
	$ui.show_inv()
	$moneycount.show()
	

func _on_timer_timeout() -> void:
	update_moneys_popup()
