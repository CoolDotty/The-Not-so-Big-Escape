extends StaticBody2D
class_name Crate


const is_destroyable = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _no_collide():
	$CollisionShape2D.disabled = true

func destroy():
	call_deferred("_no_collide")
	$Animate.current_animation = "boom"
	$Animate.play()
	$Animate.animation_finished.connect(func(_name): self.queue_free(), CONNECT_ONE_SHOT)
