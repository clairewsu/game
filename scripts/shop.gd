extends Node
class_name shop_node
var price_scene=preload("res://scenes/shop_price.tscn")
var stuff=[]
@export var multiplier:int
signal loaded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_stuff()
	for i in range(5):
		var x=randi_range(0,stuff.size()-1)
		var price=price_scene.instantiate()
		if stuff[x] is Resource:
			price.get_node("price").text=str(stuff[x].data.basevalue*multiplier)
			price.get_node("TextureRect").texture=null
		else:
			price.get_node("price").text=str(50)
			var path=str("res://art/ingredients/"+stuff[x]+".PNG")
			price.get_node("TextureRect").texture=load(path)
			price.type=stuff[x]
		price.position=Vector2(100+150*i,200)
		add_child(price)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_stuff():
	pass
	
func _on_exit_pressed() -> void:
	self.queue_free()
