extends Panel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var errmsg

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	$Label.text = str(errmsg)
	OnlineMatch.leave()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_button_up() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
