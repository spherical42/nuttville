extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var selectid = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match selectid:
		1: 
			get_node("ColorRect").set_position(Vector2(384, 24))
		2: 
			get_node("ColorRect").set_position(Vector2(384, 144))
		_: 
			get_node("ColorRect").set_position(Vector2(-400, 75))
	pass

func _on_go_button_down() -> void:
	self.hide()
	pass # Replace with function body.


func _on_1_button_down() -> void:
	selectid = 1
	pass # Replace with function body.


func _on_2_button_down() -> void:
	selectid = 2
	pass # Replace with function body.


