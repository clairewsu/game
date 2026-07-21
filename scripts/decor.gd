extends Area2D
var data:decordata
var menu_ver=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_desc()
	scale*=.24
	$Sprite2D.texture=data.tex
	$CollisionPolygon2D.polygon=data.collision
	if menu_ver:
		show_desc()
	else:
		$Sprite2D.scale*=.5
		$CollisionPolygon2D.scale*=.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_desc():
	$objdesc/desctext.text="%s\n%s"% [data.name,data.desc]	
	$objdesc.custom_minimum_size = $objdesc/desctext.get_minimum_size()
	$objdesc.show()
	
	
func hide_desc():
	if menu_ver:
		return
	$objdesc.hide()


func _on_mouse_entered() -> void:
	show_desc()


func _on_mouse_exited() -> void:
	hide_desc()
