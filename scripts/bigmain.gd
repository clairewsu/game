extends Node
var open_scene = preload("res://scenes/main.tscn")
var gather_scene=preload("res://scenes/gather.tscn")
var shop_ingredient_scene=preload("res://scenes/shop_ingredient.tscn")
var shop_potion_scene=preload("res://scenes/shop_potion.tscn")
var shop_recipe_scene=preload("res://scenes/shop_recipe.tscn")
var encounter_scene=preload("res://scenes/encounter.tscn")
var decor_scene=preload("res://scenes/decor.tscn")
var event_scene=preload("res://scenes/event.tscn")
var avatar_scene=preload("res://scenes/ari_main.tscn")
var popup_scene=preload("res://scenes/main_popup.tscn")
@onready var avatar=avatar_scene.instantiate()
@export var object_scene:PackedScene
@export var menu_scene:PackedScene
var recipeslots=[Vector2(300,190),Vector2(460,190),Vector2(300,390),Vector2(460,390),Vector2(640,190),Vector2(790,190),Vector2(640,390),Vector2(790,390)]
var slot_occupied=[false,false,false,false,false,false,false,false]
var tempingredients={}
var cards={}
var popping_up=false
var tempmoneys=Global.moneys
var visible1=true
var node=1
signal hiderecipes
signal eventchosen
signal move

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ui/open.pressed.connect(_on_open)
	$ui/event.pressed.connect(_on_event)
	$moneycount/Control/Label.text=str(Global.default_moneys)
	$recipebook.hide()
	cards=DeckManager.cards
	var popup=popup_scene.instantiate()
	popup.position=Vector2(550,350)
	move.connect(popup.move)
	add_child(popup)
	popup.get_node("Sprite2D").texture=load("res://art/main_home.PNG")
	add_child(avatar)
	avatar.scale=Vector2(.3,.3)
	avatar.position=Vector2(550,300)
	avatar.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.moneys!=tempmoneys and not popping_up:
		tempmoneys=Global.moneys
		money_changed()
	
func _on_open():
	await transition("open")
	$ui/open.hide()
	show_menu()
	await hiderecipes
	var open=open_scene.instantiate()
	add_child(open)
	$ui.hide()
	$moneycount.hide()
	visible1=false
	open.tree_exited.connect(_on_close)
	
func _on_gather(ingredients):
	await transition("gather")
	hide_menu()
	var gather=gather_scene.instantiate()
	gather.ingredients=ingredients
	add_child(gather)
	$ui.hide()
	$moneycount.hide()
	$invbutton.show()
	visible1=false
	gather.tree_exited.connect(_on_close)
	
func _on_ingredientshop():
	await transition("shop")
	hide_menu()
	var ingredientshop=shop_ingredient_scene.instantiate()
	add_child(ingredientshop)
	$ui.hide()
	$invbutton.show()
	ingredientshop.tree_exited.connect(_on_close)

func _on_potionshop():
	await transition("shop")
	hide_menu()
	var potionshop=shop_potion_scene.instantiate()
	add_child(potionshop)
	$ui.hide()
	$invbutton.show()
	potionshop.tree_exited.connect(_on_close)
	
func _on_recipeshop():
	await transition("shop")
	hide_menu()
	var recipeshop=shop_recipe_scene.instantiate()
	add_child(recipeshop)
	$ui.hide()
	$invbutton.show()
	recipeshop.tree_exited.connect(_on_close)
	
func _on_encounter():
	await transition("encounter")
	hide_menu()
	var encounter=encounter_scene.instantiate()
	var encounters=[]
	for file in DirAccess.get_files_at("res://resources/encounters/"):
		if file.ends_with(".tres"):
			encounters.append(file)
	encounter.data=load("res://resources/encounters/"+encounters.pick_random())
	add_child(encounter)
	$ui.hide()
	$moneycount.hide()
	visible1=false
	$invbutton.show()
	encounter.tree_exited.connect(_on_close)
	
func transition(type):
	var dots=[load("res://art/main_dot1.PNG"),load("res://art/main_dot2.PNG"),load("res://art/main_dot3.PNG")]
	for i in range(4):
		var popup=popup_scene.instantiate()
		popup.position=Vector2(650+100*i,350)
		move.connect(popup.move)
		add_child(popup)
		if i<3:
			popup.get_node("Sprite2D").texture=dots.pick_random()
		else:
			match type:
				"home":
					popup.get_node("Sprite2D").texture=load("res://art/main_home.PNG")
				"shop":
					popup.get_node("Sprite2D").texture=load("res://art/main_shop.PNG")
				"gather":
					popup.get_node("Sprite2D").texture=load("res://art/main_gather.PNG")
				"encounter":
					popup.get_node("Sprite2D").texture=load("res://art/main_encounter.PNG")
		await get_tree().create_timer(.2).timeout
	move.emit()
	avatar.play("walk")
	await get_tree().create_timer(1.5).timeout
	avatar.play("default")
	await get_tree().create_timer(1).timeout
	
