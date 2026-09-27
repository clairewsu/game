extends carddata
var effect=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_sold(obj,main):
	if Global.ingredients["flower"]>=2:
		if hq:
			obj.data.basevalue*=3
		else:
			obj.data.basevalue*=2
		Global.ingredients["flower"]-=2
		effect=true

func on_dismiss(guy1):
	if effect:
		var main=guy1.get_parent().get_parent()
		var pos=guy1.position
		await guy1.get_tree().create_timer(.1).timeout
		main.popup(pos+Vector2(randi_range(-30,30),0),2,"-","flower")
