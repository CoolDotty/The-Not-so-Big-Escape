extends Node2D


@export var story: DialogueResource


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().physics_frame
	if not is_instance_valid(story):
		return
	DialogueManager.show_example_dialogue_balloon(story)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
