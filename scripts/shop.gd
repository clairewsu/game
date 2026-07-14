extends Node
class_name shop_node
var price_scene=preload("res://scenes/shop_price.tscn")
var stuff=[]
var xlist=[]
@export var type:String
@export var multiplier:int
@export var object_scene:PackedScene
@export var menu_scene:PackedScene
signal loaded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_stuff()
	for i in range(5):
		var x=randi_range(0,stuff.size()-1)
		var price=price_scene.instantiate()
		price.position=Vector2(100+200*i,200)
		if type!="ingredient":
			var object=object_scene.instantiate()
			object.menu_ver=true
			object.sold=true
			object.data=load("res://resources/"+stuff[x])
			add_child(object)
			price.get_node("price").text=str(object.data.basevalue*multiplier)
			price.get_node("TextureRect").texture=null
			object.scale*=.6
			object.position=price.position+Vector2(70,0)
			object.objpos=object.position
			object._show_desc(object.data.name,object.data.color,object.data.basevalue,object.data.desc,object.position)
			if type=="potion":
				price.get_node("buy").pressed.connect(DeckManager.addtodeck.bind(object.data.name))
			if type=="recipe":
				if x in xlist:
					object.queue_free()
					return
				var menu=menu_scene.instantiate()
				menu.object=object
				add_child(menu)
				menu.scale*=.8
				menu.position=object.position+Vector2(-50,-100)
				menu.get_node("TextureRect").z_index=-10
				menu.objname=name
				menu.shop_ver=true
				price.get_node("buy").pressed.connect(DeckManager.addtobook.bind(object.data.name))
				price.maxamt=1
				xlist.append(x)
		else:
			price.get_node("price").text=str(50)
			var path=str("res://art/ingredients/"+stuff[x]+".PNG")
			price.get_node("TextureRect").texture=load(path)
			price.type=stuff[x]
		add_child(price)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_stuff():
	pass
	
func _on_exit_pressed() -> void:
	self.queue_free()
