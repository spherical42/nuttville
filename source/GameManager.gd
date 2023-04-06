extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var player = preload("res://source/playerstuff/Player.tscn")
var endscreen = preload("res://source/login and menus/endPopup.tscn")
var myID
var selection
var Players = {}
var AlivePlayers = {}
var ReadyPlayers = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OnlineMatch.connect("player_left", self, "PlayerLeft")
	OnlineMatch.connect("error", self, "hostleftcheck")
	get_parent().get_node("environment/nutt").connect("gameover", self, "gameover")
	pass # Replace with function body.

func _get_custom_rpc_methods():
	return [
		"setupGame",
		"finishedSetup"
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func StartGame(players):
	OnlineMatch.custom_rpc_sync(self, "setupGame", [players])
	

func setupGame(players):
	Players = players
	AlivePlayers = players
	#id here is 1 2 3 or 4
	for id in players:
		var currentPlayer = player.instance()
		currentPlayer.name = str(id)
		$PlayersSpawnUnder.add_child(currentPlayer)
		currentPlayer.set_network_master(id)
		currentPlayer.position = get_node("PlayerSpawnPoints/Player" + str(id)).position
		currentPlayer.connect("playerdied", self, "playerdeath", [id])
	myID = OnlineMatch.get_network_unique_id()
	var player = $PlayersSpawnUnder.get_node(str(myID))
	selection = get_parent().get_node("Control/ReadyScreen").selectid
	player.username = Online.nakama_session.username
	player.charid = selection
	#yield(get_tree().create_timer(5.0), "timeout")
	player.playerControlled = true
	OnlineMatch.custom_rpc_id_sync(self, 1, "finishedSetup", [myID])
	get_parent().HideMatchUI()
	get_parent().get_node("sound/login1").stop()
	get_parent().get_node("sound/login2").stop()
	get_parent().get_node("sound/login3").stop()
	get_parent().get_node("Players/Camera2D/ui/currentsong").text = ""

func finishedSetup(id):
	ReadyPlayers[id] = Players[id]
	if ReadyPlayers.size() == Players.size():
		get_parent().startGame() #does nothing atm


func PlayerLeft(player):
	
	pass

func hostleftcheck(error):
	if error == "Host has disconnected":
		var endpop = endscreen.instance()
		get_node("Camera2D/ui").add_child(endpop)
		endpop.errmsg = "ERROR:\nHOST HAS DISCONNECTED"
		

func playerdeath(id):
	pass

func gameover(team):
	var winscreen = endscreen.instance()
	get_node("Camera2D/ui").add_child(winscreen)
	winscreen.errmsg = "WINNER:\n" + team
	
