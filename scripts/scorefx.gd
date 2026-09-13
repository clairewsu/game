extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if "+0" in $Label.text:
		$Label.hide()

func setup(sign,points:int,type:String):
	if type=="normal":
		$Label.text=sign+str(points)
	elif type=="bonus":
		$Label.text="bonus "+sign+str(points)
	else: 
		$Label.text=sign+str(points)+"[img=64]res://art/ingredients/"+str(type)+".PNG[/img]"
	var tween = create_tween()
	tween.tween_property($Label, "position:y", $Label.position.y - 40, 0.8)
	tween.parallel().tween_property($Label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)
