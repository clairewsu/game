extends Node2D
var data=carddata
var spd=1200
var duration=.05
var physics=false
var liquidtexture:Texture2D
var masktexture:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale*=randf_range(.2,.3)
	$Sprite2D.texture=liquidtexture
	$Sprite2D.material.set_shader_parameter("bottle_tex",masktexture)
	create_tween().tween_property(self,"position",position+Vector2(randf_range(-200,200),randf_range(-20,-100)),0.2)
	await get_tree().create_timer(.2).timeout
	physics=true
	await get_tree().create_timer(duration).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if physics:
		position+=Vector2(0,spd*delta)
		pass
	
