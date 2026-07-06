extends Node2D
@onready var arm_anim=$AnimationTree.get("parameters/StateMachine/playback")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$head/blink.hide()
	$Timer.start()
	blink()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	arm_anim.travel("arms")
	await get_tree().create_timer(3).timeout
	arm_anim.travel("arms_idle")
	$Timer.start()
	
func blink():
	var tween=create_tween()
	while true:
		await get_tree().create_timer(randfn(3,.5)).timeout
		tween.tween_property($head/eyes,"scale.y",.2,.05)
		$head/eyes.hide()
		$head/blink.show()
		await get_tree().create_timer(.1).timeout
		$head/blink.hide()
		$head/eyes.show()
		tween.tween_property($head/eyes,"scale.y",1,.05)
