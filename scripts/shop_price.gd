extends Control
var maxamt=20
var amt=maxamt
var type=null
signal bought

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "star" in Global.decors:
		$price.text=str(int(int($price.text)*.9))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	amt=min(amt,maxamt)
	$amt.text=str(str(amt)+"/"+str(maxamt))
	if amt==0 or Global.moneys<int($price.text):
		$buy.disabled=true


func _on_buy_pressed() -> void:
	if amt>0 and Global.moneys>=int($price.text):
		if type!=null:
			Global.ingredients[type]+=1
		amt-=1
		Global.moneys-=int($price.text)
		bought.emit()
