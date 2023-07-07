extends CharacterBody2D


const is_destroyable = true

var dead = false

@export var speed = 400
# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	look_at(position+velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead: return
	get_input()
	move_and_slide()
	pass


func destroy():
	dead = true
	$Sprite2D.visible = false
	$FlatRat.visible = true
	call_deferred("_no_collide")

func _no_collide():
	$CollisionShape2D.disabled = true
