extends Node2D

var card_flipped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.
	
func flip_cheki():
	if(!card_flipped):
		self.get_node("AnimationPlayer").play("card_flip")
		card_flipped = true



func _on_area_2d_mouse_exited() -> void:
	pass # Replace with function body.
