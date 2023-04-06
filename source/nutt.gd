extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var team = null
var pos = 0
signal gameover()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _get_custom_rpc_methods():
	return [
		"damage"
	]

func _physics_process(delta: float) -> void:
	position.x = lerp(position.x - 3712, pos, 0.5) + 3712
	pass

func damage(amount, whohit):
	
	
	match whohit:
		"1":
			
			pos += amount/5
		"2":
			
			
			pos -= amount/5
			
		"3":
			
			
			pos += amount/5
		"4":
			
			pos -= amount/5
	print(position.x)
	if pos <= -1344:
		emit_signal("gameover", "red")
	if pos >= 1344:
		emit_signal("gameover", "blue")
	get_node("Label").text = str(position.x - 3712)
