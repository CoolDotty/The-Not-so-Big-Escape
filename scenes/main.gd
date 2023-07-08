extends Node

@onready var current_scene = get_child(0)


var trans_in = preload("res://scenes/DiamondTransitionIn.tres")
var trans_out = preload("res://scenes/DiamondTransitionOut.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.scene_ended.connect(_change_scenes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _change_scenes(next_scene: PackedScene):
	$TransitionLayer.visible = true
	trans_in.set_shader_parameter("progress", 0.0)
	$TransitionLayer/ColorRect.material = trans_in
	for i in range(0, 60):
		$TransitionLayer/ColorRect.material.set_shader_parameter(
			"progress", 
			$TransitionLayer/ColorRect.material.get_shader_parameter("progress") + (1.0 / 60)
		)
		await get_tree().physics_frame
	
	current_scene.queue_free()
	current_scene = next_scene.instantiate()
	add_child(current_scene)
	
	trans_out.set_shader_parameter("progress", 0.0)
	$TransitionLayer/ColorRect.material = trans_out
	for i in range(0, 60):
		$TransitionLayer/ColorRect.material.set_shader_parameter(
			"progress", 
			$TransitionLayer/ColorRect.material.get_shader_parameter("progress") + (1.0 / 60)
		)
		await get_tree().physics_frame
	$TransitionLayer.visible = false
