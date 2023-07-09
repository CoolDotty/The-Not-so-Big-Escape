extends Node2D


@export var opening : bool
@export var Triggers: Array[Interactable]
@export var Target_Instagators: Array[CharacterBody2D]
@export var require_triggers_to_open: int

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if(require_triggers_to_open <= 0):
		Set_isDoorOpen(true)
	for each_trigger in Triggers:
		each_trigger.on_interact.connect(Interacted)
	
	pass # Replace with function body.


var f = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if opening:
		f = min(f + 0.1, 3)
		$Icon.frame = int(f)


func _on_body_entered(body):
	if (not opening): return


func Interacted(Instigator, trigger : Interactable):
	if(Target_Instagators.has(Instigator)):
		trigger.on_interact.disconnect(Interacted)
		require_triggers_to_open = require_triggers_to_open - 1
		if(require_triggers_to_open <= 0):
			Set_isDoorOpen(true)
	pass # Replace with function body.

func Set_isDoorOpen(enable : bool):
	opening = enable
	call_deferred("_setCollisionDisable", enable)
	
func _setCollisionDisable(enable : bool):
	$StaticBody2D/CollisionShape2D.disabled = enable
