extends CanvasLayer
signal start
@export var countdown=30
var base=0
var penalty=0
var roundmult=0
var total=0
var x=1
var opensign=preload("res://art/open.PNG")
var closedsign=preload("res://art/closed.PNG.png")
var maskimg = load("res://art/opensign_mask.PNG").get_image()
var signmask = BitMap.new()
var pause=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signmask.create_from_image_alpha(maskimg)
	$pausebutton.texture_click_mask = signmask
	$pausebutton.disabled=true
	$scorecounter.hide()
	$timerlabel.hide()
	$theend.hide()
	$note1.hide()
	$note2.hide()
	$note3.hide()
	$deckcounter.hide()
	$roundcounter.hide()
	$endbutton.hide()

func show_time(text):
	$timerlabel.text = text
	$timerlabel.show()
	$Timer.start()

func get_score(basescore:int, penaltyscore:int,round:int):
	base=basescore
	penalty=penaltyscore
	roundmult=1.25**round
	
func _on_timer_timeout():
	$timerlabel.hide()
	countdown-=1
	if countdown>0:
		show_time(str(countdown))

func _on_startbutton_pressed():
	$startbutton.hide()
	$scorecounter.hide()
	$deckcounter.show()
	$roundcounter.show()
	$pausebutton.disabled=false
	$note1.show()
	$roundcounter.text="1"
	countdown=30
	start.emit()
	show_time(str(countdown))

func _on_end():
	await get_parent().dismiss_end
	$pausebutton.disabled=true
	$Timer.paused=true
	$timerlabel.text="0"
	countdown=0
	total=max(0,snapped(roundmult*(base-penalty),1))
	$theend.show()
	await get_tree().create_timer(1).timeout
	$theend.hide()
	$scorecounter.show()
	$scorecounter.text = "base score: "+str(base)
	await get_tree().create_timer(.8).timeout
	$scorecounter.text += "\npenalty: "+str(penalty)
	await get_tree().create_timer(.8).timeout
	await countmult(roundmult)
	await counttotal(total)
	$endbutton.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$deckcounter.text=str(DeckManager.deck.size())
	
func countmult(tovalue):
	var start=1
	var time=.5
	for i in range(10):
		while start<tovalue:
			start*=1.25
			if start>tovalue:
				start=tovalue
			updatemult(start)
			await get_tree().create_timer(time).timeout
			time*=.8
	if start<tovalue:
		var time1=max(start/tovalue,2)
		var tween=create_tween()
		tween.tween_method(updatemult,start,tovalue,time1)
		await tween.finished
	
func counttotal(tovalue):
	var tween=create_tween()
	if tovalue>0:
		tween.tween_method(updatetotal,0,tovalue,2.5)
		await tween.finished
	else:
		updatetotal(0)

func updatetotal(totalvalue:float):
	$scorecounter.text="base score: %d\npenalty: %d\nround bonus: x%.2f\ntotal:%d"% [base,penalty,roundmult,int(round(totalvalue))]

func updatemult(multvalue):
	$scorecounter.text="base score: %d\npenalty: %d\nround bonus: x%.2f"% [base,penalty,multvalue]

func _round(round):
	$roundcounter.text=str(round+1)
	x=x+1
	if x==1:
		$note1.z_index+=3
	elif x==2:
		$note2.show()
		$note2.z_index+=3
	elif x==3:
		$note3.show()
		$note3.z_index+=3
	elif x>3:
		x=1
		$note1.z_index+=3
	
func _on_endbutton_pressed():
	get_parent().queue_free()


func _on_pausebutton_pressed() -> void:
	pause=!pause
	if pause:
		$pausebutton.texture_normal=closedsign
		get_tree().paused=true
	if not pause:
		$pausebutton.texture_normal=opensign
		get_tree().paused=false
