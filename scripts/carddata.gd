extends Resource
class_name carddata

@export var name:String
@export_multiline var desc:String
@export var color:int #0=yellow 1=green 2=blue 3=swirl
@export var basevalue:int
@export var ingredient={"leaf":0,"flower":0,"fish":0,"feather":0,
"mushroom":0,"bone":0,"crystal":0,"rock":0,"clay":0}
@export var texture:Texture2D
@export var liquidtexture:Texture2D
@export var masktexture:Texture2D
@export var collision:PackedVector2Array

func on_sold(main):
	pass
	
func on_dismiss():
	pass
