extends Node
var data:eventdata

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$text.done.connect(_on_done)
	$text.button1.connect(data.button1)
	$text.button2.connect(data.button2)
	$text.button3.connect(data.button3)
	$text.button4.connect(data.button4)
	$bgtexture.texture=data.bg
	for i in data.steps:
		$text.queue_text(i.id,i.speaker,i.text,i.position,i.texture,i.buttons)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_done():
	data.on_done()
	self.queue_free()
