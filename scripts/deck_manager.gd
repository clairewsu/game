extends Node
@export var cards={}
var deck:Array[Resource]=[]

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addtodeck(name):
	deck.append(cards[name])
		
func draw():
	if deck.is_empty():
		return null
	var index=randi() % deck.size()
	var card=deck[index]
	deck.remove_at(index)
	return card
