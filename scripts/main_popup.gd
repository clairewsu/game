extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.y*=.2
	var tween=create_tween()
	tween.tween_property(self,"scale:y",.4,.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func move():
	var tween=create_tween()
	tween.tween_property(self,"position:x",position.x-400,1.5)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
