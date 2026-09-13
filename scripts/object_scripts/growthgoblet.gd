extends carddata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_dismiss(guy1):
	var x=2
	if hq:
		x+=1
	Global.ingredients["fish"]+=x
	Global.ingredients["flower"]+=x
	var main=guy1.get_parent().get_parent()
	var pos=guy1.position
	await guy1.get_tree().create_timer(.1).timeout
	main.popup(pos+Vector2(30,0),x,"+","fish")
	main.popup(pos+Vector2(-30,0),x,"+","flower")
