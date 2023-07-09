extends StaticBody2D
class_name Crate


const is_destroyable = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print($Sprite2D.frame)
	if dying:
		var f = $Sprite2D.frame + 1
		if f > $Sprite2D.hframes:
			queue_free()
		else:
			$Sprite2D.frame = f

func _no_collide():
	$CollisionShape2D.disabled = true

var dying = false

func destroy():
	if dying: return
	call_deferred("_no_collide")
	dying = true
	$LightOccluder2D.queue_free()
