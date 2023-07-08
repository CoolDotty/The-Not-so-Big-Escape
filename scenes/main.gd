extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.scene_ended.connect(_change_scenes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _change_scenes(next_scene: PackedScene):
	get_child(0).queue_free()
	add_child(next_scene.instantiate())
