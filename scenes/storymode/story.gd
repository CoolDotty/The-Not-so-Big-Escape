extends TextureRect
class_name Story

@export var slides: Array[Slide] = []
@export var next_scene: PackedScene

var current_frame = 0

var hack = preload("res://scenes/storymode/hack.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	_next_frame(null)
	DialogueManager.dialogue_ended.connect(_next_frame)


func _next_frame(resource):
	if current_frame < len(slides):
		var s = slides[current_frame]
		texture = s.pic
		
		var res: DialogueResource = hack.duplicate(true)
		res.lines[res.first_title]["text"] = s.text
		res.lines[res.first_title]["translation_key"] = s.text
		DialogueManager.show_example_dialogue_balloon(res)
		current_frame += 1
	else:
		Global.scene_ended.emit(next_scene)
