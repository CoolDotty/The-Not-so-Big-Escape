extends Resource
class_name Slide

@export var pic: Texture
@export_multiline var text: String
enum FX { None, Rock, Shake, Zoom}
@export var effect: FX = FX.None
