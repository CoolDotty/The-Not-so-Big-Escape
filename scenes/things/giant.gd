extends CharacterBody2D

const lore_name = "Whiskers"

@export var grad: Gradient
@export var dangerLightLeft: PointLight2D
@export var dangerLightRight: PointLight2D

enum _action_state {
	none,
	is_patrolling,
	is_spooked,
	is_alerted
}

var is_spooked = false

const patrol_speed = 150
const spook_speed = 500

var _explore_location = Vector2(0.0, 0.0)

func _ready():
	Global.mouse_squeaked.connect(
		func(mouse):
			_explore_location = mouse.get_position()
			_explore_sound_source(_explore_location)
	)

func _physics_process(delta):
	if is_spooked:
		velocity = Vector2(spook_speed, 0).rotated(rotation)
	else:
		velocity = Vector2(patrol_speed, 0).rotated(rotation)
	
	var prev_pos = position
	
	var hit = move_and_slide()
	
	if (position - prev_pos).length() < 1:
		rotation_degrees += 90
	
	color_by_danger()


# Set the color of the mouse light based on distance to player
func color_by_danger():
	# how far is the player from me
	var player = get_node("../player")
	var my_position = global_transform.origin
	var player_position = player.global_transform.origin
	var d = my_position.distance_to(player_position)
	var gradientPosition = d / 500
	print(d)
	dangerLightLeft.color = grad.sample(gradientPosition)
	dangerLightRight.color = grad.sample(gradientPosition)


func _on_destruction_zone_body_entered(body):
	if body.get("is_destroyable"):
		body.destroy()


func _on_vision_body_entered(body):
	if body == self: return
	if body is CharacterBody2D:
		_on_spooked()


func _on_spooked(min = 1.0, max = 2.0):
	is_spooked = true
	var SpookTimer = $vision/SpookTimer
	var rng = RandomNumberGenerator.new()
	var spook_random_number = rng.randf_range(min, max)
	SpookTimer.set_wait_time(spook_random_number)
	SpookTimer.start()

func _on_spook_timer_timeout():
	is_spooked = false

func _explore_sound_source(location:Vector2):
	var temp_direction: Vector2
	temp_direction = location - self.get_position()
	temp_direction = temp_direction.normalized()
	velocity = temp_direction * spook_speed
	
func check_action_state(state: _action_state):
	match state:
		_action_state.none:
			pass
		_action_state.is_patrolling:
			pass
		_action_state.is_spooked:
			pass
		_action_state.is_alerted:
			pass
		_:
			pass
	return
	
func _patrolling_tick():
	velocity = Vector2(patrol_speed, 0).rotated(rotation)
	pass
	
func _spooked_tick():
	velocity = Vector2(spook_speed, 0).rotated(rotation)
	pass
	
func _alerted_tick():
	#_explore_sound_source()
	pass
	
