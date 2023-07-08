extends CharacterBody2D

const lore_name = "Whiskers"



var is_spooked = false


const patrol_speed = 150
const spook_speed = 500



# Region: Nav

var path: Array = []
var levelNavigation: NavigationAgent2D = null
var player = null

@onready var _map : TileMap = $"../puzzle_tiles"
@onready var _navAgent : NavigationAgent2D = $NavigationAgent2D
var _explore_location = Vector2(0.0, 0.0)

# End Region

# Region: Action State

enum _action_state {
	none,
	is_patrolling,
	is_spooked,
	is_alerted
}
var _current_action_state = _action_state.none



# End Region

func _ready():
	_navAgent.set_navigation_map(_map)
	Global.mouse_squeaked.connect(
		func(mouse):
			_explore_location = mouse.global_transform.origin
			_navAgent.target_position = _explore_location
			Set_action_state(_action_state.is_alerted)
			_on_alerted()
	)

func _physics_process(delta):
	
	_action_state_tick(_current_action_state)
	
	var prev_pos = position
	
	var hit = move_and_slide()
	
	#if (position - prev_pos).length() < 1:
	#	rotation_degrees += 90




func _on_destruction_zone_body_entered(body):
	if body.get("is_destroyable"):
		body.destroy()


func _on_vision_body_entered(body):
	if body == self: return
	if body is CharacterBody2D:
		_on_spooked()


func _on_spooked(min = 1.0, max = 2.0):
	is_spooked = true
	Set_action_state(_action_state.is_spooked)
	var SpookTimer = $vision/SpookTimer
	var rng = RandomNumberGenerator.new()
	var spook_random_number = rng.randf_range(min, max)
	SpookTimer.set_wait_time(spook_random_number)
	SpookTimer.start()
	
func _on_alerted():
	var SpookTimer = $vision/SpookTimer
	var rng = RandomNumberGenerator.new()
	var spook_random_number = rng.randf_range(2.0, 3.0)
	SpookTimer.set_wait_time(spook_random_number)
	SpookTimer.start()

func _on_spook_timer_timeout():
	is_spooked = false
	Set_action_state(_action_state.is_patrolling)

func _explore_sound_source(location:Vector2):
	var temp_direction: Vector2
	temp_direction = location - self.get_position()
	temp_direction = temp_direction.normalized()
	velocity = temp_direction * spook_speed
	
func _action_state_tick(state: _action_state):
	match state:
		_action_state.none:
			_patrolling_tick()
			
		_action_state.is_patrolling:
			_patrolling_tick()
			
		_action_state.is_spooked:
			_spooked_tick()
			
		_action_state.is_alerted:
			_alerted_tick()
		_:
			pass
	return
	
func Set_action_state(state: _action_state):
	_current_action_state = state

func _patrolling_tick():
	velocity = Vector2(patrol_speed, 0).rotated(rotation)
	
func _spooked_tick():
	velocity = Vector2(spook_speed, 0).rotated(rotation)
	
func _alerted_tick():
	var dir = _navAgent.get_next_path_position() - position
	velocity = dir.normalized() * patrol_speed
	if(_navAgent.is_navigation_finished()):
		Set_action_state(_action_state.is_patrolling)
	move_and_slide()
	
	

