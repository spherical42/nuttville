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
		
		var cds = get_parent().get_node("PlayersSpawnUnder/" + str(OnlineMatch.get_network_unique_id())).cooldowns
		var labels = get_node("ui/cooldowns")
		
		labels.get_node("dash").text = "dash: " + str(cds[0])
		labels.get_node("lmb").text = "lmb: " + str(cds[1])
		labels.get_node("rmb").text = "rmb: " + str(cds[2])
		labels.get_node("shift").text = "shift: " + str(cds[3])
		
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
