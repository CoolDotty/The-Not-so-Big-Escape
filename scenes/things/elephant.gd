extends CharacterBody2D

const lore_name = "Whiskers"


var is_spooked = false


var current = false;
enum State { idle, patrol, spooked, omg, shiftyeyes }


const patrol_speed = 150
const spook_speed = 500


func _physics_process(delta):
	if is_spooked:
		velocity = Vector2(spook_speed, 0).rotated(rotation)
	else:
		velocity = Vector2(patrol_speed, 0).rotated(rotation)
	
	var prev_pos = position
	
	var hit = move_and_slide()
	
	if (position - prev_pos).length() < 1:
		rotation_degrees += 90
	
	# Mouse check
	var player = get_node("../player")
	if not is_instance_valid(player):
		return
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if not result.get("collider"):
		return
	var can_see_player = result.collider == player
	


func _on_destruction_zone_body_entered(body):
	if State.spooked and body.get("is_destroyable"):
		body.destroy()


func destroy():
	pass
	# get flattened by elephant lol
