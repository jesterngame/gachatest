extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shake(amount: float = 10.0, duration: float = 0.2):
	var original_position = position
	var tween = create_tween()

	var elapsed = 0.0
	while elapsed < duration:
		var offset = randf_range(-amount, amount)
		tween.tween_property(self, "position:x", original_position.x + offset, 0.03)
		elapsed += 0.03

	tween.tween_property(self, "position:x", original_position.x, 0.03)
	
	var tween2 = create_tween()
	tween2.tween_property($Handle, "rotation_degrees", $Handle.rotation_degrees + 720 , duration)
