extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var ready
var username
var id
var blue : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func setColor(pid):
	if pid != 0:
		id = pid
	match pid:
		1, 3:
			$ColorRect.color = Color(0,0,1,1) #blue
			blue = true
		2, 4:
			$ColorRect.color = Color(1,0,0,1) #red
			blue = false
		0: #swaps color
			match blue:
				true:
					$ColorRect.color = Color(1,0,0,1) # makes red
				false:
					$ColorRect.color = Color(0,0,1,1) # makes blue
			blue = !blue

func setReady(readytext):
	$Ready.text = readytext
	ready = readytext

func setUsername(currentUsername):
	$Username.text = currentUsername
	username = currentUsername
