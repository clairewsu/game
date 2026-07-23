extends Node
var data:eventdata

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$text.done.connect(_on_done)
	$bgtexture.texture=data.bg
	for i in data.steps:
		$text.queue_text(i.speaker,i.text,i.position,i.texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_done():
	data.on_done()
	self.queue_free()