func show_menu():
	var x=1
	$recipebook.show()
	for name in DeckManager.book:
		var object=object_scene.instantiate()
		var menu=menu_scene.instantiate()
		var slot=get_free_slot()
		if slot == -1:
			return
		object.data=name
		menu.object=object
		$recipebook.add_child(object)
		$recipebook.add_child(menu)
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
		menu.get_node("TextureRect").z_index=10
		menu.add.connect(addtodeck)
		x+=1
		hiderecipes.connect(object.queue_free)
		hiderecipes.connect(menu.queue_free)
	x=1
	
func hide_menu():
	$recipebook.hide()
	hiderecipes.emit()
	$ui/recipebookbutton.show()
	slot_occupied=[false,false,false,false,false,false,false,false]
			
func addtodeck(object,name,amount):
	for i in range(amount):
		DeckManager.addtodeck(name)
		if randf()<=object.data.hq_chance:
			for x in DeckManager.deck:
				if x.name==name and x.hq==false:
					x.hq=true
					x.basevalue*=3
					break
		for key in Global.ingredients.keys():
			Global.ingredients[key]-=object.data.ingredient[key]
	$ui.show_inv()
		
func get_free_slot():
	for i in range(slot_occupied.size()):
		if not slot_occupied[i]:
			slot_occupied[i] = true
			return i
	return -1
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move") and $recipebook.visible==true and not $recipebook/recipebook.get_global_rect().has_point(event.position):
		hide_menu()

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
	if Global.moneys<0:
		return
	popping_up=true
	var tween=create_tween()
	$moneycount.show()
	if not visible1:
		$moneycount/Control.position+=Vector2(0,-100)
		tween.tween_property($moneycount/Control,"position",$moneycount/Control.position+Vector2(0,100),.5)
	tween.tween_method(update_moneys,int($moneycount/Control/Label.text),Global.moneys,1)
	await tween.finished
	if not visible1:
		tween=create_tween()
		tween.tween_interval(.3)
		tween.tween_property($moneycount/Control,"position",$moneycount/Control.position+Vector2(0,-100),.5)
		await tween.finished
		$moneycount.hide()
	$moneycount/Control.position=Vector2(0,0)
	popping_up=false
	
func update_moneys(amt):
	$moneycount/Control/Label.text=str(amt)
	
func _on_close():
	visible1=true
	$invbutton.hide()
	if node==6:
		node=1
		Global.level+=1
	else:
		node+=1
	if node==6:
		$ui/event.hide()
		$ui/open.show()
	else:
		$ui/event.show()
		$ui/open.hide()
	$ui.show()
	$ui.show_inv()
	$moneycount.show()
	

func _on_timer_timeout() -> void:
	update_moneys_popup()
	
func _on_event():
	$ui/event.hide()
	var options=["gather","gather","gather","encounter","encounter","encounter","potionshop","ingredientshop","recipeshop"]
	for i in range(3):
		var event=event_scene.instantiate()
		event.position=Vector2(300*i,45)
		var option=options.pick_random()
		event.get_node("Button").text=option
		event.get_node("Button").pressed.connect(eventchosen.emit)
		eventchosen.connect(event.queue_free)
		match option:
			"gather":
				var gathers=[["fish","leaf","feather"],["rock","flower","fish"],["rock","crystal","bone"],["clay","bone","feather"],["leaf","flower","mushroom"],["clay","crystal","mushroom"]]
				var gather=gathers.pick_random()
				event.get_node("Button").pressed.connect(_on_gather.bind(gather))
				event.get_node("ing1").texture=load("res://art/ingredients/"+gather[0]+".PNG")
				event.get_node("ing2").texture=load("res://art/ingredients/"+gather[1]+".PNG")
				event.get_node("ing3").texture=load("res://art/ingredients/"+gather[2]+".PNG")
				event.get_node("ing1").show()
				event.get_node("ing2").show()
				event.get_node("ing3").show()
			"encounter":
				event.get_node("Button").pressed.connect(_on_encounter)
			"potionshop":
				event.get_node("Button").pressed.connect(_on_potionshop)	
			"ingredientshop":
				event.get_node("Button").pressed.connect(_on_ingredientshop)
			"recipeshop":
				event.get_node("Button").pressed.connect(_on_recipeshop)
		add_child(event)
		
func endscreen():
	$endscreen.show()
	$endscreen/text.text="the end\nyou reached level "+str(Global.level)
	$endscreen/exit.pressed.connect(self.queue_free)



func _on_invbutton_pressed() -> void:
	if $ui.visible==false:
		$ui.show()
		$ui/open.hide()
		$ui/event.hide()
		$ui.show_inv()
		$moneycount.show()
	else:
		hide_menu()
		$ui.hide()
		if not visible1:
			$moneycount.hide()
