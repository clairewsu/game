extends Node
@export var dice_scene:PackedScene
var dice_num=6
var positions=[Vector2(950,200),Vector2(1050,250),Vector2(950,300),Vector2(1050,350),Vector2(950,400),Vector2(1050,450),Vector2(950,500),Vector2(1050,550)]
var basket_positions_x=[300,400,500,600]
var occupied_positions=[]
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
		if "plant" in Global.decors and i>5:
			die.get_node("Sprite2D").texture=load("res://art/dice_plant.PNG")
	maxoccupied=occupied
	for i in range(ingredients.size()):
		areas[i].texture=load("res://art/ingredients/"+ingredients[i]+".PNG")

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
			if area is dice:
				assign_dice(1,area,120,170)
				x+=1
		for area in $area2.get_overlapping_areas():
			if area is dice:
				assign_dice(2,area,300,350)
				x+=1
		for area in $area3.get_overlapping_areas():
			if area is dice:
				assign_dice(3,area,480,530)
				x+=1
		for area in $dice_home.get_overlapping_areas():
			if area is dice:
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
	
func assign_dice(id,area,y1,y2): #cycle thru the nearest positions until it find an open
	var success=false
	if area.assigned!=id:
		var bp_x=basket_positions_x
		while not success:
			var pos_x=bp_x.reduce(func(a,b):return a if abs(area.position.x-a)<abs(area.position.x-b) else b)
			var pos_y=y1 if abs(area.position.y-y1)<abs(area.position.y-y2) else y2
			area.position=Vector2(pos_x,pos_y)
			if area.position not in occupied_positions:
				success=true
			elif Vector2(pos_x, y1 if pos_y==y2 else y2) not in occupied_positions:
				area.position=Vector2(pos_x,y1 if pos_y==y2 else y2)
				success=true
			else:
				bp_x.erase(pos_x)
		occupied_positions.append(area.position)
		area.assigned=id
