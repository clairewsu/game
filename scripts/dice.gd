extends Area2D
var drag=false
var defaultpos=Vector2(100,100)
var amt:int
var assigned=0
signal result(area,number)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if drag:
		z_index=100
	else:
		z_index=3
	if not drag and assigned==0:
		position = position.move_toward(defaultpos,40)
	if not has_overlapping_areas():
		assigned=0

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		drag = true
		
func _unhandled_input(event):
	if event.is_action_released("move"):
		drag = false
	elif drag and event is InputEventMouseMotion:
		position += event.relative

func roll():
	if assigned!=0:
		amt=randi_range(1,6)
		$Label.text=str(amt)
		result.emit(assigned,amt)
