extends Camera2D



var zoomscl = 1.0
var canzoom = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if OnlineMatch.match_state == OnlineMatch.MatchState.READY or OnlineMatch.match_state == OnlineMatch.MatchState.PLAYING:
		pass
	else:
		return
	
	if canzoom:
		if Input.is_action_pressed("scrldwn"):
			print("out")
			zoomscl += 0.02
		if Input.is_action_pressed("scrlup"):
			print("in")
			zoomscl -= 0.02
		
		zoomscl = clamp(zoomscl,0.5, 2)
		
		zoom = Vector2(zoomscl,zoomscl)
		scale = Vector2(zoomscl,zoomscl)
	pass
