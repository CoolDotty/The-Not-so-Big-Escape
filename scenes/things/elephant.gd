extends CharacterBody2D

const lore_name = "Whiskers"


var is_spooked = true


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




func _on_destruction_zone_body_entered(body):
	if body.get("is_destroyable"):
		body.destroy()
