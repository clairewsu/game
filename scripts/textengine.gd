extends CanvasLayer
@onready var text=$MarginContainer/Panel/MarginContainer/HBoxContainer/Label
@onready var speaker=$namecontainer/Label
var tween:Tween
var queue=[]
var speaker_queue=[]
var position_queue=[]
var texture_queue=[]
signal done

enum state {ready,reading,finished}
var current_state=state.ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		state.ready:
			if not queue.is_empty():
				show_text()
			else:
				done.emit()
		state.reading:
			if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("move") or Input.is_action_just_pressed("space"):
				text.visible_ratio=1
				tween.stop()
				change_state(state.finished)
		state.finished:
			$nextarrow.show()
			if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("move") or Input.is_action_just_pressed("space"):
				change_state(state.ready)
				hide_text()
	
func hide_text():
	text.text=""
	$nextarrow.hide()
	
func show_text():
	change_state(state.reading)
	var words=queue.pop_front()
	var current_speaker=speaker_queue.pop_front()
	var current_position=position_queue.pop_front()
	$Sprite2D.texture=texture_queue.pop_front()
	if current_speaker=="":
		$namecontainer.hide()
	else:
		$namecontainer.show()
		speaker.text=current_speaker
	if current_position==0:
		$namecontainer.position=Vector2(50,430)
		$Sprite2D.position=Vector2(260,390)
	elif current_position==1:
		$namecontainer.position=Vector2(850,430)
		$Sprite2D.position=Vector2(800,390)
	text.text=words
	$MarginContainer.show()
	text.visible_ratio=0
	tween=create_tween()
	tween.tween_property(text,"visible_ratio",1,len(words)*.03)
	await tween.finished
	change_state(state.finished)
	
func change_state(next_state):
	current_state=next_state

func queue_text(speaker,next_text,position,texture):
	speaker_queue.push_back(speaker)
	queue.push_back(next_text)
	position_queue.push_back(position)
	texture_queue.push_back(texture)
