extends Node
@export var guys_scene: PackedScene
@export var object_scene:PackedScene
@export var scorepopup_scene:PackedScene
@onready var path:Path2D=$guyspawn
var guy=null
var score=0
var penalty=0
var round=0
var respawning_guys=true
var respawning_object=true
var selected=false
var busy=false
var selectedslot:int
var deck:Array[PackedScene]=[]
var slots=[Vector2(80,530),Vector2(225,530),Vector2(365,530),Vector2(505,530),Vector2(655,530),Vector2(790,530),Vector2(940,530),Vector2(1080,530)]
var slot_occupied=[false,false,false,false,false,false,false,false]
signal end
signal select1(slot,scrolling:bool)
signal sellto(guy0)
signal guypressed(num)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	end.connect($ui._on_end)
	$ui.start.connect(_on_start)

func _on_start():
	round=0
	score=0
	penalty=0
	DeckManager.addtodeck()
	spawn_guy()
	spawn_object(4)
	respawning_guys=false
	respawning_object=false
	$Timer.start()

func _on_timer_timeout():
	respawning_guys=true
	respawning_object=true
	$ui.get_score(score,penalty,round)
	end.emit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("guy").is_empty() and not respawning_guys:
		respawn_guys()
	if Input.is_action_pressed("l") and selected and not busy:
		scroll("l")
	if Input.is_action_pressed("r") and selected and not busy:
		scroll("r")

func spawn_guy():
	var spawn_offsets = [
		Vector2(150,120),Vector2(425,120),Vector2(725,120),Vector2(1000,120)
	]
	
	for pos in spawn_offsets:
		guy = guys_scene.instantiate()
		guy.global_position = pos
		add_child(guy)
		guy.connect("penalty", Callable(self, "_on_loss"))
		guy.connect("dismiss",Callable(self,"_on_dismiss"))
		end.connect(guy._on_end)
		select1.connect(guy._obj_selected)
		guy.sellto.connect(_guy_clicked)
		guypressed.connect(guy._is_pressed)
	
func spawn_object(n:int):
	for i in range(n):
		var slot=get_free_slot()
		if slot == -1:
			return
		var card=DeckManager.draw()
		if card==null:
			return
		var object=object_scene.instantiate()
		object.data=card
		object.slot=slot
		object.exists=self
		object.scale*=.75
		object.position=slots[slot]
		object.defaultpos=object.position
		add_child(object)
		#object.connect("score", Callable(self, "_on_score"))
		#object.score.connect(guy._on_score)
		end.connect(object.queue_free)
		object.select.connect(_on_select)
		select1.connect(object._on_select)
		sellto.connect(object._guy_clicked)
	
func respawn_guys():
	respawning_guys=true
	for i in range(10):
		await get_tree().process_frame
	spawn_guy()
	respawn_object()
	respawning_guys=false
	round+=1
	
func respawn_object():
	respawning_object=true
	spawn_object(4)
	respawning_object=false

func get_free_slot():
	for i in range(slot_occupied.size()):
		if not slot_occupied[i]:
			slot_occupied[i] = true
			return i
	return -1
	
func _on_hit():
	pass
	
func _on_dismiss(amount:int,pos:Vector2):
	score+=amount
	popup(pos,amount,"+")
	
	
func _on_loss(amount:int,pos:Vector2):
	penalty+=amount
	popup(pos,amount,"-")
	
func popup(pos:Vector2,points:int,sign):
	var popup=scorepopup_scene.instantiate()
	popup.position=pos
	add_child(popup)
	popup.setup(sign,points)
	
func _on_select(slot):
	select1.emit(slot,false)
	selected=!selected
	if slot!=selectedslot:
		selected=true
	selectedslot=slot
	
func _guy_clicked(guy0):
	sellto.emit(guy0)

func _input(InputEvent):
	var numbers=["one","two","three","four"]
	for i in range(numbers.size()):
		if InputEvent.is_action_pressed(numbers[i]):
			guypressed.emit(i)
			
func scroll(direction):
	busy=true
	if direction=="l":
		selectedslot=max(selectedslot-1,0)
	if direction=="r":
		selectedslot=min(selectedslot+1,slot_occupied.count(true)-1)
	select1.emit(selectedslot,true)
	await get_tree().create_timer(.1).timeout
	busy=false
