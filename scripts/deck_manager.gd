extends Node
@export var cards=[
	preload("../resources/basicgold.tres"),
	preload("../resources/basicgreen.tres"),
	preload("../resources/basicblue.tres"),
	preload("../resources/basicswirl.tres")
]
var deck:Array[Resource]=[]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addtodeck():
	deck.clear() #for testing purposes
	for i in range(10):
		deck.append(cards[0])
		deck.append(cards[1])
		deck.append(cards[2])
		deck.append(cards[3])
		
func draw():
	if deck.is_empty():
		return null
	var index=randi() % deck.size()
	var card=deck[index]
	deck.remove_at(index)
	return card
