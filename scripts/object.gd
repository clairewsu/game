extends Area2D
class_name object_class
@export var particle_scene: PackedScene
@export var speed=15 #theoretically how it would zoom bk to its default pos
@export var color_id=0
@export var basevalue=100
@export var data:carddata
@export var slosh_strength=.2
@export var settle_speed=.6
@onready var gold=preload("res://art/gold.PNG")
@onready var green=preload("res://art/green.PNG")
@onready var blue=preload("res://art/blue.PNG")
@onready var swirl=preload("res://art/swirl.PNG")
var slosh=0.0
var wave_amp=0.0
var screen_size
var drag=false
var sold=false
var exists=null
var slot=-1
@export var defaultpos=Vector2(500,400)
var objpos:Vector2
var mousepos:Vector2
var liquidoffset=Vector2.ZERO
var liquidvelocity=Vector2.ZERO
var tilt=0.0
var is_moving=false
var selected=false
signal hit
signal score(amount:int,bonus:bool)
signal show_desc(name,color,cost,desc,pos:Vector2)
signal select(slot)

# Called when the node enters the scene tree for the first time.
func _ready():
	scale*=.4
	$liquid.material = $liquid.material.duplicate()
	$bottle.texture=data.texture
	$liquid.texture=data.liquidtexture
	$liquid.material.set_shader_parameter("mask_tex",data.masktexture)
	$CollisionPolygon2D.polygon = data.collision
	$objdesc.hide()
	color_id=data.color
	basevalue=data.basevalue
	input_pickable=true
	position=defaultpos
	screen_size=get_viewport_rect().size
	input_event.connect(_on_input_event)
	objpos=position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	position+=Vector2(0,-200)
	show_desc.connect(_show_desc)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drag and not sold:
		z_index=100
	elif not sold:
		z_index=3
	if sold:
		drag=false
		selected=false
		if Global.selected==self:
			Global.selected=null
	
func _physics_process(delta):
	if not drag and not sold and not selected:
		position = position.move_toward(defaultpos,speed)
	if selected:
		speed=15
		position=position.move_toward(defaultpos+Vector2(0,-100),speed)
		show_desc.emit(data.name,data.color,data.basevalue,data.desc,position)
	var moved=position-objpos
	if position != defaultpos:
		is_moving=true
	if is_moving and position==defaultpos:
		splash()
		is_moving=false
	objpos=position
	var bottle_velocity = moved / max(delta, 0.0001)
	# liquid leans opposite the bottle's motion
	var offset = -bottle_velocity * .02
	offset.x = clamp(offset.x, -.15, .15)
	offset.y = clamp(offset.y, -.15, .15)
	var amp=abs(bottle_velocity.x)*.00003
	# move liquid velocity toward that target smoothly
	liquidoffset = liquidoffset.move_toward(offset, 1 * delta)
	
	if bottle_velocity.length()<5:
		liquidoffset = liquidoffset.move_toward(Vector2.ZERO, settle_speed * delta)
		amp=0.0
	
	wave_amp = lerp(wave_amp, amp, 6.0 * delta)
	$liquid.material.set_shader_parameter("liquid_offset", liquidoffset * .5)
	var target_slosh = bottle_velocity.x * 0.003
	slosh = lerp(slosh, target_slosh, 5.0 * delta)
	$liquid.material.set_shader_parameter("slosh", slosh)
	$liquid.material.set_shader_parameter("wave_amp",wave_amp)
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		drag = true
		mousepos=get_global_mouse_position()


func _unhandled_input(event):
	if event.is_action_released("move"):
		drag = false
		if get_global_mouse_position().distance_to(mousepos)<8 and not sold:
			selected=!selected
			if selected:
				Global.selected=self
			elif Global.selected==self:
				Global.selected=null
			select.emit(slot)
		if not sold:
			for area in $sellarea.get_overlapping_areas():
				if area.is_in_group("guy"):
					sell(area)
					
	elif drag and event is InputEventMouseMotion:
		speed=30
		selected=false
		if Global.selected==self:
			Global.selected=null
		position += event.relative
		_hide_desc()

func _on_mouse_entered():
	if not sold and not is_moving:
		show_desc.emit(data.name,data.color,data.basevalue,data.desc,position)
	
func _on_mouse_exited():
	if not selected:
		_hide_desc()

func sell(guy):
	selected=false
	if Global.selected==self:
		Global.selected=null
	sold=true
	var guyslot=guy.get_free_slot()
	if guyslot == -1:
		selected=true
		Global.selected=self
		sold=false
		return
	z_index=3
	scale*=.3
	if guyslot>2:
		z_index=10
	position=guy.position+guy.slots[guyslot]
	$objdesc.hide()
	score.connect(guy._on_score)
	score.emit(basevalue,false)
	if guy.color_id==color_id:
		score.emit(basevalue*.5,true)	
	if exists != null and slot != -1:
		exists.slot_occupied[slot] = false
	data.on_sold(get_parent())
	guy.tree_exited.connect(queue_free)
	

func _exit_tree() -> void:
	_hide_desc()
		
func splash():
	for i in range(randi_range(5,8)):
		var particle=particle_scene.instantiate()
		particle.position=$bottle.position+Vector2(0,100)
		particle.liquidtexture=data.liquidtexture
		particle.z_index=0
		add_child(particle)
		
func _show_desc(name:String,color:int,cost:int,desc:String,pos:Vector2):
	if not sold:
		if color==0:
			$objdesc/TextureRect.texture=gold
		elif color==1:
			$objdesc/TextureRect.texture=green
		elif color==2:
			$objdesc/TextureRect.texture=blue
		elif color==3:
			$objdesc/TextureRect.texture=swirl
		$objdesc/desctext.text="%s \nprice: %d\n%s"% [name,cost,desc]	
		$objdesc.custom_minimum_size = $objdesc/desctext.get_minimum_size()
		$objdesc.show()
	
	
func _hide_desc():
	$objdesc.hide()

func _on_select(slot1,scrolling):
	if slot1!=slot:
		selected=false
		if Global.selected==self:
			Global.selected=null
		_hide_desc()
	elif scrolling:
		selected=true
		Global.selected=self
		
func _guy_clicked(guy0):
	if selected:
		sell(guy0)
