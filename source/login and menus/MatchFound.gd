extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.show()
	pass # Replace with function body.

func MatchFound():
	yield(get_tree().create_timer(2.0), "timeout")
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
