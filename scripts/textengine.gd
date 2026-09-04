extends CanvasLayer
@onready var text=$MarginContainer/Panel/MarginContainer/HBoxContainer/Label
@onready var speaker=$namecontainer/Label
var tween:Tween
var queue=[]
var id_queue=[]
var speaker_queue=[]
var position_queue=[]
var texture1_queue=[]
var texture2_queue=[]
var texture3_queue=[]
var buttons_queue=[]
@onready var buttons=[$Button1,$Button2,$Button3,$Button4]
var current_id=0
signal done
signal button1
signal button2
signal button3
signal button4

enum state {ready,reading,finished}
var current_state=state.ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var newid:int
	match current_state:
		state.ready:
			if not queue.is_empty():
				newid=id_queue[0]
				if not current_id==newid:
					var x=0
					for i in range(id_queue.size()):
						if id_queue[i]==0:
							x=i
							break
					slice_queue(x)
					current_id=newid
				show_text()
			else:
				done.emit()
		state.finished:
			if buttons.all(func(i): return not i.visible):
				$nextarrow.show()
	
func _unhandled_input(event):
	match current_state:
		state.reading:
			if event.is_action_pressed("enter") or event.is_action_pressed("move") or event.is_action_pressed("space"):
				text.visible_ratio=1
				tween.stop()
				change_state(state.finished)
		state.finished:
			if buttons.all(func(i): return not i.visible):
				if event.is_action_pressed("enter") or event.is_action_pressed("move") or event.is_action_pressed("space"):
						change_state(state.ready)
						hide_text()
		
func hide_text():
	text.text=""
	$nextarrow.hide()
	
func show_text():
	change_state(state.reading)
	id_queue.pop_front()
	var words=queue.pop_front()
	var current_speaker=speaker_queue.pop_front()
	var current_position=position_queue.pop_front()
	var button=buttons_queue.pop_front()
	disable_buttons(false)
	$Sprite2D.texture=texture1_queue.pop_front()
	$Sprite2D2.texture=texture2_queue.pop_front()
	$Sprite2D3.texture=texture3_queue.pop_front()
	if current_speaker=="":
		$namecontainer.hide()
	else:
		$namecontainer.show()
		speaker.text=current_speaker
	if current_position==0:
		$namecontainer.position=Vector2(50,430)
	elif current_position==1:
		$namecontainer.position=Vector2(850,430)
	for i in buttons:
		i.hide()
	for choice in button.size():
		buttons[choice].text=button[choice]
		buttons[choice].show()
	text.text=words
	$MarginContainer.show()
	text.visible_ratio=0
	tween=create_tween()
	tween.tween_property(text,"visible_ratio",1,len(words)*.03)
	await tween.finished
	change_state(state.finished)
	
func change_state(next_state):
	current_state=next_state

func queue_text(id,speaker,next_text,position,texture1,texture2,texture3,buttons):
	id_queue.push_back(id)
	speaker_queue.push_back(speaker)
	queue.push_back(next_text)
	position_queue.push_back(position)
	texture1_queue.push_back(texture1)
	texture2_queue.push_back(texture2)
	texture3_queue.push_back(texture3)
	buttons_queue.push_back(buttons)

func disable_buttons(state:bool):
	for i in buttons:
		i.disabled=state

func _on_button_1_pressed() -> void:
	if current_state==state.finished:
		button1.emit()
		disable_buttons(true)
		var idx=0
		for i in range(id_queue.size()):
			if id_queue[i]==1:
				idx=i
				break
		slice_queue(idx)
		current_id=1
		change_state(state.ready)

func _on_button_2_pressed() -> void:
	if current_state==state.finished:
		button2.emit()
		disable_buttons(true)
		var idx=0
		for i in range(id_queue.size()):
			if id_queue[i]==2:
				idx=i
				break
		slice_queue(idx)
		current_id=2
		change_state(state.ready)
		

func _on_button_3_pressed() -> void:
	if current_state==state.finished:
		button3.emit()
		disable_buttons(true)
		var idx=0
		for i in range(id_queue.size()):
			if id_queue[i]==3:
				idx=i
				break
		slice_queue(idx)
		current_id=3
		change_state(state.ready)

func _on_button_4_pressed() -> void:
	if current_state==state.finished:
		button4.emit()
		disable_buttons(true)
		var idx=0
		for i in range(id_queue.size()):
			if id_queue[i]==4:
				idx=i
				break
		slice_queue(idx)
		current_id=4
		change_state(state.ready)
		
func slice_queue(idx:int):
	id_queue=id_queue.slice(idx)
	speaker_queue=speaker_queue.slice(idx)
	queue=queue.slice(idx)
	position_queue=position_queue.slice(idx)
	texture1_queue=texture1_queue.slice(idx)
	texture2_queue=texture2_queue.slice(idx)
	texture3_queue=texture3_queue.slice(idx)
	buttons_queue=buttons_queue.slice(idx)
