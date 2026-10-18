extends CanvasLayer
var data:tutorialdata
var wait_for="move"
var pos_queue=[]
var dir_queue=[]
var text_queue=[]
var wait_queue=[]
var delay=false
var next=false
enum state {ready,waiting}
var current_state=state.waiting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in data.steps:
		pos_queue.push_back(i.pos)
		dir_queue.push_back(i.direction)
		text_queue.push_back(i.text)
		wait_queue.push_back(i.wait)
	change_state(state.ready)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		state.ready:
			if pos_queue.is_empty():
				queue_free()
				return
			show_text()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(wait_for) and current_state==state.waiting and not delay:
		if next:
			if not get_parent().get_node("moneycount").visible:
				get_parent().loadtutorial("open_nomoney")
			elif "tutorial_open_noingredients.tres" in get_parent().tutorials:
				get_parent().loadtutorial("open_noingredients")
			else:
				get_parent().loadtutorial("open2")
			queue_free()
			return
		else:
			delay=true
			change_state(state.ready)
			await get_tree().create_timer(.5).timeout
			delay=false
	
func show_text():
	change_state(state.waiting)
	var pos=pos_queue.pop_front()
	var direction=dir_queue.pop_front()
	var text=text_queue.pop_front()
	wait_for=wait_queue.pop_front()
	$Node2D.position=pos
	for i in ["bottomright","bottomleft","topright","topleft"]:
		if i!=direction:
			$Node2D.get_node("text_"+i).hide()
		else:
			$Node2D.get_node("text_"+i).show()
			$Node2D.get_node("text_"+i).get_node("RichTextLabel").text=text
	

func change_state(next_state):
	current_state=next_state
