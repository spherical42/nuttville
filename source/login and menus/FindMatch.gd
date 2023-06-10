extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.show()
	OnlineMatch.connect("matchmaker_matched",self,"OnMatchFound")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func OnMatchFound(players):
	print(players)
	get_parent().get_parent().get_node("sound/uisound/connected").play()
	get_parent().get_node("MatchFound").MatchFound()
	self.hide()
	pass

func _input(event):
	if event.is_action_released("ui_accept") and get_parent().get_node("Login").visible == false:
		_on_Button_button_down()
		pass
	pass


func _on_Button_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	
	$FindMatch.hide()
	$"2v2".hide()
	$"2v2label".hide()
	
	
	$Label/AnimationPlayer.play("loading")
	
	if not Online.is_nakama_socket_connected():
		Online.connect_nakama_socket()
		yield(Online, "socket_connected")
	
	print("Looking For Match...")
	
	var data = {
		"min_count" : 2,
		"max_count" : 2
	}
	
	if $"2v2".pressed:
		data = {
			"min_count" : 4,
			"max_count" : 4
		}
	
	
	
	OnlineMatch.start_matchmaking(Online.nakama_socket, data)
	
	
	pass # Replace with function body.



func _on_2v2_toggled(button_pressed: bool) -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	
	pass # Replace with function body.

