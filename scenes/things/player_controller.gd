extends CharacterBody2D


const lore_name = "Trunks"

const is_destroyable = true

var dead = false

@export var speed = 200
@export var frame_rate = 4
var frame_counter = 0

# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	look_at(position+velocity)
	
	if Input.is_action_just_pressed("click"):
		squeak()
	if Input.is_action_just_pressed("interact"):
		_interact()


func _ready():
	_init_interact()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead: return
	_check_interactable_inRange()
	get_input()
	
	if velocity.length() > 1:
		frame_counter += 1
		
	if frame_counter >= frame_rate:
		$Sprite2D.frame = ($Sprite2D.frame + 1) % $Sprite2D.hframes
		frame_counter = 0
	
	move_and_slide()
	pass


func destroy():
	dead = true
	$Sprite2D.visible = false
	$DeathSprite.visible = true
	call_deferred("_no_collide")
	Global.player_died.emit(self)


func _no_collide():
	$CollisionShape2D.disabled = true


func squeak():
	Global.mouse_squeaked.emit(self)


var _interact_Comp : ShapeCast2D
func _init_interact():
	_interact_Comp = $ShapeCast2D
	_interact_Comp.add_exception(self)
	
signal Player_interacting_notify()
func _interact():
	if(not _interact_Comp.is_colliding()): return
	#add sound effect here
	#add effect here
	
	#init nesseries
	var hitActor : Node2D
	
	#start
	for i in _interact_Comp.get_collision_count():
		hitActor = _interact_Comp.get_collider(i).get_owner()
		if(hitActor == null): continue
		if(hitActor is Interactable):
			hitActor._on_interact()
			Player_interacting_notify.emit()
	
func _check_interactable_inRange():
	#init nesseries
	var hitActor : Node2D
	#start
	
	for i in _interact_Comp.get_collision_count():
		hitActor = _interact_Comp.get_collider(i).get_owner()
		if(hitActor == null): continue
		if(hitActor is Interactable):
			#add show UI interacting here
			pass
