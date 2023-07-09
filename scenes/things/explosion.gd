extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time += delta
	rotation = randf_range(0, 2 * PI)
	var s = sin(time * 5)
	$Crateboom.scale = Vector2(s, s)
