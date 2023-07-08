extends CharacterBody2D

@export var speed = 400
# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	look_at(position+velocity)
	if Input.is_action_just_pressed("click"):
		squeak()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_slide()
	pass

func squeak():
	Global.mouse_squeaked.emit(self)
