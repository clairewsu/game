extends Resource
class_name tutorialhelper
@export var pos:Vector2
@export_enum("bottomright","bottomleft","topright","topleft") var direction:String
@export var wait:String
@export_multiline var text:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
