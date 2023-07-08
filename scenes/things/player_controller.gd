extends CharacterBody2D

const lore_name = "Trunks"

const is_destroyable = true

var dead = false

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	look_at(position+velocity)
	
	if Input.is_action_just_pressed("click"):
		squeak()
	if Input.is_action_just_pressed("restart"):
		_restart()
	if Input.is_action_just_pressed("interact"):
		_interact()


func _ready():
	_init_interact()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead: return
	_check_interactable_inRange()
	get_input()
	move_and_slide()
	pass


func destroy():
	dead = true
	$Sprite2D.visible = false
	$DeathSprite.visible = true
	call_deferred("_no_collide")


func _no_collide():
	$CollisionShape2D.disabled = true


func squeak():
	Global.mouse_squeaked.emit(self)
	
func _restart():
	get_tree().reload_current_scene()
	#add skipping cut scenes here
	

var _interact_Comp : ShapeCast2D
func _init_interact():
	_interact_Comp = $ShapeCast2D
	#_interact_Comp.add_exception($CollisionShape2D)
	
signal Player_interacting()
func _interact():
	#add sound effect here
	#add effect here
	Player_interacting.emit()
	
func _check_interactable_inRange():
	if(not _interact_Comp.is_colliding()): return
	#print(_interact_Comp.get_collision_count())
	var hitActor = _interact_Comp.get_collider(0)
	
