extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spin(amount: float = 10.0, duration: float = 0.2):
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", self.rotation_degrees + amount , duration)

func split(amount: float = 10.0, duration: float = 0.2):
	var tween = create_tween()
	tween.tween_property($BallBottom, "position:y", position.y + amount, duration)
	
	var tween2 = create_tween()
	tween2.tween_property($BallTop, "position:y", position.y - amount, duration)
