extends Area2D
class_name guy
@export var color_id=0
var slots=[Vector2(0,180),Vector2(-50,180),Vector2(50,180),Vector2(-25,200),Vector2(25,200)]
var slot_occupied=[false,false,false,false,false]
var textures=[]
var this_score=0
var guys=[]
var idx:int
var lastselected:String
signal penalty
signal dismiss
signal sellto(guy0)

# Called when the node enters the scene tree for the first time.
func _ready():
	scale*=.15
	$gold.hide()
	$green.hide()
	$blue.hide()
	$swirl.hide()
	for file in DirAccess.get_files_at("res://art/characters"):
		if file.ends_with(".PNG"):
			textures.append(file)
	var tex=Array(textures).pick_random()
	$individual.texture=load("res://art/characters/"+tex)
	add_to_group("guy")
	idx=get_tree().get_node_count_in_group("guy")-1
	color_id=randi()%4
	if color_id==0:
		$gold.show()
	if color_id==1:
		$green.show()
	if color_id==2:
		$blue.show()
	if color_id==3:
		$swirl.show()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _input_event(Viewport,InputEvent,int):
	if InputEvent.is_action_pressed("move"):
		if Global.selected==null:
			if true not in slot_occupied:
				penalty.emit(80,global_position)
			else:
				dismiss.emit(this_score,global_position)
			queue_free()
		else:
			sellto.emit(self)
	

func get_free_slot():
	for i in range(slot_occupied.size()):
		if not slot_occupied[i]:
			slot_occupied[i] = true
			return i
	return -1
	
func _on_score(amount:int):
	this_score+=amount
	
func _is_pressed(num):
	if num==idx:
		if Global.selected==null:
			if true not in slot_occupied:
				penalty.emit(80,global_position)
			else:
				dismiss.emit(this_score,global_position)
			queue_free()
		else:
			sellto.emit(self)
	
func _on_end():
	dismiss.emit(this_score,global_position)
	queue_free()
