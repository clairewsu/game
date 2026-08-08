extends Node
var selected=null
var ingredients={"leaf":5,"flower":5,"fish":5,"feather":5,
"mushroom":5,"bone":5,"crystal":5,"rock":5,"clay":5}
var decors=[]
var default_moneys=10000
var moneys=default_moneys
var level=1
var quota:int
var money_scene=preload("res://scenes/money_popup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	quota=level*500

func spawn_money(amt,position,parent):
	var x=clampi(amt/100,3,20)
	for i in range(x):
		var money=money_scene.instantiate()
		money.position=position
		parent.add_child(money)
		await get_tree().create_timer(.1).timeout
