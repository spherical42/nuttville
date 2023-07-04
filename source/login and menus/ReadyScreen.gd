extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var selectid = 0
var UserReady = preload("res://source/login and menus/UserReady.tscn")
var switching = []
signal PlayerReady()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.show()
	OnlineMatch.connect("player_joined", self, "PlayerJoined")
	OnlineMatch.connect("player_left", self, "PlayerLeft")
	OnlineMatch.connect("player_status_changed", self, "PlayerStatusChanged")
	OnlineMatch.connect("match_ready", self, "MatchReady")
	OnlineMatch.connect("match_not_ready", self, "MatchNotReady")
	OnlineMatch.connect("matchmaker_matched", self,"AddPlayers")
	pass # Replace with function body.

func _get_custom_rpc_methods():
	return [
		"offerswitch"
	]

func _process(_delta: float) -> void:
	match selectid:
		1: 
			get_node("selector").set_position($"1".rect_position)
		2: 
			get_node("selector").set_position($"2".rect_position)
		3:
			get_node("selector").set_position(Vector2(352, 296))
		_: 
			get_node("selector").set_position(Vector2(-1728, -704))


#remember this if from the connection from OnlineMatch.connect("matchmaker_matched",self,"AddPlayers")
func AddPlayers(players):
	
	for id in players:
		var userReady = UserReady.instance()
		$VBoxContainer.add_child(userReady)
		userReady.setUsername(players[id]["username"])
		userReady.setColor(players[id].peer_id)
		userReady.name = str(players[id].peer_id)

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
	var statusObject = $VBoxContainer.get_node_or_null(str(id))
	if statusObject:
		statusObject.setReady(status)

func _on_Button_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	emit_signal("PlayerReady")
	$"1".disabled = true
	$"2".disabled = true


func _on_1_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	selectid = 1
	$Button.disabled = false



func _on_2_button_down():
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	selectid = 2
	$Button.disabled = false


func _on_switch_button_down():
	OnlineMatch.custom_rpc_sync(self, "offerswitch", [str(OnlineMatch.get_network_unique_id())])
	


func offerswitch(id):
	if switching.find(id) == -1:
		switching.append(id)
	
	var o = $VBoxContainer.get_node(id)
	o.get_node("switch").visible = true
	
	if switching.size() >= 2:
		
		if $VBoxContainer.get_node(switching[0]).getColor() != $VBoxContainer.get_node(switching[1]).getColor():
			print("switching")
			var red = get_parent().get_parent().get_node("Players").red
			var blue = get_parent().get_parent().get_node("Players").blue
			for i in range(switching.size()):
				# do something to red and blue arrays
				var ob = $VBoxContainer.get_node_or_null(switching[i])
				ob.get_node("switch").visible = false
				yield(ob.setColor(0), "completed")
				ob = ob.getColor()
				match ob:
					"red":
						blue.erase(switching[i])
						red.append(switching[i])
					"blue":
						red.erase(switching[i])
						blue.append(switching[i])
					_:
						print("ERROR ReadyScreen.gd line 114")
				
			
			print("red: " + str(red) + " blue: " + str(blue))
			
			get_parent().get_parent().get_node("Players").red = red #set to new
			get_parent().get_parent().get_node("Players").blue = blue 
			
		else:
			for i in range(switching.size()):
				$VBoxContainer.get_node_or_null(switching[i]).get_node("switch").visible = false
		
		
		
		switching = []
		
	
