extends Node
@export var dice_scene:PackedScene
var textures=[preload("res://art/ingredients/leaf.PNG"),preload("res://art/ingredients/flower.PNG"),
preload("res://art/ingredients/fish.PNG"),preload("res://art/ingredients/feather.PNG"),preload("res://art/ingredients/mushroom.PNG"),
preload("res://art/ingredients/bone.PNG"),
preload("res://art/ingredients/crystal.PNG"),preload("res://art/ingredients/rock.PNG"),
preload("res://art/ingredients/clay.PNG")]
var dice_num=6
var positions=[Vector2(850,200),Vector2(950,250),Vector2(850,300),Vector2(950,350),Vector2(850,400),Vector2(950,450),Vector2(850,500),Vector2(950,550)]
var occupied=0
var maxoccupied=0
var can_roll=false
var rolled=false
var ingredients=[]
var gained={"leaf":0,"flower":0,"fish":0,"feather":0,"mushroom":0,"bone":0,"crystal":0,"rock":0,"clay":0}
@onready var areas=[$area1/ingredient,$area2/ingredient,$area3/ingredient]
signal roll

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$errormsg.hide()
	if "plant" in Global.decors:
		dice_num+=2
	for i in range(dice_num):
		var die=dice_scene.instantiate()
		die.position=positions[i]
		die.defaultpos=positions[i]
		die.add_to_group("dice")
		occupied+=1
		roll.connect(die.roll)
		die.result.connect(_on_rolled)
		add_child(die)
	maxoccupied=occupied
	for i in range(3):
		var x=randi_range(0,Global.ingredients.size()-1)
		ingredients.append(Global.ingredients.keys()[x])
		areas[i].texture=textures[x]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if occupied==0 and not rolled:
		can_roll=true
	else:
		can_roll=false
	
func _unhandled_input(event: InputEvent) -> void:
	var x=0
	if event.is_action_released("move"):
		for area in $area1.get_overlapping_areas():
			area.assigned=1
			x+=1
		for area in $area2.get_overlapping_areas():
			area.assigned=2
			x+=1
		for area in $area3.get_overlapping_areas():
			area.assigned=3
			x+=1
		for area in $dice_home.get_overlapping_areas():
			area.assigned=0
		occupied=maxoccupied-x
	if event.is_action_released("enter"):
		if can_roll:
			roll.emit()
			rolled=true
			$rollbutton.hide()
			for i in gained.keys():
				Global.ingredients[i]+=gained[i]
		elif not can_roll and not rolled:
			$errormsg.show()
			await get_tree().create_timer(1).timeout
			$errormsg.hide()

func _on_rolled(area,amt):
	if area==1:
		gained[ingredients[0]]+=amt
		$area1/Label.text=str(gained[ingredients[0]])
	elif area==2:
		gained[ingredients[1]]+=amt
		$area2/Label.text=str(gained[ingredients[1]])
	elif area==3:
		gained[ingredients[2]]+=amt
		$area3/Label.text=str(gained[ingredients[2]])


func _on_rollbutton_pressed() -> void:
	if can_roll:
		roll.emit()
		rolled=true
		$rollbutton.hide()
		for i in gained.keys():
			Global.ingredients[i]+=gained[i]
	elif not can_roll and not rolled:
		$errormsg.show()
		await get_tree().create_timer(1).timeout
		$errormsg.hide()


func _on_exit_pressed() -> void:
	self.queue_free()
