extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var ready
var username
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func setColor(pid):
	id = pid
	match pid:
		1, 3:
			$ColorRect.color = Color(0,0,1,1) #blue
		2, 4:
			$ColorRect.color = Color(1,0,0,1) #red

func setReady(readytext):
	$Ready.text = readytext
	ready = readytext

func setUsername(currentUsername):
	$Username.text = currentUsername
	username = currentUsername
