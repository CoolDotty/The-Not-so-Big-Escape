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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead: return
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
