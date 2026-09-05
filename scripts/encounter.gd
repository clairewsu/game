extends Node
var data:eventdata

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$text.done.connect(_on_done)
	$text.button1.connect(data.button1.bind(self))
	$text.button2.connect(data.button2.bind(self))
	$text.button3.connect(data.button3.bind(self))
	$text.button4.connect(data.button4.bind(self))
	$text.get_node("bgtexture").texture=data.bg
	for i in data.steps:
		$text.queue_text(i.id,i.speaker,i.text,i.position,i.texture1,i.texture2,i.texture3,i.buttons)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if data.type=="francine" and $text/Button1.text=="a":
		var options=[]
		while options.size()<4:
			var x=(Global.ingredients.keys().pick_random())
			if x not in options:
				options.append(str(x))
		$text/Button1.text=options[0]
		$text/Button2.text=options[1]
		$text/Button3.text=options[2]
		$text/Button4.text=options[3]

func _on_done():
	data.on_done()
	self.queue_free()
