extends Node

@onready var packed_scene = null
@onready var current_scene = get_child(0)


var trans_in = preload("res://scenes/DiamondTransitionIn.tres")
var trans_out = preload("res://scenes/DiamondTransitionOut.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.scene_ended.connect(_change_scenes)
	Global.player_died.connect(_u_sux)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var game_over = $DeathLayer.visible
	if game_over:
		if Input.is_action_just_pressed("restart"):
			Global.scene_ended.emit(packed_scene)


func _u_sux(player):
	var new_cam = Camera2D.new()
	new_cam.offset.x = 50
	player.add_child(new_cam)
	new_cam.make_current()
	$DeathLayer.visible = true
	for i in range(0, 120):
		#if (not is_instance_valid(new_cam)): return
		$DeathLayer/ColorRect.material.set_shader_parameter(
			"right",
			-1.0 + ((i / 120.0) * 4.0)
		)
		new_cam.zoom = new_cam.zoom.lerp(Vector2(5, 5), 0.1)
		await get_tree().physics_frame


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
	
	$DeathLayer.visible = false
	current_scene.queue_free()
	packed_scene = next_scene
	await get_tree().physics_frame
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
