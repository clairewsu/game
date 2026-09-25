extends Node
var game_scene=preload("res://scenes/bigmain.tscn")
var object_scene=preload("res://scenes/object.tscn")
var objectbg_scene=preload("res://scenes/make_menu.tscn")
var starting=[]
var x:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$continue.hide()
	$Label2.hide()
	$start.mouse_entered.connect(_on_button_mouse_entered.bind($start))
	$tutorial.mouse_entered.connect(_on_button_mouse_entered.bind($tutorial))
	$start.mouse_exited.connect(_on_button_mouse_exited.bind($start))
	$tutorial.mouse_exited.connect(_on_button_mouse_exited.bind($tutorial))
	$settings.mouse_entered.connect(_on_button_mouse_entered.bind($settings))
	$settings.mouse_exited.connect(_on_button_mouse_exited.bind($settings))
	$start.pivot_offset=$start.size/2
	$tutorial.pivot_offset=$tutorial.size/2
	$settings.pivot_offset=$settings.size/2
	x=$start.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if starting.size()==2:
		$continue.disabled=false
	else:
		$continue.disabled=true


func _on_start_pressed() -> void:
	$start.hide()
	$Label.hide()
	$tutorial.hide()
	$Label2.show()
	$settings.hide()
	$continue.show()
	$TextureRect.texture=load("res://art/main_bg.png")
	var stuff=[]
	var xlist=[]
	for file in DirAccess.get_files_at("res://resources/"):
		if file.ends_with(".tres") and not DeckManager.book.any(func(r): return r.resource_path == str("res://resources/"+file)) and not load("res://resources/"+file).rarity=="rare":
			stuff.append(file)
	stuff=stuff.filter(func(file):return file not in DeckManager.excluded)
	var i=0
	while i<6:
		var x=randi_range(0,stuff.size()-1)
		var object=object_scene.instantiate()
		object.menu_ver=true
		object.sold=true
		object.data=load("res://resources/"+stuff[x])
		object.data.hq=false
		add_child(object)
		object.scale*=.6
		object.position=Vector2(200+250*ceil(i/2),150)
		if i%2==0:
			object.position+=Vector2(0,250)
		object.objpos=object.position
		if x in xlist:
			object.queue_free()
			continue
		xlist.append(x)
		var menu=objectbg_scene.instantiate()
		menu.object=object
		menu.select=true
		menu.selected.connect(addtolist)
		menu._show_desc()
		add_child(menu)
		menu.scale*=.8
		menu.position=object.position+Vector2(-50,-100)
		menu.get_node("TextureRect").z_index=-10
		menu.objname=object.data.name
		menu.shop_ver=true
		i+=1
		$continue.pressed.connect(object.queue_free)
		$continue.pressed.connect(menu.queue_free)

func addtolist(a):
	if a in starting:
		starting.erase(a)
	else:
		starting.append(a)
	
func _on_end():
	$start.show()
	$Label.show()
	$tutorial.show()
	$settings.show()
	$TextureRect.texture=load("res://art/openingbg.PNG")


func _on_continue_pressed() -> void:
	var game=game_scene.instantiate()
	add_child(game)
	$continue.hide()
	$Label2.hide()
	for i in starting:
		DeckManager.addtobook(i)
	game.tree_exited.connect(_on_end)


func _on_button_mouse_entered(button) -> void:
	create_tween().tween_property(button,"scale",Vector2(1.5,1.5),.1)
	
func _on_button_mouse_exited(button) -> void:
	create_tween().tween_property(button,"scale",Vector2(x,x),.1)


func _on_settings_pressed() -> void:
	$settingsui.show()
