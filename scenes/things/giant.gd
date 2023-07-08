extends CharacterBody2D

const lore_name = "Whiskers"

@export var grad: Gradient
@export var dangerLightLeft: PointLight2D
@export var dangerLightRight: PointLight2D

var is_spooked = false

const patrol_speed = 150
const spook_speed = 500
const max_acceleration = 500



# Region: Nav

var path: Array = []
var levelNavigation: NavigationAgent2D = null
var player = null

var avaliableTiles
@onready var _map : TileMap = $"../puzzle_tiles"
@onready var _navAgent : NavigationAgent2D = $NavigationAgent2D
var _explore_location = Vector2(0.0, 0.0)

# End Region

# Region: Action State

enum _action_state {
	none,
	is_patrolling,
	is_spooked,
	is_agro,
	is_alerted,
	is_agro_windup
}
var _current_action_state: _action_state = _action_state.none



# End Region

func _ready():
	_navAgent.set_navigation_map(_map)
	avaliableTiles = _map.get_used_cells_by_id(0,0,Vector2i(1,0))
	Global.mouse_squeaked.connect(
		func(mouse):
			_explore_location = mouse.global_transform.origin
			_navAgent.target_position = _explore_location
			Set_action_state(_action_state.is_alerted)
			_on_alerted()
	)

func _physics_process(delta):
	
	_action_state_tick(delta, _current_action_state)
	if(_check_NavStuck(position)):
		Nav_stuck_timer.start()
		pass
	
	rotation = velocity.angle()
	
	color_by_danger()


# Set the color of the mouse light based on distance to player
func color_by_danger():
	# how far is the player from me
	# var player = $"../player"
	# var my_position = global_transform.origin
	# var player_position = player.global_transform.origin
	# var d = my_position.distance_to(player_position)
	# var gradientPosition = d / 500
	# dangerLightLeft.color = grad.sample(gradientPosition)
	# dangerLightRight.color = grad.sample(gradientPosition)
	if _current_action_state == _action_state.is_agro:
		dangerLightLeft.color = Color.YELLOW
		dangerLightRight.color = Color.YELLOW
	elif _current_action_state == _action_state.is_agro_windup:
		dangerLightLeft.color = Color.RED
		dangerLightRight.color = Color.RED
	else:
		dangerLightLeft.color = Color.WHITE
		dangerLightRight.color = Color.WHITE


func _on_destruction_zone_body_entered(body):
	if _current_action_state == _action_state.is_agro and body.get("is_destroyable"):
		body.destroy()


func _on_vision_body_entered(body):
	if body == self: return
	if body is CharacterBody2D:
		var space_state = get_world_2d().direct_space_state
		var player = get_node("../player")
		var my_position = global_transform.origin
		var player_position = player.global_transform.origin
		var query = PhysicsRayQueryParameters2D.create(my_position, player_position)
		var result = space_state.intersect_ray(query)
		if result.collider == player:
			_agro(body)

func _on_vision_body_exited(body):
		$vision/StateTimer.start(1)

func _agro(target):
	if _current_action_state == _action_state.is_agro or _current_action_state == _action_state.is_agro_windup:
		return
	player = target
	agro_vector = (position - target.position).normalized() * -1
	Set_action_state(_action_state.is_agro_windup)

func _on_spooked(min = 1.0, max = 2.0):
	is_spooked = true
	Set_action_state(_action_state.is_agro)
	var SpookTimer = $vision/StateTimer
	var rng = RandomNumberGenerator.new()
	var spook_random_number = rng.randf_range(min, max)
	SpookTimer.set_wait_time(spook_random_number)
	SpookTimer.start()
	
func _on_alerted():
	var SpookTimer = $vision/StateTimer
	var rng = RandomNumberGenerator.new()
	var spook_random_number = rng.randf_range(2.0, 3.0)
	SpookTimer.set_wait_time(spook_random_number)
	SpookTimer.start()

func _on_spook_timer_timeout():
	is_spooked = false
	player = null
	if (_current_action_state == _action_state.is_agro or _current_action_state == _action_state.is_agro_windup):
		return
	Set_action_state(_action_state.is_patrolling)

func _explore_sound_source(location:Vector2):
	var temp_direction: Vector2
	temp_direction = location - self.get_position()
	temp_direction = temp_direction.normalized()
	velocity = temp_direction * spook_speed
	
func _action_state_tick(delta, state: _action_state):
	match state:
		_action_state.none:
			_patrolling_tick()
			
		_action_state.is_patrolling:
			_patrolling_tick()
			
		_action_state.is_spooked:
			_spooked_tick()
			
		_action_state.is_alerted:
			_alerted_tick()
			
		_action_state.is_agro:
			_agro_tick(delta)
		_action_state.is_agro_windup:
			_agro_windup(delta)
		_:
			pass
	return
	
func Set_action_state(state: _action_state):
	_current_action_state = state

func _patrolling_tick():
	var dir = _navAgent.get_next_path_position() - position
	velocity = dir.normalized() * patrol_speed
	if(_navAgent.is_navigation_finished() or not _navAgent.is_target_reachable()):
		_setRandom_Nav_target_Pos()
		
	move_and_slide()
func _spooked_tick():
	velocity = Vector2(spook_speed, 0).rotated(rotation)
	move_and_slide()
	
func _alerted_tick():
	var dir = _navAgent.get_next_path_position() - position
	velocity = dir.normalized() * patrol_speed
	if(_navAgent.is_navigation_finished()):
		Set_action_state(_action_state.is_patrolling)
	move_and_slide()
	

var agro_vector: Vector2 = Vector2.ZERO

func _agro_tick(delta):
	velocity += agro_vector * max_acceleration * delta * 1.5
	
	var prev_pos = position
	move_and_slide()
	if (prev_pos - position).length() < 0.1:
		Set_action_state(_action_state.is_patrolling)
		rotation = agro_vector.angle()
		agro_vector = Vector2.ZERO

var _agro_timer
func _agro_windup(delta):
	$AnimatedSprite2D.speed_scale = 2.0
	var shake = 5
	$AnimatedSprite2D.offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
	if is_instance_valid(_agro_timer):
		return
	_agro_timer = Timer.new()
	add_child(_agro_timer)
	_agro_timer.wait_time = 1.0
	_agro_timer.one_shot = true
	_agro_timer.start()
	await _agro_timer.timeout
	Set_action_state(_action_state.is_agro)
	_agro_timer = null
	$AnimatedSprite2D.speed_scale = 1.0
	$AnimatedSprite2D.offset = Vector2.ZERO
	

@onready var Nav_stuck_timer : Timer = $Nav_stuck_timer
var _last_record_loc = Vector2(0.0,0.0)
func _check_NavStuck(location: Vector2):
	var dist = location.distance_to(_last_record_loc)
	if(dist > 1.0):
		_last_record_loc = location
		return true
	return false

func _setRandom_Nav_target_Pos():
	var rng = RandomNumberGenerator.new()
	var rndAvaliableTile = avaliableTiles[rng.randi_range(0,avaliableTiles.size()-1)]
	_navAgent.target_position = _map.map_to_local(rndAvaliableTile)

func _on_nav_stuck_timer_timeout():
	if (_current_action_state == _action_state.is_agro or _current_action_state == _action_state.is_agro_windup):
		return
	_setRandom_Nav_target_Pos()
	
