extends TextureRect
class_name Story

@export var slides: Array[Slide] = []
@export var next_scene: PackedScene

var current_frame = 0

var hack = preload("res://scenes/storymode/hack.dialogue")

var shake = 0.0

var time = 0.0

var saved_position

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	_next_frame(null)
	DialogueManager.dialogue_ended.connect(_next_frame)
	
	saved_position = position


func _process(delta):
	var s = slides[current_frame - 1]
	
	if s.effect == Slide.FX.Zoom:
		time += delta
		var zom = max(scale.x - 0.1, 1.1)
		scale = Vector2(zom, zom)
	else:
		scale = Vector2(1,1)
	
	if s.effect == Slide.FX.Rock:
		time += delta
		rotation = sin(time * 5) / 20
	
	if s.effect == Slide.FX.Shake:
		position = Vector2(saved_position.x+randf_range(-shake, shake), saved_position.y+randf_range(-shake, shake))
		shake = max(shake - 0.5, 0.0)
	else:
		shake = 0.0
		position = saved_position


func _next_frame(resource):
	if current_frame < len(slides):
		var s = slides[current_frame]
		texture = s.pic
		
		var res: DialogueResource = hack.duplicate(true)
		res.lines[res.first_title]["text"] = s.text
		res.lines[res.first_title]["translation_key"] = s.text
		DialogueManager.show_example_dialogue_balloon(res)
		current_frame += 1
		
		time = 0.0
		rotation = 0.0
		if s.effect == Slide.FX.Shake:
			shake = 60.0
		if s.effect == Slide.FX.Zoom:
			scale = Vector2(3, 3)
	else:
		Global.scene_ended.emit(next_scene)
