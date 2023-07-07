extends CharacterBody2D

const lore_name = "Trunks"

const is_destroyable = true

var dead = false

@export var speed = 400
@export var grad: Gradient
@export var dangerLight: PointLight2D

# Called when the node enters the scene tree for the first time.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	look_at(position+velocity)
	

# Set the color of the mouse light based on distance to elephant
func color_by_danger():
	# how far is the elephant from me
	var elephant = get_node("../elephant")
	var player_position = global_transform.origin
	var elephant_position = elephant.global_transform.origin
	var d = player_position.distance_to(elephant_position)
	var gradientPosition = d / 500
	dangerLight.color = grad.sample(gradientPosition)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead: return
	get_input()
	move_and_slide()
	color_by_danger()
	pass


func destroy():
	dead = true
	$Sprite2D.visible = false
	$FlatRat.visible = true
	call_deferred("_no_collide")

func _no_collide():
	$CollisionShape2D.disabled = true
