extends Control
var amt=20
var type=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if amt==0 or Global.moneys<int($price.text):
		$buy.disabled=true


func _on_buy_pressed() -> void:
	if amt>0 and Global.moneys>=int($price.text):
		if type!=null:
			Global.ingredients[type]+=1
		amt-=1
		$amt.text=str(str(amt)+"/20")
		Global.moneys-=int($price.text)
