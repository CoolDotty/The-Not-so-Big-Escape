extends Area2D


@export var next_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var opening = false
var f = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if opening:
		f = min(f + 0.1, 3)
		$Icon.frame = int(f)


func _on_body_entered(body):
	opening = true
	if body.get("lore_name") == "Trunks":
		assert(next_scene, "No next_scene assigned to exit")
		Global.scene_ended.emit(next_scene)
