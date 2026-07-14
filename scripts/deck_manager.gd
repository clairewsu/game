extends Node
@export var cards={}
var deck:Array[Resource]=[]
var book:Array[Resource]=[]
var booklim=8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open("res://resources")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var card = load("res://resources/" + file_name)
		cards[card.name] = card
		file_name = dir.get_next()
	dir.list_dir_end()
	addtobook("basic magic potion")
	addtobook("basic growth potion")
	addtobook("basic gold potion")
	addtobook("basic wind potion")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addtodeck(name):
	deck.append(cards[name])
	
func addtobook(name):
	if book.size()<booklim:
		book.append(cards[name])
		
func draw():
	if deck.is_empty():
		return null
	var index=randi() % deck.size()
	var card=deck[index]
	deck.remove_at(index)
	return card
