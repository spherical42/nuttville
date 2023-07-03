extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var readyPlayers = {}
var usernames = {}
var uid = {}
var nutt = "main"

func _get_custom_rpc_methods():
	return [
		"playerIsReady"
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/ReadyScreen.connect("PlayerReady", self, "playerReady")
	$environment/nutt.connect("gameover", self, "onGameover")
	randomize()
	var menurand
	menurand = randi() % 3 + 1
	
	match menurand:
		1:
			get_node("sound/login1").play()
			get_node("Players/Camera2D/ui/currentsong").text = "Blood Drain (Melty Blood: Actress Again) Jazz Cover - The Consouls"
			
		2:
			get_node("sound/login2").play()
			get_node("Players/Camera2D/ui/currentsong").text = "Hoshi To Bokura To (Persona 5) Jazz Cover - The Consouls"
			
		3:
			get_node("sound/login3").play()
			get_node("Players/Camera2D/ui/currentsong").text = "Juggernaut - Andrew Neu"
			
		_:
			pass
	
	
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_released("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func playerReady():
	OnlineMatch.custom_rpc_sync(self, "playerIsReady", [OnlineMatch.get_my_session_id(), $Control/ReadyScreen.selectid])
	

func playerIsReady(id, selid):
	var selection : String
	match selid:
		1: selection = "Carlos"
		2: selection = "Antonio"
	
	
	$Control/ReadyScreen.setReadyStatus(id, selection)
	
	if OnlineMatch.is_network_server():
		readyPlayers[id] = true
		if readyPlayers.size() == OnlineMatch.players.size():
			OnlineMatch.start_playing()
			$Players.StartGame(OnlineMatch.get_player_names_by_peer_id())



func startGame():
	print("all players ready. starting game...")
	
	
 
func HideMatchUI():
	$Control/ReadyScreen.hide()
	$Control.hide()

func onGameover(winners):
	pass

func end_game(winners : String):
	get_tree().reload_current_scene()
	pass
	



