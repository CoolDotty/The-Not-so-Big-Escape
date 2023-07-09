extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


signal pressurePlate_Active(Instigator)

func _on_body_entered(body):
	#print("pressure plate!")
	#add sound here
	#add effect here
	_on_interact(body)
	pressurePlate_Active.emit(body)
