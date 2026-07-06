extends Node2D
var moving=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale*=.15
	position+=Vector2(randi_range(-30,30),randi_range(-30,30))
	await get_tree().create_timer(.9).timeout
	moving=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not moving:
		return
	position=position.move_toward(Vector2(50,50),50)
	if position.distance_to(Vector2(50,50))<5:
		self.queue_free()
