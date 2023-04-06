extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var selectid = 0
var UserReady = preload("res://source/login and menus/UserReady.tscn")
signal PlayerReady()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OnlineMatch.connect("player_joined", self, "PlayerJoined")
	OnlineMatch.connect("player_left", self, "PlayerLeft")
	OnlineMatch.connect("player_status_changed", self, "PlayerStatusChanged")
	OnlineMatch.connect("match_ready", self, "MatchReady")
	OnlineMatch.connect("match_not_ready", self, "MatchNotReady")
	OnlineMatch.connect("matchmaker_matched", self,"AddPlayers")
	pass # Replace with function body.


func _process(_delta: float) -> void:
	match selectid:
		1: 
			get_node("ColorRect").set_position(Vector2(352, 8))
		2: 
			get_node("ColorRect").set_position(Vector2(352, 152))
		3:
			get_node("ColorRect").set_position(Vector2(352, 296))
		_: 
			get_node("ColorRect").set_position(Vector2(-576, 128))


#remember this if from the connection from OnlineMatch.connect("matchmaker_matched",self,"AddPlayers")
func AddPlayers(players):
	
	for id in players:
		var userReady = UserReady.instance()
		$VBoxContainer.add_child(userReady)
		userReady.setUsername(players[id]["username"])
		userReady.name = id

func PlayerJoined(player):
	print(player)
	pass

func PlayerLeft(player):
	print(player)
	pass

func PlayerStatusChanged(player, status):
	pass

func MatchReady(player):
	pass

func MatchNotReady(player):
	pass


func setReadyStatus(id, status):
	var statusObject = $VBoxContainer.get_node_or_null(id)
	if statusObject:
		statusObject.setReady(status)

func _on_Button_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	emit_signal("PlayerReady")
	$"1".disabled = true
	$"2".disabled = true
	pass # Replace with function body.


func _on_1_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	selectid = 1
	$Button.disabled = false
	pass # Replace with function body.


func _on_2_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	selectid = 2
	$Button.disabled = false
	pass # Replace with function body.


func _on_3_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	selectid = 3
	$Button.disabled = false
	pass # Replace with function body.





