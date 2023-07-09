extends Node2D


signal interacted


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var used = false


func _physics_process(delta):
	if used:
		rotation += 0.1
	if Input.is_action_just_pressed("interact"):
		var p = $"../player"
		if not is_instance_valid(p): return
		if (p.position - position).length() < 80:
			used = true
			interacted.emit()
