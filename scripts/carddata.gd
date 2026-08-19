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
@export var fill=0.6
@export var amt:int:
	set(value):
		var oldamt=amt
		amt=value
		hq=amt>=10
		if amt>=10 and oldamt<10:
			hq_chance+=.1
@export var collision:PackedVector2Array
var hq_chance=0
var hq:bool

		
func on_sold(main):
	pass
	
func on_dismiss(guy1):
	pass
